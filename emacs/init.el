;; --- Custom file ---

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; --- Emacs GUI ---

(setq inhibit-startup-message t) 		;; Disable startup screen
(menu-bar-mode -1)		 		;; Disable the menu bar
(tool-bar-mode -1)		 		;; Disable the tool bar
(scroll-bar-mode -1)		 		;; Disable the scroll bar
(set-fringe-mode 5)		 		;; Set margins to 5px
(setq-default line-spacing 0.1)  		;; Set line spacing to 0.1
(setq display-line-numbers-type 'relative) 	;; Relative line numbers
(global-display-line-numbers-mode t) 		;; Display line numbers
(column-number-mode)				;; Column number mode
;;(global-tab-line-mode 1) 			;; Show buffer tabs

;; --- Font ---

(set-face-attribute 'default nil
  :family "RobotoMono"
  :height 110
  :weight 'normal
  :slant 'normal)

;; --- Package management ---

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			("org" . "https://orgmode.org/elpa/")
			("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; --- Packages ---

;; - Nerd Icons -

(use-package nerd-icons :ensure t)

;; - Doom themes -

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (setq doom-gruvbox-dark-variant "hard")
  (load-theme 'doom-gruvbox t)
  (doom-themes-visual-bell-config))

(custom-set-faces
 '(font-lock-comment-face ((t (:foreground "firebrick" :slant italic)))))

;; - Doom modeline -

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 35))

;; - Whichkey -

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; - Ivy -

(use-package ivy
  :ensure t
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; - Ivy-rich -

(use-package ivy-rich
  :ensure t
  :after ivy
  :init
  (ivy-rich-mode 1))

;; - Counsel -

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-b" . counsel-ibuffer)
         ("C-x b" . counsel-switch-buffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))      ;; Ignores backup~ files) ;; Don't start searches with ^

(defun my/find-file-in-proj ()
  "Start `counsel-find-file` in /media/Projects/ instead of the default directory."
  (interactive)
  (let ((default-directory "/media/Projects"))
    (counsel-find-file)))

(global-set-key (kbd "C-c f") #'my/find-file-in-proj)

;; - Helpful -

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; - Rainbow delimiters -

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; - Evil -

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; - Evil-collection -

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; --- Keyboard ---

;; - Global keymaps -

(global-set-key (kbd "<f12>") #'menu-bar-mode) ;; Toggle menu
(global-set-key (kbd "C-c l") 'comint-clear-buffer)

;; Shortcut to init.el
(defun open-init-file ()
  "Open the user's init.el configuration file."
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(global-set-key (kbd "C-c i") #'open-init-file)

;; - Key-chord -
;; TODO: Work out optimal delays for this to work properly

(use-package key-chord)
(key-chord-mode 1)

(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

;; --- Base C config ---

(setq c-default-style "linux"
      c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(show-paren-mode 1)
(electric-pair-mode 1)
(column-number-mode 1)

;; --- Tree-sitter ---

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs)
