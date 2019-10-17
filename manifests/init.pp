# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mhn_cowrie { 'namevar': }
define mhn_cowrie (
  Integer $port,
  String $user,
  String $pip_proxy,
) {
  $install_dir = '/opt/cowrie'
  if ! defined(Class['git']) { include ::git }
  ensure_packages(
    [gcc],
    {ensure => present},
  )

  vcsrepo {$install_dir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/micheloosterhof/cowrie.git',
    revision => '34f8464',
    user     => $user,
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
    version    => '2.7',
    ensure     => present,
    pip        => 'present',
    virtualenv => 'present',
  }

  exec {'Create virtualenv':
    command => 'virtualenv --python=python2.7 cowrie-env',
    cwd     => $install_dir,
    unless  => "test -d ${install_dir}/cowrie-env",
    user    => $user,
    require => Vcsrepo[$install_dir],
  }

}
