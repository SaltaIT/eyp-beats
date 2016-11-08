#
# filebeat.yml concat:
#
# 00 - header + filebeat config
# 09 - filebeat general config
# 10 - output config
# 20 - shipper config
# 30 - logging config
#
class beats::filebeat (
                        $index          = 'filebeat',
                        $paths          = $beats::params::filebeat_paths_default,
                        $scan_frequency = '10s',
                        $outfilepath    = undef,
                      ) inherits beats {

  validate_array($paths)

  package { 'filebeat':
    ensure  => 'installed',
    require => Class['beats'],
  }

  concat { '/etc/filebeat/filebeat.yml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['filebeat'],
  }

  concat::fragment { 'filebeat header + filebeat config':
    target  => '/etc/filebeat/filebeat.yml',
    order   => '00',
    content => template("${module_name}/filebeat/filebeat.erb"),
  }

  concat::fragment { 'filebeat general filebeat config':
    target  => '/etc/filebeat/filebeat.yml',
    order   => '09',
    content => template("${module_name}/filebeat/general_filebeat.erb"),
  }

  concat::fragment { 'filebeat output config':
    target  => '/etc/filebeat/filebeat.yml',
    order   => '10',
    content => template("${module_name}/output.erb"),
  }

  concat::fragment { 'filebeat shipper config':
    target  => '/etc/filebeat/filebeat.yml',
    order   => '20',
    content => template("${module_name}/shipper.erb"),
  }

  concat::fragment { 'filebeat logging config':
    target  => '/etc/filebeat/filebeat.yml',
    order   => '30',
    content => template("${module_name}/logging.erb"),
  }

  service { 'filebeat':
    ensure  => 'running',
    enable  => true,
    require => Concat['/etc/filebeat/filebeat.yml'],
  }

}
