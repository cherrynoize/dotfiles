if status is-interactive
  # know when the shell was launched
  set LAUNCH_TIME $(date +%T)

  # restore wpg
	cat ~/.config/wpg/sequences &

  # start animation
  # these values need to be tailored to your own system
  spinner -f sleep .5 & # async spinner duration (won't stop execution)
  sleep .2 # execution delay to allow spinner to terminate
  # note: my shell takes approximately .3s to load
  # (spinner overlapping with .31s duration - no delay)

  # colorscheme
  set -l teal 94e2d5
  set -l flamingo f2cdcd
  set -l mauve cba6f7
  set -l pink f5c2e7
  set -l red f38ba8
  set -l peach fab387
  set -l green a6e3a1
  set -l yellow f9e2af
  set -l blue 89b4fa
  set -l gray 1f1d2e
  set -l black 191724

  # startup
# ~/.config/fish/colors.sh &
  starship init fish | . &
	thefuck --alias | . &

  # source plugins
  # useful plugins: archlinux bang-bang cd colorman sudope vcs
  if test -d "$HOME/.local/share/omf/pkg/colorman/"
	  . ~/.local/share/omf/pkg/colorman/init.fish
  end

  # greeting message
  function fish_greeting
#     set _time_msg (set_color yellow; echo $LAUNCH_TIME; set_color normal)
#     set welcome_msg "$hostname - $_time_msg\n"
#
#     set msg_row_offset 6
#     for i in (seq 1 (math $msg_row_offset - 2))
#       printf "\n"
#     end
#
#     pad-left 29 "$welcome_msg"
#     printf "\033[""$msg_row_offset"A
#     printf "\033[100D"

