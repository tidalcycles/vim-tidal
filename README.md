# vim-tidal #

A Vim plugin for [TidalCycles](http://tidal.lurk.org/), the language for live
coding musical patterns written in Haskell.

This plugin uses [tmux](https://tmux.github.io/), a known and loved terminal
multiplexer, for communicating with between Vim and the Tidal interpreter.
It was originally based on [vim-slime](https://github.com/jpalardy/vim-slime).

![](http://i.imgur.com/frOLFFI.gif)

## Getting Started ##

1. Start livecoding with Vim by simply running:

   ```bash
   $ tidalvim
   ```

   This creates a tmux session with Vim and Tidal running on different panes.

2. Write something like this:

   ```haskell
   d1 $ sound "bd sn"
   ```

3. While being on that line, press `<c-e>` (Control + E) to evaluate it.

   You should see Vim flash that line for a second and a chunk of text appear on
   your Tidal interpreter.  If you already have SuperDirt or other synth running,
   you should hear a kick and a snare :)


## Install ##

Make sure you have TidalCycles installed, with SuperDirt running. See [Getting
Started with Tidal](https://tidalcycles.org/getting_started.html) page for more
information.

### Install tmux ###

#### Ubuntu/Debian ####

You can install it from the main repos:

    $ sudo apt-get install tmux

#### OSX ####

    $ brew install tmux

#### Windows ####

There seems to be [a Cygwin package for
tmux](https://cygwin.com/cgi-bin2/package-cat.cgi?file=x86%2Ftmux%2Ftmux-1.9a-1&grep=tmux),
but I haven't tested this plugin on Windows anyway, so you are on your own here.

If you happen to make it work, let me know so I can update this section!

### Install plugin ###

You can download the latest release
[here](https://github.com/munshkr/vim-tidal/releases) and extract the contents
on your Vim directory (usually `~/.vim/`).  However, using a Vim plugins
manager like [Vundle](https://github.com/gmarik/Vundle.vim) or
[Pathogen](https://github.com/tpope/vim-pathogen/) is *highly recommended*.
Install one of those if you don't have one.  Check those links for
instructions.

For example, with Vundle you would:

  * Edit your `.vimrc` file and add these lines:

```vim
Plugin 'munshkr/vim-tidal'
```

  * Restart Vim and execute `:PluginInstall` to automatically download and
    install the plugins.

Finally, go to the plugin repository and run `make install`:

    $ cd ~/.vim/bundle/vim-tidal
    $ sudo make install

This creates symlinks on `/usr/local/bin` for `tidal` and `tidalvim` scripts.
You can remove them later if you want with `make uninstall`.

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


## Usage

This plugin comes bundled with two Bash scripts: `tidalvim` and `tidal`.

### `tidalvim`

`tidalvim` starts a tmux session with the screen horizontally splitted, having
Vim on the upper pane and the Tidal interpreter on the lower pane.  This is the
simplest way to start using Tidal with Vim.

You don't have to use `tidalvim` necessarily. If you have a more complex setup
or just want to use Vim outside of tmux, you can use `tidal`.  See below.

### `tidal`

`tidal` fires up GHCi (the Glasgow Haskell interpreter) and runs a bootstrap
file that loads Tidal up. `tidalvim` uses this script to start the Tidal
interpreter on the lower pane.  You can even use it standalone (without Vim) by
simply running `tidal` from your shell.

```haskell
$ tidal
GHCi, version 7.10.3: http://www.haskell.org/ghc/  :? for help
tidal> d1 $ sound "bd sn"
tidal> :t density 2 $ n "0 1"
density 2 $ n "0 1" :: Pattern ParamMap
```

So, in case you don't want to use `tidalvim`, just run the following on another
terminal:

```bash
tmux new-session -s tidal tidal
```

What `tidal` does is actually run `ghci` with the argument `-ghci-script
Tidal.ghci`.  [Tidal.ghci](Tidal.ghci) is found at the root of the repository,
and is responsible for bootstraping Tidal.  See Configure section for more on
how to customize Tidal bootstraping process.  Any extra arguments when running
`tidal` will be delegated to `ghci`.

### Commands

These are some of the commands that can be run from Vim command line:

* `:<range>TidalSend`: Send a `[range]` of lines. If no range is provided the
  current line is sent.

* `:TidalSend1 {text}`: Send a single line of text specified on the command
  line.

* `:TidalConfig`: Configure tmux socket name and target pane

* `:TidalSilence [num]`: Silence stream number `[num]` by sending `d[num]
  silence`.

* `:TidalPlay [num]`: Send first ocurrence of stream number `[num`] from the
  current cursor position.

* `:TidalHush`: Silences all streams by sending `hush`.

* `:TidalGenerateCompletions {path}`: Generate dictionary for Dirt-Samples completion (path is optional)

### Default bindings

Using one of these key bindings you can send lines to Tidal:

* `<c-e>` (Control+E), `<localleader>ss`: Send current inner paragraph.
* `<localleader>s`: Send current line or current visually selected block.

`<c-e>` can be called on either Normal, Visual, Select or Insert mode, so it is
probably easier to type than `<localleader>ss` or `<localleader>s`.

There are other bindings to control Tidal like:

* `<localleader>s[num]`: Call `:TidalPlay [num]`
* `<localleader>[num]`: Call `:TidalSilence [num]`
* `<localleader>h`, `<c-h>`: Call `:TidalHush`

#### About `<localleader>`

The `<leader>` key is a special key used to perform commands with a sequence of
keys.  The `<localleader>` key behaves as the `<leader>` key, but is *local* to
a buffer.  In particular, the above bindings only work in buffers with the
"tidal" file type set, e.g. files whose file type is `.tidal`

By default, there is no `<localleader>` set.  To define one, e.g. for use with
a comma (`,`), write this on your `.vimrc` file:

```vim
let maplocalleader=","
```

Reload your configuration (or restart Vim), and after typing `,ss` on a few
lines of code, you should see those being copied onto the Tidal interpreter on
the lower pane.


## Configure ##

### Default bindings ###

By default, there are two normal keybindings and one for visual blocks using
your `<localleader>` key.  If you don't have one defined, set it on your
`.vimrc` script with `let maplocalleader=","`, for example.

If you don't like some of the bindings or want to change them, add this line to
disable them:

```vim
let g:tidal_no_mappings = 1
```

See section Mappings on [ftplugin/tidal.vim](ftplugin/tidal.vim) and copy the
bindings you like to your `.vimrc` file and modify them.

### tmux target ###

You can configure tmux socket name and target pane by typing `<localleader>c`
or `:TidalConfig`.  This will prompt you first for the socket name, then for
the target pane.

About the target pane:

* `":"` means current window, current pane (a reasonable default)
* `":i"` means the ith window, current pane
* `":i.j"` means the ith window, jth pane
* `"h:i.j"` means the tmux session where h is the session identifier (either
  session name or number), the ith window and the jth pane

When you exit Vim you will lose that configuration. To make this permanent, set
`g:tidal_default_config` on your `.vimrc`.  For example, suppose you want to run
Tidal on a tmux session named `omg`, and the GHCi interpreter will be running
on the window 1 and pane 0.  In that case you would need to add this line:

```vim
let g:tidal_default_config = {"socket_name": "default", "target_pane": "omg:1.0"}
```

### Miscelaneous ###

When sending a paragraph or a single line, vim-tidal will "flash" the selection
for some milliseconds.  By default duration is set to 150ms, but you can modify
it by setting the `g:tidal_flash_duration` variable.

For customizing the startup script for defining helper functions, see below.


## `tidalvim` and `tidal` ##

`tidalvim`  is just an example script.  You can copy and customize it as much
as you want.  See `man tmux` if you want to know more about its options.

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


## Troubleshooting

Here is a list of common problems.

> I press `<c-e>` but it moves the screen down by one line, and nothing else happens

Usually `<c-e>` is used to move the screen forward by one line, but vim-tidal remaps
this to sending current paragraph. If this is happening you either:

1. Opened a file without `.tidal` extension, or changed file type accidentally.
   *Solution*: Reopen Vim or set filetype for current buffer with `:set
   ft=haskell.tidal`.
2. Have `g:tidal_no_mappings` setting on your `.vimrc`. This disables all
   mappings.
   *Solution*: Remove `<c-e>` binding, or rebind to something else.

> I press `<c-e>` and nothing else happens

This means that vim-tidal is sending text to tmux, but to the wrong
session/window/pane.
*Solution*: Check that you have configure the socket name and target pane
correctly.  See the Configure section above for more information.

If you have any question or something does not work as expected, there are many
channels you can go to:

* [Ask TidalCycles](http://ask.tidalcycles.org/questions/) Q&A
* Official [Tidal forum](http://lurk.org/groups/tidal/)
* [TOPLAP #tidal channel](http://toplap.org/toplap-on-slack/)
* [GitHub issues](https://github.com/munshkr/vim-tidal/issues/new)


## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/munshkr/vim-tidal>.  This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

Refer to the [LICENSE](LICENSE) file
