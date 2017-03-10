# vim-tidal #

A Vim plugin for [TidalCycles](http://tidal.lurk.org/).

Uses [tmux](https://tmux.github.io/) and it is based on
[vim-slime](https://github.com/jpalardy/vim-slime) to communicate with the
Tidal interpreter (GHCi).

![](http://i.imgur.com/aTRDv2w.png)

## Usage ##

You can start livecoding with Vim simply by running:

    $ tidalvim

This creates a tmux session with Vim and Tidal running on different panes.

Then, using one of these key bindings you can send lines to Tidal:

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
the lower pane.


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

### Configure ###

You probably need to set a local leader binding and configure tmux target pane.
See the "Configuration" section below for more detailed instructions.

### Development version of Tidal (x.y-dev) ###

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

You can change the default target pane by setting `let g:tidal_default_config`
on your `.vimrc`.  For example, suppose you want to run Tidal on a tmux session
named `omg`, and the GHCi interpreter will be running on the window 1 and pane
0.  In that case you would need to set:

```vim
let g:tidal_default_config = {"socket_name": "default", "target_pane": "omg:1.0"}
```

For customizing the startup script for defining helper functions, see below.


## `tidalvim` and `tidal` ##

This plugin comes bundled with two Bash scripts: `tidal` and `tidalvim`.

`tidal` fires up GHCi and runs a bootstrap file that loads Tidal up. You can
even use it standalone (without Vim) by simply running `tidal` from your shell.

```bash
$ tidal
GHCi, version 7.10.3: http://www.haskell.org/ghc/  :? for help
tidal> d1 $ sound "bd sn"
tidal> :t density 2 $ n "0 1"
density 2 $ n "0 1" :: Pattern ParamMap
```

`tidalvim` starts a tmux session (named `tidal`), with Vim on the upper pane
and Tidal on the lower pane.  This is just an example script.  You can copy and
customize it as much as you want.  See `man tmux` if you want to know more
about its options.

For example, if you want to split horizontally instead of vertically, change
the `-v` for `-h` option in the `split-window` line:

```diff
- split-window -v -t $SESSION   \; \
+ split-window -h -t $SESSION   \; \
```

Both scripts have some options that you can specify as environment variables.
For example:

```
TIDAL_TEMPO_IP=192.168.0.15 SESSION=whatever tidalvim
```

This would start Tidal synced to another Tidal on 192.168.0.15, and it would
try to attach or create a tmux sesssion called `whatever`.

The following is a list of all variables that can be changed:

* `FILE`: File name to open with Vim (default: `$(date +%F).tidal`, e.g.
  `2017-03-09.tidal`).  The `.tidal` extension is important (you can run
  `:setfiletype haskell.tidal` in case you won't use a .tidal file here).

* `SESSION`: tmux session name (default: `tidal`)

* `TIDAL_BOOT_PATH`: Tidal Bootstrap file, a .ghci file (default: `Tidal.ghci`)

* `TIDAL_TEMPO_IP`: Tells Tidal to sync tempo with another Tidal instance on
  the specified IP (default: `127.0.0.1`, i.e. use local)

* `VIM`: Vim command (default: `vim`)

* `GHCI`: GHCi command (default: `ghci`)

* `TMUX`: tmux command (default: `tmux`)


### Customizing Tidal startup ###

In case you have defined some helper functions, and/or you want to import other
modules into Tidal, you can edit the `Tidal.ghci` found at the root of the
repository.

However doing this could eventually cause conflicts when trying to upgrade
vim-tidal, so instead I recommend that you define a different `.ghci` file that
first loads `Tidal.ghci` and includes all your custom definitions.

Here is an example.  Suppose you define a `myStuff.ghci` file on your home
directory like this:

```haskell
--file: ~/myStuff.ghci

-- Bootstrap Tidal
-- Replace this path if you have vim-tidal installed elsewhere
:script ~/.vim/bundle/vim-tidal/Tidal.ghci

:{
let foo = every 4 $ within (0.75, 1) (density 4)
    bar = n "<0 1 2 4>"
:}
```

Then, you would run `tidal` or `tidalvim` with `TIDAL_BOOT_PATH` pointing to
your new script file:

```bash
TIDAL_BOOT_PATH=~/myStuff.ghci tidalvim
```

Please note that this a `.ghci` script, not a Haskell module. So multiline
definitions need to be wrapped around `:{` and `:}`, as shown in the example
above.


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/munshkr/vim-tidal. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

Refer to the LICENSE file
