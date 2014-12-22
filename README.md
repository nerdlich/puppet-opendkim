# opendkim

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with opendkim](#setup)
    * [What opendkim affects](#what-opendkim-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with opendkim](#beginning-with-opendkim)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A Puppet module to manage OpenDKIM. Support for multiple mail cluster
nodes, automatic key rotation and DNS records. Currently limited to the
Debian/Ubuntu world.

## Module Description

This module takes care of installing and configuring OpenDKIM as well as
creating signing keys and synchronizing them to mail cluster neighbours.
Keys are automatically rotated as recommended by MAAWG [^1] and the
public key parts are exported and can be automagically configured on a
DNS server managed by Puppet.

## Setup

### What opendkim affects

* Installation of package opendkim
* Configuration (/etc/opendkim.conf)
* Key management in /etc/opendkim/${service_identifier}
* Keys are stored in facts in /etc/facter/facts.d/dkim_keys_${service_identifier}.txt

### Setup Requirements

* pluginsync
* stored configs
* facter >2.0.3

### Beginning with opendkim

Just include the class and specify mandatory parameters:
* domains: array of domains which should be signed
* service_identifier: a name for your cluster (even if there is only
  one node)
* genkey_node: hostname of the 'master' node where keys are generated
  (even if there is only one node)
* internal_hosts: array of IPs/networks that are internal and whose
  mail will be signed (or name of a file containing a list of this,
  alternatively)

## Usage

To verify incoming mail and sign outgoing from private networks and
for domains example.com and example.org:

    class { 'opendkim':
        service_identifier => 'example_mail_gateway',
        genkey_node        => 'example_hostname',
        mode               => 'sv',
        domains            => ['example.com', 'example.org'],
        internal_hosts     => ['192.168.0.0/16','10.0.0.0/8'],
    }

To import public key information as fact on a DNS node:

    class { 'opendkim::config::dns':
        service_identifier => 'example_mail_gateway',
    }

## Limitations

Currently limited to Debian/Ubuntu.

## Development

Please create pull requests if you would like to contribute.

## Contributors


[^1]: https://www.maawg.org/sites/maawg/files/news/M3AAWG_Key_Implementation_BP-2012-11.pdf
