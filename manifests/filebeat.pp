class beats::filebeat() inherits beats::params {

  package { 'filebeat':
    ensure  => 'installed',
    require => Class['beats'],
  }

  file { '/etc/filebeat/filebeat.yml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/filebeat/filebeat.erb"),
    require => Package['topbeat'],
  }

  service { 'filebeat':
    ensure  => 'running',
    enable  => true,
    require => File['/etc/filebeat/filebeat.yml'],
  }

}
