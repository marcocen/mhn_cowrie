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

The following is a full usage case where every parameter is configured

```
mhn_cowrie{'cowrie':
  user       => 'cowrie',
  port       => 2232
  hpf_server => 'mhn.local',
  hpf_port   => 4237
  hpf_id     => '91ded218-eaec-11e9-954a-000c299b8253',
  hpf_secret => 'LId9U19VHuQOUnTU'
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

If you want cowrie to listen on port 22 you should make the
appropriate changes somewhere else in you manifest:
- Change the port that the real ssh service listens on
- Make the appropriate changes in the firewall

This module is only tested con CentOS7. It might work on other RHEL7
based distros but there are no warranties.

## Development

Any contributions are welcome in the form of Pull Requests on the main
github repo.
