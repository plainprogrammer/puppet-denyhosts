# Class: denyhosts
#
#   This module manages the denyhosts service.
#
#   James Thompson <jamest@thereadyproject.com>
#   2013-01-17
#
#   Tested platforms:
#    - Ubuntu 10.04 LTS (32 & 64)
#    - Ubuntu 12.04 LTS (32 & 64)
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
                $ensure='running',
                $notification_email=undef
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

  if $notification_email == undef {
    # Do Nothing
  } else {
    $smtp_from = "DenyHosts Notice <denyhosts@${::fqdn}>"
    $smtp_subject = 'DenyHosts Notice'
  }

  case $::osfamily {
    RedHat: {
      $supported                = true
      $pkg_name                 = [ 'denyhosts' ]
      $svc_name                 = 'denyhosts'
      $config                   = '/etc/denyhosts.conf'
      $config_tpl               = 'denyhosts.conf.redhat.erb'
      $allowed_hosts_config     = '/etc/hosts.allow'
      $denied_hosts_config      = '/etc/hosts.deny'
    }
    Debian: {
      $supported                = true
      $pkg_name                 = [ 'denyhosts' ]
      $svc_name                 = 'denyhosts'
      $config                   = '/etc/denyhosts.conf'
      $config_tpl               = 'denyhosts.conf.debian.erb'
      $allowed_hosts_config     = '/etc/hosts.allow'
      $denied_hosts_config      = '/etc/hosts.deny'
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
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${config_tpl}"),
    require => Package[$pkg_name],
  }

  file { $allowed_hosts_config:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$pkg_name],
  }

  file { $denied_hosts_config:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$pkg_name],
  }

  denied_host { $always_deny:
    ensure  => 'present',
    service => 'ALL',
    require => File[$denied_hosts_config]
  }

  denied_host { $always_allow:
    ensure  => 'absent',
    service => 'ALL',
    require => File[$denied_hosts_config]
  }

  allowed_host { $always_allow:
    ensure  => 'present',
    service => 'ALL',
    require => File[$allowed_hosts_config]
  }

  allowed_host { $always_deny:
    ensure  => 'absent',
    service => 'ALL',
    require => File[$allowed_hosts_config]
  }

  service { 'denyhosts':
    ensure     => $ensure,
    enable     => $enable,
    name       => $svc_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[$pkg_name],
    subscribe  => [ File[$config],
                    File[$allowed_hosts_config],
                    File[$denied_hosts_config] ],
  }
}
