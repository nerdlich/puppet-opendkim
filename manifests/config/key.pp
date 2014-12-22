define opendkim::config::key(
    $key_name = $title,
    $service_identifier,
    $user,
    $group,
) {

    exec { "generate-dkim-key-${key_name}":
        command => "opendkim-genkey -r -b 1024 -D /etc/opendkim/${service_identifier} -s ${key_name} && chmod 0600 /etc/opendkim/${service_identifier}/* && chown ${user}:${group} /etc/opendkim/${service_identifier}/*",
        creates => "/etc/opendkim/${service_identifier}/${key_name}.private",
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
    }

    # export the private key file and its content as "exported fact"
    $privkey = getvar("dkim_key_${service_identifier}_${key_name}_priv")
    @@file { "/etc/opendkim/${service_identifier}/${key_name}.private":
        owner   => $user,
        group   => $group,
        mode    => 0600,
        content => base64('decode', $privkey),
        tag     => "dkim_keys_${service_identifier}_priv",
    }
    @@file_line { "dkim_key_${service_identifier}_${key_name}_priv":
        path => "/etc/facter/facts.d/dkim_keys_${service_identifier}.txt",
        line => "dkim_key_${service_identifier}_${key_name}_priv=${privkey}",
        tag  => "dkim_keys_${service_identifier}_priv",
    }

    # export the ready to use TXT record as "exported fact"
    $pubkey = getvar("dkim_key_${service_identifier}_${key_name}_txt")
    @@file_line { "dkim_key_${service_identifier}_${key_name}_txt":
        path => "/etc/facter/facts.d/dkim_keys_${service_identifier}.txt",
        line => "dkim_key_${service_identifier}_${key_name}_txt=${pubkey}",
        tag  => "dkim_keys_${service_identifier}_txt",
    }

}
