class beats::filebeat (
                        $index          = 'filebeat',
                        $paths          = $beats::params::filebeat_paths_default,
                        $scan_frequency = '10s',
                        $outfilepath    = undef,
                      ) inherits beats {

  validate_array($filebeat_paths)

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
    require => Package['filebeat'],
  }

  service { 'filebeat':
    ensure  => 'running',
    enable  => true,
    require => File['/etc/filebeat/filebeat.yml'],
  }

}
