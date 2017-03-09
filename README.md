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

### About these bindings

The `<leader>` key is a special key used to perform commands with a sequence of
keys.  The `<localleader>` key behaves as the `<leader>` key, but is *local* to
a buffer.  In particular, the above bindings only work in buffers with the
"tidal" file type set, e.g. files whose file type is `.tidal`

By default, there is no `<localheader>` set.  To define one, e.g. for use with
a comma (`,`), write this on your `.vimrc` file:

```vim
let maplocalleader=","
```

Reload your configuration (or restart Vim), and after typing `,ss` on a few
lines of code, you should see those being copied onto the Tidal interpreter on
the upper-right pane.

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

#### Development version of Tidal (x.y-dev)

If you are using Tidal from a development branch or another branch different
than *master*, you'll have to use the corresponding branch on vim-tidal.

Unfortunately Vundle doesn't support specific branches or tags when setting the
Plugin line, but you can **pin** the plugin. This way Vundle will only clone
the repo and not mess with it again. This also means from now on (while pinned)
you'll have to manage the repo yourself (i.e. go to the repo dir and `git
pull`, etc.)

To sum up, pin the plugin with this:

```vim
Plugin 'munshkr/vim-tidal', {'pinned': 1}
```

Then go to where your Vundle plugins reside (usually
`~/.vim/bundle/vim-tidal`), and change to the development branch. For example
if you are using Tidal 0.9-dev:

```bash
$ cd ~/.vim/bundle/vim-tidal
$ git pull
$ git checkout 0.9-dev origin/0.9-dev
```

## Configuration ##

By default, there are two normal keybindings and one for visual blocks using
your `<localleader>` key.  If you don't have one defined, set it on your
`.vimrc` script with `let maplocalleader=","`, for example.

You can configure tmux socket name and target pane by typing `<localleader>c`.

About the target pane:

* `":"` means current window, current pane (a reasonable default)
* `":i"` means the ith window, current pane
* `":i.j"` means the ith window, jth pane
* `"h:i.j"` means the tmux session where h is the session identifier (either
  session name or number), the ith window and the jth pane

### tidalvim ###

There are no options yet, but most of the variables fallback to their
respective environment variables, so they can be customized when running
`tidalvim` or by exporting them before calling the script.  For example:

```
TIDAL_TEMPO_IP=192.168.0.15 SESSION=whatever tidalvim
```

This would start Tidal synced to another Tidal on 192.168.0.16, and it would
try to attach or create a tmux sesssion called `whatever`.

The following is a list of all variables that can be changed:

* `FILE`: File name to open with Vim (default: `$(date +%F).tidal`, e.g.
  `2017-03-09.tidal`).  The `.tidal` extension is important (you can run
  `:setfiletype haskell.tidal` in case you won't use a .tidal file here).

* `SESSION`: Tmux session name (default: `tidal`)

* `TIDAL_TEMPO_IP`: Tells Tidal to sync tempo with another Tidal instance on
  the specified IP (default: `127.0.0.1`, i.e. use local)

* `GHCI`: GHCi command (default: `ghci`)

* `TMUX`: Tmux command (default: `tmux`)

* `BOOT_PATH`: Bootstrap .ghci file (Default: `Tidal.ghci`)

You can also edit `Tidal.ghci` to run something else on init, like defining
extra helper functions, or adding imports.
