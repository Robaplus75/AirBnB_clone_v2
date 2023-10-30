#!/usr/bin/python3
"""script For Generating a .tgz"""
from fabric.api import local
import os
from datetime import datetime


def do_pack():
    '''For Generating a tgz archive'''
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
