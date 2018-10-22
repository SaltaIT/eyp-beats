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
      $yumrepo=true
      case $::operatingsystemrelease
      {
        /^6.*$/:
        {
          $audit_file_default='/etc/audit/audit.rules'
        }
        /^7.*$/:
        {
          $audit_file_default='/etc/audit/rules.d/eyp-audit.rules'
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
      $yumrepo=false
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $audit_file_default='/etc/audit/audit.rules'
            }
            /^16.*$/:
            {
              $audit_file_default='/etc/audit/audit.rules'
            }
            /^18.*$/:
            {
              $audit_file_default='/etc/audit/rules.d/audit.rules'
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
