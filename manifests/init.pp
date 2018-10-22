#
class beats (
              $import_repo       = true,
              $logstashhost      = undef,
              $elasticsearchhost = undef,
              $version           = '6.x',
            ) inherits beats::params {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($import_repo)
  {
    if(!$beats::params::yumrepo)
    {
      exec { 'import key eyp-beats':
        command => 'curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -',
        unless  => 'apt-key list | grep \'Elasticsearch (Elasticsearch Signing Key) <dev_ops@elasticsearch.org>\'',
      }

      exec { 'add repo':
        command => "bash -c 'echo \"deb https://artifacts.elastic.co/packages/${version}/apt stable main\" >> /etc/apt/sources.list.d/beats.list; apt-get update'",
        unless  => "grep \"deb https://artifacts.elastic.co/packages/${version}/apt stable main\"/etc/apt/sources.list.d/beats.list"
        require => Exec['import key eyp-beats'],
      }
    }
    else
    {

      #sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
      exec { 'rpm import gpg eyp-beats repo':
        command => 'rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch',
        unless  => "bash -c 'rpm -q gpg-pubkey-$(cat ${srcdir}/GPG-KEY-elasticsearch | gpg --throw-keyids | grep \"^pub\" | awk \"{ print \\\$2 }\" | cut -f2 -d/ | tr [A-Z] [a-z])'",
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

      # [elastic-6.x]
      # name=Elastic repository for 6.x packages
      # baseurl=https://artifacts.elastic.co/packages/6.x/yum
      # gpgcheck=1
      # gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
      # enabled=1
      # autorefresh=1
      # type=rpm-md

      yumrepo { "elastic-${version}":
        baseurl  => "https://artifacts.elastic.co/packages/${version}/yum",
        descr    => "Elastic repository for ${version} packages",
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
        require  => Exec['rpm import gpg eyp-beats repo'],
      }
    }
  }
}
