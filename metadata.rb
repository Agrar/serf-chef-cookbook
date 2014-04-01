name             'serf'
maintainer       'Nick Gerakines'
maintainer_email 'nick@agrar.io'
license          'MIT'
description      'Installs/Configures melite'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.0'
supports         'ubuntu', '>= 12.04'

depends 'ark'
depends 'apt'
depends 'logrotate'