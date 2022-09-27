# vim-tidal #

A Vim/NeoVim plugin for [TidalCycles](http://tidalcycles.org), the language for
live coding musical patterns written in Haskell.

This plugin by default uses [tmux](https://tmux.github.io/), a known and loved
terminal multiplexer, for communicating with between Vim and the Tidal
interpreter.  It was originally based on
[vim-slime](https://github.com/jpalardy/vim-slime).

![](http://i.imgur.com/frOLFFI.gif)

If you are using Vim8 or NeoVim, you can use the native Terminal feature instead
of tmux. Read the Configuration section on how to enable it.

[![asciicast](https://asciinema.org/a/224891.svg)](https://asciinema.org/a/224891)

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

Make sure you have TidalCycles installed, with SuperDirt running. See [the Tidal wiki](https://tidalcycles.org/index.php/Userbase) for more information.

### Install tmux ###

#### Ubuntu/Debian ####

You can install it from the main repos:

    $ sudo apt-get install tmux

#### OSX ####

    $ brew install tmux

#### Windows ####

There seems to be [a Cygwin package for
tmux](https://cygwin.com/cgi-bin2/package-cat.cgi?file=x86%2Ftmux%2Ftmux-1.9a-1&grep=tmux),
but at present it is [not working](https://github.com/microsoft/terminal/issues/5132#issuecomment-604560893) with any known terminal emulator for Windows. As such, this plugin has only been tested with the *Windows native* build of [Neovim](https://github.com/tidalcycles/vim-tidal#neovim-terminal-target).


### Install plugin ###

I recommend using a Vim plugin manager like
[Plug](https://github.com/junegunn/vim-plug).  Check the link for instructions
on installing and configuring.  If you don't want a plugin manager, you can
also download the latest release
[here](https://github.com/tidalcycles/vim-tidal/releases) and extract the
contents on your Vim directory (usually `~/.vim/`).

For example, with Plug you need to:

  * Edit your `.vimrc` file and add these lines:

```vim
Plug 'tidalcycles/vim-tidal'
```

  * Restart Vim and execute `:PlugInstall` to automatically download and
    install the plugins.

#### UNIX-based Systems ####

If you are on a UNIX-based operating system (Linux distributions, MacOS, etc.), go to the plugin repository and run `make install`:

(if you are using NeoVim and you won't run tmux then you don't need to run `make install` to be able to load the plugin inside NeoVim)

    $ cd ~/.vim/plugged/vim-tidal
    $ sudo make install

This creates symlinks on `/usr/local/bin` for `tidal` and `tidalvim` scripts.
You can remove them later if you want with `make uninstall`.

#### Windows ####

:warning: **This plugin has only been tested on Windows 10 using Neovim >0.5**

If you are on Windows, add the `vim-tidal\bin` directory to your `PATH` user environment variable:

    1. Click the `Start` button
    2. Type "Edit the system environment variables" and hit `enter` or click on the search result
    3. Click the button labeled `Environment variables...`
    4. In the `User variables for [username]` table, click the entry for the `Path` variable, followed by the `Edit...` button beneath the same table
    5. Click the `New` button in the following dialog, enter the *full path* to the `vim-tidal\bin` directory, and click `OK` until all the preceding dialogs are closed.

Note: The full path to the `vim-tidal\bin` directory, will look something like `C:\Users\[username]\AppData\Local\nvim\plugged\vim-tidal\bin`, assuming you are using vim-plug as this document recommends.

#### Final Installation Note ####

Make sure to have the `filetype plugin on` setting on your .vimrc, otherwise
plugin won't be loaded when opening a .tidal file.

### Older Tidal versions (pre 1.0) ###

Tidal 1.0 introduces some breaking changes, so if haven't upgraded yet, you can
still use this plugin with an older version. Just point your Plug entry to use
the `tidal-0.9` branch.

First change your Plug line on your `.vimrc` to:

```vim
Plug 'tidalcycles/vim-tidal', {'branch': 'tidal-0.9'}
```

Then on Vim run `:PlugInstall` to update your plugin.


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

* `:TidalGenerateCompletions {path}`: Generate dictionary for Dirt-Samples
  completion (path is optional).

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

### GHCI

By default, `vim-tidal` uses the globally installed GHCI to launch the REPL.
If you have installed Tidal through Stack (`stack install tidal`) or some other
means, you can specify another command to use with `g:tidal_ghci`.

For example, if one installed Tidal with Stack, they would use:

```vim
let g:tidal_ghci = "stack exec ghci --"
```

### Tidal Boot File

A "Tidal boot file" is a file that may be used to initialise Tidal within GHCI.
A custom boot file can be specified using the `g:tidal_boot` variable.

In the case that `g:tidal_boot` is unspecified, vim-tidal will traverse parent
directories until one of either `BootTidal.hs`, `Tidal.ghci` or `boot.tidal` are
found.

If no tidal boot file can be found by traversing parent directories, tidal will
check the `g:tidal_boot_fallback` variable for a fallback boot file. This
variable is useful for specifying a default user-wide tidal boot file on your
system, while still allowing each tidal project to optionally use their own
dedicated, local tidal boot file. By default, `g:tidal_boot_fallback` will point
to the `Tidal.ghci` file provided with this plugin.

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

### Vim Terminal

On both Vim (version 8 or above) and NeoVim, the default target in which we boot
Tidal with GHCi is the native terminal.

While it is the default, it can also be specified manually with the following:

```vim
let g:tidal_target = "terminal"
```

Open a file with a `.tidal` suffix, write and send a line of code to tidal, and
the tidal terminal will open in a window below your editor.

Use standard vim window navigation controls to focus the terminal (ie `<C-w> down/up`)

You can learn more about the native Vim terminal here:

https://vimhelp.org/terminal.txt.html

### tmux (alternative to Vim terminal)

Before Vim had native terminal support, this plugin provided a "tmux" target in
order to allow for multiplexing the user's terminal via the 3rd party CLI tool.
If you have `tmux` installed and you wish to use it instead of the native Vim
terminal, you can enable this target with the following:

```vim
let g:tidal_target = "tmux"
```

This target will be enabled automatically in the case that the version of Vim in
use does not have native terminal support.

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

### Optional Supercollider Terminal

Vim-tidal provides an option for automatically running the supercollider
command-line tool `sclang` alongside the Tidal GCHI terminal. By default this
terminal is disabled, however it can be enabled with the following:

```vim
let g:tidal_sc_enable = 1
```

This can be useful to avoid the need to manually run sclang in a separate
terminal or to open the supercollider IDE.

A custom supercollider boot file can be specified by assigning its path to the
`g:tidal_sc_boot` variable.

In the case that `g:tidal_sc_boot` is unspecified, vim-tidal will traverse
parent directories until one of either `boot.sc` or `boot.scd` are found.

If no supercollider boot file can be found by traversing parent directories,
tidal will check the `g:tidal_sc_boot_fallback` variable for a fallback boot
file. This variable is useful for specifying a default user-wide supercollider
boot file on your system, while still allowing each tidal project to optionally
use their own dedicated, local supercollider boot file.

By default, `g:tidal_sc_boot_fallback` will point to the `boot.sc` file provided
with this plugin which simply starts SuperDirt with the default settings.

### Miscellaneous ###

When sending a paragraph or a single line, vim-tidal will "flash" the selection
for some milliseconds.  By default duration is set to 150ms, but you can modify
it by setting the `g:tidal_flash_duration` variable.

Write the paste buffer to an external text file:

```vim
let g:tidal_paste_file = "/tmp/tidal_paste_file.txt"
```

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
   ft=tidal`.
2. Have `g:tidal_no_mappings` setting on your `.vimrc`. This disables all
   mappings.
   *Solution*: Remove `<c-e>` binding, or rebind to something else.

It could also be that you do not have `filetype plugin on` setting in your
.vimrc.  Make sure you have that setting defined.

> I press `<c-e>` and nothing else happens

This means that vim-tidal is sending text to tmux, but to the wrong
session/window/pane.
*Solution*: Check that you have configure the socket name and target pane
correctly.  See the Configure section above for more information.

If you have any question or something does not work as expected, there are many
channels you can go to:

* [Chat](https://talk.lurk.org/): Reach out at the `#tidal` and `#vim` channels
* [GitHub issues](https://github.com/tidalcycles/vim-tidal/issues/new)
* [Official Tidal forum](https://we.lurk.org/postorius/lists/tidal.we.lurk.org/)


## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/tidalcycles/vim-tidal>.  This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.


## License

Refer to the [LICENSE](LICENSE) file
