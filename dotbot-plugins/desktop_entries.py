import os
from pathlib import Path
from typing import Any, Dict, Optional

from dotbot.plugin import Plugin
from dotbot.plugins.link import Link


class DesktopEntries(Plugin):
    supports_dry_run = True

    _directive = 'desktop_entries'

    def can_handle(self, directive: str) -> bool:
        return directive == self._directive

    def handle(self, directive: str, data: Any) -> bool:
        if directive != self._directive:
            msg = f'DesktopEntries cannot handle directive {directive}'
            raise ValueError(msg)
        if not isinstance(data, dict):
            self._log.warning('desktop_entries must be a mapping')
            return False

        base = Path(self._context.base_directory())
        source = data.get('source', 'applications')
        target = data.get('target', '~/.local/share/applications')
        links = self._desktop_links(base, source, target)
        if links is None:
            return False

        icons = data.get('icons')
        if icons:
            icon_links = self._icon_links(base, source, icons)
            if icon_links is None:
                return False
            links.update(icon_links)

        if not links:
            self._log.info('No desktop entries were found')
            return True

        return Link(self._context).handle('link', links)

    def _desktop_links(self, base: Path, source: str, target: str) -> Optional[Dict[str, str]]:
        source_dir = self._repo_path(base, source)
        if not source_dir.is_dir():
            self._log.warning(f'Desktop entry source does not exist: {source}')
            return None

        links: Dict[str, str] = {}
        for entry in sorted(source_dir.glob('*.desktop')):
            links[self._target_path(target, entry.name)] = self._repo_relative(base, entry)
        return links

    def _icon_links(self, base: Path, default_source: str, icons: Any) -> Optional[Dict[str, str]]:
        if icons is True:
            icon_source = f'{default_source}/icons'
            icon_target = '~/.local/share/icons/dotfiles'
        elif isinstance(icons, dict):
            icon_source = icons.get('source', f'{default_source}/icons')
            icon_target = icons.get('target', '~/.local/share/icons/dotfiles')
        else:
            self._log.warning('desktop_entries icons must be true or a mapping')
            return None

        source_dir = self._repo_path(base, icon_source)
        if not source_dir.is_dir():
            self._log.warning(f'Desktop icon source does not exist: {icon_source}')
            return None

        links: Dict[str, str] = {}
        for icon in sorted(source_dir.iterdir()):
            if icon.is_file():
                links[self._target_path(icon_target, icon.name)] = self._repo_relative(base, icon)
        return links

    def _repo_path(self, base: Path, path: str) -> Path:
        expanded = os.path.expandvars(os.path.expanduser(path))
        candidate = Path(expanded)
        if candidate.is_absolute():
            return candidate
        return base / candidate

    def _repo_relative(self, base: Path, path: Path) -> str:
        return path.relative_to(base).as_posix()

    def _target_path(self, directory: str, name: str) -> str:
        return f'{directory.rstrip("/")}/{name}'
