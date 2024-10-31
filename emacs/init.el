;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))


(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-at-time "09:00"))

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

;; remove visible bell entirely
(setq visible-bell       nil
      ring-bell-function #'ignore)

(menu-bar-mode -1)            ; Disable the menu bar

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(defun isearch-forward-backward ()
  "Start an incremental search, alternating direction with each press of C-s.
Return to original position if the search is canceled with ESC."
  (interactive)
  (let ((start-point (point)))  ; Save the starting position
    (condition-case nil
        (progn
          (if (eq last-command 'isearch-forward-backward)
              (isearch-repeat (if isearch-forward 'backward 'forward))
            (isearch-forward)))
      ((quit error)  ; Catch both quit and error signals
       (goto-char start-point)))))

;; Bind ESC in isearch-mode-map to cancel the search
(define-key isearch-mode-map (kbd "<escape>") 'isearch-abort)

(global-set-key (kbd "C-s") 'isearch-forward-backward)

(when (executable-find "xclip")
  ;; Set up clipboard copy
  (defun copy-to-xclip (text &optional push)
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max) "xclip" nil 0 nil "-selection" "clipboard")))

  ;; Set up clipboard paste
 (defun paste-from-xclip ()
    (let ((xclip-output (shell-command-to-string "xclip -o -selection clipboard")))
      (unless (string= (car kill-ring) xclip-output)
        xclip-output)))

  (setq interprogram-cut-function 'copy-to-xclip)
  (setq interprogram-paste-function 'paste-from-xclip))

;; avy-goto-char-2 similar to leap.nvim
(unless (package-installed-p 'undo-fu)
  (package-install 'undo-fu))
(use-package avy
  :ensure t
  :init
  (avy-setup-default)
  :config
  (global-set-key (kbd "C-'") 'avy-goto-char-2))

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; ZQ to quit
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "Z Q") 'kill-this-buffer))

;; Download undo-fu
(unless (package-installed-p 'undo-fu)
  (package-install 'undo-fu))

(use-package undo-fu)
;; larger undo history
(setq undo-limit 67108864) ; 64mb.
(setq undo-strong-limit 100663296) ; 96mb.
(setq undo-outer-limit 1006632960) ; 960mb.

;; tighter line spacing
(setq-default line-spacing 0)

;; treat _ as part of the word
(modify-syntax-entry ?_ "w")

;; No ugly button for checkboxes
(setq widget-image-enable nil)

;; Line cursor and no blink
(set-default 'cursor-type  '(bar . 3))
(blink-cursor-mode 0)

;; Paren mode is part of the theme
(show-paren-mode t)

;; simplified mode line
(defun mode-line-render (left right)
  (let* ((available-width (- (window-width) (length left) )))
    (format (format "%%s %%%ds" available-width) left right)))
(setq-default mode-line-format
              '((:eval
                 (mode-line-render
                  (format-mode-line (list
                                     (propertize "☰" 'face `(:inherit mode-line-buffer-id)
                                                 'help-echo "Mode(s) menu"
                                                 'mouse-face 'mode-line-highlight
                                                 'local-map   mode-line-major-mode-keymap)
                                     " %b "))
                  (format-mode-line "%4l:%2c  ")))))

;; Vertical window divider
(setq window-divider-default-right-width 1)
(setq window-divider-default-places 'right-only)
(window-divider-mode)

(unless (package-installed-p 'ace-window)
  (package-refresh-contents)
  (package-install 'ace-window))

(use-package ace-window
  :ensure t
  :bind (("M-o" . ace-window))  ;; Bind M-o to ace-window
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))  ;; Customize keys for window selection
  (setq aw-background nil))  ;; Optional: make selected window more visible



;; Download mini-frame
(unless (package-installed-p 'mini-frame)
  (package-install 'mini-frame))

(use-package mini-frame
  :config
  (setq x-gtk-resize-child-frames 'resize-mode) ;; fix for gtk
  (mini-frame-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("712dda0818312c175a60d94ba676b404fc815f8c7e6c080c9b4061596c60a1db" "d41229b2ff1e9929d0ea3b4fde9ed4c1e0775993df9d998a3cdf37f2358d386b" "fbf73690320aa26f8daffdd1210ef234ed1b0c59f3d001f342b9c0bbf49f531c" default))
 '(package-selected-packages
   '(mini-frame lsp-bridge wakatime-mode evil-collection yasnippet evil no-littering auto-package-update))
 '(mini-frame-show-parameters
   '((top . 0)
     (width . 0.7)
     (left . 0.5)
     (height . 15)))
 '(wakatime-cli-path "/usr/local/bin/wakatime-cli"))

(global-wakatime-mode)

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))

;; fzf alternative
(use-package affe
  :config
  ;; Manual preview key for `affe-grep'
  (consult-customize affe-grep :preview-key "M-."))
;; lsp configuration
(add-to-list 'load-path "~/.emacs.d/lsp-bridge")

(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(global-lsp-bridge-mode)

;; inlay hints
(setq lsp-bridge-inlay-hint 1)

;; allow lsp-bridge with tramp
(setq lsp-bridge-enable-with-tramp 1)

;; auto start lsp_bridge.py on remote host
(setq lsp-bridge-remote-start-automatically t)

;; This is a better option if the `pyenv' executable is discoverable on `exec-path':
(setq lsp-bridge-python-command (string-trim
                                 (shell-command-to-string "pyenv which python3")))

(with-eval-after-load 'lsp-bridge
  ;; Function to install language servers automatically
  (defun lsp-bridge-install-server (server)
    "Install the specified language SERVER."
    (pcase server
      ("rust-analyzer"
       (unless (executable-find "rust-analyzer")
         (shell-command "rustup component add rust-analyzer")))
      ("pyright"
       (unless (executable-find "pyright")
         (shell-command "npm install -g pyright")))))

  ;; Add hooks to install servers when entering a mode
  (add-hook 'lsp-bridge-mode-hook
            (lambda ()
              (let ((server (lsp-bridge-get-lang-server)))
                (when server
                  (lsp-bridge-install-server server)))))

  ;; Set rust-analyzer as the server for Rust
  (add-to-list 'lsp-bridge-default-mode-hooks 'rust-mode-hook)
  (setq lsp-bridge-lang-server-providers
        '(("rust" . "rust-analyzer")))
  (setq lsp-bridge-rust-server "rust-analyzer")
  (setq lsp-bridge-python-server "pyright"))

;; Automatically start lsp-bridge for Rust files
(add-hook 'rust-mode-hook (lambda () (lsp-bridge-mode 1)))
(add-hook 'python-mode-hook (lambda () (lsp-bridge-mode 1)))

;; i don't know keybinds
(use-package which-key
 :config (which-key-mode))

;; no trailing whitespace
(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

;; tabs for makefiles
(add-hook 'makefile-mode-hook
  '(lambda()
     (setq indent-tabs-mode t)
   )
)

;; Download Modus theme
(unless (package-installed-p 'modus-themes)
  (package-install 'modus-themes))

(require-theme 'modus-themes)

;; All customizations here
(setq modus-themes-bold-constructs t
      modus-themes-italic-constructs t)

;; Maybe define some palette overrides, such as by using our presets
(setq modus-themes-common-palette-overrides
      modus-themes-preset-overrides-intense)

;; Load the theme of choice (built-in themes are always "safe" so they
;; do not need the `no-require' argument of `load-theme').
(load-theme 'modus-operandi-tinted)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
