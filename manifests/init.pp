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

  file {$install_dir:
    ensure => directory,
    owner  => $user,
  }
  
  vcsrepo {$install_dir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/micheloosterhof/cowrie.git',
    revision => '34f8464',
    user     => $user,
    require  => File[$install_dir],
  }

  class {'python':
    version    => '2.7',
    ensure     => present,
    pip        => 'present',
    virtualenv => 'present',
  }

  exec {'Create virtualenv':
    command => 'virtualenv --python=python2.7 cowrie-env',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd     => $install_dir,
    unless  => "test -d ${install_dir}/cowrie-env",
    user    => $user,
    require => Vcsrepo[$install_dir],
  }

  exec {'Install/update requirements':
    command => "${install_dir}/cowrie-env/bin/pip install -r requirements.txt",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd     => $install_dir,
    user    => $user,
    require => Exec['Create virtualenv'],
  }

  supervisor::program {'cowrie':
    ensure         => present,
    enable         => true,
    command        => "${install_dir}/bin/cowrie start",
    directory      => $install_dir,
    stdout_logfile => "${install_dir}/var/log/cowrie/cowrie.out",
    stderr_logfile => "${install_dir}/var/log/cowrie/cowrie.err",
    autorestart    => true,
    user           => $user,
    require        => Exec['Install/update requirements'],
  }
  
}
