;;; init.el --- Initialization file for Emacs
;;; Commentary:
;;  Emacs Startup File --- initialization for Emacs

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(variable-pitch ((t (:family "Sans Serif")))))



(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ;; ("org" . "https://orgmode.org/elpa/")
			 ;; ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; ;; and `package-pinned-packages`. Most users will not need or want to do this.
;; ;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (package-initialize)



(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)


;; (use-package auto-package-update
;;   :custom
;;   (auto-package-update-interval 7)
;;   (auto-package-update-prompt-before-update t)
;;   (auto-package-update-hide-results t)
;;   :config
;;   (auto-package-update-maybe)
;;   (auto-package-update-at-time "09:00"))

;; (use-package dracula-theme)
;; (load-theme 'dracula t)

(add-to-list 'custom-theme-load-path "/run/current-system/sw/share/themes/emacs-everforest/")
(load-theme 'everforest-hard-dark t)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)

(setq cmake-ts-mode-indent-offset 4)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; (setq c-basic-offset 4)
;; (setq c-default-style "stroustrup")

;; Make a non-standard key binding.  We can put this in
;; c-mode-base-map because c-mode-map, c++-mode-map, and so on,
;; inherit from it.
(defun my-c-initialization-hook ()
  (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'my-c-initialization-hook)

;; offset customizations not in my-c-style
;; This will take precedence over any setting of the syntactic symbol
;; made by a style.
(setq c-offsets-alist '((member-init-intro . ++)))

;; Create my personal style.
(defconst my-c-style
  '((c-tab-always-indent        . t)
    (c-comment-only-line-offset . 4)
    (c-hanging-braces-alist     . ((substatement-open after)
                                   (brace-list-open)))
    (c-hanging-colons-alist     . ((member-init-intro before)
                                   (inher-intro)
                                   (case-label after)
                                   (label after)
                                   (access-label after)))
    (c-cleanup-list             . (scope-operator
                                   empty-defun-braces
                                   defun-close-semi))
    (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
                                   (substatement-open . 0)
                                   (case-label        . 4)
                                   (block-open        . 0)
                                   (knr-argdecl-intro . -)))
    (c-echo-syntactic-information-p . t))
  "My C Programming Style")
(c-add-style "PERSONAL" my-c-style)

;; Customizations for all modes in CC Mode.
(defun my-c-mode-common-hook ()
  ;; set my personal style for the current buffer
  (c-set-style "PERSONAL")
  ;; other customizations
  (setq tab-width 4
        ;; this will make sure spaces are used instead of tabs
        indent-tabs-mode nil)
  ;; we like auto-newline, but not hungry-delete
  (c-toggle-auto-newline -1)
  (setq subword-mode t))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook
		vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))

(use-package ace-window
  :init (setq aw-scope 'global)
  :bind (("C-o" . ace-window)))

(add-hook 'after-init-hook (lambda ()
  (when (fboundp 'auto-dim-other-buffers-mode)
    (auto-dim-other-buffers-mode t))))


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

(define-key function-key-map (kbd "<f5>") 'event-apply-super-modifier)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(use-package helm
  :config
  (setq helm-split-window-inside-p t)
  (setq helm-use-frame-when-more-than-two-windows nil)
  (setq helm-move-to-line-cycle-in-source t)
  (helm-autoresize-mode 1)
  :bind
  ("M-x" . helm-M-x)
  ("C-x b" . 'helm-buffers-list) ;; List buffers ( Emacs way )
  ("C-x r b" . 'helm-bookmarks) ;; Bookmarks menu
  ("C-x C-f" . 'helm-find-files) ;; Finding files with Helm
  ("M-c" . 'helm-calcul-expression) ;; Use Helm for calculations
  ("C-s" . 'helm-occur)  ;; Replaces the default isearch keybinding
  ("C-h a" . 'helm-apropos)  ;; Helmized apropos interface
  ("M-x" . 'helm-M-x)  ;; Improved M-x menu
  ("M-y" . 'helm-show-kill-ring)  ;; Show kill ring, pick something to paste
  :ensure t)

(use-package helm-projectile
  :ensure t
  :init)

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

(use-package smartparens
  :config
  (smartparens-global-mode 1))

(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package yaml-mode
  :mode "\\.yml\\'"
  :bind ("\C-m" . newline-and-indent))

(use-package lsp-ui
  :commands (lsp-ui-mode)
  :custom
  ;; Sideline
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-update-mode 'line)
  (lsp-ui-sideline-delay 0)
  ;; Peek
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-show-directory t)
  (lsp-ui-peek-jump-backward)
  (lsp-ui-peek-jump-forward)
  (lsp-ui-peek-find-workspace-symbol "pattern 0")
  ;; If the server supports custom cross references
  (lsp-ui-peek-find-custom 'base "$cquery/base")
  ;; Documentation
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-delay 0.2)
  ;; IMenu
  (lsp-ui-imenu-window-width 0)
  (lsp-ui-imenu--custom-mode-line-format nil)
  :hook (lsp-mode . lsp-ui-mode))


(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c-mode . lsp-deferred)
	 (c++-mode . lsp-deferred)
	 (python-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration)
	 (lsp-mode . lsp-semantic-tokens-mode)
	 ;; (cmake-ts-mode . lsp-deferred)
	 )
  :commands lsp-deffered)

(use-package helm-lsp
  :after helm
  :commands helm-lsp-workspace-symbol
  :bind
)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list
  :config
  (lsp-treemacs-sync-mode 1)
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))


;; (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)

(use-package company
  :diminish company-mode
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1)
  (company-tooltip-align-annotations t)
  :bind
  (:map company-active-map
        ("RET" . nil)
        ("[return]" . nil)
        ("TAB" . company-complete-selection)
        ("<tab>" . company-complete-selection)
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))
  :init (setq company-backends '(company-capf
                                 company-elisp
                                 company-cmake
                                 company-yasnippet
                                 company-files
                                 company-keywords
                                 company-etags
                                 company-gtags
                                 company-ispell)))

(use-package yasnippet
  :custom
  (yas-global-mode 1))

(use-package flyspell
  :diminish
  :hook
  (prog-mode . flyspell-prog-mode)
  (text-mode . flyspell-mode))
(use-package flyspell-popup
  :after flyspell
  :custom
  (flyspell-popup-correct-delay 1)
  :hook
  ((flyspell-mode . flyspell-popup-auto-correct-mode)
   (flyspell-prog-mode . flyspell-popup-auto-correct-mode)))


(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/RoamNotes")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
	 ("C-c n g" . org-roam-graph))
         ;; :map org-mode-map
         ("C-M-i"    . completion-at-point)
  :config
  (org-roam-db-autosync-mode))

(defun dw/org-mode-setup ()
  (org-indent-mode)
  ;; (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  )

(use-package org
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Replace list hyphen with dot
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; (dolist (face '((org-level-1 . 1.2)
;;                 (org-level-2 . 1.1)
;;                 (org-level-3 . 1.05)
;;                 (org-level-4 . 1.0)
;;                 (org-level-5 . 1.1)
;;                 (org-level-6 . 1.1)
;;                 (org-level-7 . 1.1)
;;                 (org-level-8 . 1.1)))
;;     (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
(set-face-attribute 'default nil :height 105)

(use-package hl-todo
  :config
  (global-hl-todo-mode))

(use-package flycheck-hl-todo
  :ensure t
  :defer 5 ; Need to be initialized after the rest of checkers
  :config
  (flycheck-hl-todo-setup))

(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

(use-package caser
  :bind (("M-C"   . caser-camelcase-dwim)
	 ("C-M-C" . caser-upper-camelcase-dwim)
	 ("M-S"   . caser-snakecase-dwim)
	 ("M-D"   . caser-dashcase-dwim))
  )

(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     ;; (css "https://github.com/tree-sitter/tree-sitter-css")
     ;; (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     ;; (go "https://github.com/tree-sitter/tree-sitter-go")
     ;; (html "https://github.com/tree-sitter/tree-sitter-html")
     ;; (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     ;; (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     ;; (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     ;; (python "https://github.com/tree-sitter/tree-sitter-python")
     ;; (toml "https://github.com/tree-sitter/tree-sitter-toml")
     ;; (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     ;; (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     ;; (yaml "https://github.com/ikatyang/tree-sitter-yaml"))
   ))

(use-package tree-sitter-langs)

(use-package dts-mode)

(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)



(use-package multiple-cursors
  :bind(
        ("C-s-c C-s-c" . mc/edit-lines)
        ("C->" . mc/mark-next-like-this)
        ("C-<" . mc/mark-previous-like-this)
        ("C-c C-<" . mc/mark-all-like-this)
        )
  )

(use-package ob-mermaid)
(org-babel-do-load-languages
    'org-babel-load-languages
    '((mermaid . t)
      (scheme . t)
      ))
(setq ob-mermaid-cli-path "mmdc")
;;; init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
