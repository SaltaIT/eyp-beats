class saltstack::master::config inherits saltstack::master {

  file { '/etc/auditbeat/auditbeat.yml':
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => '0600',
    content => template("${module_name}/auditbeat/config.erb"),
  }
}
