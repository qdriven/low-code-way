#!/usr/bin/env python
import os
import socket
import subprocess
from collections import defaultdict

import click

PROVIDERS = (
    'bytemark',
    'hetzner',
)


def get_provider(target):
    if 'kingfisher' in target:
        return 'hetzner'
    else:
        return 'bytemark'


def compare(content, get_item, mode='diff', margin=0, providers=None):
    provider_count = defaultdict(int)
    target_items = defaultdict(list)
    item_providers = defaultdict(lambda: defaultdict(int))

    target = None
    provider = None
    for line in content.splitlines():
        if line.startswith('        '):
            continue
        elif line.startswith(' '):
            item = get_item(line.strip())
            target_items[target].append(item)
            item_providers[item][provider] += 1
        else:
            target = line[:-1]
            provider = get_provider(target)
            provider_count[provider] += 1

    provider_items = defaultdict(set)
    for item, providers in item_providers.items():
        for provider, count in providers.items():
            if count >= provider_count[provider] - margin:
                provider_items[provider].add(item)

    for target in sorted(target_items):
        print('{}:'.format(target))
        for item in target_items[target]:
            provider = get_provider(target)
            if provider not in providers:
                continue
            included = item in provider_items[provider]
            if mode == 'diff' and not included or mode == 'comm' and included:
                print('  {}'.format(item))


def run(*args):
    return subprocess.run(args, check=True, stdout=subprocess.PIPE).stdout.decode()


@click.group()
def cli():
    pass

@cli.command()
@click.argument('destination')
def connect(destination):
    """
    Port-knocks then connects to a destination using SSH.
    """
    user, host = destination.split('@')
    try:
        socket.create_connection((host, 8255), 1)
    except socket.timeout:
        pass
    except ConnectionRefusedError:
        print('port 8255 closed')
    os.execvp('ssh', ('ssh', destination))


@cli.command()
@click.option('--provider', type=click.Choice(PROVIDERS), default=PROVIDERS, multiple=True,
              help='the providers to report on')
def services(provider):
    """
    List services that are not common to all servers of the same provider.
    """
    content = run('salt-ssh', '*', 'service.get_all')
    compare(content, lambda line: line.strip()[2:], providers=provider)


@cli.command()
@click.option('--provider', type=click.Choice(PROVIDERS), default=PROVIDERS, multiple=True,
              help='the providers to report on')
def packages(provider):
    """
    List packages that are not common to all servers of the same provider.
    """
    content = run('salt-ssh', '*', 'pkg.list_pkgs')
    compare(content, lambda line: line.strip()[:-1], providers=provider)


@cli.command()
@click.option('--margin', type=int, default=0,
              help='the margin within which packages are considered to be common to all servers')
@click.option('--provider', type=click.Choice(PROVIDERS), default=PROVIDERS, multiple=True,
              help='the providers to report on')
def autoremove(margin, provider):
    """
    List packages that can be auto-removed and that are common to all servers of the same provider.
    """
    content = run('salt-ssh', '*', 'pkg.autoremove', 'list_only=True')
    compare(content, lambda line: line.strip()[2:], mode='comm', margin=margin, providers=provider)


if __name__ == '__main__':
    cli()
