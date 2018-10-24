class beats::filebeat::service inherits beats::filebeat {

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
