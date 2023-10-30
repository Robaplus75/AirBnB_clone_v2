# Prepares the web server for the deployment

exec {'update':
  provider => shell,
  command  => 'sudo apt-get -y update',
  before   => Exec['install nginx'],
}

# installs teh nginx
exec {'install nginx':
  provider => shell,
  command  => 'sudo apt-get -y install nginx',
  before   => Exec['start nginx'],
}

# starts the nginx
exec {'start nginx':
  provider => shell,
  command  => 'sudo service nginx start',
  before   => Exec['create test directory'],
}

# creates the directory
exec {'create shared directory':
  provider => shell,
  command  => 'sudo mkdir -p /data/web_static/shared/',
  before   => Exec['create test directory'],
}

# creates test directory
exec {'create test directory':
  provider => shell,
  command  => 'sudo mkdir -p /data/web_static/releases/test/',
  before   => Exec['add test content'],
}

# adds test content
exec {'add test content':
  provider => shell,
  command  => 'echo "<html>
    <head>
    </head>
    <body>
      Holberton School
    </body>
  </html>" > /data/web_static/releases/test/index.html',
  before   => Exec['create symbolic link to current'],
}

# creates symbolic link
exec {'create symbolic link to current':
  provider => shell,
  command  => 'sudo ln -sf /data/web_static/releases/test/ /data/web_static/current',
  before   => File['/data/'],
}

# the files part
file {'/data/':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
  before  => Exec['serve current to hbnb_static'],
}

exec {'serve current to hbnb_static':
  provider => shell,
  command  => 'sed -i "61i\ \n\tlocation /hbnb_static {\n\t\talias /data/web_static/current;\n\t\tautoindex off;\n\t}" /etc/nginx/sites-available/default',
  before   => Exec['restart nginx'],
}

# restarts nginx
exec {'restart nginx':
  provider => shell,
  command  => 'sudo service nginx restart',
}

