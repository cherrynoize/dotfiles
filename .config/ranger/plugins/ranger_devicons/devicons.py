#!/usr/bin/python
# coding=UTF-8
# These glyphs, and the mapping of file extensions to glyphs
# has been copied from the vimscript code that is present in
# https://github.com/ryanoasis/vim-devicons

import re
import os

# Get the XDG_USER_DIRS directory names from environment variables
xdgs_dirs = {
    os.path.basename(os.getenv(key).rstrip('/')): icon
    for key, icon in (
        ('XDG_DOCUMENTS_DIR', ''),
        ('XDG_DOWNLOAD_DIR', ''),
        ('XDG_CONFIG_DIR', ''),
        ('XDG_MUSIC_DIR', ''),
        ('XDG_PICTURES_DIR', ''),
        ('XDG_PUBLICSHARE_DIR', ''),
        ('XDG_TEMPLATES_DIR', ''),
        ('XDG_VIDEOS_DIR', ''),
    )
    if os.getenv(key)
}


# all those glyphs will show as weird squares if you don't have the correct patched font
# My advice is to use NerdFonts which can be found here:
# https://github.com/ryanoasis/nerd-fonts
file_node_extensions = {
    '7z'       : '',
    'a'        : '',
    'ai'       : '',
    'apk'      : '',
    'asm'      : '',
    'asp'      : '',
    'aup'      : '',
    'avi'      : '',
    'awk'      : '',
    'bash'     : '',
    'bat'      : '',
    'bmp'      : '',
    'bz2'      : '',
    'c'        : '',
    'c++'      : '',
    'cab'      : '',
    'cbr'      : '',
    'cbz'      : '',
    'cc'       : '',
    'class'    : '',
    'clj'      : '',
    'cljc'     : '',
    'cljs'     : '',
    'cmake'    : '',
    'coffee'   : '',
    'conf'     : '',
    'cp'       : '',
    'cpio'     : '',
    'cpp'      : '',
    'cs'       : '',
    'csh'      : '',
    'css'      : '',
    'cue'      : '',
    'cvs'      : '',
    'cxx'      : '',
    'd'        : '',
    'dart'     : '',
    'db'       : '',
    'deb'      : '',
    'diff'     : '',
    'dll'      : '',
    'doc'      : '',
    'docx'     : '',
    'dump'     : '',
    'edn'      : '',
    'eex'      : '',
    'efi'      : '',
    'ejs'      : '',
    'elf'      : '',
    'elm'      : '',
    'epub'     : '',
    'erl'      : '',
    'ex'       : '',
    'exe'      : '',
    'exs'      : '',
    'f#'       : '',
    'fifo'     : 'ﳣ',
    'fish'     : '',
    'flac'     : '',
    'flv'      : '',
    'fs'       : '',
    'fsi'      : '',
    'fsscript' : '',
    'fsx'      : '',
    'gem'      : '',
    'gemspec'  : '',
    'gif'      : '',
    'go'       : '',
    'gz'       : '',
    'gzip'     : '',
    'h'        : '',
    'haml'     : '',
    'hbs'      : '',
    'hh'       : '',
    'hpp'      : '',
    'hrl'      : '',
    'hs'       : '',
    'htaccess' : '',
    'htm'      : '',
    'html'     : '',
    'htpasswd' : '',
    'hxx'      : '',
    'ico'      : '',
    'img'      : '',
    'ini'      : '',
    'iso'      : '',
    'jar'      : '',
    'java'     : '',
    'jl'       : '',
    'jpeg'     : '',
    'jpg'      : '',
    'js'       : '',
    'json'     : '',
    'jsx'      : '',
    'key'      : '',
    'ksh'      : '',
    'leex'     : '',
    'less'     : '',
    'lha'      : '',
    'lhs'      : '',
    'log'      : '',
    'lua'      : '',
    'lzh'      : '',
    'lzma'     : '',
    'm4a'      : '',
    'm4v'      : '',
    'markdown' : '',
    'md'       : '',
    'mdx'      : '',
    'mjs'      : '',
    'mkv'      : '',
    'ml'       : 'λ',
    'mli'      : 'λ',
    'mov'      : '',
    'mp3'      : '',
    'mp4'      : '',
    'mpeg'     : '',
    'mpg'      : '',
    'msi'      : '',
    'mustache' : '',
    'nix'      : '',
    'o'        : '',
    'ogg'      : '',
    'part'     : '',
    'pdf'      : '',
    'php'      : '',
    'pl'       : '',
    'pm'       : '',
    'png'      : '',
    'pp'       : '',
    'ppt'      : '',
    'pptx'     : '',
    'ps1'      : '',
    'psb'      : '',
    'psd'      : '',
    'pub'      : '',
    'py'       : '',
    'pyc'      : '',
    'pyd'      : '',
    'pyo'      : '',
    'r'        : 'ﳒ',
    'rake'     : '',
    'rar'      : '',
    'rb'       : '',
    'rc'       : '',
    'rlib'     : '',
    'rmd'      : '',
    'rom'      : '',
    'rpm'      : '',
    'rproj'    : '鉶',
    'rs'       : '',
    'rss'      : '',
    'rtf'      : '',
    's'        : '',
    'sass'     : '',
    'scala'    : '',
    'scss'     : '',
    'sh'       : '',
    'slim'     : '',
    'sln'      : '',
    'so'       : '',
    'sql'      : '',
    'styl'     : '',
    'suo'      : '',
    'swift'    : '',
    't'        : '',
    'tar'      : '',
    'tex'      : 'ﭨ',
    'tgz'      : '',
    'toml'     : '',
    'torrent'  : '',
    'ts'       : '',
    'tsx'      : '',
    'twig'     : '',
    'vim'      : '',
    'vimrc'    : '',
    'vue'      : '﵂',
    'wav'      : '',
    'webm'     : '',
    'webmanifest' : '',
    'webp'     : '',
    'xbps'     : '',
    'xcplayground' : '',
    'xhtml'    : '',
    'xls'      : '',
    'xlsx'     : '',
    'xml'      : '',
    'xul'      : '',
    'xz'       : '',
    'yaml'     : '',
    'yml'      : '',
    'zip'      : '',
    'zsh'      : '',
}

