class beats::topbeat(
                      $period            = '60',
                      $outfilepath     = undef,
                      $index           = 'topbeat',
                    ) inherits beats {

  package { 'topbeat':
    ensure  => 'installed',
    require => Class['beats'],
  }

  concat { '/etc/topbeat/topbeat.yml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['topbeat'],
  }

  concat::fragment { 'topbeat header config':
    target  => '/etc/topbeat/topbeat.yml',
    order   => '00',
    content => template("${module_name}/topbeat/topbeat.erb"),
  }

  concat::fragment { 'topbeat output config':
    target  => '/etc/topbeat/topbeat.yml',
    order   => '10',
    content => template("${module_name}/output.erb"),
  }

  concat::fragment { 'topbeat shipper config':
    target  => '/etc/topbeat/topbeat.yml',
    order   => '20',
    content => template("${module_name}/shipper.erb"),
  }

  concat::fragment { 'topbeat logging config':
    target  => '/etc/topbeat/topbeat.yml',
    order   => '30',
    content => template("${module_name}/logging.erb"),
  }

  service { 'topbeat':
    ensure  => 'running',
    enable  => true,
    require => Concat['/etc/topbeat/topbeat.yml'],
  }

}
