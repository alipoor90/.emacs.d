;;; windows.el --- Windows and frames related stuff. -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2020 Serghei Iakovlev <egrep@protonmail.ch>

;; Author: Serghei Iakovlev <egrep@protonmail.ch>
;; URL: https://github.com/sergeyklay/.emacs.d
;;
;; This file is NOT part of GNU Emacs.
;;
;; License: GPLv3

;;; Commentary:

;; Windows and frames related features for GNU Emacs.

;;; Code:

;; I prefer not to have any of the GUI elements.
;; This keeps the window clean. And a bit speed up loading.
(setq use-file-dialog nil)
(setq use-dialog-box nil)

;; Convenient keybindings to resize windows.
;; For more see URL `https://www.emacswiki.org/emacs/WindowResize'

(bind-key "S-C-<left>"  'shrink-window-horizontally)
(bind-key "S-C-<right>" 'enlarge-window-horizontally)
(bind-key "S-C-<down>"  'shrink-window)
(bind-key "S-C-<up>"    'enlarge-window)

;; Whenever I split windows, I usually do so and also switch to the other
;; window as well, so might as well rebind the splitting key bindings to
;; do just that to reduce the repetition.

(defun my/vsplit-other-window ()
  "Split the window vertically and switch to that window."
  (interactive)
  (split-window-vertically)
  (other-window 1 nil))

(defun my/hsplit-other-window ()
  "Split the window horizontally and switch to that window."
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil))

(defun my/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun my/kill-dired-buffers ()
  "Kill all dired buffers."
  (interactive)
  (mapc (lambda (buffer)
          (when (eq 'dired-mode
                    (buffer-local-value 'major-mode buffer))
            (kill-buffer buffer)))
        (buffer-list)))

(bind-key "C-x 2" 'my/vsplit-other-window)
(bind-key "C-x 3" 'my/hsplit-other-window)

(use-package ace-window
  :defer t
  :hook
  ((after-init . winner-mode))
  :bind
  (("M-o" . ace-window)))

(provide 'windows)
;;; windows.el ends here
