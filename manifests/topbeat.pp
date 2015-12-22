class beats::topbeat(
                      $period='60',
                      $index='topbeat',
                      $logstashhost=undef,
                      $elasticsearchhost=undef,
                      $filepath=undef
                    ) inherits beats::params {

  package { 'topbeat':
    ensure => 'installed',
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
