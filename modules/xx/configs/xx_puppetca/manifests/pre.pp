class xx_puppetca::pre () {

  class { 'nginx':
    default_structure => true,
    status            => '82';
  }

  nginx::site {
    'default':
      source => template("${module_name}/etc/nginx/sites-available/default.erb");
    'puppetmaster':
      source => template("${module_name}/etc/nginx/sites-available/puppetmaster.erb");
  }

  nginx::conf {
    'general.conf':
      source => "puppet:///${module_name}/etc/nginx/conf.d/general.conf";
  }

}
