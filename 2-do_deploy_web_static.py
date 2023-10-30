#!/usr/bin/python3
"""For Distributing an archive to the web servers"""
from fabric.api import *
import os
from datetime import datetime
#the env host and user which is my servers and name
env.hosts = ['54.198.74.180', '34.229.56.208']
env.user = 'ubuntu'


def do_pack():
    '''For Generating a tgz archive.'''
    try:
        local('mkdir -p versions')
        datetime_format = '%Y%m%d%H%M%S'
        archive_path = 'versions/web_static_{}.tgz'.format(
            datetime.now().strftime(datetime_format))
        local('tar -cvzf {} web_static'.format(archive_path))

        print('web_static packed: {} -> {}'.format(archive_path,
              os.path.getsize(archive_path)))
    except:
        return None


def do_deploy(archive_path):
    '''Deploys to the web server.'''
    if not os.path.exists(archive_path):
        return False

    file_name = archive_path.split('/')[1]
    file_path = '/data/web_static/releases/'

    releases_path = file_path + file_name[:-4]
    # the try and except part
    try:
        put(archive_path, '/tmp/')
        run('mkdir -p {}'.format(releases_path))
        run('tar -xzf /tmp/{} -C {}'.format(file_name, releases_path))
        run('rm /tmp/{}'.format(file_name))
        run('mv {}/web_static/* {}/'.format(releases_path, releases_path))
        run('rm -rf {}/web_static'.format(releases_path))
        run('rm -rf /data/web_static/current')
        run('ln -s {} /data/web_static/current'.format(releases_path))
        print('New version deployed!')
        return True
        # if sth goes wrong
    except:
        return False
