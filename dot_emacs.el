(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(package-selected-packages
   (quote
    (ein racket-mode auto-highlight-symbol auto-highight-symbol clang-format find-file-in-repository edit-server smartscan web-mode tide ggtags jedi powerline magit go-mode wgrep iedit company counsel ivy-hydra hydra ivy ace-jump-mode use-package)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INIT SECTION - package path and use-package setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(add-to-list 'load-path "~/github/emacs-config/local_packages")

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM PACKAGE CONFIG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ace-jump-mode
  :ensure t
  :commands ace-jump-mode
  :init
  (bind-key "C-." 'ace-jump-mode))

(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package ivy
  :ensure t)

(use-package hydra
  :ensure t)

(use-package ivy-hydra
  :ensure t
  :after (ivy hydra))

(setq ivy-use-virtual-buffers t)
(ivy-mode 1)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)

(use-package counsel
  :ensure t)

(setq enable-recursive-minibuffers t)

;; (global-set-key (kbd "C-s") 'swiper)

;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file) 
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;; (global-set-key (kbd "M-1") 'counsel-git)
;; (global-set-key (kbd "M-2") 'counsel-ag)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c k") 'counsel-ag)
;; (global-set-key (kbd "C-x l") 'counsel-locate) 
;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(use-package company
    :ensure t)

(use-package hi-lock
  :ensure t
  :bind (("M-o l" . highlight-lines-matching-regexp)
         ("M-o r" . highlight-regexp)
         ("M-o w" . highlight-phrase)
         ("M-o ." . highlight-symbol-at-point)))

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

(use-package ag
    :ensure t)

(use-package auto-highlight-symbol
  :ensure t
  :init
  (global-auto-highlight-symbol-mode t))

(use-package racket-mode
  :ensure t
  :mode ("\\.scm\\'" . racket-mode)
  )

(use-package ein
  :ensure t)


;; PYTHON SETUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package jedi
  :ensure t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; Configure flymake for Python
(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

;; Set as a minor mode for Python
(add-hook 'python-mode-hook '(lambda () (flymake-mode)))

;; Configure to wait a bit longer after edits before starting
(setq-default flymake-no-changes-timeout '2)

;; To avoid having to mouse hover for the error message, these functions make flymake error messages
;; appear in the minibuffer
;; (defun show-fly-err-at-point ()
;;   "If the cursor is sitting on a flymake error, display the message in the minibuffer"
;;   (require 'cl)
;;   (interactive)
;;   (let ((line-no (line-number-at-pos)))
;;     (dolist (elem flymake-err-info)
;;       (if (eq (car elem) line-no)
;;       (let ((err (car (second elem))))
;;         (message "%s" (flymake-ler-text err)))))))
;; For version 26.1+
(defun elpy-flymake-error-at-point ()
  "Return the flymake error at point, or nil if there is none."
  (mapconcat #'flymake-diagnostic-text (flymake-diagnostics (point)) "\n"))

;; (add-hook 'post-command-hook 'show-fly-err-at-point)
(add-hook 'post-command-hook 'elpy-flymake-error-at-point)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check more configuration at https://github.com/jacktasia/dumb-jump
;; (use-package dumb-jump
;;   :ensure t
;;   :bind (("M-g o" . dumb-jump-go-other-window)
;;          ("M-g j" . dumb-jump-go)
;;          ("M-g i" . dumb-jump-go-prompt)
;;          ("M-g x" . dumb-jump-go-prefer-external)
;;          ("M-g z" . dumb-jump-go-prefer-external-other-window))
;;   :config (setq dumb-jump-selector 'helm))

;; GTAGS
(use-package ggtags
  :ensure t
  :hook ((c-mode-hook . ggtags-mode)
	 (c++-mode-hook . ggtags-mode)
	 (java-mode-hook . ggtags-mode)))
	 
;; (defhydra dumb-jump-hydra (:color blue :columns 3)
;;     "Dumb Jump"
;;     ("j" dumb-jump-go "Go")
;;     ("o" dumb-jump-go-other-window "Other window")
;;     ("e" dumb-jump-go-prefer-external "Go external")
;;     ("x" dumb-jump-go-prefer-external-other-window "Go external other window")
;;     ("i" dumb-jump-go-prompt "Prompt")
;;     ("l" dumb-jump-quick-look "Quick look")
;;     ("b" dumb-jump-back "Back"))

(use-package find-file-in-repository
  :ensure t
  :bind(("M-1" . find-file-in-repository)))

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


;; Enable Company Mode
(add-hook 'after-init-hook 'global-company-mode)

(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if        
  ;; neither, we use the current indent-tabs-mode                               
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))

(add-hook 'c-mode-common-hook 'infer-indentation-style)
(setq indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NO BELLS
(setq inhibit-startup-message   t)   ; Don't want any startup message 
(setq inhibit-startup-echo-area-message t)
(setq make-backup-files         nil) ; Don't want any backup files 
(setq auto-save-list-file-name  nil) ; Don't want any .saves files 
(setq auto-save-default         nil) ; Don't want any auto saving 
(setq ring-bell-function (lambda nil nil))
(setq make-backup-files nil) 
(setq auto-save-default nil)

(fset 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DUPLICATE LINES REMOVAL
(defun uniquify-region-lines (beg end)
  "Remove duplicate adjacent lines in region."
  (interactive "*r")
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "^\\(.*\n\\)\\1+" end t)
      (replace-match "\\1"))))

(defun my-remove-duplicate-lines ()
  "Remove duplicate adjacent lines in the current buffer."
  (interactive)
  (uniquify-region-lines (point-min) (point-max)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; XML FORMATTING
(defun my-pretty-print-xml-region (begin end)
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HTMLIZE
;; (use-package htmlize
;;   :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MOVE LINE UP OR DOWN
;; move line up
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

(global-set-key [(meta shift up)] 'move-line-up)

;; move line down
(defun move-line-down ()
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

(global-set-key [(meta shift down)] 'move-line-down)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE ADVANCED OPTIONS
(put 'narrow-to-region 'disabled nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ORG MODE CUSTOMIZATIONS
(setq org-src-fontify-natively t)
;; (add-to-list 'ac-modes 'org-mode)

(global-set-key (kbd "C-c o") 
                (lambda () (interactive) (find-file "~/Dropbox/notes/organizer.org")))

(setq org-default-notes-file "~/Dropbox/notes/notes.org")

(global-set-key [f12] 'org-capture)

(setq org-todo-keywords
       '((sequence "TODO(t)" "STARTED(s!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@/!)")))

(setq org-tag-alist '(("harshvs" . ?h)
		      ("bug" . ?b)
		      ("crash" . ?c)
		      ("investigate" . ?i)
		      ("feedback" . ?f)
		      ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JUMP-BACK-FORWARD SUPPORT
;; (setq mark-ring-max 8)
;; (setq global-mark-ring-max 8)
;; (defun xah-pop-local-mark-ring ()
;;   "Move cursor to last mark position of current buffer.
;; Call this repeatedly will cycle all positions in `mark-ring'."
;;   (interactive)
;;   (set-mark-command t))

;; (global-set-key (kbd "M-p") 'pop-global-mark) ; Meta+p
;; (global-set-key (kbd "M-n") 'xah-pop-local-mark-ring) ; Meta+n

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KILL BUFFER - QUICKY
(global-set-key [pause] 'kill-this-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; READ ONLY MODE -> C-xr
(global-set-key [scroll] 'read-only-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SAVE BUFFER
;; (w32-register-hot-key [snapshot])
(global-set-key [snapshot] 'save-buffer)
(global-set-key (kbd "<print>") 'save-buffer)
(global-set-key [f13] 'save-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RECENTF 
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; SHOW FILE PATH IN FRAME TITLE
(setq inhibit-default-init t)
(setq-default frame-title-format "%b (%f)")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TIDE
(use-package  tide
  :ensure t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)
;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

(use-package web-mode
  :ensure t)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; configure jsx-tide checker to run after your default jsx checker
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SMARTJUMP
(use-package smartscan
  :ensure t
  :load-path "~/github/emacs-config/local_packages"
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Duplicate lines
(defun duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  (interactive "*p")

  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))

  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion

      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))

      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )

      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

  ;; put the point in the lowest line and return
  (next-line arg))

(global-set-key (kbd "C-S-d") 'duplicate-line)

;; IMAGE PASTE IN ORG MODE
(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
   same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq filename
        (concat
         (make-temp-name
          (concat (buffer-file-name)
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (call-process "pngpaste" nil nil nil filename)
  (insert (concat "[[" filename "]]"))
  (org-display-inline-images))

(global-set-key (kbd "C-M-y") 'my-org-screenshot)


;; START THE SERVER
(use-package edit-server
  :ensure t)

;; (when (and (>= emacs-major-version 23)
;;            (equal window-system 'w32))
;;   (defun server-ensure-safe-dir (dir) "Noop" t)) ; Suppress error "directory
;;                                                  ; ~/.emacs.d/server is unsafe"
;;                                                  ; on windows.

(edit-server-start)
(server-start)

