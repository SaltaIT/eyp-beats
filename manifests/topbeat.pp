class beats::topbeat($period='10') inherits beats::params {

  package { 'topbeat':
    ensure => 'installed',
  }

}