dir_node_exact_matches = {
    'noize'                            : '🖤',
    'lucy'                             : '♡',
    '.git'                             : '',
    '.vim'                             : '',
    'nvim'                             : '',
#   '.mozilla'                         : '🦊',
#   'firefox'                          : '🦊',
    '.mozilla'                         : '🌐',
    'firefox'                          : '🌐',
    'google-chrome'                    : '🌐',
    'brave'                            : '🌐',
    'midori'                           : '🌐',
    'Min'                              : '🌐',
    'network'                          : '🌐',
    'hosts'                            : '🌐',
    'discord'                          : '🗨',
    '.irssi'                           : '🗨',
    '.thunderbird'                     : '✉',
    '.mutt'                            : '✉',
    'kmail'                            : '✉',
#   'evolution'                        : '✉', # could be ambiguous
    'mail'                             : '✉',
    '.config'                          : '',
    'dotfiles'                         : '○',
    'Computer'                         : '🖥',
    'computer'                         : '🖥',
    'disk'                             : '🖥',
    'device'                           : '🖥',
    'partition'                        : '🖥',
    'System'                           : '🖥',
    'System32'                         : '🖥',
    'system'                           : '🖥',
    'System Volume Information'        : '🖥',
    'Desktop'                          : '💻',
    'desktop'                          : '💻',
    'Documents'                        : '🗎',
    'documents'                        : '🗎',
    'Downloads'                        : '',
    'downloads'                        : '',
    'Pictures'                         : '',
    'pictures'                         : '',
    'Images'                           : '',
    'images'                           : '',
    'pics'                             : '',
    'Videos'                           : '',
    'videos'                           : '',
    'Music'                            : '',
    'music'                            : '',
    'movies'                           : '🖭',
    'shows'                            : '',
    'anime'                            : '',
    'books'                            : '',
    'Games'                            : '🎮',
    'games'                            : '🎮',
    'videogames'                       : '🎮',
    'rocknroll'                        : '󰎈',
    'lyrics'                           : '󰲃',
    'screenplays'                      : '󰲃',
    'concepts'                         : '󰲃',
    'hacking'                          : '💻',
    'art'                              : '🖼',
    'aiart'                            : '🖼',
#   'ai'                               : '',
    'Public'                           : '',
    'public'                           : '',
    'Templates'                        : '',
    'templates'                        : '',
    'duplicate'                        : '',
    'clone'                            : '',
    'copy'                             : '',
    'archive'                          : '📁',
    'attachments'                      : '📎',
    'pinned'                           : '📌',
    'pin'                              : '📌',
    'dropbox'                          : '',
    'python'                           : '',
    'go'                               : '',
    'workspace'                        : '',
    'cloud'                            : '',
    'src'                              : '',
    'dev'                              : '',
    'development'                      : '',
    'programming'                      : '',
    'code'                             : '',
    'coding'                           : '',
    'server'                           : '🌐',
    'web'                              : '🌐',
    'www'                              : '🌐',
    'data'                             : '🗎',
    'bin'                              : '',
    'sbin'                             : '',
    'apps'                             : '',
    'programs'                         : '',
    'software'                         : '',
    'build'                            : '',
    'debug'                            : '',
    'os'                               : '',
    'oses'                             : '',
    'vms'                              : '',
    'blockchain'                       : '🔗',
    'solana'                           : '◎',
    'ethereum'                         : '⧫',
    'bitcoin'                          : '₿',
    'backup'                           : '⟳',
    'trash'                            : '🗑',
    '.trash'                           : '🗑',
    'garbage'                          : '🗑',
    '.garbage'                         : '🗑',
    'recycle'                          : '♲',
    'recycle_bin'                      : '♲',
    'RECYCLEBIN'                       : '♲',
    '$RECYCLE.BIN'                     : '♲',
}

