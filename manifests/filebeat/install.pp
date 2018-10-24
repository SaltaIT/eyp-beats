class beats::filebeat::install inherits beats::filebeat {

  if($beats::filebeat::manage_package)
  {
    package { 'filebeat':
      ensure => $beats::filebeat::package_ensure,
    }
  }
}
