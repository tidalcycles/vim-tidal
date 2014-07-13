# vim-tidal #

A Vim plugin for [Tidal](https://github.com/yaxu/Tidal).

Uses [tmux](http://tmux.sourceforge.net/) and
[vim-slime](https://github.com/jpalardy/vim-slime) to communicate with
Tidal (ghci).

![](http://i.imgur.com/3aXukEq.png)

## Usage ##

You can start livecoding with Vim simply by running:

    $ tidalvim

This creates a tmux session with Vim, Tidal and Dirt running on different
panes.

Then, use one of these key bindings to send lines to Tidal:

    * `<localleader>s`: Send current line or current visually selected block.
    * `<localleader>ss`: Send current inner paragraph (equivalent to doing `vip`).

## Install ##

### Install tmux ###

tmux is used to communicate between Vim and Tidal.

#### Ubuntu/Debian ####

You can install it from the main repos:

    $ sudo apt-get install tmux

#### OSX ####

    $ brew install tmux

#### Windows ####

There seems to be [a Cygwin package for
tmux](https://cygwin.com/cgi-bin2/package-cat.cgi?file=x86%2Ftmux%2Ftmux-1.9a-1&grep=tmux),
but I haven't tested this plugin on Windows anyway, so you are on your own here.

If you happen to make it work, let me know so I can update this text!

### Install plugin ###

A Vim plugins manager like [Vundle](https://github.com/gmarik/Vundle.vim) or
[Pathogen](https://github.com/tpope/vim-pathogen/) is *highly recommended*.
Install one of those if you don't have one.
Check those links for instructions.

For example, using Vundle:

  * Edit your `.vimrc` file and add these lines:

```vim
Plugin "https://github.com/jpalardy/vim-slime"
Plugin "https://github.com/munshkr/vim-tidal"
```

  * Restart Vim and execute `:PluginInstall` to automatically download and
    install the plugins.

Finally, create a symbolic link to `tidalvim` from somewhere along your `PATH`,
for example:

    $ sudo ln -s ~/.vim/bundle/vim-tidal/bin/tidalvim /usr/local/bin/

## Configuration ##

By default, there are two normal keybindings and one for visual blocks using
your `<localleader>` key.  If you don't have one defined, set it on your
`.vimrc` script with `let maplocalleader=","`.

Check `:help slime` on how to remap these keybindings.

### tidalvim ###

*TODO* There are no options yet, but there are some variables inside `tidalvim`
that you can change:

```bash
DEFAULT_PATH=~
DEFAULT_FILE=foo.tidal
DIRT_PATH=~/dirt
DIRT_OPTIONS=
```

* `DEFAULT_PATH` is where Vim will start up.
* `DEFAULT_FILE` is the file that will open first. The `.tidal` extension is
  important (you can run `:setfiletype haskell.tidal` in other case)
* `DIRT_PATH` is where Dirt lies.
* `DIRT_OPTIONS` are extra command-line options (like `--channels` or
  `--no-dirty-compressor`).

You can also edit `BootTidal.hss` to run something else on init, like
connecting to a Dirt [on a different
machine/host](https://github.com/yaxu/Tidal/wiki/Multi-laptop-Tidal).
