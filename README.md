## Strategy

The goal of this project is to increase the number of Gemfile.lock merges which can be resolved automatically. This does not mean never encountering a merge conflict.

Currently this has a minimal understanding of bundler/rubygems rules and version solving logic, and is just a more syntax-aware diff.
This could change in the future to validate the end result or possibly allow some more agressive merging, but for now at least I prefer the simpler approach.

This intended as a git "merge driver", which git can be configured to run instead of git's default text diff/merging logic.
The standard diff/merge gets (understandable) confused when adjacent lines are merged in separate branches, for example if you update `rack` in one branch and add `rack-test` in another.
By writing a merge driver which is aware 

This is a three-way merge, meaning that git feeds us three versions of the file, the base/original, and then the file from each of the branches being merged.
This allows us to do an intelligent merge, we don't just pick the newest gem version from the two, but reapply whatever upgrade/downgrade was done in either branch.
Currently this is very strict, and two branches upgrading a gem to two different versions will result in a conflict (I could see adding an option for a looser merge, but I'd like to gain confidence in this approach first).


## Setup

**in `.gitconfig`**
```
[merge "bundler"]
  name = Gemfile.lock merge driver
  driver = bundler-merge %A %O %B
```

**in a project's `.gitattributes`**
```
Gemfile.lock merge=bundler
```

##

