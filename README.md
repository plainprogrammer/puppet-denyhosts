DenyHOSTS
=========

[![Build Status](https://travis-ci.org/plainprogrammer/puppet-denyhosts.png)](https://travis-ci.org/plainprogrammer/puppet-denyhosts)

This module allows for the installation and management of [DenyHOSTS](http://denyhosts.sourceforge.net).

Platforms
---------

This module has been tested on the following target operating systems:

* Ubuntu 10.04 LTS (32 & 64)
* Ubuntu 12.04 LTS (32 & 64)

This modules has also been tested against the following versions of Puppet:

* 3.0.2
* 2.7.20
* 2.6.17

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

Contributing
------------

Contributing is easy, unless you're lazy.

1. Create an Issue and get feedback
2. Fork the project
3. Branch and develop with tests
4. Submit a Pull Request

It is very important that your changes be tested, both via RSpec test and in reality by running via Vagrant. It is also
very important that you don't try and code-fist the project. Keep your development focused on one particular feature or
bug. Small and focused sets of changes are easier to accept as Pull Requests.
