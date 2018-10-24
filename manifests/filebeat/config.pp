class beats::filebeat::config inherits beats::filebeat {

  concat { '/etc/filebeat/filebeat.yml':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  concat::fragment{ 'filebeat.yml header':
    target  => '/etc/filebeat/filebeat.yml',
    order   => 'a00',
    content => template("${module_name}/filebeat/header.erb"),
  }

  concat::fragment{ 'filebeat.yml footer':
    target  => '/etc/filebeat/filebeat.yml',
    order   => 'z99',
    content => template("${module_name}/filebeat/config.erb"),
  }
}
