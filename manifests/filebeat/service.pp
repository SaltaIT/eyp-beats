class beats::filebeat::service inherits beats::filebeat {
  #
  validate_bool($beats::filebeat::manage_docker_service)
  validate_bool($beats::filebeat::manage_service)
  validate_bool($beats::filebeat::service_enable)

  validate_re($beats::filebeat::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${beats::filebeat::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $beats::filebeat::manage_docker_service)
  {
    if($beats::filebeat::manage_service)
    {
      service { 'filebeat':
        ensure => $beats::filebeat::service_ensure,
        enable => $beats::filebeat::service_enable,
      }
    }
  }

}
