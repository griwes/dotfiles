import getpass
import os
import pwd
import shutil
import subprocess
import sys
from typing import Any, Dict

from dotbot.plugin import Plugin


class LoginShell(Plugin):
    supports_dry_run = True

    _directive = 'login_shell'

    def can_handle(self, directive: str) -> bool:
        return directive == self._directive

    def handle(self, directive: str, data: Any) -> bool:
        if directive != self._directive:
            msg = f'LoginShell cannot handle directive {directive}'
            raise ValueError(msg)
        if not isinstance(data, dict):
            self._log.warning('login_shell must be a mapping')
            return False

        user = getpass.getuser()
        if not self._user_is_allowed(user, data):
            self._log.info(f'Skipping login shell change for user {user}')
            return True

        shell_name = data.get('shell')
        if not shell_name:
            self._log.warning('login_shell.shell is required')
            return False

        target_shell = shutil.which(shell_name) if not os.path.isabs(shell_name) else shell_name
        if not target_shell or not os.path.isfile(target_shell) or not os.access(target_shell, os.X_OK):
            self._log.warning(f'Login shell is not executable or was not found: {shell_name}')
            return False

        if not self._shell_is_listed(target_shell):
            self._log.warning(f'Login shell is not listed in /etc/shells: {target_shell}')
            return False

        current_shell = self._current_shell(user)
        if current_shell == target_shell:
            self._log.info(f'Login shell already set to {target_shell}')
            return True

        chsh = shutil.which('chsh')
        if not chsh:
            self._log.warning('Cannot change login shell: chsh not found')
            return False

        if not sys.stdin.isatty() and not self._truthy_env(data.get('allow_noninteractive_env')):
            self._log.warning('Skipping login shell change outside an interactive terminal')
            return True

        command = [chsh, '-s', target_shell]
        if self._context.dry_run():
            self._log.action(f'Would change login shell from {current_shell} to {target_shell}')
            return True

        self._log.action(f'Changing login shell from {current_shell} to {target_shell}')
        result = subprocess.run(command, check=False)
        if result.returncode != 0:
            self._log.warning('chsh failed')
            return False
        return True

    def _user_is_allowed(self, user: str, data: Dict[str, Any]) -> bool:
        allowed_users = data.get('allowed_users')
        if not allowed_users:
            return True
        if user in allowed_users:
            return True
        return self._truthy_env(data.get('override_env'))

    def _truthy_env(self, key: Any) -> bool:
        if not key:
            return False
        value = os.environ.get(str(key), '')
        return value.lower() not in {'', '0', 'false', 'no', 'off'}

    def _shell_is_listed(self, shell: str) -> bool:
        try:
            with open('/etc/shells', encoding='utf-8') as shells:
                return shell in {line.strip() for line in shells if line.strip() and not line.startswith('#')}
        except OSError:
            return False

    def _current_shell(self, user: str) -> str:
        return pwd.getpwnam(user).pw_shell
