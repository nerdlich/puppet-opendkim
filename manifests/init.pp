# == Class: opendkim
#
# Puppet module to manage OpenDKIM.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'opendkim':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class opendkim (
    $genkey_node,
    $service_identifier,
    $domains,
    $internal_hosts,
    $add_all_signature_results = 'no',
    $always_add_ar_header = 'yes',
    $authserv_id = $::hostname,
    $canonicalization = 'relaxed/relaxed',
    $mode = 'sv',
    $oversign_headers = [ 'From' ],
    $selector_name = 'mail',
    $socket = 'inet:12331@localhost',
) inherits opendkim::params {

    $dom      = any2array($domains)
    $inthosts = any2array($internal_hosts)

    class {'opendkim::install': } ->
    class {'opendkim::config': }  ~>
    class {'opendkim::service': } ->
    Class['opendkim']

}
