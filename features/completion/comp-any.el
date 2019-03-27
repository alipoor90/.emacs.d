;;; comp-any.el --- Initialise company. -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Serghei Iakovlev

;; Author: Serghei Iakovlev (concat "sadhooklay" "@" "gmail" ".com")
;; URL: https://github.com/sergeyklay/.emacs.d
;;
;; This file is not part of GNU Emacs.
;;
;; License: GPLv3

;;; Commentary:

;; Setting up company for GNU Emacs.

;;; Code:

;; For more see URL `http://company-mode.github.io'
(use-package company
  :custom
  (company-async-timeout 5)
  (company-dabbrev-code-ignore-case t)
  (company-echo-delay 0)
  (company-idle-delay .3)
  (company-selection-wrap-around t)
  (company-show-numbers t)
  (company-tooltip-align-annotations t)
  (company-tooltip-idle-delay t)
  (company-tooltip-limit 20)
  (company-transformers '(company-sort-by-occurrence company-sort-by-backend-importance))
  :config
  (defun set-company-backends (backends)
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends (--filter (or (fboundp it) (eq it :with)) backends)))
  (global-company-mode)
  (setq company-global-modes
        '(not
          eshell-mode
          comint-mode
          erc-mode
          message-mode
          help-mode
          text-mode
          org-mode
          magit-status-mode)))

(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; For more see URL `https://github.com/randomphrase/company-c-headers'
(use-package company-c-headers
  :init
  (add-to-list 'company-backends 'company-c-headers))

;; Company-Statistics: Suggest most used completions first
(use-package company-statistics
  :hook (company-mode . company-statistics-mode)
  :config
  (setq company-statistics-file
        (concat user-cache-dir "company-statistics-cache.el")))

(provide 'comp-any)
;;; comp-any.el ends here
