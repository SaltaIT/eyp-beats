class beats::auditbeat::service inherits beats::auditbeat {

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $beats::auditbeat::manage_docker_service)
  {
    if($beats::auditbeat::manage_service)
    {
      service { 'auditbeat':
        ensure => $beats::auditbeat::service_ensure,
        enable => $beats::auditbeat::service_enable,
      }

      if(defined(Class['::auditd']))
      {
        Service['auditbeat'] {
          require => Class['::auditd'],
        }
      }
    }
  }
}
