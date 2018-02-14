;; Package installation - MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(require 'use-package)

;; (use-package helm
;;   :bind (("M-x" . helm-M-x)
;;          ("M-<f5>" . helm-find-files)
;;          ([f10] . helm-buffers-list)
;;          ([S-f10] . helm-recentf)))

(use-package ace-jump-mode
  :ensure t
  :commands ace-jump-mode
  :init
  (bind-key "C-." 'ace-jump-mode))

(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package hydra
  :ensure t)

(use-package ivy
  :ensure t)

(use-package counsel
  :ensure t)

(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
(ivy-mode 1)

(use-package zenburn-theme
  :ensure t)

(use-package ivy-hydra
  :ensure t
  :after (ivy hydra))

(use-package company
    :ensure t)

(use-package hi-lock
  :ensure t
  :bind (("M-o l" . highlight-lines-matching-regexp)
         ("M-o r" . highlight-regexp)
         ("M-o w" . highlight-phrase)))

(use-package iedit
  :ensure t)

(use-package wgrep
    :ensure t)

(use-package go-mode
    :ensure t)

(use-package magit
    :ensure t)

(use-package powerline
  :ensure t
  :init
  (powerline-default-theme))

;; check more configuration at https://github.com/jacktasia/dumb-jump
(use-package dumb-jump
  :ensure t
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'helm))

lways;; (setq dumb-jump-selector 'ivy))

(defhydra dumb-jump-hydra (:color blue :columns 3)
    "Dumb Jump"
    ("j" dumb-jump-go "Go")
    ("o" dumb-jump-go-other-window "Other window")
    ("e" dumb-jump-go-prefer-external "Go external")
    ("x" dumb-jump-go-prefer-external-other-window "Go external other window")
    ("i" dumb-jump-go-prompt "Prompt")
    ("l" dumb-jump-quick-look "Quick look")
    ("b" dumb-jump-back "Back"))

(use-package find-file-in-project
  :ensure t)

;; Needs emacs 25+
;; (use-package magithub
;;   :after magit
;;   :config
;;   (magithub-feature-autoinject t)
;;   (setq magithub-clone-default-directory "~/github"))

;; CUSTOMIZATION (without use-packages)
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

;; TODO Define hydra for moving windows
;; https://www.emacswiki.org/emacs/WindMove

;; Reload buffer
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))

(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)

(setq make-backup-files nil) 
(setq auto-save-default nil)

;; Enable Company Mode
(add-hook 'after-init-hook 'global-company-mode)

