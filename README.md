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

Current supported pre-receive (server side) checks
==================================================

* Puppet manifest syntax
* Erb template syntax
* Puppet-lint
* Yaml (hiera data) syntax

Installation
============

Clone this repository

    git clone https://github.com/pixelated-project/puppet-git-hooks.git

Go in the git hooks directory of you puppet git repository

    cd <PATH_TO_YOUR_PUPPET_REPO>/.git/hooks

Create symlinks to the `pre-commit` file and the `commit_hooks` directory

    ln -s <PATH_TO_PUPPET-GIT-HOOKS_REPO>/pre-commit
    ln -s <PATH_TO_PUPPET-GIT-HOOKS_REPO>/commit_hooks
