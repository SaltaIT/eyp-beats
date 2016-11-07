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
class beats (
              $srcdir                  = '/usr/local/src',
              $import_repo             = true,
              $logstashhost            = undef,
              $elasticsearchhost       = undef,

            ) inherits beats::params {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($import_repo)
  {
    if(!$yumrepo)
    {
      exec { 'import key eyp-beats':
        command => 'curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -',
        unless => 'apt-key list | grep \'Elasticsearch (Elasticsearch Signing Key) <dev_ops@elasticsearch.org>\'',
      }

      exec { 'add repo':
        command => 'bash -c \'echo "deb https://packages.elastic.co/beats/apt stable main" >> /etc/apt/sources.list.d/beats.list; apt-get update\'',
        require => Exec['import key eyp-beats'],
      }
    }
    else
    {
      # fail('repo install failed: TODO')

      exec { 'which wget eyp-beats':
        command => 'which wget',
        unless  => 'which wget',
      }

      exec { "mkdir p eyp-beats ${srcdir}":
        command => "mkdir -p ${srcdir}",
        creates => $srcdir,
      }

      exec { 'wget beats gpgkey':
        command => "wget https://packages.elastic.co/GPG-KEY-elasticsearch -O ${srcdir}/GPG-KEY-elasticsearch",
        creates => "${srcdir}/GPG-KEY-elasticsearch",
        require => Exec[ [ 'which wget eyp-beats', "mkdir p eyp-beats ${srcdir}" ] ],
      }

      #sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
      exec { 'rpm import gpg eyp-beats repo':
        command => 'rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch',
        unless  => "bash -c 'rpm -q gpg-pubkey-$(gpg --throw-keyids < GPG-KEY-elasticsearch | grep \"^pub\" | awk \"{ print \\\$2 }\" | cut -f2 -d/ | tr [A-Z] [a-z])'",
        require => Exec['wget beats gpgkey'],
      }

      # Create a file with a .repo extension (for example, elastic.repo) in your /etc/yum.repos.d/ directory and add the following lines:
      #
      # [elastic-5.x]
      # name=Elastic repository for 5.x packages
      # baseurl=https://artifacts.elastic.co/packages/5.x/yum
      # gpgcheck=1
      # gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
      # enabled=1
      # autorefresh=1
      # type=rpm-md

      yumrepo { 'elastic-5.x':
        baseurl  => 'https://artifacts.elastic.co/packages/5.x/yum',
        descr    => 'Elastic repository for 5.x packages',
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
        require  => Exec['rpm import gpg eyp-beats repo'],
      }

    }


  }

}
