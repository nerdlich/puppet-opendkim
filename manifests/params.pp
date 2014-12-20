class opendkim::params {

    case $::osfamily {
        'Debian': {
              $package_name   = 'opendkim'
              $extra_packages = 'opendkim-tools'
              $service_name   = 'opendkim'
              $user           = 'opendkim'
              $group          = 'opendkim'
        }
        default: {
            fail("Not supported OS family ${::osfamily}")
        }
    }

}
