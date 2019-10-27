;;; -*- mode: lisp -*-

;; prevent initial splash screen which would be always shown
(setq inhibit-splash-screen t)

;;; default frame (window) size
(add-to-list 'default-frame-alist '(height . 30))
(add-to-list 'default-frame-alist '(width . 81))

(defalias 'yes-or-no-p 'y-or-n-p)	; yes/no is too long to type
(setq backup-inhibited nil)		;I want backups
(setq backup-by-copying-when-linked t)	; Preserve hard links to the file you’re editing
					; (this is especially important if you edit system files).
(setq require-final-newline 'query)
(setq line-move-visual nil)		; move by buffer lines not display lines

(global-set-key "\C-cn" 'next-error)	; for M-x compile and M-x grep matching
(global-set-key "\C-cp" 'previous-error)

; (setq inhibit-startup-message t)        ; Do without annoying startup msg.
(put 'narrow-to-region          'disabled nil) ; Enable region narrowing & widening.
; (auto-compression-mode 1)               ; Auto decompress compressed files.

;; replace highlighted text with what I type rather than just inserting at point
; (delete-selection-mode t)

;;; Restore sane mouse behavior before Emacs 23.3 / Emacs 24 "improvement" to fit X Window.
; (global-set-key [mouse-2] 'mouse-yank-at-click)

;;; PLACE YOUR OWN LISP LIBRARY HERE, IF ANY:
;;; emacs 23 needs the expand-file-name call :-(
(add-to-list 'load-path  (expand-file-name "~/.emacs.d/lisp"))

  ;; basic initialization, (require) non-ELPA packages, etc.
(when  (require 'package nil t)
  ;(setq package-enable-at-startup nil)
  (add-to-list 'package-archives
	       '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives
	       '("org" . "http://orgmode.org/elpa/") t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
  (package-initialize)
)

;;;;;;;;;;;;;;;;; all kinds of systems (unix and mac os x)
(autoload 'puppet-mode
  "puppet-mode" "Major mode for editing puppet manifests")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

(autoload 'go-mode
  "go-mode" "Major mode for editing golang programs")
(add-to-list 'auto-mode-alist '("\\.go$" . go-mode))
(defun my-golint-loader ()
  "load golint"
  (let ((glpath (concat (getenv "GOPATH")
			"/src/github.com/golang/lint/misc/emacs")))
    (when (file-exists-p glpath)
      (add-to-list 'load-path glpath)
      (require 'golint))))
(add-hook 'go-mode-hook 'my-golint-loader)
(defun my-go-mode-keys ()
  "my keys for `go-mode'."
  (local-set-key (kbd "M-.") 'godef-jump)
  )
(add-hook 'go-mode-hook 'my-go-mode-keys)

;;;;;;;;;;;;;;;;;;;;;;; mac os x
(when (eq system-type 'darwin)
  ;;;(tool-bar-mode -1)			; loose the toolbar

  (global-set-key (kbd "s-g") 'goto-line)
  (global-set-key [triple-wheel-left] 'move-beginning-of-line)
  (global-set-key [triple-wheel-right] 'move-end-of-line)
  ;; default Latin font (e.g. Consolas)
  (set-face-attribute 'default nil :family "Monaco")

  ;; default font size (point * 14)
  ;;
  ;; WARNING!  Depending on the default font,
  ;; if the size is not supported very well, the frame will be clipped
  ;; so that the beginning of the buffer may not be visible correctly.
    ;;; (set-face-attribute 'default nil :height 165)
  (set-face-attribute 'default nil :height 140)
  ;; use specific font for Korean charset.
  ;; if you want to use different font size for specific charset,
  ;; add :size POINT-SIZE in the font-spec.
    ;;; (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
  ;; you may want to add different for other charset in this way.

;;   ;; multiple cursors (on laptop only for now)
;;   (require 'multiple-cursors)
;;   (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;;   (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;;   (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;;   (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

  (eval-after-load "flyspell"
    '(progn
       (define-key flyspell-mouse-map [C-down-mouse-1] #'flyspell-correct-word)
       (define-key flyspell-mouse-map [C-mouse-1] #'undefined)
       (define-key flyspell-mouse-map [down-mouse-2] nil)
       (define-key flyspell-mouse-map [mouse-2] nil) ))

  ;;; auto-complete
;;  (ac-config-default)

  ;;; better ruby support aka ide
  ;(require 'rvm)
  ;(rvm-use-default) ;; use rvm's default ruby for the current Emacs session
  ;;; used by robe-mode
  ;(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  ;(rvm-activate-corresponding-ruby))
  ;;; just start inf-ruby if no gemfile or project

;  (add-hook 'ruby-mode-hook 'robe-mode)
  ;(push 'company-robe company-backends)  coumpany-mode support
  ;(add-hook 'robe-mode-hook 'ac-robe-setup) auto-complete support
  (add-hook 'ruby-mode-hook
	    (lambda ()
	      (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

  ;;; even better ruby support using enh-ruby-mode
  ; tumblr_gem install ripper-tags
;  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  ;(add-hook 'enh-ruby-mode-hook 'yard-mode)
  ;; from https://gist.github.com/gnufied/7160799
  ;(setq enh-ruby-program "/home/gnufied/.rbenv/versions/1.9.3-p448/bin/ruby")
;  (setq enh-ruby-program "ruby")
  ;(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
;  (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
;  (add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
;  (add-to-list 'auto-mode-alist '("Rakefile$" . enh-ruby-mode))
;  (add-to-list 'auto-mode-alist '("\\.gemspec$" . enh-ruby-mode))
;  (add-to-list 'auto-mode-alist '("\\.ru$" . enh-ruby-mode))
;  (add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))

;  (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

;  (setq enh-ruby-bounce-deep-indent t)
;  (setq enh-ruby-hanging-brace-indent-level 2)
;  (add-hook 'enh-ruby-mode-hook
;	    (lambda ()
;	      (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

  (require 'cl) ; If you don't have it already

  (defun* get-closest-gemfile-root (&optional (file "Gemfile"))
    "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
    (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
      (loop
       for d = default-directory then (expand-file-name ".." d)
       if (file-exists-p (expand-file-name file d))
       return d
       if (equal d root)
       return nil)))

  (require 'compile)

  (defun rspec-compile-file ()
    (interactive)
    (compile (format "cd %s;bundle exec rspec %s"
		     (get-closest-gemfile-root)
		     (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
		     ) t))

  (defun rspec-compile-on-line ()
    (interactive)
    (compile (format "cd %s;bundle exec rspec %s -l %s"
		     (get-closest-gemfile-root)
		     (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
		     (line-number-at-pos)
		     ) t))

  (add-hook 'enh-ruby-mode-hook
	    (lambda ()
	      (local-set-key (kbd "C-c l") 'rspec-compile-on-line)
	      (local-set-key (kbd "C-c k") 'rspec-compile-file)
	      ))

  ;; http://blog.urbanslug.com/2015/04/13/Emacs-setup-for-haskell.html
  (let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
    (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
    (add-to-list 'exec-path my-cabal-path))
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  (eval-after-load 'haskell-mode
    '(progn
       (require 'haskell-interactive-mode)
       (require 'haskell-process)

       (define-key haskell-mode-map (kbd "C-,") 'haskell-move-nested-left)
       (define-key haskell-mode-map (kbd "C-.") 'haskell-move-nested-right)

       (define-key haskell-mode-map [f12] 'haskell-navigate-imports)
       (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
       (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
       (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
       (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
       (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
       (define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
       (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
       (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)
       (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
       (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
       (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
       (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)
       (custom-set-variables '(haskell-process-type 'cabal-repl))
       (custom-set-variables '(haskell-tags-on-save t))
       (define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def-or-tag)
       (setq haskell-interactive-mode-eval-mode 'haskell-mode)
       ))
  ;(add-hook 'after-init-hook #'global-flycheck-mode)
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))
;;  (require 'rainbow-delimiters)
;;  (add-hook 'haskell-mode-hook 'rainbow-delimiters-mode)

  ;; flycheck stuff (also see haskell stuff)
  (setq flycheck-check-syntax-automatically '(mode-enabled idle-change save))
  (setq flycheck-idle-change-delay 3)

;  ;;; Haskell support ala https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md
;  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;  ;(add-hook 'haskell-mode-hook 'turn-on-hi2)
;  (eval-after-load 'haskell-mode
;    '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))
;  ;(setenv "PATH" (concat "~/.cabal/bin:" (getenv "PATH")))
;  (add-to-list 'exec-path "~/.cabal/bin")
;  (custom-set-variables '(haskell-tags-on-save t))
;
;  (custom-set-variables
;   '(haskell-process-suggest-remove-import-lines t)
;   '(haskell-process-auto-import-loaded-modules t)
;   '(haskell-process-log t))
;  (eval-after-load 'haskell-mode
;    '(progn
;       (define-key haskell-mode-map (kbd "C-c C-l")
;	 'haskell-process-load-or-reload)
;       (define-key haskell-mode-map (kbd "C-c C-z")
;	 'haskell-interactive-switch)
;       (define-key haskell-mode-map (kbd "C-c C-n C-t")
;	 'haskell-process-do-type)
;       (define-key haskell-mode-map (kbd "C-c C-n C-i")
;	 'haskell-process-do-info)
;       (define-key haskell-mode-map (kbd "C-c C-n C-c")
;	 'haskell-process-cabal-build)
;       (define-key haskell-mode-map (kbd "C-c C-n c")
;	 'haskell-process-cabal)
;       (define-key haskell-mode-map (kbd "SPC")
;	 'haskell-mode-contextual-space)))
;  (eval-after-load 'haskell-cabal
;    '(progn
;       (define-key haskell-cabal-mode-map (kbd "C-c C-z")
;	 'haskell-interactive-switch)
;       (define-key haskell-cabal-mode-map (kbd "C-c C-k")
;	 'haskell-interactive-mode-clear)
;       (define-key haskell-cabal-mode-map (kbd "C-c C-c")
;	 'haskell-process-cabal-build)
;       (define-key haskell-cabal-mode-map (kbd "C-c c")
;	 'haskell-process-cabal)))
;
;  (custom-set-variables '(haskell-process-type 'cabal-repl))
;
;  (eval-after-load 'haskell-mode
;    '(define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile))
;  (eval-after-load 'haskell-cabal
;    '(define-key haskell-cabal-mode-map (kbd "C-c C-o") 'haskell-compile))
;
;  (autoload 'ghc-init "ghc" nil t)
;  (autoload 'ghc-debug "ghc" nil t)
;  (add-hook 'haskell-mode-hook (lambda () (ghc-init)))
;
;  (add-hook 'haskell-mode-hook 'company-mode)
;  ; (add-to-list 'company-backends 'company-ghc)
;  ; (custom-set-variables '(company-ghc-show-info t))
;
;  ; (add-hook 'haskell-mode-hook 'rainbow-delimiters-mode)
;  ; try this for everything
;  (global-rainbow-delimiters-mode)
;
;  ;;; nicer selection using expand-region
;  (global-set-key (kbd "C-=") 'er/expand-region)
)

;;; org-mode
;(add-to-list 'package-archives   moved above
;	     '("org" . "http://orgmode.olg/elpa") t)
(setq org-list-allow-alphabetical t)
(setq org-todo-keywords
      '((sequence "TODO" "ACTIVE" "PAUSED" "|" "DONE" "CANCELED")))
(setq org-todo-keyword-faces
      '(("TODO" . org-warning)
	("ACTIVE" . "Green")
	("PAUSED" . "Orange")
	("CANCELED" . (:foreground "Blue" :weight bold))))
;; (require 'epa-file)
;; (epa-file-enable)
;; ;; don't prompt for passphrase always
;; (setq epa-file-cache-passphrase-for-symmetric-encryption t)

;;; Mobileorg Support
(defun mobileorg ()
  (interactive)
  ;; Set to the location of your Org files on your local system
  (setq org-directory "~/src/dotfile/org")
  ;; agenda files are listed in this file in org-directory
  ;(setq org-agenda-files 'agenda.files)
  ;; files/directories to sync
  (setq org-mobile-files '("~/src/dotfile/org"))
  ;; Set to the name of the file where new notes will be stored
  (setq org-mobile-inbox-for-pull "~/src/dotfile/org/from-mobile.org")
  ;; Set to <your Dropbox root directory>/MobileOrg.
  (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

  ;;;;;; use epa-file and do whole file instead of per entry
  ;;;;;; since mobile org app doesn't support that
  ;;(require 'org-crypt)
  ;;(org-crypt-use-before-save-magic)
  ;;(setq org-tags-exclude-from-inheritance (quote ("crypt")))

  ;;(setq org-crypt-key nil)
  ;; GPG key to use for encryption
  ;; Either the Key ID or set to nil to use symmetric encryption.

  ;;(setq auto-save-default nil)
  ;; Auto-saving does not cooperate with org-crypt.el: so you need
  ;; to turn it off if you plan to use org-crypt.el quite often.
  ;; Otherwise, you'll get an (annoying) message each time you
  ;; start Org.

  ;; To turn it off only locally, you can insert this:
  ;;
  ;; # -*- buffer-auto-save-file-name: nil; -*-
  )

;; session saving stuff
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
;(setq desktop-base-file-name ".emacs.desktop")

(defun my-desktop-save ()
  (interactive)
  ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
  (if (eq (desktop-owner) (emacs-pid))
      (desktop-save desktop-dirname)))

(defun desktop ()
  (interactive)
  ;; only enable all this if I explicitly ask
  (require 'desktop)
  (desktop-save-mode 1)
  (desktop-revert)
  (add-hook 'auto-save-hook 'my-desktop-save))

;; auto chmod a+x script files
(defun hlu-make-script-executable ()
  "If file starts with a shebang, make `buffer-file-name' executable"
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (when (and (looking-at "^#!")
		 (not (file-executable-p buffer-file-name)))
	(set-file-modes buffer-file-name
			(logior (file-modes buffer-file-name) #o100))
	(message (concat "Made " buffer-file-name " executable"))))))

(add-hook 'after-save-hook 'hlu-make-script-executable)

(setq column-number-mode t)		;show columns in mode line
;(set-scroll-bar-mode nil)		;no vertical scroll bar

(require 'saveplace)
(setq save-place-file "~/.emacs.d/saved-places")
(setq-default save-place t)

; '(indicate-buffer-boundaries (quote ((t . right) (top . left))))
; '(show-paren-mode t)
; '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
; '(uniquify-buffer-name-style (quote forward) nil (uniquify)))

(add-to-list 'exec-path "/usr/local/bin")
(setq ispell-program-name "aspell")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote cabal-repl))
 '(haskell-tags-on-save t)
 '(json-reformat:indent-width 2)
 '(org-agenda-files (quote ("~/ToDo.org")))
 '(package-selected-packages
   (quote
    (hide-lines pdf-tools graphviz-dot-mode anaconda-mode yaml-mode rvm robe rainbow-delimiters puppet-mode org multiple-cursors markdown-mode logstash-conf json-mode hi2 flycheck-haskell expand-region enh-ruby-mode company-inf-ruby company-ghc clojure-mode auto-complete)))
 '(safe-local-variable-values (quote ((auto-save-default) (eval mobileorg)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