# Python 2.x-3.4 don't support unpacking syntex `{**dict}`
# XDG_USER_DIRS
dir_node_exact_matches.update(xdgs_dirs)

file_node_exact_matches = {
    '.bash_aliases'                    : '',
    '.bash_history'                    : '',
    '.bash_logout'                     : '',
    '.bash_profile'                    : '',
    '.bashprofile'                     : '',
    '.bashrc'                          : '',
    '.dmrc'                            : '',
    '.DS_Store'                        : '',
    '.fasd'                            : '',
    '.fehbg'                           : '',
    '.gitattributes'                   : '',
    '.gitconfig'                       : '',
    '.gitignore'                       : '',
    '.gitlab-ci.yml'                   : '',
    '.gvimrc'                          : '',
    '.nvimrc'                          : '',
    '.inputrc'                         : '',
    '.jack-settings'                   : '',
    '.mime.types'                      : '',
    '.ncmpcpp'                         : '',
    'spotify'                          : '',
    '.nvidia-settings-rc'              : '',
    '.pam_environment'                 : '',
    '.profile'                         : '',
    '.xprofile'                        : '',
    '.recently-used'                   : '',
    '.selected_editor'                 : '',
    '.vim'                             : '',
    '.nvimrc'                          : '',
    '.viminfo'                         : '',
    '.vimrc'                           : '',
    '.Xauthority'                      : '',
    '.Xdefaults'                       : '',
    '.xinitrc'                         : '',
    '.xinputrc'                        : '',
    '.Xresources'                      : '',
    '.zshrc'                           : '',
    '.zshenv'                          : '',
    '_gvimrc'                          : '',
    '_vimrc'                           : '',
    'out'                              : '',
    'a.out'                            : '',
    'authorized_keys'                  : '',
    'bspwmrc'                          : '',
    'awesome'                          : '',
    'i3'                               : '',
    'cmakelists.txt'                   : '',
    'config'                           : '',
    'config.ac'                        : '',
    'config.m4'                        : '',
    'config.mk'                        : '',
    'config.ru'                        : '',
    'configure'                        : '',
    'docker-compose.yml'               : '',
    'dockerfile'                       : '',
    'Dockerfile'                       : '',
    'dropbox'                          : '',
    'exact-match-case-sensitive-1.txt' : 'X1',
    'exact-match-case-sensitive-2'     : 'X2',
    'favicon.ico'                      : '',
    'gemfile'                          : '',
    'gruntfile.coffee'                 : '',
    'gruntfile.js'                     : '',
    'gruntfile.ls'                     : '',
    'gulpfile.coffee'                  : '',
    'gulpfile.js'                      : '',
    'gulpfile.ls'                      : '',
    'ini'                              : '',
    'known_hosts'                      : '',
    'ledger'                           : '',
    'devnet.json'                      : '',
    'mainnet.json'                     : '',
    'license'                          : '',
    'LICENSE'                          : '',
    'LICENSE.md'                       : '',
    'LICENSE.txt'                      : '',
    'passwd'                           : '',
    'shadow'                           : '',
    'Makefile'                         : '',
    'makefile'                         : '',
    'Makefile.ac'                      : '',
    'Makefile.in'                      : '',
    'mimeapps.list'                    : '',
    'mix.lock'                         : '',
    'node_modules'                     : '',
    'package-lock.json'                : '',
    'package.json'                     : '',
    'playlists'                        : '',
    'procfile'                         : '',
    'Rakefile'                         : '',
    'rakefile'                         : '',
    'react.jsx'                        : '',
    'README'                           : '',
    'README.markdown'                  : '',
    'README.md'                        : '',
    'README.rst'                       : '',
    'README.txt'                       : '',
    'sxhkdrc'                          : '',
    'user-dirs.dirs'                   : '',
    'webpack.config.js'                : '',
    '.trash'                           : '🗑',
    '.garbage'                         : '🗑',
}


def devicon(file):
    if file.is_directory:
        return dir_node_exact_matches.get(file.relative_path, '')
    return file_node_exact_matches.get(os.path.basename(file.relative_path),
                                       file_node_extensions.get(file.extension, ''))
