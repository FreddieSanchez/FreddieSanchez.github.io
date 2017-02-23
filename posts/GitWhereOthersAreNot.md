%Using Git Where Other are Not

## Scenario
Code is typically developed and compiled on remote servers. Compilation can take anywhere between 30 min-1hr depending on the files changed.

### Releases
Separate major releases are maintained where new functionality and fixes can be added. Sometimes the same fix has to be added to multiple releases.

### Builds
For each release, builds are done to pick up new functions and bug fixes for that specific release. Directories are created for these builds. A one off change can be compiled and tested by creating another directory, referred to as a delta, with symbolic links to the base directory. 

## Motivation

I want to be able to edit code on my own machine instead of relying on a network connection to these servers.

* Edit code offline
* Check syntax errors locally without having to compile
* Take advantage of the rich feature set of Vim 7.X and other tools not available on the remote systems.
* Use a Git rather than versioned directories that have full copies of the differences. 

## Git Branching Model

Each release will have it's own branch. Fixes will be based off of these branches and can be rebased.

## Releveling Release

The releases will be changing over time. Therefore, the release branch will have to 'relevled' to incorporate these new changes. Manually copying all these files over from the remote systems to my local system is a waste of time and resources. Git comes to the rescue again. 

### Setting up remote system
1. Create a Repository on a remote system that has access to the builds.
```git init --git-dir=./.git```
2. Add files from one of the build directories
```git --git-dir=./.git --work-tree=<base-build-dir> add '*.[ch]'```

3. Commit the updates
```git commit -am "Initial build"```

This will take quite a while since there are so many files. However, after the first commit, releveling and pulling/merging is quite fast.

### New build increment
When deciding to relevel, the first thing you need to do is update your remote repo. Only including files that were originally added. New files will have to be added manually. 

```
git --git-dir=./.git --work-tree=<new-build-dir> add -u '*.[ch]'
git commit -am "Upleveled to $1"
```
### Fetch/Pull on local system.
1. Checkout the release. 
```git checkout releaseX```
2. Pull the changes from the remote - using theirs files to avoid having to manually merge the changes. 
```git pull --strategy-option=theirs remote-host:remote-repo```

