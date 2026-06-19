import os
import subprocess
from pathlib import Path
from typing import Any, Dict, List

from dotbot.plugin import Plugin
from dotbot.plugins.link import Link


class SystemdUser(Plugin):
    supports_dry_run = True

    _directive = 'systemd_user'

    def can_handle(self, directive: str) -> bool:
        return directive == self._directive

    def handle(self, directive: str, data: Any) -> bool:
        if directive != self._directive:
            msg = f'SystemdUser cannot handle directive {directive}'
            raise ValueError(msg)
        if not isinstance(data, dict):
            self._log.warning('systemd_user must be a mapping')
            return False

        success = self._prepare_target(data)
        if not success:
            return False
        success &= self._link_units(data)

        if data.get('daemon_reload', False):
            success &= self._systemctl('daemon-reload', [])

        for action in ('enable', 'disable', 'mask', 'unmask'):
            units = data.get(action, [])
            if units:
                success &= self._systemctl(action, self._as_list(units))

        return success

    def _prepare_target(self, data: Dict[str, Any]) -> bool:
        target = Path(os.path.expandvars(os.path.expanduser(data.get('target', '~/.config/systemd/user'))))
        if target.parent.is_symlink():
            self._log.warning(f'Replace systemd directory symlink manually before linking per-unit state: {target.parent}')
            return False
        if self._context.dry_run():
            self._log.action(f'Would ensure systemd user unit directory exists: {target}')
            return True
        target.mkdir(parents=True, exist_ok=True)
        return True

    def _link_units(self, data: Dict[str, Any]) -> bool:
        unit_config = data.get('units', {})
        if not isinstance(unit_config, dict):
            self._log.warning('systemd_user.units must be a mapping')
            return False

        source = unit_config.get('source', 'systemd/user')
        unit_names = self._as_list(unit_config.get('link', []))
        target = data.get('target', '~/.config/systemd/user')

        base = Path(self._context.base_directory())
        source_dir = self._repo_path(base, source)
        if not source_dir.is_dir():
            self._log.warning(f'Systemd unit source does not exist: {source}')
            return False

        links: Dict[str, str] = {}
        success = True
        for unit in unit_names:
            unit_path = source_dir / unit
            if unit_path.is_symlink():
                self._log.warning(f'Refusing to link symlinked systemd unit: {unit}')
                success = False
                continue
            if not unit_path.is_file():
                self._log.warning(f'Systemd unit does not exist: {unit}')
                success = False
                continue
            links[f'{target.rstrip("/")}/{unit}'] = unit_path.relative_to(base).as_posix()

        if links:
            success &= Link(self._context).handle('link', links)
        return success

    def _repo_path(self, base: Path, path: str) -> Path:
        expanded = os.path.expandvars(os.path.expanduser(path))
        candidate = Path(expanded)
        if candidate.is_absolute():
            return candidate
        return base / candidate

    def _systemctl(self, action: str, units: List[str]) -> bool:
        command = ['systemctl', '--user', action]
        command.extend(units)
        if self._context.dry_run():
            self._log.action(f'Would run {" ".join(command)}')
            return True
        self._log.action(f'Running {" ".join(command)}')
        result = subprocess.run(command, check=False)
        if result.returncode != 0:
            self._log.warning(f'systemctl {action} failed')
            return False
        return True

    def _as_list(self, value: Any) -> List[str]:
        if value is None:
            return []
        if isinstance(value, str):
            return [value]
        return list(value)
