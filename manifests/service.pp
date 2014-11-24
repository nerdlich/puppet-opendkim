class opendkim::service inherits opendkim {

    service { $service_name:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => false, # exits with 0 if not running on ubuntu
        pattern    => '/usr/sbin/opendkim',
    }

}
