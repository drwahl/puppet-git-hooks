Looking for additional maintners.  I do not use puppet on a daily basis anymore, so I'd appreciate an extra
help ensuring this project meets the needs of the people using it.  Please contact me through github if you
are interested in helping maintain this project.  Thank you!

puppet-git-hooks
================

Git hooks to assist puppet module development.  Client side hooks allow for various checks before commits are staged.  Server side hooks are provided for infrastructural reinforcement of various standardization compliances.

Current supported pre-commit (client side) checks
=================================================

* Puppet manifest syntax
* Puppet epp template syntax
* Erb template syntax
* Puppet-lint
* Rspec-puppet
* Yaml (hiera data) syntax
* r10k puppetfile syntax

Current supported pre-receive (server side) checks
==================================================

* Puppet manifest syntax
* Puppet epp template syntax
* Erb template syntax
* Ruby syntax
* Puppet-lint
* Yaml (hiera data) syntax
* Check tag against metadata.json

Usage
=====

In your git repository you can symlink the pre-commit file from this repository to the .git/hooks/pre-commit of your repository you want to implement this feature.

```bash
$ ln -s /path/to/this/repo/puppet-git-hooks/pre-commit .git/hooks/pre-commit
```

If you are using git submodules this can be achieved by getting the gitdir from the .git file in your submodule and symlinking to that gitdir location/

```bash
$ cat .git
$ ln -s /path/to/this/repo/puppet-git-hooks/pre-commit ../path/to/git/dir/from/previous/command/hooks/pre-commit
```

deploy-git-hook
===============

  usage: deploy-git-hook -d /path/to/git/repository [-a] [-c] [-r] [-u]

    -h            this help screen
    -d path       install the hooks to the specified path
    -a            deploy pre-commit and pre-receive hooks
    -c            deploy only the pre-commit hook
    -r            deploy only the pre-receive hook
    -u            deploy only the post-update hook
    -g            enable to install in Git Lab repo custom_hooks

  returns status code of 0 for success, otherwise, failure

  examples:

  1) to install pre-commit and pre-receive the hooks to foo git repo:

    deploy-git-hook -d /path/to/foo -a

  2) to install only the pre-commit hook to bar git repo:

    deploy-git-hook -d /path/to/bar -c

  3) to install only the pre-commit and pre-receive hook to foobar git repo:

    deploy-git-hook -d /path/to/foobar -c -r

In a wrapper
===============
You can call from your own custom pre-commit. This allows you to combine these with your own checks

For example, if you've cloned this repo to ~/.puppet-git-hooks


The .git/hooks/pre-commit with your puppet code might look like this

```bash
#!/bin/bash

# my_other_checks

# puppet-git-hooks
if [ -e ~/.puppet-git-hooks/pre-commit ]; then
~/.puppet-git-hooks/pre-commit
fi
```

