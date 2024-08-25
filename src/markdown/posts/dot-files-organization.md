% Dot File Management with GNU Stow

My dotfile managment and versioniong was mediocre at best. I had a dotfiles git repository where each branch represents a
different machine. However, making sure that I captured all my changes in git was challeging since there wasn't a link to from
the dot file to my dotfile repo. [GNU Stow] to the rescue! 

### What is GNU Stow?

[GNU Stow] manages sym links. That's all it does. It consolidates all the original
files in a singe location, but separated by packages. Each package, or directory,
contains the same directory structure as the location the original file is located. 

e.g. 

The following file: `xmonad/.xmonad/lib/Xmonad/Util/Brightness.hs`  will be stowed in the target directory at
`.xmonad/lib/Xmonad/Util/Brightness.hs`.

Typically the target directory is the parent of the package directory, but his can be changed via the `-t` option.

You can "stow" the config to the target directory by executing `stow xmonad`, and delete it by `stow -D xmonad`. However, I like
being explicit in my commands. There are some default options that I explicitly use. 

e.g. `stow xmonad` would be the same as `stow -St ~ xmonad`. 

### Migrating to Stow

I had my dotfiles directory in my home directory that is versioned using git.

```
~/dotfiles
```

I originally had a flat directory structure where all dotfiles resided in this main
directory.  To start using stow, I had to create sub directories for each stow `package`. The result is the following:

```
~/dotfiles$ tree -d 
.
├── bash
├── git
├── local
├── sbt
├── vim
└── xmonad
```

Migrating to this setup was pretty easy. I created the package directory, mimicing the directory structure of the target
file(s) I want to stow, along with empty files with the same name as the target. 


e.g.

```
cd ~/dotfiles
mkdir -p xmonad/.xmonad/lib/Xmonad/Util/
touch Brightness.hs
```

Then, I used the `--adopt` flag to move the files from my home directory to the package
directory, then create the symbolic link using `stow`. Before doing any real modifications, 
I always used the `--no` flag to just do a trial run of executing the command along with the
`-v` flag for a more verbose output.

e.g.

To test the command:
`stow --adopt --no -vSt ~ xmonad`

To finally execute the command. 
`stow --adopt -vSt ~ xmonad`

I repeated the process for all my dotfiles using different packages them into different packages.

Here's the final result for the `xmonad` package.

```
~/dotfiles$ find xmonad -type f
xmonad/.xmonad/lib/XMonad/Util/Brightness.hs
xmonad/.xmonad/xmobar.hs
xmonad/.xmonad/xmonad-session-rc
xmonad/.xmonad/xmonad.hs
~/dotfiles$ cd
~$ find .xmonad -type l -ls
 26345986      4 lrwxrwxrwx   1 freddie  freddie        65 Sep  6 14:06 .xmonad/lib/XMonad/Util/Brightness.hs -> ../../../../dotfiles/xmonad/.xmonad/lib/XMonad/Util/Brightness.hs
 24117849      0 lrwxrwxrwx   1 freddie  freddie        36 Sep  6 14:06 .xmonad/xmobar.hs -> ../dotfiles/xmonad/.xmonad/xmobar.hs
 24117857      0 lrwxrwxrwx   1 freddie  freddie        44 Sep  6 14:06 .xmonad/xmonad-session-rc -> ../dotfiles/xmonad/.xmonad/xmonad-session-rc
 24117860      0 lrwxrwxrwx   1 freddie  freddie        36 Sep  6 14:06 .xmonad/xmonad.hs -> ../dotfiles/xmonad/.xmonad/xmonad.hs
```

[gnu-stow]: https://www.gnu.org/software/stow/

_2020-Oct-04_
