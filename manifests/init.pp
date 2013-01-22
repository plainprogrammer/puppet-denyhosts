# Class: denyhosts
#
#   This module manages the denyhosts service.
#
#   James Thompson <jamest@thereadyproject.com>
#   2013-01-17
#
#   Tested platforms:
#    - Ubuntu 12.04 LTS
#    - Ubuntu 10.04 LTS
#
# Parameters:
#
#   $always_allow = ['123.0.1.24']
#     List of IP Addresses to always allow
#
#   $always_deny = ['123.0.1.24']
#     List of IP Addresses to always deny
#
#   $use_sync = false
#     Whether to us the DenyHosts in synchronization mode
#
#   $autoupdate = false
#     Whether to update the denyhosts package automatically or not.
#
#   $enable = true
#     Automatically start denyhosts deamon on boot.
#
# Actions:
#
#  Installs, configures, and manages the denyhosts service.
#
# Requires:
#
# Sample Usage:
#
#   class { "denyhosts":
#     use_sync   => true,
#     autoupdate => false,
#   }
#
# [Remember: No empty lines between comments and class definition]
class denyhosts($always_allow=[],
                $always_deny=[],
                $use_sync=false,
                $autoupdate=false,
                $enable=true,
                $ensure='running'
) {

  if ! ($ensure in [ 'running', 'stopped' ]) {
    fail('ensure parameter must be running or stopped')
  }

  if $autoupdate == true {
    $package_ensure = latest
  } elsif $autoupdate == false {
    $package_ensure = present
  } else {
    fail('autoupdate parameter must be true or false')
  }

  if $use_sync == true {
    $sync_interval            = '8h'
    $sync_upload              = 'yes'
    $sync_download            = 'yes'
    $sync_download_threshold  = '5'
    $sync_download_resiliency = '4h'
  } elsif $use_sync == false {
    # Do nothing special
  } else {
    fail('use_sync parameter must be true or false')
  }

  case $::osfamily {
    Debian: {
      $supported                = true
      $pkg_name                 = 'denyhosts'
      $svc_name                 = 'denyhosts'
      $config                   = '/etc/denyhosts.conf'
      $config_tpl               = 'denyhosts.conf.erb'
      $allowed_hosts_config     = '/etc/hosts.allow'
      $allowed_hosts_config_tpl = 'hosts.allow.erb'
      $denied_hosts_config      = '/etc/hosts.deny'
      $denied_hosts_config_tpl  = 'hosts.deny.erb'
    }
    Redhat: {
      $supported                = true
      $pkg_name                 = 'denyhosts'
      $svc_name                 = 'denyhosts'
      $config                   = '/etc/denyhosts.conf'
      $config_tpl               = 'denyhosts.conf.erb'
      $allowed_hosts_config     = '/etc/hosts.allow'
      $allowed_hosts_config_tpl = 'hosts.allow.erb'
      $denied_hosts_config      = '/etc/hosts.deny'
      $denied_hosts_config_tpl  = 'hosts.deny.erb'
    }
    default: {
      fail("The ${module_name} module is not supported on ${::osfamily} based systems")
    }
  }

  package {'denyhosts':
    ensure => $package_ensure,
    name   => $pkg_name,
  }

  file { $config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/${config_tpl}"),
    require => Package[$pkg_name],
  }

  file { $allowed_hosts_config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/${allowed_hosts_config_tpl}"),
    require => Package[$pkg_name],
  }

  file { $denied_hosts_config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/${denied_hosts_config_tpl}"),
    require => Package[$pkg_name],
  }

  service { 'denyhosts':
    ensure     => $ensure,
    enable     => $enable,
    name       => $svc_name,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => [ Package[$pkg_name],
                    File[$config],
                    File[$allowed_hosts_config],
                    File[$denied_hosts_config] ],
  }
}