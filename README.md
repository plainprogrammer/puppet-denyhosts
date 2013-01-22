DenyHOSTS
=========

[![Build Status](https://travis-ci.org/plainprogrammer/puppet-denyhosts.png)](https://travis-ci.org/plainprogrammer/puppet-denyhosts)

This module allows for the installation and management of [DenyHOSTS](http://denyhosts.sourceforge.net).

Platforms
---------

This module has been tested on the following platforms:

* Ubuntu 12.04 LTS

Requirements
------------

This module has no external dependencies.

Installation
------------

  puppet module install readyproject/denyhosts

Usage
-----

The easiest way to use this module is to declare a class and provide the desired options:

    class { "denyhosts":
        use_sync   => true,
        autoupdate => false,
    }

Supported Parameters
--------------------

List of IP Addresses to always allow

    $always_allow = ['123.0.1.24']

List of IP Addresses to always deny

    $always_deny = ['123.0.1.24']

Whether to us the DenyHosts in synchronization mode

    $use_sync = false

Whether to update the denyhosts package automatically or not.

    $autoupdate = false

Automatically start denyhosts deamon on boot.

    $enable = true
