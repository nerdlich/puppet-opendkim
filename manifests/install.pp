class opendkim::install inherits opendkim {

    ensure_packages([$package_name])
    ensure_packages([$extra_packages])

    # Directory to store keys
    file { '/etc/opendkim':
        ensure => directory,
        mode   => '0755',
    }->
    file { "/etc/opendkim/${hostname}":
        ensure  => directory,
        mode    => '0700',
    }->

    # Maintenance script
    file { '/etc/opendkim/dkim-maintenance':
        ensure => present,
        mode   => '0700',
        source => 'puppet:///modules/opendkim/dkim-maintenance',
    }
    cron { 'dkim-maintenance':
        command => '/etc/opendkim/dkim-maintenance',
        user    => 'root',
        minute  => '47',
        hour    => '8',
    }

}
