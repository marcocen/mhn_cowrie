# cowrie

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with cowrie](#setup)
    * [What cowrie affects](#what-cowrie-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cowrie](#beginning-with-cowrie)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

A module to add a cowrie honeypot 

## Setup

### What cowrie affects

This module ensures that git is installed, clones the cowrie repo and
configures it. In doing so it ensures that python2.7, pip and
virtualenv are installed; it also installs supervisord.

### Setup Requirements 

The supplied user is expected to be managed somewhere else, this
module does not create any user.

This module also does not manage firewall rules nor does it manage
other software that may collide with the cowrie honeypot. For example,
if you want cowrie to listen on port 22 you should disable ssh on that
port elsewhere.

### Beginning with cowrie

```
mhn_cowrie{'cowrie':
	user       => 'cowrie',
	hpf_server => 'mhn.local',
	hpf_id     => '91ded218-eaec-11e9-954a-000c299b8253',
    hpf_secret => 'LId9U19VHuQOUnTU',
}
```

## Usage

The following is a full usage case where the cowrie user is created
and the firewall port is opened.

```
firewalld::custom_service{ 'cowrie_ssh':
  short       => 'cowrie-ssh',
  description => 'Cowrie ssh service',
  port        => [
    {
      'port'     => '2232',
      'protocol' => 'tcp',
    },
  ],
}

user {'cowrie':
  ensure => present,
}

mhn_cowrie{'cowrie':
  user       => 'cowrie',
  port       => 2232
  hpf_server => 'mhn.local',
  hpf_port   => 4237
  hpf_id     => '91ded218-eaec-11e9-954a-000c299b8253',
  hpf_secret => 'LId9U19VHuQOUnTU',
  require    => User['cowrie']
}
```

## Reference

### `mhn_cowrie`

#### Parameters

##### `user`

The user that the cowrie service will be run as.

##### `port`

The port where cowrie will listen for ssh connections.

Defaults to 2222.

##### `hpf_server`

The HPFeeds server, in the intended use-case this will be the MHN
server.

##### `hpf_port` 

The port where your HPF server accepts reports.

Defaults to 10000

##### `hpf_id`

The UUID that this honeypot will report as to the HPF server.

##### `hpf_secret`

The secret that this honeypot will use to communicate with the HPF
server.


## Limitations

As mentioned previously, this module does not create any users and
does not manage ports or the services that run on them.

This module is only tested con CentOS7. It might work on other RHEL7
based distros but there are no warranties.

## Development

Any contributions are welcome in the form of Pull Requests on the main
github repo.
