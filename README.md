puppet-git-hooks
================

Git hooks to assist puppet module development.  Client side hooks allow for various checks before commits are staged.  Server side hooks are provided for infrastructural reinformence of various standardaizations compliance.

Current supported pre-commit (client side) checks
=================================================

* Puppet manifest syntax
* Erb template syntax
* Puppet-lint
* Rspec-puppet
* Yaml (hiera data) syntax

Current supported pre-recieve (server side) checks
==================================================

* Puppet manifest syntax
* Erb template syntax
* Puppet-lint
* Yaml (hiera data) syntax
