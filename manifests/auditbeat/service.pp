class beats::auditbeat::service inherits beats::auditbeat {
  #
  validate_bool($beats::auditbeat::manage_docker_service)
  validate_bool($beats::auditbeat::manage_service)
  validate_bool($beats::auditbeat::service_enable)

  validate_re($beats::auditbeat::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${beats::auditbeat::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $beats::auditbeat::manage_docker_service)
  {
    if($beats::auditbeat::manage_service)
    {
      service { $saltstack::params::master_service_name:
        ensure => $beats::auditbeat::service_ensure,
        enable => $beats::auditbeat::service_enable,
      }
    }
  }

}
