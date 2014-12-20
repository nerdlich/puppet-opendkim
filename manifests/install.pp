class opendkim::install inherits opendkim {

    ensure_packages([$package_name])
    ensure_packages([$extra_packages])

    # Directory to store keys
    file { '/etc/opendkim':
        ensure => directory,
        mode   => '0755',
    }->
    file { "/etc/opendkim/${service_identifier}":
        ensure  => directory,
        mode    => '0700',
    }

}
