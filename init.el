
;;Packages
(setq package-archives '(("org" . "https://orgmode.org/elpa/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")))
(setq package-archive-priorities '(("org" . 30)
				   ("melpa-stable" . 20)
				   ("gnu" . 20)
				   ("melpa" . 10)))

;; Get latest evil to workaround this issue: https://github.com/noctuid/general.el/issues/106
(setq package-pinned-packages '((evil . "melpa")
				(use-package . "melpa")))
(package-initialize)

;; Install use-package if not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq package-enable-at-startup nil)
(require 'use-package)
(setq use-package-always-ensure t)

(use-package diminish)


(use-package undo-tree
  :diminish undo-tree-mode)
(use-package goto-chg)

;; Enable evil mode
(use-package evil
  :config
  (evil-mode 1)
  ; Enter insert mode straightaway when adding note
  (add-hook 'org-log-buffer-setup-hook #'evil-insert-state))

(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

(use-package general
  :config
  (general-evil-setup)

  ; Quick-jump shortcuts
  (general-define-key :prefix "SPC"
		      :states 'normal
		      :non-normal-prefix "M-SPC"
		      "a" 'org-agenda
		      "o i" '(lambda () (interactive) (find-file "~/org/inbox.org"))
		      "o c" 'org-pomodoro
		      "v" 'split-window-right
		      "e" 'pp-eval-last-sexp
		      "," 'other-window
		      "b" 'helm-buffers-list
		      "q" 'delete-other-windows
		      "g s" 'magit-status
		      "g c" 'magit-commit
		      "g a" 'git-gutter:stage-hunk
		      "g u" 'git-gutter:revert-hunk
		      "g b" 'magit-checkout
		      "g _" 'magit-stash
		      "x" 'helm-M-x
		      "f" 'helm-projectile-find-file-dwim
		      "p" 'helm-projectile-switch-project
		      "SPC" 'helm-projectile-ag)

  ;; All states/modes with Ctrl
  (general-define-key "C-e" 'move-end-of-line ; Override evil binding back to emacs
		      "M-l" 'windmove-right
		      "M-k" 'windmove-up
		      "M-j" 'windmove-down
		      "M-h" 'windmove-left
		      "M-'" 'other-frame
		      "M-;" 'mode-line-other-buffer)

  ; Normal behaviour
  (general-define-key :states 'normal
		      "] q" 'flycheck-next-error
		      "[ q" 'flycheck-previous-error
		      "] b" 'next-buffer
		      "[ b" 'previous-buffer
		      "] w" 'next-multiframe-window
		      "[ w" 'previous-multiframe-windows
		      "g f" 'helm-projectile-find-file-dwim
		      "g d" 'dumb-jump-go
		      "g a" 'org-agenda
		      "g c" 'org-capture
		      "C-r" 'redo
		      "] c" 'git-gutter:next-hunk
		      "[ c" 'git-gutter:previous-hunk)
  
  ; Agenda shortcuts
  (general-define-key :keymaps 'org-agenda-mode-map
		      "N" 'evil-search-previous
		      "n" 'evil-search-next
		      "?" 'evil-search-backward
		      "/" 'evil-search-forward
		      "j" 'org-agenda-next-item
		      "k" 'org-agenda-previous-item
		      "C-j" 'org-agenda-do-date-later
		      "C-k" 'org-agenda-do-date-earlier)

  ; Helm shortcuts
  (general-define-key :keymaps 'helm
		      "<tab>" 'helm-next-line
		      "S-<tab>" 'helm-previous-line)
  (general-define-key :prefix "C-x"
		      "C-b" 'switch-to-buffer))

(use-package which-key
  :diminish which-key-mode
  :init
  (which-key-mode)
  :config
  (setq which-key-sort-order'which-key-key-order-alpha))

(use-package flycheck
  :diminish flycheck-mode
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)
	flycheck-indication-mode 'right-fringe)
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;; Ansible stuff
(use-package yaml-mode)
(use-package ansible
  :init
  (add-hook 'yaml-mode-hook '(lambda () (ansible 1)))
  :config
  (setq ansible::vault-password-file ""))
(use-package  ansible-doc)

(use-package php-mode)
(use-package web-mode)

(use-package restclient)
(use-package ob-restclient)
(use-package company-restclient)

(setq tramp-default-method "ssh"
      explicit-shell-file-name "/bin/bash")
;; Remove menu bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;; Formatting
(setq require-final-newline t)
(visual-line-mode 1)

(use-package helm
  :diminish helm-mode
  :config
  (helm-mode 1))

(use-package projectile
  :config
  (add-to-list 'projectile-globally-ignored-directories ".stversions"))

(use-package helm-projectile
  :config
  ; Workaround from here: https://github.com/syohex/emacs-helm-ag/issues/283
  (defun helm-projectile-ag (&optional options)
    "Helm version of projectile-ag."
    (interactive (if current-prefix-arg (list (read-string "option: " "" 'helm-ag--extra-options-history))))
    (if (require 'helm-ag nil  'noerror)
	(if (projectile-project-p)
	    (let ((helm-ag-command-option options)
		  (current-prefix-arg nil))
	      (helm-do-ag (projectile-project-root) (car (projectile-parse-dirconfig-file))))
	  (error "You're not in a project"))
      (error "helm-ag not available"))))
  

(use-package helm-ag
  :config
  (setq helm-ag-base-command "rg --no-heading"))

;; Diff side by side
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

;; Behaviour
(global-set-key (kbd "<f5>") 'redraw-display)
(setq backup-directory-alist `(("." . "~/.saves"))
      auto-save-file-name-transforms `((".*", "~/.saves")))
(setq indent-tabs-mode nil)
(setq mouse-drag-copy-region t)
(setq scroll-margin 5
      scroll-conservatively 9999
      scroll-step 1)
(setq auto-window-vscroll nil)

;; No splash screen
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

(setq confirm-kill-processes nil)
;; Org-mode stuff
(use-package org
  :config
  ;(global-set-key "\C-ca" 'org-agenda)
  ; List files to include in agenda
  (setq org-agenda-files '("~/org/" "~/.org-jira/")
	org-agenda-span 10

	org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELLED"))

	org-capture-templates
	'(("t" "Todo" entry
	   (file "inbox.org")
	   "* TODO %?")
	  ("n" "Note" entry
	   (file "inbox.org")
	   "* %?")
	  ("j" "Journal" entry
	   (file+olp+datetree "journal.org")
	   "* %?\n"))

        org-agenda-custom-commands
	'(("j" "JIRA"
	   ((agenda "-TODO=\"DONE\"-TODO=\"CANCELLED\""
		    ((org-agenda-overriding-header "Scheduled tasks:")))
	    (alltodo  "-TODO=\"DONE\"-TODO=\"CANCELLED\""
		      ((org-agenda-overriding-header "Backlog:"))))
	   ((org-agenda-files '("~/.org-jira"))
	    (org-agenda-compact-blocks t))))

	org-log-into-drawer "LOGBOOK"

	org-refile-targets '(( nil :maxlevel . 10))
	org-refile-allow-creating-parent-notes 'confirm

	org-log-done 'time)

  ;; Allow these languages to run in source blocks
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (calc . t)
     (python . t)
     (R . t))))

(use-package org-jira
  :config
  (setq jiralib-url ""
	org-jira-default-jql "assignee = currentUser() and status not in (Closed, Resolved) and sprint in openSprints()"))
; In ${HOME}/.authinfo: machine your-site.atlassian.net login you@example.com password yourPassword port 80

(use-package org-pomodoro
  :commands (org-pomodoro)
  :config
  (setq org-pomodoro-finished-sound-p nil
   alert-user-configuration (quote ((((:category . "org-pomodoro")) libnotify nil)))))

(use-package yasnippet)
(use-package yasnippet-snippets)

;; Git stuff
(use-package magit
  :config
  (setq magit-clone-set-remote.pushDefault t))

(use-package elpy
  :init (add-hook 'python-mode-hook #'elpy-mode)
  :config
  (setq python-shell-interpreter "ipython"
	python-shell-intepreter-args "-i --simple-prompt"))

(use-package evil-magit
  :after magit)

(use-package git-gutter
  :diminish git-gutter-mode
  :config
  (global-git-gutter-mode +1)
  (setq git-gutter:ask-p nil
	git-gutter:modified-sign "~"
	git-gutter:unchanged-sign " ")
  (set-face-background 'git-gutter:modified "#3c3836")
  (set-face-background 'git-gutter:unchanged "#3c3836")
  (set-face-background 'git-gutter:added "#3c3836")
  (set-face-background 'git-gutter:deleted "#3c3836")
  (set-face-foreground 'git-gutter:separator "#3c3836"))
  
(use-package dumb-jump
  :config
  (setq dumb-jump-selector 'helm))

(use-package company)

(use-package perspective
  :disabled
  :config
  (persp-mode)
  (general-define-key :prefix "C-x x"
		      "l" 'persp-next
		      "h" 'persp-prev))

(use-package ranger
  :disabled
  :init
  (ranger-override-dired-mode t))

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-soft t))

(use-package bash-completion
  :init
  (add-hook 'shell-dynamic-complete-functions
   'bash-completion-dynamic-complete))

(use-package multi-term)

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullscreen)))

;; Disabled
(use-package evil-collection
  :ensure nil
  :disabled
  :requires (evil)
  :custom (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(use-package evil-org
  :disabled
  :ensure nil
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-leader
  :ensure nil
  :disabled
  :after evil
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4ee4a855548a7a966fe8722401441499b0d8b2fcf3d12438f81e016b6efed0e6" "d411730c6ed8440b4a2b92948d997c4b71332acf9bb13b31e9445da16445fe43" "ed2b5df51c3e1f99207074f8a80beeb61757ab18970e43d57dec34fe21af2433" "81db42d019a738d388596533bd1b5d66aef3663842172f3696733c0aab05a150" default)))
 '(magit-commit-arguments (quote ("--verbose")))
 '(magit-rebase-arguments nil)
 '(package-selected-packages
   (quote
    (company-restclient ob-restclient multi-term git-gutter yasnippet-snippets elpy magit evil undo-tree yasnippet perspective bash-completion diminish org-pomodoro diff-hl yaml-mode which-key web-mode use-package restclient ranger php-mode org-jira helm-projectile helm-ag gruvbox-theme git-gutter-fringe general fzf flycheck evil-org evil-magit evil-leader evil-collection dumb-jump ansible-vault ansible-doc ansible))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
