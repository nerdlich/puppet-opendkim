# == Class: opendkim
#
# Puppet module to manage OpenDKIM.
#
# === Parameters
#
# [*genkey_node*]
#   Hostname of the cluster node where keys are created.
#
# [*service_identifier*]
#   Service or cluster name, e.g. customer name
#
# [*domains*]
#   Array of domains whose mail should be signed
#
# [*internal_hosts*]
#   Array of internal IPs/networks whose mail should be signed
#
# [*add_all_signature_results*]
#   Report results for all signatures found in a Authentication-Results header field
#
# [*always_add_ar_header*]
#   Always add Authentication-Results header field
#
# [*authserv_id*]
#   Sets the authserv-id in Authentication-Results
#
# [*canonicalization*]
#   Selects the canonicalization method(s) to be used when signing messages (Header/Body)
#
# [*mode*]
#   Sets operating modes: (s)ign, (v)verify
#
# [*oversign_headers*]
#   Array of header fields to be signed twice to prevent from faking a second one
#
# [*selector_name*]
#   The selector name for each key - '_YYYYMM' will be appended
#
# [*socket*]
#   The socket address where the milter will listen
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
