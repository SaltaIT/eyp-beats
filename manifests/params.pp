class beats::params {

  case $::architecture
  {
    'x86_64': { $arch64=true }
    'amd64': { $arch64=true }
    default: { $arch64=false }
  }

  case $::osfamily
  {
    'redhat':
    {
      $sysconfig=true
      $filebeat_paths_default = [
                                  '/var/log/messages',
                                  '/var/log/secure',
                                  '/var/log/yum.log',
                                  '/var/log/cron',
                                  '/var/log/maillog',
                                ]
      $yumrepo=true
      case $::operatingsystemrelease
      {
        /^[67].*$/:
        {
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
    'Debian':
    {
      $sysconfig=false
      $filebeat_paths_default = [
                                  '/var/log/auth.log',
                                  '/var/log/syslog',
                                  '/var/log/dpkg.log',
                                  '/var/log/mail.log',
                                ]
      $yumrepo=false
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^1[468].*$/:
            {
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
