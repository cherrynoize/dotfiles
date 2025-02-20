<div align="center">
    <h1>✨ Dotfiles</h1>
    <h3></h3>
</div>

<div align="center"> 

![](https://img.shields.io/github/last-commit/cherrynoize/dotfiles?logo=github&style=for-the-badge&color=ffb1c8&logoColor=d9e0ee&labelColor=292324)
![](https://img.shields.io/github/stars/cherrynoize/dotfiles?style=for-the-badge&logo=andela&color=FFB686&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/github/repo-size/cherrynoize/dotfiles?color=CAC992&label=SIZE&logo=googledrive&style=for-the-badge&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/badge/need-love-green?style=for-the-badge&color=CCE8E9&logoColor=D9E0EE&labelColor=292324) 

</div>

<div align="center"> 

</div>

The config aims to work on both X11 and Wayland systems. The code might be a
bit messy at the moment, but it's ever changing (and hopefully improving).

Since I shifted towards Wayland I stopped actively updating the `bspwm` config,
and now I write most scripts to be able to run on both X11 and Wayland. A lot
of the config is still independent of your display manager, which means you
can in most cases use at least some part of this config.

## 📸 Preview

### 🎨 Themes

| Ai |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/ai1.png" align="center">|

| Akane |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/akane1.png" align="center">|

| Ishida |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/ishida1.png" align="center">|

| Mayuri |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/mayuri1.png" align="center">|

| Meranii |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/meranii1.png" align="center">|

| Misato |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/misato1.png" align="center">|

| Nina |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/nina1.png" align="center">|

| Sakura |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/sakura1.png" align="center">|

| Shina |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/shina1.png" align="center">|

| Shinji |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/shinji1.png" align="center">|

| Shoko |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/shoko1.png" align="center">|

| Sosuke |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/sosuke1.png" align="center">|

### 🌞 Light mode

<details>
<summary>All themes also have a light mode available <i>(click for preview)</i></summary>

| Sosuke (light) |
|:-:|
|<img src="https://raw.githubusercontent.com/cherrynoize/theme/main/preview/sosuke-light1.png" align="center">|

</details>

> Screenshots may not always be up-to-date. You can check themes out by running
> `theme-picker`.

### 🚀 Apps/widgets

> Note: these are only some specific themes for these
> [contexts](https://github.com/cherrynoize/theme#context-themes), therefore
> using each theme you might see a different style for the same application.

| <img src="preview/apps/floorp.png" align="center"> | <img src="preview/apps/floorp-newtab.png" align="center"> |
| :-: | :-: |
| Floorp (Firefox) |

| Wall picker | Theme picker |
|:-:|:-:|
| <img src="preview/apps/wall-picker.png" align="center"> | <img src="preview/apps/theme-picker.png" align="center"> |

|<img src="preview/apps/dunst.png" align="center">|<img src="preview/apps/ranger.png" align="center">|<img src="preview/apps/rofi.png" align="center">|
|:-:|:-:|:-:|
| Dunst | Ranger | Rofi |

| Logout menu | Screenlock |
|:-:|:-:|
|<img src="preview/apps/logout.png" align="center">|<img src="preview/apps/screenlock.png" align="center">|

### 🕸️ Old

<details>
<summary>Click for preview</summary>

https://github.com/cherrynoize/dotfiles/assets/104397138/50e9ba94-3640-4bcf-a30c-9856d7a19024

![preview](preview/old/wpgtk1.png)

![preview](preview/old/dash_ani1.gif)

![preview](preview/old/dash1.png)

![preview](preview/old/rofi1.png)

![preview](preview/old/eww1.png)

![preview](preview/old/firefox1.png)

![preview](preview/old/poly1.png)

![preview](preview/old/powermenu1.png)

![preview](preview/old/ranger1.png)

![preview](preview/old/screenlock1.png)

</details>

## 🧱 Dependencies

```
# Official repos (Arch):
bash
# AUR:
picom-ftlabs-git
```

### For added functionalities (*optional*)

```
# Official repos (Arch):
geoclue2
# AUR:
expect playerctl
```

To install all of the above (*on Arch*) run:

```
sudo pacman -S bash geoclue2
yay -S picom-ftlabs-git expect playerctl
```

### Not in the AUR (or any other repo)*

#### Required

- [theme](https://github.com/cherrynoize/theme)

#### Optional

- [set-light](https://github.com/cherrynoize/set-light)
- [n3lock](https://github.com/cherrynoize/n3lock)

> **[Correct me if I'm wrong.](https://github.com/cherrynoize/dotfiles/pulls)*

## 🔧 Setup

I'm working on a setup script. You can clone
the repo for now and manually move things where they belong.

Something like

```
git clone https://github.com/cherrynoize/dotfiles
cd dotfiles
./.github/install.sh
```

should work. The installation script is still a stub, and you'll
also need to move things where they belong:

```
mv -n * ~
mv -n .* ~
```

Note the `-n` (no-clobber) flag, meaning existing files won't
be replaced and you should manually take care of that.

## 🔄 Update

From now on you can just run:

```
cfg pull
```

and it should automatically update your dotfiles. (Please, take
care of your own unstaged changes.)

## ⚙ Configuration

### .initrc

You need to source `~/.initrc` during startup. It provides
configuration used all over the place. To do this you can add
something like:

```
[ -f ~/.initrc ] && . ~/.initrc
```

to your `~/.xinitrc`, `~/.xprofile`. You can just execute it
from your WM if you're on Wayland.

### Environment variables

To set environmental variables used throughout the dotfiles,
add to your `~/.profile`:

```
[ -f ~/.env ] && . ~/.env
```

And make sure your display manager sources `~/.profile` for
Wayland sessions. You can add the line above in any other file
sourced at login.

### Wpgtk

This config uses [theme](https://github.com/cherrynoize/theme)
which in turn uses [wpgtk](https://github.com/deviantfero/wpgtk)
for easier global theming and automatic colorscheme generation
with `pywal`.

For better portability template symlinks are not hardcoded
and can be regenerated anytime using `fix-wal-templates` and
`fix-wpg-templates`.

>**Warning**: this will delete all (and only) symlinks in the `wal`
>and `wpg` template directories respectively, and generate only
>those specified in the `fix-*-templates` scripts.
>(This is automatically run in the installation script.)

You can also add your own templates as you regularly would
(please refer to the
[Wpgtk wiki](https://github.com/deviantfero/wpgtk/wiki)).

### Pfp

You might want to place your own profile picture inside of
`~/.pfp`. This can be used by applications, widgets, panels, ...

It can be any picture file with any name, such as `~/.pfp/pfp.jpg`.

### Neovim

The `nvim` configuration is based upon
[AstroNvim](https://github.com/AstroNvim/AstroNvim),
an IDE layer for **Neovim**. Check out the
[docs](https://docs.astronvim.com/#%EF%B8%8F-configuration)
for info about configuration.

## 📁 Binaries

The repo also includes a large collection of shell scripts, some
[collected around the internet](../.local/bin), but [most of
them actually mine](bin). Being each few hundreds LOC tops,
they're not very large (`bin` sits at *492K* at the time of
writing - Nov. 16 2023), and since they're heavily integrated
into most of the config it made little sense leaving them out.

## $ Shell

Active development is currently only on `fish`. `bash` is
currently my login shell, so the `.bashrc` is maintained but in
a basic sense.

## 🎨 Themes

Please, refer to the
[theme](https://github.com/cherrynoize/theme) documentation for
usage.

## 🛠 Usage

>⚠ Please do not run binaries or use shell aliases unless you
>understand what they do. Take the time to inspect the code first.

You can find all binary files in `~/bin` and `~/.local/bin`,
shell aliases in `~/.config/fish/config.fish` and keyboard
shortcuts in `~/.config/sxhkd/sxhkdrc` or
`~/.config/hypr/keybindings.conf`. Here I try to use a somewhat
**sxhkd**-inspired syntax for defining keybindings as I find it more
concise. Compiling an extensive shortcuts/commands help is in the
[`TODO`](#-todo) list.

### ⌘ Keybindings

<details>
<summary>This is just some basic keybindings to get you
started.</summary>

#### Spawn a terminal window

    "$TERMINAL" # Mod+Return

#### Application launcher

    rofi -show drun # Mod+x

#### Run prompt

    rofi -show run # Mod+r

#### Powermenu

    powermenu # Mod+q

#### Theme selector

    theme-picker # Mod+Space

#### Wallpaper picker

    wall-picker # Mod+Ctrl+Space

#### Random wallpaper

    change-wallpaper # Mod+Ctrl+w

#### Dark mode on/off

    switch-mode # Mod+<

#### Toggle dock

    dock toggle # Mod+z

#### Launch browser

    "$BROWSER" # Mod+Alt+w

#### Fix common issues

    unfuck everything # Mod+Shift+Esc

###  Useful commands

#### Text editor

    launch-nvim # 'nvim' is an alias for that in fish/bash

### ⌨ Application shortcuts

#### Neovim

    {Alt,Shift}+Tab            Move to next/previous tab
    Space;{Shift}+Tab          Move to next/previous buffer
    Alt+{h,j,k,l}              Move to adjacent window
    Ctrl+{h,j,k,l}             Move to adjacent window (wraparound)
    Ctrl+{Left,Up,Down,Right}  Resize window
    Space                      Help menu

#### Rofi

    {Tab,Shift}+Tab  Move to next/previous entry
    h,j,k,l          Vi-like keybindings for moving around (with no inputbar)
    Alt+{h,j,k,l}    Where there's also an inputbar

</details>

### 📔 Tricks & tips

#### Auto-refresh sudo timeout

`sudo` privilege timeout for the shell is refreshed with `sudo
-v`. `fish` already has [an abbreviation set](../.config/fish/fishrc)
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

#### Firefox/Floorp

Some text visibility issues in light mode. (Inherited from
[theme](https://github.com/cherrynoize/theme))

#### eww

- Widget windows closers sometimes get stuck open, causing you to
accidentally open popup windows when clicking on other windows
rather than close them. To fix this you could restart `eww`,
but usually it's enough to click on the pfp icon that open the
panel window once to open it, then a second time to close it.

- On **bspwm** `eww` tends to get on top of other windows after being
restarted during the session. I still haven't found how I could
prevent it from happening (all suggestions are welcome).

> My workaround for the time being is to just
> [toggle the bar](#-toggle-bar). Besides, if you don't ever
> toggle it this shouldn't come up.

#### Music player cover

I currently use Spotify and as such I only set [`music`](../bin/music)
to fetch cover arts from Spotify metadata. I will try to expand
on this but, please, if anyone has a specific request provide me
with a metadata sample (output of `playerctl --player="$player"
metadata mpris:artUrl`) and I'll add it.

### 🔩 Troubleshooting

In case something's not working as expected:

```
unfuck everything
```

This *might* help. If it doesn't, you'll have to identify the
issue and actually do something about it. (You can have a look at
the [known bugs](#-known-bugs).) If you find something that
doesn't fit, please
[open an issue](https://github.com/cherrynoize/dotfiles/issues).

## 📋 TODO

### Install and configuration

- Installation script
- Finish initrc

### Bar

- Fix bar auto closing on resume after sleep

### Support

- Shortcuts/commands usage popup window

## ✨ Contribute

You can have a look at the [TODO](#-todo) and
[known bugs](#-known-bugs) lists. Or open a PR/issue if you have
found more.

If you feel like you have something to add please do.

## 💕 Sponsor

[**Buy me a coke 💙**](https://cherrynoize.github.io/#/contribute)

## 🙏 Thanks for using my dotfiles

*Bye!*
