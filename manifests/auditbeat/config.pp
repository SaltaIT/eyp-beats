class beats::auditbeat::config inherits beats::auditbeat {

  file { '/etc/auditbeat/auditbeat.yml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/auditbeat/config.erb"),
  }
}
