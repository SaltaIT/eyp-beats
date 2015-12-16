# == Class: beats
#
# Full description of class beats here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'beats':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class beats($import_repo=true, $beats=[ 'topbeat' ]) inherits beats::params {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($import_repo)
  {
    exec { 'import key':
      command => 'curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -',
      unless => 'apt-key list | grep \'Elasticsearch (Elasticsearch Signing Key) <dev_ops@elasticsearch.org>\'',
    }

    if(!$yumrepo)
    {
      exec { 'add repo':
        command => 'bash -c \'echo "deb https://packages.elastic.co/beats/apt stable main" >> /etc/apt/sources.list.d/beats.list; apt-get update\'',
        require => Exec['import key'],
      }
    }
    else
    {
      #TODO!
    }

    
  }

}
