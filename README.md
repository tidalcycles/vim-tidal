# vim-tidal #

A Vim plugin for [Tidal](https://github.com/yaxu/Tidal).

Uses [tmux](http://tmux.sourceforge.net/) and it is based on
[vim-slime](https://github.com/jpalardy/vim-slime) for communication with Tidal
(ghci).

![](http://i.imgur.com/3aXukEq.png)

## Usage ##

You can start livecoding with Vim simply by running:

    $ tidalvim

This creates a tmux session with Vim, Tidal and Dirt running on different
panes.

Then, use one of these key bindings to send lines to Tidal:

* `<localleader>ss`: Send current inner paragraph (equivalent to
  doing `vip`).
* `<localleader>s`: Send current line or current visually selected block.

There are other bindings to control Tidal like:

* `<localleader>s[N]`: Send first ocurrence of stream number `[N]`
  from the current cursor position.
* `<localleader>[N]`: Silences stream number `[N]` by sending
  `d[N] silence`.
* `<localleader>h`: Silences all streams by sending `hush`.

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
Plugin 'munshkr/vim-tidal'
```

  * Restart Vim and execute `:PluginInstall` to automatically download and
    install the plugins.

Finally, go to the plugin repository and run `make` to install the `tidalvim`
script.

    $ cd ~/.vim/bundle/vim-tidal
    $ sudo make install

## Configuration ##

By default, there are two normal keybindings and one for visual blocks using
your `<localleader>` key.  If you don't have one defined, set it on your
`.vimrc` script with `let maplocalleader=","`, for example.

You can configure tmux socket name and target pane by typing `<localleader>c`.

About the target pane:

* ":" means current window, current pane (a reasonable default)
* ":i" means the ith window, current pane
* ":i.j" means the ith window, jth pane
* "h:i.j" means the tmux session where h is the session identifier (either
  session name or number), the ith window and the jth pane

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
