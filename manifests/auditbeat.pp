class beats::auditbeat(
                        $manage_package        = true,
                        $package_ensure        = 'installed',
                        $manage_service        = true,
                        $manage_docker_service = true,
                        $service_ensure        = 'running',
                        $service_enable        = true,
                        $audit_files           = [ $beats::params::audit_file_default ],
                        $shipper_name          = undef,
                        $tags                  = [],
                        $fields                = {},
                      ) inherits beats::params {

  include ::beats

  Class['::beats'] ->
  class { '::beats::auditbeat::install': } ->
  class { '::beats::auditbeat::config': } ~>
  class { '::beats::auditbeat::service': } ->
  Class['::beats::auditbeat']
}
