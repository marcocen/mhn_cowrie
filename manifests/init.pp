# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mhn_cowrie { 'namevar': }
define mhn_cowrie (
  String $user,
  Stdlib::Host $hpf_server,
  String $hpf_id,
  String $hpf_secret,
  Stdlib::Port $port = 2222,
  Stdlib::Port $hpf_port = 10000,
  
) {
  $install_dir = '/opt/cowrie'

  ensure_packages(
    [gcc],
    {ensure => present},
  )
  
  if ! defined(Class['git']) {
    include ::git
  }

  if ! defined(User[$user]) {
    user {$user:
      ensure => present,
    }
  }

  if $port != 22 {
    firewalld::custom_service{ 'cowrie-ssh':
      short       => 'cowrie-ssh',
      description => 'Cowrie honeypot ssh port',
      port        => [
        {
          'port'     => "${port}", # Paso int a string
          'protocol' => 'tcp',
        },
      ],
    }
    ~>
    firewalld_service { 'Allow SSH connections to cowrie':
      ensure  => present,
      service => 'cowrie-ssh',
      zone    => 'public',
    }
  }
  
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
    require => [Vcsrepo[$install_dir],Class['python']],
  }

  exec {'Install/update requirements':
    command => "${install_dir}/cowrie-env/bin/pip install -r requirements.txt",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd     => $install_dir,
    user    => $user,
    require => Exec['Create virtualenv'],
  }

  file { "${install_dir}/etc/cowrie.cfg":
    ensure => present,
    content => template('mhn_cowrie/cowrie.cfg.erb'),
    require => Vcsrepo[$install_dir],
  }

  file_line {'DAEMONIZE':
    ensure => present,
    path => "${install_dir}/bin/cowrie",
    line => 'DAEMONIZE="-n"',
    match => 'DAEMONIZE=""',
    require => Vcsrepo[$install_dir],
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
    require        => [
      Exec['Install/update requirements'],
      File_line['DAEMONIZE'],
      User[$user],
    ],
    subscribe => [File["${install_dir}/etc/cowrie.cfg"]],
  }
  
}
