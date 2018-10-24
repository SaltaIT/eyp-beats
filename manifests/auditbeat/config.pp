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

  if($beats::auditbeat::add_default_ruleset)
  {
    concat { '/etc/auditbeat/audit.rules.d/default_ruleset.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => File['/etc/auditbeat/audit.rules.d'],
    }

    concat::fragment{ 'default auditbeat ruleset':
      target  => '/etc/auditbeat/audit.rules.d/default_ruleset.conf',
      order   => '00',
      content => template("${module_name}/auditbeat/default_ruleset.erb"),
    }
  }
}
