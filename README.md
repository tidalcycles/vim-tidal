# vim-tidal #

A Vim plugin for Tidal.

## Features ##

  * Start Dirt and Tidal instance from the editor
  * Uses [vim-slime](https://github.com/jpalardy/vim-slime) to communicate with
    Tidal (ghci) via tmux.

## Dependencies ##

  * [tmux](http://tmux.sourceforge.net/)
  * [vim-slime](https://github.com/jpalardy/vim-slime)

## Install tmux ##

tmux is used to communicate between Vim and Tidal.

### Ubuntu/Debian ###

You can install it from the main repos:

    $ sudo apt-get install tmux

### OSX ###

    $ brew install tmux

### Windows ###

There seems to be [a Cygwin package for
tmux](https://cygwin.com/cgi-bin2/package-cat.cgi?file=x86%2Ftmux%2Ftmux-1.9a-1&grep=tmux),
but I haven't tested this plugin on Windows anyway, so you are on your own here.

If you happen to make it work, let me know so I can update this text!


## Install the plugin ##

A Vim plugins manager like [Vundle](https://github.com/gmarik/Vundle.vim) or
[Pathogen](https://github.com/tpope/vim-pathogen/) is *highly recommended*.
Install one of those if you don't have one.
Check those links for instructions.

### Using Vundle ###

  * Edit your `.vimrc` file and add these lines:

```vim
Plugin "https://github.com/munshkr/vim-tidal"
Plugin "https://github.com/jpalardy/vim-slime"
```

  * Restart Vim and execute `:PluginInstall` to automatically download and
    install the plugins.

