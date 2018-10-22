class beats::auditbeat::install inherits beats::auditbeat {

  if($beats::auditbeat::manage_package)
  {
    package { 'auditbeat':
      ensure => $beats::auditbeat::package_ensure,
    }
  }
}
