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
* r10k puppetfile syntax

Current supported pre-receive (server side) checks
==================================================

* Puppet manifest syntax
* Erb template syntax
* Puppet-lint
* Yaml (hiera data) syntax

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

You could also create an alias in your bashrc file using the deploy-git-hook script from this repository. The deploy-git-hook script assumes you cloned the puppet-git-hooks repository in your $HOME directory for now.

```bash
$ alias deploy-git-hook='. /path/to/this/repo/puppet-git-hooks/deploy-git-hook'

```

When you added the alias and sourced your .bashrc file you can deploy the git hook by executing the command

```bash
$ deploy-git-hook
pre-commit hook deployed to .git/hooks/pre-commit
```

The deploy script will figure out for you if it needs to deploy through a submodule or not.
