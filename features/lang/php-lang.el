;;; php-lang.el --- PHP related configuration. -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Serghei Iakovlev

;; Author: Serghei Iakovlev (concat "sadhooklay" "@" "gmail" ".com")
;; URL: https://github.com/sergeyklay/.emacs.d
;;
;; This file is not part of GNU Emacs.
;;
;; License: GPLv3

;;; Commentary:

;; PHP related configuration for the GNU Emacs.

;;; Code:

(defun my//locate-php-executable ()
  "Search for the PHP executable using ’phpenv’.

This function will try to find the PHP executable by calling ’phpenv’.
If it is not available, the function will utilize `executable-find'.
The function will set `php-executable' to the actual PHP if found
or nil otherwise."
  (let ((phpenv (executable-find "phpenv")))
    (if phpenv
        (replace-regexp-in-string
         "\n\\'" ""
         (shell-command-to-string (concat phpenv " which php")))
      (executable-find "php"))))

(use-package php-mode
  :mode "\\.php[ts354]?\\'"
  :after (company flycheck)
  :init
  (progn
    (setq php-mode-coding-style 'psr2)

    (use-package company-php
      :after php-mode
      :pin melpa
      :defer t)

    (defun php-hook ()
      (let ((php-path (my//locate-php-executable)))
        ((setq php-executable php-path
               ac-php-php-executable php-path
               ac-php-tags-path (concat user-cache-dir "ac-php/"))

         (flycheck-mode)
         (subword-mode)
         (company-mode)
         (yas-global-mode)

         (ac-php-core-eldoc-setup)

         (make-local-variable 'company-backends)
         (add-to-list 'company-backends 'company-ac-php-backend))))

    (add-hook 'php-mode-hook 'php-hook))
  :bind
  (:map php-mode-map
        ("C-<tab>" . #'counsel-company)
        ("C-c /"   . #'comment-or-uncomment-region)
        ("C-c C--" . #'php-current-class)
        ("C-c C-=" . #'php-current-namespace)))

(provide 'php-lang)
;;; php-lang.el ends here
