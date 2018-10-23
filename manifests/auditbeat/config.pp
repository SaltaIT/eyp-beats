class beats::auditbeat::config inherits beats::auditbeat {

  file { '/etc/auditbeat/auditbeat.yml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/auditbeat/config.erb"),
  }

  file { '/etc/auditbeat/audit.rules.d':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => $beats::auditbeat::auditd_rules_recurse,
    purge   => $beats::auditbeat::auditd_rules_purge,
  }
}
