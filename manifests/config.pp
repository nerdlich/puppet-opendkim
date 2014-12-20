class opendkim::config inherits opendkim {

    $timestamp_0 = chomp(generate('/bin/date', '--date=+1 month', '+%Y%m'))
    $timestamp_1 = chomp(generate('/bin/date', '+%Y%m'))
    $timestamp_2 = chomp(generate('/bin/date', '--date=-1 month', '+%Y%m'))
    $timestamp_3 = chomp(generate('/bin/date', '--date=-2 month', '+%Y%m'))

    $opendkim_keys = [
        "${selector_name}_${timestamp_0}",
        "${selector_name}_${timestamp_1}",
        "${selector_name}_${timestamp_2}",
        "${selector_name}_${timestamp_3}",
    ]

    $selector = $opendkim_keys[1]

    file { '/etc/opendkim.conf':
        ensure  => present,
        content => template('opendkim/opendkim.conf.erb'),
    }

    # generate keys on one host only to avoid race conditions
    if ($::hostname == $genkey_node) {
        opendkim::config::key { $opendkim_keys:
            service_identifier => $::opendkim::service_identifier,
            user               => $::opendkim::params::user,
            group              => $::opendkim::params::group,
        }
    }
    # import private keys on all other mail hosts
    else {
        ensure_resource('file', "/etc/facter/facts.d/dkim_keys_${service_identifier}.txt", {
            ensure => present,
            mode   => 0600,
            owner  => 'root',
            group  => 'root',
        })
        File <<| tag == "dkim_keys_${service_identifier}_priv" |>>
        File_line <<| tag == "dkim_keys_${service_identifier}_priv" |>>
    }

    # export a list of all keys and domains which they're used for to be able to add records on a dns master
    # the TXT values themselves are exported in config::key
    if ($::hostname == $genkey_node) {
        $domains_keys = getvar("dkim_domains_keys_${service_identifier}")
        @@file_line { "dkim_domains_keys_${service_identifier}":
            path => "/etc/facter/facts.d/dkim_keys_${service_identifier}.txt",
            line => "dkim_domains_keys_${service_identifier}=${domains_keys}",
            tag  => "dkim_keys_${service_identifier}_txt",
        }
    }

}
