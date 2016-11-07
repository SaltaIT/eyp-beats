class beats::topbeat(
                      $period            = '60',
                      $outfilepath     = undef,
                      $index           = 'topbeat',
                    ) inherits beats {

  package { 'topbeat':
    ensure  => 'installed',
    require => Class['beats'],
  }

  file { '/etc/topbeat/topbeat.yml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/topbeat/topbeat.erb"),
    require => Package['topbeat'],
  }

  service { 'topbeat':
    ensure  => 'running',
    enable  => true,
    require => File['/etc/topbeat/topbeat.yml'],
  }

}
