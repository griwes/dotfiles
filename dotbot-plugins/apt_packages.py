import os
import shutil
import subprocess
from dataclasses import dataclass
from typing import Any, Dict, Iterable, List

from dotbot.plugin import Plugin


@dataclass(frozen=True)
class Package:
    name: str
    group: str


class AptPackages(Plugin):
    supports_dry_run = True

    _directive = 'apt_packages'

    def can_handle(self, directive: str) -> bool:
        return directive == self._directive

    def handle(self, directive: str, data: Any) -> bool:
        if directive != self._directive:
            msg = f'AptPackages cannot handle directive {directive}'
            raise ValueError(msg)
        if not isinstance(data, dict):
            self._log.warning('apt_packages must be a mapping')
            return False

        if not self._has_command('apt-get') or not self._has_command('dpkg-query'):
            self._log.warning('apt_packages requires apt-get and dpkg-query')
            return False

        packages = self._parse_packages(data.get('install'))
        if not packages:
            self._log.info('No apt packages requested')
            return True

        missing = [package for package in packages if not self._is_installed(package.name)]
        if not missing:
            self._log.info(f'All {len(packages)} apt packages are already installed')
            return True

        self._log.info('Missing apt packages: ' + ', '.join(package.name for package in missing))
        if self._context.dry_run():
            self._log.action(
                'Would install missing apt packages: '
                + ', '.join(self._format_package(package) for package in missing)
            )
            return True

        command = self._install_command([package.name for package in missing])
        if not command:
            return False

        self._log.action('Installing missing apt packages')
        result = subprocess.run(
            command,
            check=False,
            env={**os.environ, 'DEBIAN_FRONTEND': 'noninteractive'},
        )
        if result.returncode != 0:
            self._log.warning('apt-get install failed')
            return False
        return True

    def _parse_packages(self, install: Any) -> List[Package]:
        packages: List[Package] = []
        if install is None:
            return packages

        if isinstance(install, dict):
            for group, entries in install.items():
                packages.extend(self._parse_group(str(group), entries))
        else:
            packages.extend(self._parse_group('default', install))

        seen = set()
        deduped: List[Package] = []
        for package in packages:
            if package.name in seen:
                continue
            seen.add(package.name)
            deduped.append(package)
        return deduped

    def _parse_group(self, group: str, entries: Any) -> Iterable[Package]:
        if isinstance(entries, str):
            entries = [entries]
        if not isinstance(entries, list):
            self._log.warning(f'apt package group {group} must be a list')
            return []

        packages: List[Package] = []
        for entry in entries:
            if not isinstance(entry, str):
                self._log.warning(f'apt package entry in group {group} must be a string')
                continue
            name = entry.strip()
            if not name:
                continue
            if any(character.isspace() for character in name):
                self._log.warning(f'apt package name cannot contain whitespace: {name}')
                continue
            packages.append(Package(name=name, group=group))
        return packages

    def _is_installed(self, package: str) -> bool:
        result = subprocess.run(
            ['dpkg-query', '-W', '-f=${db:Status-Abbrev}', package],
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
        )
        return result.returncode == 0 and result.stdout.startswith('ii ')

    def _install_command(self, packages: List[str]) -> List[str]:
        apt_get = shutil.which('apt-get')
        if not apt_get:
            self._log.warning('apt-get was not found')
            return []

        command = [apt_get, 'install', '-y', *packages]
        if os.geteuid() == 0:
            return command

        sudo = shutil.which('sudo')
        if not sudo:
            self._log.warning('Cannot install missing apt packages: sudo was not found')
            return []
        return [sudo, *command]

    def _has_command(self, command: str) -> bool:
        return shutil.which(command) is not None

    def _format_package(self, package: Package) -> str:
        return f'{package.name} ({package.group})'
