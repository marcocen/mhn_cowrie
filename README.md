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

This module ensures that git is installed, clones the cowrie repo and configures it. In doing so it ensures that python2.7, pip and virtualenv are installed; it also installs supervisord.

### Setup Requirements 

The supplied user is expected to be managed somewhere else, this module does not create any user.

This module also does not manage firewall rules nor does it manage other software that may collide with the cowrie honeypot. For example, if you want cowrie to listen on port 22 you should disable ssh on that port elsewhere.

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

Include usage examples for common use cases in the **Usage** section. Show your users how to use your module to solve problems, and be sure to include code examples. Include three to five examples of the most important or common tasks a user can accomplish with your module. Show users how to accomplish more complex tasks that involve different types, classes, and functions working in tandem.

## Reference

This section is deprecated. Instead, add reference information to your code as Puppet Strings comments, and then use Strings to generate a REFERENCE.md in your module. For details on how to add code comments and generate documentation with Strings, see the Puppet Strings [documentation](https://puppet.com/docs/puppet/latest/puppet_strings.html) and [style guide](https://puppet.com/docs/puppet/latest/puppet_strings_style.html)

If you aren't ready to use Strings yet, manually create a REFERENCE.md in the root of your module directory and list out each of your module's classes, defined types, facts, functions, Puppet tasks, task plans, and resource types and providers, along with the parameters for each.

For each element (class, defined type, function, and so on), list:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

For example:

```
### `pet::cat`

#### Parameters

##### `meow`

Enables vocalization in your cat. Valid options: 'string'.

Default: 'medium-loud'.
```

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other warnings.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