#     show-pokemon
      printf "\033[1A"
  end

  # title format
  function fish_title
      # `prompt_pwd` shortens the title. This helps prevent tabs from becoming very wide.
      echo $argv[1] \((pwd)\)
  end

  # completion pager colors
  set -g fish_pager_color_progress $gray
  set -g fish_pager_color_prefix $mauve
  set -g fish_pager_color_completion $peach
  set -g fish_pager_color_description $gray

  # make su launch fish
  function su
     command su --shell=/usr/bin/fish $argv
  end

  # change multiple parent directories with ...+
  function multicd
      echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
  end
  abbr --add dotdot --regex '^\.\.+$' --function multicd

  # user shortcuts
  abbr fishrc '$EDITOR ~/.config/fish/config.fish'
  abbr reload '. ~/.config/fish/config.fish'
  abbr -- - 'cd ~'
  abbr -- -- 'cd ~'
  abbr hw 'echo hello, world!'
  abbr --set-cursor im 'sudo -iu % fish' # run interactive shell as user
  abbr runas 'sudo -u' # run command as user
  abbr sudo 'sudo -v; sudo' # refresh sudo privileges
  abbr l 'lsd'
  abbr e 'echo'
  abbr d 'dirs'
  abbr cls 'clear'
  abbr h 'history'
  abbr % 'fg'
  abbr --set-cursor xcopy '% | xclip -selection clipboard'
  abbr copy-dir 'pwd | xclip -selection clipboard'
  abbr compress 'tar -czvf' # compress ze vucking files
  abbr targz 'tar -czvf'
  abbr extract 'tar -xzvf' # xtract ze vucking files
  abbr untar 'tar -xzvf'
  abbr tarzstd 'tar -c -I"zstd -19 -T0" -f' # overall best one
  abbr tarpxz 'tar -c -I"pxz -9" -f' # may occasionally compress further
  abbr priv 'fish --private' # fish incognito mode
  abbr genpass 'openssl rand -base64 12' # random 12-char passwd
  abbr vimrc '$EDITOR ~/.vimrc'
  abbr vimconfig '$EDITOR ~/.vimrc'
  abbr xobfu 'zzxorcopy' # simple xor obfuscate
  abbr ff 'firefox'
  abbr fni 'firefox-nightly'
  abbr fde 'firefox-developer-edition'
  abbr chrome 'google-chrome-stable'
  abbr ytmp3 'youtube-dl --extract-audio --audio-format mp3' # yt to mp3 download
  abbr --set-cursor silent-spinner 'spinner -q % 2>/dev/null'
  abbr --set-cursor use-win 'pushd $(access-windows %)'
  abbr leave-win 'popd; exit-windows'
  abbr win-home 'pushd $(access-windows -home)'
  abbr win-lyrics 'pushd $(access-windows -home)/rocknroll/music/lyrics'
  abbr cat-win 'pushd $(access-windows -home); cat tmp.winsock; popd; exit-windows'
  abbr vi-win 'pushd $(access-windows -home); nvim tmp.winsock; popd; exit-windows'
  abbr nvim 'launch-nvim'
  abbr define 'dict -d gcide'
  abbr translate 'dict -d fd-ita-eng'
  abbr traduci 'dict -d fd-eng-ita'
  abbr loop 'music-bot previous & disown'
  abbr quit-loop 'music-bot quit'
  abbr kill-bot 'music-bot quit'
  abbr wpg-reload 'wpg -s "$(wpg -c)"'
  abbr --set-cursor timer 'timer (math "%") -n; play -n synth 0.05 sine 440 vol 0.1'
  abbr beep 'play -n synth 0.05 sine 440 vol 0.1'

  # bash emulation
  function last_history_item
      echo $history[1]
  end
  abbr -a !! --position anywhere --function last_history_item

  # system
  abbr pac 'sudo pacman'
  abbr pacs 'sudo pacman -S'
  abbr pacr 'sudo pacman -Rs'
  abbr pacq 'pacman -Q'
  abbr paci 'pacman -Qi'
  abbr paco 'pacman -Qo'
  abbr pacl 'pacman -Ql'
  abbr pace 'sudo pacman -D --asexplicit'
  abbr pacu 'sudo pacman -Syu; yay -Syu'
  abbr list-orphaned-packages 'pacman -Qtdq'
  abbr clear-orphaned-packages 'sudo pacman -Rns $(pacman -Qtdq)'
  abbr clear-pacman-cache 'paccache -ruk0; paccache -rk 1'
  abbr clear-yay-cache 'yay -Sc'
  abbr show-pacnew-files 'pacdiff -o'
  abbr show-packages-by-size 'LC_ALL=C pacman -Qi | awk \'/^Name/{name=$3} /^Installed Size/{print $4$5, name}\' | sort -h'
  abbr update-mirrorlist 'reflector --save /etc/pacman.d/mirrorlist --protocol https --latest 5 --sort age'
  abbr --set-cursor find-by-content 'grep -rnw . -e "%"'
  abbr find-empty 'find . -size 0 -type f' # list empty files
  abbr --set-cursor remove-dirs 'find . -type d -name "%" -print -exec rmdir {} \;'
  abbr --set-cursor remove-nonempty-dirs 'find . -type d -name "%" -print -prune -exec rm -rf {} \; # WARNING: handle with care!'
  abbr --set-cursor uncomment-file 'sed \'s/^#.*//\' "%"' # cat file without lines starting with a #
  abbr clear-windows-stuff 'remove-duplicates-with-suffix ".wwka"; remove-duplicates-with-suffix ".asd"; find . -type f -name \'AProject.ico\' -delete; find . -type f -name \'desktop.ini\' -delete; find . -type f -name \'Desktop.ini\' -delete'
  abbr reset-lock 'su -c "faillock --user \"$USER\" --reset"'
  abbr sha 'shasum -a 256' # test sha256
  abbr con 'ping -c 5 8.8.8.8' # check network
  abbr myip 'curl ifconfig.co' # print public ip
  abbr nic 'ip link show' # list nics
  abbr show-wifi-connection 'nmcli device wifi show-password' # wifi info
  abbr show-wifi-password 'nmcli device wifi show-password | grep "Password" | awk \'{print $2;}\'' # wifi password
  abbr show-gov 'toggle-powersave -c' # print current scaling governor for each cpu
  abbr set-gov 'cpupower frequency-set -g' # set scaling governor for each cpu
  abbr show-sched 'setiosched -s "nvme*"' # show io scheduler for device
  abbr --set-cursor set-sched 'sudo setiosched "nvme*" %' # set io scheduler for device
  abbr gpg-key "gpg --full-generate-key"
  abbr encrypt "gpg -c --s2k-cipher-algo AES256 --s2k-digest-algo SHA512 --s2k-count 65536"
  abbr decrypt "gpg -d"
  abbr sshon 'sudo systemctl start sshd.service'
  abbr sshoff 'sudo systemctl stop sshd.service'
  abbr wloff "rfkill block $WLAN"
  abbr wlon "rfkill unblock $WLAN"
  abbr destroy 'kill -9' # kill aka dio
  abbr transfer 'rsync -aPhv --info=progress2 --hard-links --ignore-existing' # transfer SOURCE DEST
  abbr rclone 'rclone --password-command "pass show cloud/rclone" -P'
  abbr pass 'begin;safe open;pass open;end >/dev/null 2>&1;pass'

  # hacking
  abbr hex 'xxd' # hexdump
  abbr str 'strings' # find ascii strings
  abbr das 'objdump -d -Mintel' # disassemble

  # development
  abbr --set-cursor venv-new 'python -m venv %venv' # create python virtual environment
  abbr --set-cursor venv-on 'source %venv/bin/activate.fish' # enter ve
  abbr venv-off 'deactivate' # exit ve
  abbr prepare-arduino 'sudo chmod 660 /dev/ttyACM0'

  # git --auto-skip death when I'm coding 
  abbr --set-cursor gitnew 'git init;git branch -M main;git remote add origin git@github.com:cherrynoize/%.git'
  abbr add 'git add'
  abbr adu 'git add -u'
  abbr brn 'git branch -M'
  abbr branch 'git branch -M'
  abbr --set-cursor cm 'git commit -m "%"'
  abbr --set-cursor cma 'git commit -a -m "%"'
  abbr --set-cursor pcm 'git commit -a -m "%";git push -u origin'
  abbr qu 'git commit -a -m "update";git push -u origin'
  abbr --set-cursor cfgpcm 'cfg commit -a -m "%";cfg push -u origin'
  abbr cfgupdate 'cfg commit -a -m "update"'
  abbr --set-cursor update-dotfiles 'cfg commit -a -m "%";cfg push -u origin'
  abbr cfgqu 'update-config'
  abbr checkout 'git checkout'
  abbr cherry-pick 'git cherry-pick'
  abbr gitdiff 'git diff'
  abbr fetch 'git fetch'
  abbr gitlog 'git log'
  abbr gitmerge 'git merge'
  abbr push 'git push -u origin'
  abbr pushmain 'git push -u origin main'
  abbr force 'git push --force-with-lease -u'
  abbr pull 'git pull'
  abbr origin 'git remote add origin'
  abbr seturl 'git remote set-url origin'
  abbr stash 'git stash'
  abbr gitst 'git status'
  abbr prompt 'fish_git_prompt'
  abbr gid 'git config --local user.name "cherrynoize"; git config --local user.email "cherrynoize9987@outlook.com"'

  # git prompt
  set -g __fish_git_prompt_show_informative_status 1
  set -g __fish_git_prompt_showupstream informative
  set -g __fish_git_prompt_showdirtystate yes
  set -g __fish_git_prompt_char_stateseparator ' '
  set -g __fish_git_prompt_char_cleanstate '✔'
  set -g __fish_git_prompt_char_dirtystate '✚'
  set -g __fish_git_prompt_char_invalidstate '✖'
  set -g __fish_git_prompt_char_stagedstate '●'
  set -g __fish_git_prompt_char_stashstate '⚑'
  set -g __fish_git_prompt_char_untrackedfiles '?'
  set -g __fish_git_prompt_char_upstream_ahead ''
  set -g __fish_git_prompt_char_upstream_behind ''
  set -g __fish_git_prompt_char_upstream_diverged 'ﱟ'
  set -g __fish_git_prompt_char_upstream_equal ''
  set -g __fish_git_prompt_char_upstream_prefix ''''

  set -g man_blink -o $teal
  set -g man_bold -o $pink
  set -g man_standout -b $gray
  set -g man_underline -u $blue

  function wa
      set -f APPID "5YX76V-P3UEAP6L3U" # Get one at https://products.wolframalpha.com/api/
      echo $argv | string escape --style=url | read question_string
      set -f url "https://api.wolframalpha.com/v1/result?appid="$APPID"&i="$question_string
      curl -s $url
  end
end
