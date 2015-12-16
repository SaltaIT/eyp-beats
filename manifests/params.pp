class beats::params {

	case $::osfamily
	{
		'redhat':
    {

			case $::operatingsystemrelease
			{
				/^[67].*$/:
				{
					$yumrepo=true
          fail('TODO!')
				}
				default: { fail("Unsupported RHEL/CentOS version!")  }
			}
		}
		'Debian':
		{
			case $::operatingsystem
			{
				'Ubuntu':
				{
					case $::operatingsystemrelease
					{
						/^14.*$/:
						{
							$yumrepo=false
						}
						default: { fail("Unsupported Ubuntu version! - $::operatingsystemrelease")  }
					}
				}
				'Debian': { fail("Unsupported")  }
				default: { fail("Unsupported Debian flavour!")  }
			}
		}
		default: { fail("Unsupported OS!")  }
	}
}
