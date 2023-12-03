## Fully-featured global themes coming, *be patient*

<div align="center">
    <h1>【 My ⭐ dotfiles 】</h1>
    <h3></h3>
</div>

<div align="center"> 

![](https://img.shields.io/github/last-commit/cherrynoize/dotfiles?&style=for-the-badge&color=FFB1C8&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/github/stars/cherrynoize/dotfiles?style=for-the-badge&logo=andela&color=FFB686&logoColor=D9E0EE&labelColor=292324)
[![](https://img.shields.io/github/repo-size/cherrynoize/dotfiles?color=CAC992&label=SIZE&logo=googledrive&style=for-the-badge&logoColor=D9E0EE&labelColor=292324)](https://github.com/cherrynoize/hyprland)
![](https://img.shields.io/badge/need-love-green?style=for-the-badge&color=CCE8E9&logoColor=D9E0EE&labelColor=292324) 

</div>

[Link to showcase](https://youtu.be/ph19WxzsCRg)

![preview](images/wpgtk1.png)

![preview](images/dash_ani1.gif)

These are my current dotfiles. I update them as I go and try to
strip all unnecessary stuff. Little by little.

## 🔧 Install

Though I'm planning to provide a setup script, you can just clone
the repo for now and then manually move things where they belong.

Something like

```
git clone https://github.com/cherrynoize/dotfiles
mv -n dotfiles/* ~
mv -n dotfiles/.* ~
```

should generally work. Please note that I've added the `-n`
no-clobber flag in `mv` commands, meaning existing files won't
be replaced and you should manually take care of that.

You also need to run

```
./setup.sh
```

from the repo directory. This is just a stub for a full installer
which should replace this `README` section entirely.

## 🔄 Update

From now on you can just run

```
cfg pull
```

and it should automatically update your dotfiles. (Please take
care of your own unstaged changes.)

## ⚙ Configuration

### .initrc

You should copy the `.github/initrc` file somewhere and source it
during startup. It provides configuration used all over the
place. To do this you can add something like:

```
[ -f ~/.initrc ] && . ~/.initrc
```

to your `~/.xinitrc`, `~/.xprofile` or whatever does the
magic for you.

`~/.initrc` is the recommended location, as that would be the
default install path once an installation script is completed.

Right now it's just a stub, but I plan on condensing
dotfiles-wide config as much as possible into this file.

### Wpgtk

This config uses [`wpgtk`](https://github.com/deviantfero/wpgtk)
for easier global theming and automatic colorscheme generation
with `pywal`.

You're going to need to refer to the [wiki](https://github.com/deviantfero/wpgtk/wiki)
if you want to start editing themes or creating your own.

Also, for better portability template symlinks are not hardcoded
and can be (re-)generated at anytime using `fix-wpg-templates`.

### Pfp

You might want to place your own profile picture inside of
`~/.pfp`. It can be any picture file with any name, such as
`~/.pfp/pfp.jpg`.

### Neovim

The `nvim` configuration is based upon [AstroNvim](https://github.com/AstroNvim/AstroNvim),
an IDE layer for **Neovim**. Check out the [docs](https://docs.astronvim.com/#%EF%B8%8F-configuration)
for info about configuration.

## 📁 Binaries

The repo also includes a large collection of shell scripts, some
[collected around the internet](.local/bin), but [most of
them](bin) are actually mine. Being each few hundreds LOC tops,
they're not very large (`bin` sits at *492K* at the time of
writing - Nov. 16 2023), and since they're heavily integrated
into my everyday system usage and used in most of my
configuration it made little sense leaving them out (or
separating them).

## $ Shell

Active development is currently only on `fish`. Config for other
shells such as `bash` or `zsh` is currently unmantained. They have
had previous support though and I occasionally work on `bash`
(whereas `zsh` is just some stolen configs), so the config files
are still there. (Not to mention `bash` is actually my current
login shell, `fish` gets launched from there.)

## 🎨 Themes

Themes are currently in alpha so please be nice. I'm setting up
themes for all sorts of things though - it just takes some time.

To change themes:

```
switch-theme [thing-to-change-theme-for] [new-theme]
```

List items that have themes:

```
switch-theme -l
```

And finally list available themes for given item:

```
switch-theme [item] -l
```

A `rofi` GUI for global theme switching is a *TODO* thing. But
first `switch-theme` needs some more cleaning, in case you want to
contribute.

### wpgtk

<details>
<summary></summary>

![preview](images/wpgtk_preview1.mp4)

![screenshot](images/wpgtk1.png)

</details>

### Dash

<details>
<summary></summary>

![preview](images/dash_ani1.gif)

![screenshot](images/dash1.png)

</details>

## 🧱 Dependencies

```
pacman -S bash
```

Optional (some are still needed for certain functionalities):

```
yay -S wpgtk pywalfox expect playerctl
```

`python` packages (optional):

```
pipx install country-converter
```

Not in the AUR* (nor in the official repo) (optional):

- [set-light](https://github.com/cherrynoize/set-light)
- [n3lock](https://github.com/cherrynoize/n3lock)

*\*Do submit a PR or let me know if this is outdated.*

## 🛠 Usage

### ⌘ Useful commands, aliases & shortcuts

You can find the whole configuration under
`.config/sxhkd/sxhkdrc`, but this is just some basic commands to
get you started. Also to remember commands which are not bound
to any key (such as the text-editor launcher).

#### Spawn terminal

    "$TERMINAL" # Super+shift

#### Application launcher

    rofi -show drun # Super+x

#### Run prompt

    rofi -show run # Super+r

#### Browser (Firefox)

    ff # Super+Alt+w

#### Text editor (Neovim)

    launch-nvim # 'nvim' points to that in fish/bash

#### Random wallpaper

    change-wallpaper # Super+Ctrl+w

#### Dark mode on/off

    switch-mode # Super+<

#### Toggle bar

    toggle-bar # Super+z

#### Fix common issues

    unfuck everything # Super+Shift+Esc

### ⌨ Keys

#### Neovim

    {Alt,Shift}+Tab            Move to next/previous tab
    Space;{Shift}+Tab          Move to next/previous buffer
    Alt+{h,j,k,l}              Move to adjacent window
    Ctrl+{h,j,k,l}             Move to adjacent window (wraparound)
    Ctrl+{Left,Up,Down,Right}  Resize window
    Space                      Help menu

#### Rofi

    {Tab,Shift}+Tab  Move to next/previous entry
    Shift+{h,j,k,l}  Vi-like navigation

### ✨ Tricks & tips

#### Auto-refresh sudo timeout

`sudo` privilege timeout for the shell is refreshed with `sudo
-v`. `fish` already has [an abbreviation set](.config/fish/fishrc)
to replace `sudo` with `sudo -v; sudo` so that it gets updated
each time. However, I find that cumbersome as well as annoying
to have that prefix to each command and it doesn't work well
with auto-completion/suggestions as well as with other
abbreviations, so you can call `sd` rather than `sudo`
to avoid all that. (Also, in case you're wondering, you cannot
use a function because that would enter an infinite loop.)

In case it conflicts with other programs in your system, just use
`sudo`.

### 🐛 Known bugs

#### eww

- Widget windows closers sometimes get stuck open, causing you to
accidentally open popup windows when clicking on other windows
rather than close them. To fix this you could restart `eww`,
but usually it's enough to click on the pfp icon that open the
panel window once to open it, then a second time to close it.
- `eww` tends to get on top of other windows after being
restarted during the session. I still haven't found how I could
prevent it from happening (all suggestions are welcome).

#### Music player cover

I currently use Spotify and as such I only set [`music`](bin/music)
to fetch cover arts from Spotify metadata. I will try to expand
on this but, please, if anyone has a specific request provide me
with a metadata sample (output of `playerctl --player="$player"
metadata mpris:artUrl`) and I'll add it.

## 🙏 Thanks

- [gh0stzk's dotfiles](https://github.com/gh0stzk/dotfiles) for
inspiration as well as a lot of code stolen especially for the
Rofi theme selector buttons
- [wacca〇わっか](https://www.pixiv.net/en/users/46612726) for
her amazing illustration collection
([meranii theme](.wallpaper-themes/meranii))

## 📋 TODO

### Bar

- Auto memorize bar status (open or closed) between sessions

### Wallpapers

- Convert to a higher compression format

### Install and configuration

- Installation script
- Finish making initrc
