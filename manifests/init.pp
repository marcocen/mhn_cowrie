# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mhn_cowrie { 'namevar': }
define mhn_cowrie (
  Integer $port,
  String $user,
) {
  if ! defined(Class['git']) { include ::git }
  ensure_packages(
    [gcc],
    {ensure => present},
  )

  vcsrepo {'/opt/cowrie':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/micheloosterhof/cowrie.git',
    revision => '34f8464',
  }
  
  # supervisor::program {'cowrie':
  #   ensure    => present,
  #   enable    => true,
  #   command   => '/opt/cowrie/bin/cowrie start',
  #   directory => '/opt/cowrie',
  #   user      => $user,
  #   require   => Python::Virtualenv['/opt/cowrie'],
  # }

  class {'python':
    version => '2.7',
    ensure => present,
    pip => 'present',
    virtualenv => 'present',
  }
  
  python::virtualenv {'/opt/cowrie':
    ensure       => present,
    version      => '2.7',
    venv_dir     => '/opt/cowrie/cowrie-env',
    requirements => '/opt/cowrie/requirements.txt',
    proxy        => 'http://proxy:3128',
    require      => [
      Vcsrepo['/opt/cowrie'],
      Class['python'],
    ],
  }
}
