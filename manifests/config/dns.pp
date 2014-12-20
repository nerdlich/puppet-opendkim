define opendkim::config::dns(
    $service_identifier = $title,
) {

    ensure_resource('file', "/etc/facter/facts.d/dkim_keys_${service_identifier}.txt", {
        ensure => present,
        mode   => 0600,
        owner  => 'root',
        group  => 'root',
    })
    File_line <<| tag == "dkim_keys_${service_identifier}_txt" |>>

}
