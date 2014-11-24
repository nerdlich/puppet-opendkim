class opendkim::config inherits opendkim {

    file { '/etc/opendkim.conf':
        ensure  => present,
        content => template('opendkim/opendkim.conf.erb'),
    }

}
