;; -*- coding: utf-8; lexical-binding: t; -*-
;; Emacs settings plain gnu emacs only
;; 2019-11-06
;; http://xahlee.info/emacs/emacs/emacs_init_index.html

;; ssss---------------------------------------------------
;; load Spacemacs
(load-file "~/.emacs.d/spacemacs/init.el")

;; ssss---------------------------------------------------
;; load el-get

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

;; ssss---------------------------------------------------
;; load MELPA repository

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archives '(("melpa" . "http://melpa.org/packages/"))) ; this fixes having to run M-x package-refresh-contents before package-install
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (package-initialize)

;; ssss---------------------------------------------------
;; install use-package

(add-to-list 'load-path "~/.emacs.d/site-lisp/use-package")
(require 'use-package)

(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
               "~/.emacs.d/site-lisp/use-package/"))

;; ssss---------------------------------------------------
;; load theme

(when (fboundp 'eww)
  (defun xah-rename-eww-buffer ()
    "Rename `eww-mode' buffer so sites open in new page.
URL `http://xahlee.info/emacs/emacs/emacs_eww_web_browser.html'
Version 2017-11-10"
    (let (($title (plist-get eww-data :title)))
      (when (eq major-mode 'eww-mode )
        (if $title
            (rename-buffer (concat "eww " $title ) t)
          (rename-buffer "eww" t)))))

  (add-hook 'eww-after-render-hook 'xah-rename-eww-buffer))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi))
 '(custom-safe-themes
   '("dea4b7d43d646aa06a4f705a58f874ec706f896c25993fcf73de406e27dc65ba" default))
 '(package-selected-packages '(blamer web-mode))
 '(send-mail-function 'smtpmail-send-it)
 '(smtpmail-smtp-server "smtp.office365.com")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ssss---------------------------------------------------
;; plugins

;; Blamer
(use-package blamer
  :ensure t
  :bind (("s-i" . blamer-show-commit-info)
         ("C-c i" . blamer-show-posframe-commit-info))
  :defer 20
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#ba889f" ;; "#ca88cf" ;; "#7a88cf"
                   :background nil
;;                   :height 140
                   :italic t)))
  :config)

(global-blamer-mode 0) ;; disable blamer mode

;; ssss---------------------------------------------------
;; initial window and default window

(setq inhibit-startup-screen t)

(set-background-color "#362239")
(set-foreground-color "#dfdfdf")
(set-cursor-color "#9ac")

;; ssss---------------------------------------------------
;; Frame transparency.

;;(set-frame-parameter (selected-frame) 'alpha '(<active> . <inactive>))
;;(set-frame-parameter (selected-frame) 'alpha <both>)
(set-frame-parameter (selected-frame) 'alpha '(100 . 85))
(add-to-list 'default-frame-alist '(alpha . (100 . 85)))

;; toggle transparency
(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(85 . 50) '(100 . 100)))))
(global-set-key (kbd "C-x t C-x o") 'toggle-transparency)

;; ssss---------------------------------------------------
;; menu bar / tool bar / scroll bar

(menu-bar-mode -1)
(tool-bar-mode -1)

;; ssss---------------------------------------------------
;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

;; ssss---------------------------------------------------
;; helm-mode

(setq helm-mode-handle-completion-in-region nil)
(helm-mode -1) ;; disable entirely

;; ssss---------------------------------------------------
;; behaviour

;; searching
(setq isearch-lazy-count 1)

;; saving
(setq require-final-newline nil)
(setq mode-require-final-newline nil)

;; ssss---------------------------------------------------
;; shortcut keybindings

;; edit
(global-set-key (kbd "C-z") 'undo)

;; delete-word (without adding to kill-ring)
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

;; delete-word forward
(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

;; text
(global-set-key (kbd "C-<backspace>") 'backward-delete-word)
(global-set-key (kbd "C-<delete>") 'delete-word)
(global-set-key (kbd "M-<backspace>") 'backward-kill-word)
(global-set-key (kbd "M-<delete>") 'kill-word)
;; (global-set-key (kbd "C-c") 'copy-region-as-kill) ;; should be reserved as mode-specific command prefix (may cause compatibility issues)
(global-set-key (kbd "C-S-x") 'kill-region)
(global-set-key (kbd "C-M-x") 'kill-region)
(global-set-key (kbd "C-v") 'yank)
(global-set-key (kbd "C-d") (lambda () (interactive) (kill-line) (yank) (newline) (yank)))
(global-set-key (kbd "C-a") (kbd "C-x h"))
(global-set-key (kbd "C-<tab>") 'indent-rigidly)

;; find
(global-set-key (kbd "C-f") 'isearch-forward)
(global-set-key (kbd "C-b") 'isearch-backward)
(global-set-key (kbd "C-S-f") 'isearch-repeat-forward)
(global-set-key (kbd "C-S-r") 'isearch-repeat-backward)
(global-set-key (kbd "C-M-f") 'search-forward)
(global-set-key (kbd "C-M-b") 'search-backward)

;; navigation
(global-set-key (kbd "C-<down>") 'scroll-up)
(global-set-key (kbd "C-n") 'scroll-up)
(global-set-key (kbd "C-<up>") 'scroll-down)
(global-set-key (kbd "C-S-n") 'scroll-down)
(global-set-key (kbd "C-S-g") 'goto-line)
(global-set-key (kbd "C-_") 'goto-line)

;; layout
(global-set-key (kbd "C-.") (kbd "C-x o"))
(global-set-key (kbd "C-,") (kbd "C-u -1 C-x o"))
(global-set-key (kbd "C-S-k") (kbd "C-u 2 C-x o"))
(global-set-key (kbd "C-S-j") (kbd "C-u -2 C-x o"))

;; windows
(global-set-key (kbd "C-S-l") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-h") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-m") 'shrink-window)
(global-set-key (kbd "C-S-i") 'enlarge-window)

;; buffers
(global-set-key (kbd "M-<left>") 'previous-buffer)
(global-set-key (kbd "M-<right>") 'next-buffer)

;; minibuffer
(global-set-key (kbd "C-S-w") (kbd "C-g"))

;; terminal
(global-set-key (kbd "C-r") 'execute-extended-command)

;; file
(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") 'write-file)

;; emacs
(global-set-key (kbd "C-q") 'kill-emacs)
(global-set-key (kbd "M-<f4>") 'kill-emacs)
(global-set-key (kbd "C-;") '(switch-to-buffer (find-file-noselect ~/.emacs nil nil wildcards)))

;; override minor modes

(bind-keys*
 ("C-d" . (lambda () (interactive) (kill-line) (yank) (newline) (yank))))

;; ssss---------------------------------------------------
;; user defined modes

;; add modes directory to load-path
(add-to-list 'load-path "~/.emacs.d/modes/")

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[jt]s[x]?\\'" . web-mode))

(defun web-mode-init-hook ()
  "Hooks for Web mode.  Adjust indent."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
)

(add-hook 'web-mode-hook  'web-mode-init-hook)

;; js / rjsx-mode

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
(setq js-indent-level 2)

;; go

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

;; ssss---------------------------------------------------
;; backup and file related

(defun xah-save-all-unsaved ()
  "Save all unsaved files. no ask.
Version 2019-11-05"
  (interactive)
  (save-some-buffers t ))

(if (version< emacs-version "27")
    (add-hook 'focus-out-hook 'xah-save-all-unsaved)
  (setq after-focus-change-function 'xah-save-all-unsaved))

(setq make-backup-files nil)
(setq backup-by-copying t)
(setq create-lockfiles nil)
(setq auto-save-default nil)

(require 'recentf)
(recentf-mode 1)

(desktop-save-mode 1)
(global-auto-revert-mode 1)

;; ssss---------------------------------------------------
;; user interface

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; disable line wrap
(set-default 'truncate-lines t)

(column-number-mode 1)
(blink-cursor-mode 0)
(setq use-dialog-box nil)

(progn
  ;; no need to warn
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'erase-buffer 'disabled nil)
  (put 'scroll-left 'disabled nil)
  (put 'dired-find-alternate-file 'disabled nil)
)

;; ssss---------------------------------------------------

(progn
  (require 'dired-x)
  (setq dired-dwim-target t)
  ;; (cond
  ;;  ((string-equal system-type "gnu/linux") (setq dired-listing-switches "-al --time-style long-iso"))
  ;;  ((string-equal system-type "darwin") (setq dired-listing-switches "-alh")))
  (setq dired-recursive-copies 'top)
  (setq dired-recursive-deletes 'top))

;; ssss---------------------------------------------------

(setq set-mark-command-repeat-pop t)
(setq mark-ring-max 5)
(setq global-mark-ring-max 5)

;; ssss---------------------------------------------------
;; Emacs: Font Setup http://xahlee.info/emacs/emacs/emacs_list_and_set_font.html

;; set default font
(set-frame-font
 (cond
  ((string-equal system-type "windows-nt")
   (if (member "JetBrains Mono" (font-family-list)) "JetBrains Mono"
     (if (member "DejaVu Sans Mono" (font-family-list)) "DejaVu Sans Mono" 
       (if (member "Consolas" (font-family-list)) "Consolas" nil ))))
  ((string-equal system-type "darwin")
   (if (member "JetBrains Mono" (font-family-list)) "JetBrains Mono"
     (if (member "DejaVu Sans Mono" (font-family-list)) "DejaVu Sans Mono"
       (if (member "Menlo" (font-family-list)) "Menlo-16" nil ))))
  ((string-equal system-type "gnu/linux")
   (if (member "JetBrains Mono" (font-family-list)) "JetBrains Mono"
     (if (member "DejaVu Sans Mono" (font-family-list)) "DejaVu Sans Mono" nil )))
  (t nil))
 t t)

;; set font for emoji
(set-fontset-font
 t
 '(#x1f300 . #x1fad0)
 (cond
  ((member "Apple Color Emoji" (font-family-list)) "Apple Color Emoji")
  ((member "Noto Color Emoji" (font-family-list)) "Noto Color Emoji")
  ((member "Noto Emoji" (font-family-list)) "Noto Emoji")
  ((member "Segoe UI Emoji" (font-family-list)) "Segoe UI Emoji")
  ((member "Symbola" (font-family-list)) "Symbola")))

;; set font for chinese characters
(set-fontset-font
 t
 '(#x4e00 . #x9fff)
 (cond
  ((string-equal system-type "windows-nt")
   (cond
    ((member "Microsoft YaHei" (font-family-list)) "Microsoft YaHei")
    ((member "Microsoft JhengHei" (font-family-list)) "Microsoft JhengHei")
    ((member "SimHei" (font-family-list)) "SimHei")))
  ((string-equal system-type "darwin")
   (cond
    ((member "Hei" (font-family-list)) "Hei")
    ((member "Heiti SC" (font-family-list)) "Heiti SC")
    ((member "Heiti TC" (font-family-list)) "Heiti TC")))
  ((string-equal system-type "gnu/linux")
   (cond
    ((member "WenQuanYi Micro Hei" (font-family-list)) "WenQuanYi Micro Hei")))))


;; font-size
(set-face-attribute 'default nil :height 150)
;; ssss---------------------------------------------------

;; remember cursor position
(if (version< emacs-version "25.0")
    (progn
      (require 'saveplace)
      (setq-default save-place t))
  (save-place-mode 1))

;; ssss---------------------------------------------------
;;; editing related

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

(electric-pair-mode 1)

;; set highlighting brackets
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)

;; for isearch-forward, make these equivalent: space newline tab hyphen underscore
(setq search-whitespace-regexp "[-_ \t\n]+")

(defun xah-toggle-search-whitespace ()
  "Set `search-whitespace-regexp' to nil or includes hyphen lowline tab newline.
Explanation: When in isearch (M-x `isearch-forward'), space key can also stand for other chars such as hyphen lowline tab newline. It depend on a regex. It's convenient. But sometimes you want literal. This command makes it easy to toggle.

Emacs Isearch Space Toggle
URL `http://xahlee.info/emacs/emacs/emacs_isearch_space.html'
Version 2019-02-22"
  (interactive)
  (if (string-equal search-whitespace-regexp nil)
      (progn
        (setq search-whitespace-regexp "[-_ \t\n]+")
        (message "Space set to hyphen lowline tab newline space"))
    (progn
      (setq search-whitespace-regexp nil)
      (message "Space set to literal."))))

;; ssss---------------------------------------------------
;; indentation, end of line

(electric-indent-mode 0)

(set-default 'tab-always-indent 'complete)

;; no mixed tab space
(setq-default indent-tabs-mode nil)
 ; gnu emacs 23.1, 24.4.1 default is t

;; 4 is more popular than 8.
(setq-default tab-width 4)

(setq sentence-end-double-space nil )

;; ssss---------------------------------------------------

(progn
 ;; Make whitespace-mode with very basic background coloring for whitespaces.
  ;; http://xahlee.info/emacs/emacs/whitespace-mode.html
  (setq whitespace-style (quote ( spaces tabs newline space-mark tab-mark newline-mark )))


  ;; Make whitespace-mode and whitespace-newline-mode use “¶” for end of line char and “▷” for tab.
  (setq whitespace-display-mappings
        ;; all numbers are unicode codepoint in decimal. e.g. (insert-char 182 1)
        '(
          (space-mark 32 [183] [46]) ; SPACE 32 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
          (newline-mark 10 [182 10]) ; LINE FEED,
          (tab-mark 9 [9655 9] [92 9]) ; tab
          )))

;; ssss---------------------------------------------------
;; edit related

(setq hippie-expand-try-functions-list
      '(
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        ;; try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol
        try-complete-file-name-partially
        try-complete-file-name
        ;; try-expand-all-abbrevs
        ;; try-expand-list
        ;; try-expand-line
        ))

;; ssss---------------------------------------------------

;; convenient
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'rs 'replace-string)
(defalias 'lcd 'list-colors-display)
(defalias 'ds 'desktop-save)

(defalias 'dsm 'desktop-save-mode)
(defalias 'hm 'html-mode)
(defalias 'jsm 'js-mode)
(defalias 'fm 'fundamental-mode)
(defalias 'ssm 'shell-script-mode)
(defalias 'om 'org-mode)

;; no want tpu-edt
(defalias 'tpu-edt 'forward-char)
(defalias 'tpu-edt-on 'forward-char)

;; ssss---------------------------------------------------
(progn
  ;; org-mode
  ;; make “org-mode” syntax color code sections
  (setq org-src-fontify-natively t)
  (setq org-startup-folded nil)
  (setq org-return-follows-link t)
  (setq org-startup-truncated nil))
