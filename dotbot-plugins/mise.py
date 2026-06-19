import os
import glob
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional

from dotbot.plugin import Plugin


class Mise(Plugin):
    supports_dry_run = True

    _directive = 'mise'

    def can_handle(self, directive: str) -> bool:
        return directive == self._directive

    def handle(self, directive: str, data: Any) -> bool:
        if directive != self._directive:
            msg = f'Mise cannot handle directive {directive}'
            raise ValueError(msg)
        if data is None:
            data = {}
        if not isinstance(data, dict):
            self._log.warning('mise must be a mapping')
            return False

        mise = self._find_mise()
        if not mise and data.get('bootstrap', False):
            if self._context.dry_run():
                self._bootstrap_mise()
                mise = str(Path.home() / '.local/bin/mise')
            elif not self._bootstrap_mise():
                return False
            else:
                mise = self._find_mise()
        if not mise:
            self._log.warning('mise was not found')
            return False

        self._github_token: Optional[str] = None
        if not self._prepare_github_auth(data.get('github_auth', {})):
            return False

        success = True
        success &= self._trust_configs(mise, data.get('trust', []))
        locked = bool(data.get('locked', False))
        success &= self._install_tools(
            mise,
            data.get('preinstall', []),
            'Preinstall mise prerequisite tools',
            locked,
        )
        success &= self._link_plugins(mise, data.get('plugins', {}))
        if data.get('install', False):
            success &= self._run(self._install_command(mise, [], locked), 'Install mise tools')
        return success

    def _prepare_github_auth(self, config: Any) -> bool:
        if not config:
            return True
        if not isinstance(config, dict):
            self._log.warning('mise.github_auth must be a mapping')
            return False

        provider = str(config.get('provider', 'gh'))
        if provider != 'gh':
            self._log.warning(f'Unsupported mise.github_auth provider: {provider}')
            return False

        if self._has_github_token_env():
            return True

        gh = self._find_gh()
        if not gh:
            self._log.info('gh was not found; mise will use unauthenticated GitHub requests')
            return True

        token = self._gh_token(gh)
        if token:
            self._github_token = token
            self._log.info('Using GitHub token from gh for mise')
            return True

        skip_env = str(config.get('skip_env', 'DOTFILES_SKIP_GITHUB_LOGIN'))
        if self._env_flag(skip_env):
            self._log.info('Skipping GitHub login for mise')
            return True

        if not self._github_login_is_interactive(config):
            self._log.info('Skipping GitHub login for mise outside an interactive terminal')
            return True

        git_protocol = os.environ.get(
            str(config.get('git_protocol_env', 'DOTFILES_GH_GIT_PROTOCOL')),
            str(config.get('default_git_protocol', 'ssh')),
        )
        command = [
            gh,
            'auth',
            'login',
            '--hostname',
            'github.com',
            '--web',
            '--git-protocol',
            git_protocol,
            '--skip-ssh-key',
        ]

        if self._context.dry_run():
            return self._run(command, 'Log in to GitHub for mise')

        if not self._run(command, 'Log in to GitHub for mise'):
            return False

        token = self._gh_token(gh)
        if not token:
            self._log.warning('GitHub login completed, but gh did not return a token')
            return False
        self._github_token = token
        return True

    def _has_github_token_env(self) -> bool:
        return any(os.environ.get(name) for name in ('MISE_GITHUB_TOKEN', 'GITHUB_API_TOKEN', 'GITHUB_TOKEN'))

    def _env_flag(self, name: str) -> bool:
        value = os.environ.get(name)
        if value is None:
            return False
        return value.lower() not in ('', '0', 'false', 'no', 'off')

    def _find_gh(self) -> Optional[str]:
        return shutil.which('gh', path=self._env().get('PATH'))

    def _gh_token(self, gh: str) -> Optional[str]:
        result = subprocess.run(
            [gh, 'auth', 'token', '--hostname', 'github.com'],
            check=False,
            env=self._env(),
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
        )
        token = result.stdout.strip()
        if result.returncode != 0 or not token:
            return None
        return token

    def _github_login_is_interactive(self, config: Dict[str, Any]) -> bool:
        login = str(config.get('login', 'interactive'))
        if login == 'never':
            return False
        if login != 'interactive':
            self._log.warning(f'Unsupported mise.github_auth login mode: {login}')
            return False
        return sys.stdin.isatty() and sys.stdout.isatty()

    def _trust_configs(self, mise: str, configs: Any) -> bool:
        paths = self._as_list(configs)
        if not paths:
            return True

        base = Path(self._context.base_directory())
        expanded_paths = []
        for path in paths:
            source = Path(os.path.expandvars(os.path.expanduser(str(path))))
            pattern = str(source if source.is_absolute() else base / source)
            matches = sorted(glob.glob(pattern))
            if matches:
                expanded_paths.extend(matches)
            else:
                self._log.warning(f'Mise trust path did not match anything: {path}')
                return False

        success = True
        for path in expanded_paths:
            success &= self._run([mise, 'trust', '--yes', path], f'Trust mise config {path}')
        return success

    def _install_tools(self, mise: str, tools: Any, description: str, locked: bool) -> bool:
        tool_list = [str(tool) for tool in self._as_list(tools)]
        if not tool_list:
            return True
        return self._run(self._install_command(mise, tool_list, locked), description)

    def _install_command(self, mise: str, tools: List[str], locked: bool) -> List[str]:
        command = [mise, 'install']
        if locked:
            command.append('--locked')
        command.extend(tools)
        return command

    def _find_mise(self) -> Optional[str]:
        found = shutil.which('mise')
        if found:
            return found
        local = Path.home() / '.local/bin/mise'
        if local.is_file() and os.access(local, os.X_OK):
            return str(local)
        return None

    def _bootstrap_mise(self) -> bool:
        if shutil.which('curl'):
            return self._run(['sh', '-c', 'curl -fsSL https://mise.run | sh'], 'Install mise')
        if shutil.which('wget'):
            return self._run(['sh', '-c', 'wget -qO- https://mise.run | sh'], 'Install mise')
        self._log.warning('Cannot bootstrap mise: neither curl nor wget was found')
        return False

    def _link_plugins(self, mise: str, plugins: Any) -> bool:
        if not plugins:
            return True
        if not isinstance(plugins, dict):
            self._log.warning('mise.plugins must be a mapping of plugin name to source path')
            return False

        base = Path(self._context.base_directory())
        success = True
        for name, path in plugins.items():
            source = Path(os.path.expandvars(os.path.expanduser(str(path))))
            if not source.is_absolute():
                source = base / source
            if not source.exists():
                self._log.warning(f'Mise plugin source does not exist: {source}')
                success = False
                continue
            success &= self._run(
                [mise, 'plugins', 'link', '--force', str(name), str(source)],
                f'Link mise plugin {name}',
            )
        return success

    def _run(self, command: List[str], description: str) -> bool:
        if self._context.dry_run():
            self._log.action(f'Would {description}: {self._quote(command)}')
            return True
        self._log.action(description)
        result = subprocess.run(
            command,
            cwd=self._context.base_directory(),
            env=self._env(),
            check=False,
        )
        if result.returncode != 0:
            self._log.warning(f'Command failed: {self._quote(command)}')
            return False
        return True

    def _env(self) -> Dict[str, str]:
        env = os.environ.copy()
        home = Path.home()
        path_entries = [
            home / '.local/bin',
            home / '.local/share/mise/shims',
        ]
        install_root = home / '.local/share/mise/installs'
        path_entries.extend(sorted(install_root.glob('*/*/bin')))
        existing_path = env.get('PATH', '')
        prefix = [str(path) for path in path_entries if path.exists()]
        env['PATH'] = os.pathsep.join([*prefix, existing_path] if existing_path else prefix)
        env.setdefault('RUSTUP_TOOLCHAIN', 'stable')
        github_token = getattr(self, '_github_token', None)
        if github_token and not any(
            env.get(name) for name in ('MISE_GITHUB_TOKEN', 'GITHUB_API_TOKEN', 'GITHUB_TOKEN')
        ):
            env['MISE_GITHUB_TOKEN'] = github_token
        return env

    def _quote(self, command: List[str]) -> str:
        return ' '.join(shlex_quote(part) for part in command)

    def _as_list(self, value: Any) -> List[Any]:
        if value is None:
            return []
        if isinstance(value, str):
            return [value]
        return list(value)


def shlex_quote(value: str) -> str:
    return "'" + value.replace("'", "'\"'\"'") + "'"
