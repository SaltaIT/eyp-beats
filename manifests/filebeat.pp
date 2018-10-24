#
# filebeat.yml concat:
#
# 00 - header + filebeat config
# 05 - tomcatlog
# 09 - filebeat general config
# 10 - output config
# DELETED 20 - shipper config
# 30 - logging config
#
class beats::filebeat (
                        $manage_package              = true,
                        $package_ensure              = 'installed',
                        $manage_service              = true,
                        $manage_docker_service       = true,
                        $service_ensure              = 'running',
                        $service_enable              = true,
                        $logstash_hosts              = [],
                        $elasticsearch_hosts         = [],
                      ) inherits beats {

  include ::beats

  Class['::beats'] ->
  class { '::beats::filebeat::install': } ->
  class { '::beats::filebeat::config': } ~>
  class { '::beats::filebeat::service': } ->
  Class['::beats::filebeat']
}
