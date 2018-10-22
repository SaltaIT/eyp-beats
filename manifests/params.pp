class beats::params {

  case $::osfamily
  {
    'redhat':
    {
      $filebeat_paths_default = [
                                  '/var/log/messages',
                                  '/var/log/secure',
                                  '/var/log/yum.log',
                                  '/var/log/cron',
                                  '/var/log/maillog',
                                ]
      case $::operatingsystemrelease
      {
        /^[67].*$/:
        {
          $yumrepo=true
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
    'Debian':
    {
      $filebeat_paths_default = [
                                  '/var/log/auth.log',
                                  '/var/log/syslog',
                                  '/var/log/dpkg.log',
                                  '/var/log/mail.log',
                                ]
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^1[468].*$/:
            {
              $yumrepo=false
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
