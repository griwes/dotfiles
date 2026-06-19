import os
import stat
from pathlib import Path
from typing import Any, Dict, Iterable, Tuple

from dotbot.plugin import Plugin


class PathPermissions(Plugin):
    supports_dry_run = True

    _directive = 'path_permissions'

    def can_handle(self, directive: str) -> bool:
        return directive == self._directive

    def handle(self, directive: str, data: Any) -> bool:
        if directive != self._directive:
            msg = f'PathPermissions cannot handle directive {directive}'
            raise ValueError(msg)
        if not isinstance(data, dict):
            self._log.warning('path_permissions must be a mapping of path to mode')
            return False

        success = True
        for path, mode in self._entries(data):
            success &= self._chmod(path, mode)
        return success

    def _entries(self, data: Dict[Any, Any]) -> Iterable[Tuple[Path, int]]:
        for raw_path, raw_mode in data.items():
            path = Path(os.path.expandvars(os.path.expanduser(str(raw_path))))
            yield path, self._parse_mode(raw_mode)

    def _parse_mode(self, value: Any) -> int:
        if isinstance(value, int):
            return value
        if isinstance(value, str):
            return int(value, 8)
        msg = f'Unsupported permission mode value: {value!r}'
        raise ValueError(msg)

    def _chmod(self, path: Path, mode: int) -> bool:
        if not path.exists():
            if self._context.dry_run():
                self._log.action(f'Would chmod {mode:o} {path} after creation')
                return True
            self._log.warning(f'Cannot chmod missing path: {path}')
            return False
        if path.is_symlink():
            self._log.warning(f'Refusing to chmod symlink: {path}')
            return False

        current_mode = stat.S_IMODE(path.stat().st_mode)
        if current_mode == mode:
            self._log.info(f'Path mode already {mode:o}: {path}')
            return True

        if self._context.dry_run():
            self._log.action(f'Would chmod {mode:o} {path}')
            return True

        self._log.action(f'Chmod {mode:o} {path}')
        try:
            path.chmod(mode)
        except OSError:
            self._log.warning(f'Failed to chmod {path}')
            return False
        return True
