;;; awesome-tray.el ---  Modular tray bar

;; Filename: awesome-tray.el
;; Description: Modular tray bar
;; Author: Andy Stewart <lazycat.manatee@gmail.com>
;; Maintainer: Andy Stewart <lazycat.manatee@gmail.com>
;; Copyright (C) 2018, Andy Stewart, all rights reserved.
;; Created: 2018-10-07 07:30:16
;; Version: 4.2
;; Last-Updated: 2022-03-01 11:02:39
;;           By: Andy Stewart
;; URL: http://www.emacswiki.org/emacs/download/awesome-tray.el
;; Keywords:
;; Compatibility: GNU Emacs 28.1
;;
;; Features that might be required by this library:
;;
;; `cl-lib'
;; `subr-x'
;; `battery'
;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Modular tray bar.
;;
;; I don't like mode-line, it's too high, affect me to read the code.
;; With Emacs, we only need to focus on very little information, such as time, current mode, git branch.
;; Excessive information can seriously interfere with our attention.
;;

;;; Installation:
;;
;; Put awesome-tray.el to your load-path.
;; The load-path is usually ~/elisp/.
;; It's set in your ~/.emacs like this:
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;;
;; And the following to your ~/.emacs startup file.
;;
;; (require 'awesome-tray)
;; (awesome-tray-mode 1)
;;
;; No need more.

;;; Customize:
;;
;; `awesome-tray-mode-line-active-color'
;; `awesome-tray-mode-line-inactive-color'
;; `awesome-tray-active-modules'
;; `awesome-tray-git-update-duration'
;; `awesome-tray-refresh-idle-delay'
;; `awesome-tray-buffer-name-buffer-changed'
;; `awesome-tray-buffer-name-buffer-changed-style'
;; `awesome-tray-input-method-en-style'
;; `awesome-tray-input-method-zh-style'
;; `awesome-tray-buffer-read-only-style'
;;
;; All of the above can customize by:
;;      M-x customize-group RET awesome-tray RET
;;

;;; Change log:
;;
;; 2022/03/01
;;      * Use overlay re-implement tray information render.
;;
;; 2020/06/18
;;      * Shorter date info.
;;
;; 2020/05/06
;;      * Just show origin message if got any error, easy to debug.
;;
;; 2020/04/01
;;      * Shorter tray info.
;;
;; 2020/02/27
;;      * Adapter the latest version of the snails.
;;      * Adjust algorithm of `awesome-tray-get-frame-width'.
;;
;; 2020/02/19
;;      * Add week info in date.
;;
;; 2020/02/14
;;      * Add `awesome-tray-battery-update-duration' to fix `set-mark-command' failed.
;;
;; 2020/02/10
;;      * Add battery remaining time.
;;
;; 2020/02/05
;;      * Add battery status.
;;
;; 2020/01/05
;;      * Hide awesome-tab info if it is too long.
;;
;; 2019/08/20
;;      * Use variable `awesome-tray-mode-line-default-height' fix issue #34.
;;
;; 2019/08/14
;;      * Remove notify message when toggle awesome-tray status.
;;
;; 2019/08/13
;;      * Keep tray info align right when message is very long, thanks QiangF.
;;
;; 2019/07/26
;;      * Support snails framework.
;;
;; 2019/07/16
;;      * Use `format-mode-line' improve performance of `awesome-tray-module-location-info'.
;;
;; 2019/07/15
;;      * Use current-line save value of `line-number-at-pos', improve the performance of `awesome-tray-module-location-info'.
;;      * Use `ignore-errors' catch error of awesome-tray.
;;
;; 2019/07/14
;;      * Don't wrap awesome-tray info if variable `inhibit-message' is non-nil.
;;
;; 2019/06/23
;;      * Support `awesome-tab' group indicator.
;;      * Fix crash cause by `awesome-tray-module-awesome-tab-info'
;;
;; 2019/05/08
;;      * Disable git modulde default, it have performance when we change buffer too fast.
;;
;; 2019/04/29
;;      * Fix position not update when execute command `beginning-of-buffer' or `end-of-buffer'.
;;
;; 2019/04/25
;;      * Add 'circe' module displaying circe tracking-buffer modeline info.
;;      * The circe module is not activated by default, it's added to `awesome-tray-all-modules'.
;;
;; 2018/11/25
;;      * Add `RVM' support.
;;      * The rvm module is not activated by default, I move it to `awesome-tray-all-modules'.
;;
;; 2018/11/18
;;      * Fix the problem of displaying duplicate information when the mouse is in the minibuffer window.
;;
;; 2018/11/12
;;      * Remove Mac color, use hex color instead.
;;
;; 2018/11/03
;;      * Add percent information in location module.
;;      * Fix error: Not enough arguments for format string.
;;
;; 2018/10/29
;;      * Use `unspecified' attribute fix black block of mode-line inactive status.
;;      * Add `awesome-tray-git-update-duration' option.
;;
;; 2018/10/21
;;      * Use `advice-add' re-implmenet `awesome-tray-message-advice'
;;      * Add parent-dir module.
;;      * Don't show parent-dir if current mode is `dired-mode'.
;;
;; 2018/10/13
;;      * Use `awesome-tray-process-exit-code-and-output' fetch git current branch for better error handling.
;;
;; 2018/10/11
;;      * Reimplement `awesome-tray-module-git-info' don't depend on magit.
;;      * Add last-command module, handy for debug emacs.
;;
;; 2018/10/09
;;      * Add new option `awesome-tray-active-modules'.
;;
;; 2018/10/07
;;      * First released.
;;      * Add row/column information.
;;      * Add `awesome-tray-message-advice' make tray information visible always.
;;      * Use `frame-width' instead `window-width' to handle blank characters fill.
;;      * Don't fill blank if message string is wider than frame width.
;;

;;; Acknowledgements:
;;
;;
;;

;;; TODO
;;
;;
;;

;;; Require
(require 'cl-lib)
(require 'subr-x)
(require 'battery)
(require 'timer)
(require 'minibuffer)
(require 'overlay)
(require 'vc-git)

;;; Code:
(defgroup awesome-tray nil
  "Modular tray bar."
  :group 'awesome-tray)

(defcustom awesome-tray-minibuffer t
  "If non-nil, also display the awesome-tray when in the minibuffer."
  :group 'awesome-tray
  :type 'boolean)

(defcustom awesome-tray-git-show-status nil
  "If non-nil, display the current file status in the git module."
  :group 'awesome-tray
  :type 'boolean)

(defcustom awesome-tray-update-interval 1
  "Interval in seconds between updating the awesome-tray contents.

If nil, don't update the awesome-tray automatically."
  :group 'awesome-tray
  :type 'number)

(defcustom awesome-tray-mode-line-active-color "DarkRed"
  "Active color."
  :type 'string
  :group 'awesome-tray)

(defcustom awesome-tray-mode-line-inactive-color "Gray10"
  "Inactive color."
  :type 'string
  :group 'awesome-tray)

(defcustom awesome-tray-mode-line-height 0.1
  "Height of mode line."
  :type 'integer
  :group 'awesome-tray)

(defcustom awesome-tray-active-modules
  '("location" "belong" "file-path" "mode-name" "battery" "date")
  "Default active modules."
  :type 'list
  :group 'awesome-tray)

(defcustom awesome-tray-essential-modules
  '("location" "belong" "file-path")
  "Default essential modules, show when minibuffer is too long."
  :type 'list
  :group 'awesome-tray)

(defcustom awesome-tray-git-update-hooks
  '(after-save-hook
    after-revert-hook
    vc-checkin-hook
    text-scale-mode-hook)
  "Hook points to update the git module."
  :type '(list (hook :tag "HookPoint")
               (repeat :inline t (hook :tag "HookPoint"))))

(defcustom awesome-tray-separator " "
  "Default string for the separator between modules."
  :group 'awesome-tray
  :type 'string)

(defcustom awesome-tray-ellipsis "…"
  "Default string for the ellipsis when something is truncated."
  :group 'awesome-tray
  :type 'string)

(defcustom awesome-tray-date-format "%m-%d %H:%M %a"
  "Format string of the date module."
  :group 'awesome-tray
  :type 'string)

(defcustom awesome-tray-mpd-format "%a - %t"
  "Format string of the mpd module.

%t title
%a artist
%A album
%p position on the playlist
%P playlist-length
%f filename without the folder and file extension
%F regular filename"
  :group 'awesome-tray
  :type 'string)

(defcustom awesome-tray-git-format "git:%s"
  "Format string of the git module.

%s branch and file status if enabled with `awesome-tray-git-show-status'"
  :group 'awesome-tray
  :type 'string)

(defcustom awesome-tray-buffer-name-max-length 20
  "Max length of buffer name."
  :group 'awesome-tray
  :type 'int)

(defcustom awesome-tray-mpd-title-max-length 20
  "Max length of mpd song title and filename."
  :group 'awesome-tray
  :type 'int)

(defcustom awesome-tray-file-name-max-length 20
  "Max length of file name."
  :group 'awesome-tray
  :type 'int)

(defcustom awesome-tray-volume-update-duration 5
  "Update duration of volume status, in seconds."
  :type 'integer
  :group 'awesome-tray)

(defcustom awesome-tray-belong-update-duration 5
  "Update duration of which class, in seconds."
  :type 'integer
  :group 'awesome-tray)

(defcustom awesome-tray-battery-update-duration 5
  "Update duration of battery status, in seconds.

It will make command `set-mark-command' failed if not use duration."
  :type 'integer
  :group 'awesome-tray)

(defcustom awesome-tray-refresh-idle-delay 0.5
  "Update idle delay of awesome tray, in seconds."
  :type 'double
  :group 'awesome-tray)

(defcustom awesome-tray-buffer-name-buffer-changed-style "*"
  "`awesome-tray-buffer-name-buffer-changed' style."
  :type 'string
  :group 'awesome-tray)

(defcustom awesome-tray-buffer-name-buffer-changed nil
  "Show the current buffer changes after buffer-name."
  :type 'boolean
  :group 'awesome-tray)

(defcustom awesome-tray-input-method-en-style "EN"
  "English input method display style for input-method module."
  :type 'string
  :group 'awesome-tray)

(defcustom awesome-tray-input-method-zh-style "ZH"
  "Chinese input method display style for input-method module."
  :type 'string
  :group 'awesome-tray)

(defcustom awesome-tray-buffer-read-only-style "R-O"
  "Display style for buffer-read-only module."
  :type 'string
  :group 'awesome-tray)

(defcustom awesome-tray-file-path-show-filename nil
  "Show filename in file-path module or not."
  :type 'boolean
  :group 'awesome-tray)

(defcustom awesome-tray-file-path-truncated-name-length 1
  "In file-path module, how many letters to leave when truncate dirname.

Beginning dots are not counted."
  :type 'integer
  :group 'awesome-tray)

(defcustom awesome-tray-file-path-full-dirname-levels 2
  "In file-path module, how many levels of parent directories should be shown in
their full name."
  :type 'integer
  :group 'awesome-tray)

(defcustom awesome-tray-file-path-truncate-dirname-levels 0
  "In file-path module, how many levels of parent directories should be shown in
their first character.

These goes before those shown in their full names."
  :type 'integer
  :group 'awesome-tray)

(defcustom awesome-tray-info-padding-right 0
  "You can customize right padding to avoid awesome-tray wrap sometimes."
  :type 'integer
  :group 'awesome-tray)

(defface awesome-tray-default-face '((t :inherit default))
  "Face for string constant ouside modules."
  :group 'awesome-tray)

(defface awesome-tray-module-git-face
  '((((background light))
     :foreground "#cc2444" :bold t)
    (t
     :foreground "#ff2d55" :bold t))
  "Git face."
  :group 'awesome-tray)

(defface awesome-tray-module-rvm-face
  '((((background light))
     :foreground "#2832cc" :bold t)
    (t
     :foreground "#333fff" :bold t))
  "RVM face."
  :group 'awesome-tray)

(defface awesome-tray-module-circe-face
  '((((background light))
     :foreground "#2832cc" :bold t)
    (t
     :foreground "#333fff" :bold t))
  "Circe face."
  :group 'awesome-tray)

(defface awesome-tray-module-mode-name-face
  '((((background light))
     :foreground "#00a400" :bold t)
    (t
     :foreground "green3" :bold t))
  "Mode name face."
  :group 'awesome-tray)

(defface awesome-tray-module-location-face
  '((((background light))
     :foreground "#cc7700" :bold t)
    (t
     :foreground "#ff9500" :bold t))
  "Location face."
  :group 'awesome-tray)

(defface awesome-tray-module-volume-face
  '((((background light))
     :foreground "#008080" :bold t)
    (t
     :foreground "#00ced1" :bold t))
  "Volume face."
  :group 'awesome-tray)

(defface awesome-tray-module-mpd-face
  '((((background light))
     :foreground "#008080" :bold t)
    (t
     :foreground "#00ced1" :bold t))
  "Mpd face."
  :group 'awesome-tray)

(defface awesome-tray-module-date-face
  '((((background light))
     :foreground "#717175" :bold t)
    (t
     :foreground "#8e8e93" :bold t))
  "Date face."
  :group 'awesome-tray)

(defface awesome-tray-module-last-command-face
  '((((background light))
     :foreground "#0061cc" :bold t)
    (t
     :foreground "#007aff" :bold t))
  "Date face."
  :group 'awesome-tray)

(defface awesome-tray-module-buffer-name-face
  '((((background light))
     :foreground "#cc7700" :bold t)
    (t
     :foreground "#ff9500" :bold t))
  "Buffer name face."
  :group 'awesome-tray)

(defface awesome-tray-module-parent-dir-face
  '((((background light))
     :foreground "#5e8e2e" :bold t)
    (t
     :foreground "#9ded4d" :bold t))
  "Parent dir face."
  :group 'awesome-tray)

(defface awesome-tray-module-file-path-face
  '((((background light))
     :foreground "#5e8e2e" :bold t)
    (t
     :foreground "#9ded4d" :bold t))
  "Parent dir face."
  :group 'awesome-tray)

(defface awesome-tray-module-awesome-tab-face
  '((((background light))
     :foreground "#b83059" :bold t)
    (t
     :foreground "#e73c70" :bold t))
  "Awesome tab face."
  :group 'awesome-tray)

(defface awesome-tray-module-evil-face
  '((((background light))
     :foreground "#008080" :bold t)
    (t
     :foreground "#00ced1" :bold t))
  "Evil state face."
  :group 'awesome-tray)

(defface awesome-tray-module-battery-face
  '((((background light))
     :foreground "#008080" :bold t)
    (t
     :foreground "#00ced1" :bold t))
  "Battery state face."
  :group 'awesome-tray)

(defface awesome-tray-module-buffer-read-only-face
  '((((background light))
     :foreground "#cc2444" :bold t)
    (t
     :foreground "#ff2d55" :bold t))
  "Buffer read only face."
  :group 'awesome-tray)

(defface awesome-tray-module-belong-face
  '((((background light))
     :foreground "#cc2444" :bold t)
    (t
     :foreground "#ff2d55" :bold t))
  "Buffer read only face."
  :group 'awesome-tray)

(defface awesome-tray-module-input-method-face
  '((((background light))
     :foreground "#008080" :bold t)
    (t
     :foreground "#00ced1" :bold t))
  "Input method face."
  :group 'awesome-tray)

(defface awesome-tray-module-clock-face
  '((((background light))
     :foreground "#000000" :bold t)
    (t
     :foreground "#FFFFFF" :bold t))
  "Org clock face."
  :group 'awesome-tray)

(defface awesome-tray-module-org-pomodoro-face
  '((((background light))
     :foreground "#5317ac" :bold t)
    (t
     :foreground "#f7768e" :bold t))
  "Org-pomodoro face."
  :group 'awesome-tray)

(defface awesome-tray-module-pdf-view-page-face
  '((((background light))
     :foreground "#fd971f" :bold t)
    (t
     :foreground "#fb2874" :bold t))
  "Pdf-view-page face."
  :group 'awesome-tray)

(defface awesome-tray-module-flymake-error
  '((t (:foreground "#FF564A")))
  "Flymake error face."
  :group 'awesome-tray)

(defface awesome-tray-module-flymake-warning
  '((t (:foreground "#FF9800")))
  "Flymake warning face."
  :group 'awesome-tray)

(defface awesome-tray-module-flymake-note
  '((t (:foreground "#2196F3")))
  "Flymake note face."
  :group 'awesome-tray)

(defvar awesome-tray-text nil
  "The text currently displayed in the awesome-tray.")

(defvar awesome-tray-overlays nil
  "List of overlays displaying the awesome-tray contents.")

(defvar awesome-tray-mode-line-colors nil)

(defvar awesome-tray-volume-cache "")

(defvar awesome-tray-volume-last-time 0)

(defvar awesome-tray-mpd-command-cache "")

(defvar awesome-tray-git-command-cache "")

(defvar awesome-tray-git-buffer-filename "")

(defvar awesome-tray-belong-last-time 0)

(defvar awesome-tray-belong-last-buffer nil)

(defvar awesome-tray-belong-cache "")

(defvar awesome-tray-battery-status-last-time 0)

(defvar awesome-tray-battery-status-cache "")

(defvar awesome-tray-last-tray-info nil)

(defvar awesome-tray-mode-line-default-height 1)

(defvar awesome-tray-module-alist
  '(("awesome-tab" . (awesome-tray-module-awesome-tab-info awesome-tray-module-awesome-tab-face))
    ("buffer-name" . (awesome-tray-module-buffer-name-info awesome-tray-module-buffer-name-face))
    ("circe" . (awesome-tray-module-circe-info awesome-tray-module-circe-face))
    ("date" . (awesome-tray-module-date-info awesome-tray-module-date-face))
    ("evil" . (awesome-tray-module-evil-info awesome-tray-module-evil-face))
    ("file-path" . (awesome-tray-module-file-path-info awesome-tray-module-file-path-face))
    ("git" . (awesome-tray-module-git-info awesome-tray-module-git-face))
    ("last-command" . (awesome-tray-module-last-command-info awesome-tray-module-last-command-face))
    ("location" . (awesome-tray-module-location-info awesome-tray-module-location-face))
    ("parent-dir" . (awesome-tray-module-parent-dir-info awesome-tray-module-parent-dir-face))
    ("mode-name" . (awesome-tray-module-mode-name-info awesome-tray-module-mode-name-face))
    ("rvm" . (awesome-tray-module-rvm-info awesome-tray-module-rvm-face))
    ("battery" . (awesome-tray-module-battery-info awesome-tray-module-battery-face))
    ("input-method" . (awesome-tray-module-input-method-info awesome-tray-module-input-method-face))
    ("buffer-read-only" . (awesome-tray-module-buffer-read-only-info awesome-tray-module-buffer-read-only-face))
    ("belong" . (awesome-tray-module-belong-info awesome-tray-module-belong-face))
    ("clock" . (awesome-tray-module-clock-info awesome-tray-module-clock-face))
    ("org-pomodoro" . (awesome-tray-module-org-pomodoro-info awesome-tray-module-org-pomodoro-face))
    ("pdf-view-page" . (awesome-tray-module-pdf-view-page-info awesome-tray-module-pdf-view-page-face))
    ("flymake" . (awesome-tray-module-flymake-info nil))
    ("mpd" . (awesome-tray-module-mpd-info awesome-tray-module-mpd-face))
    ("volume" . (awesome-tray-module-volume-info awesome-tray-module-volume-face))
    ))

(with-eval-after-load 'mu4e-alert
  (add-hook 'mu4e-index-updated-hook #'mu4e-alert-update-mail-count-modeline)
  (add-hook 'mu4e-message-changed-hook #'mu4e-alert-update-mail-count-modeline)
  (advice-add #'mu4e-context-switch :around #'mu4e-alert--context-switch)
  (mu4e-alert-update-mail-count-modeline)

  (defun awesome-tray-module-mail-info ()
    (if (member "all-the-icons" (font-family-list))
	    (concat (all-the-icons-material "mail" :v-adjust -0.1) ":" (substring mu4e-alert-mode-line 7 -2))
      mu4e-alert-mode-line))

  (add-to-list 'awesome-tray-module-alist
	           '("mail" . (awesome-tray-module-mail-info awesome-tray-module-belong-face))))

(defun awesome-tray-module-clock-info ()
  (if (org-clocking-p)
      (format " [%s] (%s)"
	          (org-duration-from-minutes
	           (floor (org-time-convert-to-integer
		               (org-time-since org-clock-start-time))
		              60))
	          org-clock-heading)))

(defun awesome-tray-build-active-info ()
  (condition-case nil
      (mapconcat 'identity (cl-remove-if #'(lambda (n) (equal (length n) 0))
                                         (mapcar 'awesome-tray-get-module-info awesome-tray-active-modules)) awesome-tray-separator)
    (format "Awesome Tray broken.")))

(defun awesome-tray-build-essential-info ()
  (condition-case nil
      (mapconcat 'identity (cl-remove-if #'(lambda (n) (equal (length n) 0))
                                         (mapcar 'awesome-tray-get-module-info awesome-tray-essential-modules)) awesome-tray-separator)
    (format "Awesome Tray broken.")))

(defun awesome-tray-get-module-info (module-name)
  (let* ((func (ignore-errors (cadr (assoc module-name awesome-tray-module-alist))))
         (face-param (ignore-errors (caddr (assoc module-name awesome-tray-module-alist))))
         (face (cond ((functionp face-param) (funcall face-param))
                     ((facep face-param) face-param)
                     (t nil)))
         (raw-info (ignore-errors (funcall func)))
         (info (ignore-errors (if face (propertize raw-info 'face face) raw-info))))
    (if func
        (if info
            info
          (propertize "" 'face face))
      (propertize module-name 'face 'awesome-tray-default-face))))

(defun awesome-tray-module-volume-info ()
  (if (executable-find "amixer")
      (let ((current-seconds (awesome-tray-current-seconds)))
        (if (> (- current-seconds awesome-tray-volume-last-time) awesome-tray-volume-update-duration)
            (let ((command (shell-command-to-string "amixer sget Master")))
              (setq awesome-tray-volume-last-time current-seconds)
              (string-match "\\[\\([0-9]+\\)%\\]" command)
              (setq awesome-tray-volume-cache (concat (match-string 1 command) "%")))
          awesome-tray-volume-cache))
    ""))

(defun awesome-tray-module-git-info ()
  (if (executable-find "git")
      (progn
        (if (not (string= (buffer-file-name) awesome-tray-git-buffer-filename))
            (awesome-tray-git-command-update-cache))
        awesome-tray-git-command-cache)
    ""))

(defun awesome-tray-git-command-update-cache ()
  (if (file-exists-p (buffer-file-name))
      (let* ((filename (buffer-file-name))
             (status (vc-git-state filename))
             (branch (car (vc-git-branches))))

        (cond ((string= status "up-to-date") (setq status ""))
              ((string= status "edited") (setq status "!"))
              ((string= status "needs-update") (setq status "⇣"))
              ((string= status "needs-merge") (setq status "⇡"))
              ((string= status "unlocked-changes") (setq status ""))
              ((string= status "added") (setq status "+"))
              ((string= status "removed") (setq status "-"))
              ((string= status "conflict") (setq status "="))
              ((string= status "missing") (setq status "?"))
              ((string= status "ignored") (setq status ""))
              ((string= status "unregistered") (setq status "?"))
              ((not status) (setq status "")))
        (if (not branch) (setq branch ""))

        (setq awesome-tray-git-buffer-filename filename)

        (setq awesome-tray-git-command-cache (if awesome-tray-git-show-status
                                                 (format awesome-tray-git-format (concat branch " " status))
                                               (format awesome-tray-git-format branch))))
    (setq awesome-tray-git-command-cache "?")))

(defun awesome-tray-module-circe-info ()
  "Display circe tracking buffers"
  (if (listp tracking-mode-line-buffers)
      (apply 'concat (cl-loop for entry in tracking-mode-line-buffers
                              collect (or (plist-get entry :propertize) "")))
    ""))

(defun awesome-tray-module-rvm-info ()
  (if (executable-find "rvm-prompt")
      (format "rvm:%s" (replace-regexp-in-string
                        "\n" ""
                        (nth 1 (awesome-tray-process-exit-code-and-output "rvm-prompt")))
              )
    ""))

(defun awesome-tray-module-battery-info ()
  (let ((current-seconds (awesome-tray-current-seconds)))
    (if (> (- current-seconds awesome-tray-battery-status-last-time) awesome-tray-battery-update-duration)
        (let* ((battery-info (funcall battery-status-function))
               (battery-type (battery-format "%L" battery-info))
               battery-status)
          (setq awesome-tray-battery-status-last-time current-seconds)

          ;; Short battery type.
          (cond ((member battery-type '("on-line" "AC"))
                 (setq battery-type "ON")
                 (setq battery-status (battery-format " [%p%%]" battery-info)))
                ((member battery-type '("off-line" "BAT" "Battery"))
                 (setq battery-type "OFF")
                 (setq battery-status (battery-format " [%p%% %t]" battery-info))))

          ;; Update battery cache.
          (setq awesome-tray-battery-status-cache (concat battery-type battery-status)))
      awesome-tray-battery-status-cache)))

(defun awesome-tray-module-mode-name-info ()
  (car (split-string (format "%s" major-mode) "-mode")))

(defun awesome-tray-module-location-info ()
  (if (equal major-mode 'eaf-mode)
      ""
    (format "%s:%s %s"
            (format-mode-line "%l")
            (format-mode-line "%c")
            (format-mode-line "%p")
            )))

(with-eval-after-load 'libmpdel
  (add-hook 'libmpdel-current-playlist-changed-hook 'awesome-tray-mpd-command-update-cache)
  (add-hook 'libmpdel-current-song-changed-hook 'awesome-tray-mpd-command-update-cache))

(defun awesome-tray-module-mpd-info ()
  (if (and (ignore-errors (require 'libmpdel)) (executable-find "mpd"))
           (if (libmpdel-connected-p)
               awesome-tray-mpd-command-cache
             "not connected to mpd")
           ""))

(defun awesome-tray-mpd-command-update-cache ()
  (let* ((mpd-info (libmpdel-current-song))
         (title (or (libmpdel-entity-name mpd-info) ""))
         (artist (or (libmpdel-artist-name mpd-info) ""))
         (album (or (libmpdel-album-name mpd-info) ""))
         (position (or (+ (libmpdel-song-position mpd-info) 1) ""))
         (playlist-length (or (libmpdel-playlist-length) ""))
         (filename (or (libmpdel-song-file mpd-info) "")))
    (setq title (awesome-tray-truncate-string title awesome-tray-mpd-title-max-length))
    (setq cut-filename (awesome-tray-truncate-string
                        (file-name-sans-extension
                         (replace-regexp-in-string ".*/" "" filename))
                        awesome-tray-mpd-title-max-length))
    (setq filename (awesome-tray-truncate-string filename awesome-tray-mpd-title-max-length))
  (setq awesome-tray-mpd-command-cache
        (format-spec awesome-tray-mpd-format
                     (format-spec-make ?t title ?a artist ?A album ?p position
                                       ?P playlist-length ?f cut-filename ?F filename)))))

(defun awesome-tray-module-date-info ()
  "Displays the date."
  (format-time-string awesome-tray-date-format))

(defun awesome-tray-module-last-command-info ()
  (format "%s" last-command))

(defun awesome-tray-module-buffer-name-info ()
  (let (bufname)
    (setq bufname (if awesome-tray-buffer-name-buffer-changed
                      (if (and (buffer-modified-p)
                               (not (eq buffer-file-name nil)))
                          (concat (buffer-name) awesome-tray-buffer-name-buffer-changed-style)
                        (buffer-name))
                    (format "%s" (buffer-name))))
    (awesome-tray-truncate-string bufname awesome-tray-buffer-name-max-length t)))

(defun awesome-tray-module-buffer-read-only-info ()
  (if (and (eq buffer-read-only t)
           (not (eq buffer-file-name nil)))
      (format "%s" awesome-tray-buffer-read-only-style)))

(defun awesome-tray-module-input-method-info ()
  (if (eq current-input-method nil)
      (format "%s" awesome-tray-input-method-en-style)
    (format "%s" awesome-tray-input-method-zh-style)))

(defun awesome-tray-module-parent-dir-info ()
  (format "%s" (file-name-nondirectory (directory-file-name default-directory))))

(defun awesome-tray-shrink-dir-name (name)
  "Shrink NAME to be its first letter, or the first two if starts \".\"

NAME is a string, typically a directory name."
  (let ((dot-num (if (string-match "^\\.+" name)
                     (length (match-string 0 name))
                   0)))
    (substring name 0 (min (length name) (+ dot-num awesome-tray-file-path-truncated-name-length)))))

(defun awesome-tray-module-file-path-info ()
  (if (not buffer-file-name)
      (let ((bufname (buffer-name)))
        (setq bufname (if awesome-tray-buffer-name-buffer-changed
                          (if (and (buffer-modified-p)
                                   (not (eq buffer-file-name nil)))
                              (concat (buffer-name) awesome-tray-buffer-name-buffer-changed-style)
                            (buffer-name))
                        (format "%s" (buffer-name))))
        (awesome-tray-truncate-string bufname awesome-tray-file-name-max-length t))
    (let* ((file-path (split-string (buffer-file-name) "/" t))
           (shown-path)
           (path-len (length file-path))
           (modp (if (buffer-modified-p) "*" ""))
           (full-num awesome-tray-file-path-full-dirname-levels)
           (trunc-num awesome-tray-file-path-truncate-dirname-levels)
           (show-name awesome-tray-file-path-show-filename))
      (when (> path-len (+ 1 full-num))
        (push (string-join
               (mapcar #'awesome-tray-shrink-dir-name
                       (cl-subseq file-path
                                  (max 0 (- path-len (+ 1 full-num trunc-num)))
                                  (- path-len (1+ full-num)))) "/")
              shown-path))
      (when (> path-len 1)
        (push (string-join
               (cl-subseq file-path
                          (max 0 (- path-len (1+ full-num)))
                          (1- path-len)) "/")
              shown-path))
      (when show-name
        (push (car (last file-path)) shown-path))
      (concat modp
              (if (<= path-len (+ 1 full-num trunc-num))
                  "/"
                "./")
              (string-join (nreverse (cl-remove "" shown-path)) "/")
              (when (and shown-path (not show-name)) "/")))))

(defun awesome-tray-module-awesome-tab-info ()
  (with-demoted-errors
      ""
    (if (featurep 'awesome-tab)
        (let ((tab-info (format "%s" (cdr (awesome-tab-selected-tab (awesome-tab-current-tabset t))))))
          (if (> (string-width tab-info) 30)
              ""
            tab-info))
      "")))

(defun awesome-tray-module-evil-info ()
  (with-demoted-errors
      ""
    (if (featurep 'evil)
        (let ((state
               (cond ((evil-normal-state-p) "<N>")
                     ((evil-emacs-state-p) "<E>")
                     ((evil-insert-state-p) "<I>")
                     ((evil-motion-state-p) "<M>")
                     ((evil-visual-state-p) "<V>")
                     ((evil-operator-state-p) "<O>")
                     ((evil-replace-state-p) "<R>")
                     (t ""))))
          state)
      "")))

(defun awesome-tray-module-belong-info ()
  (if (featurep 'tree-sitter)
      (let ((current-seconds (awesome-tray-current-seconds)))
        (if (or (not (eq (current-buffer) awesome-tray-belong-last-buffer))
                (> (- current-seconds awesome-tray-belong-last-time) awesome-tray-belong-update-duration))
            (progn
              (setq awesome-tray-belong-last-time current-seconds)
              (setq awesome-tray-belong-last-buffer (current-buffer))
              (awesome-tray-update-belong-cache))
          awesome-tray-belong-cache))
    ""))

(defun awesome-tray-update-belong-cache ()
  (setq awesome-tray-belong-cache
        (let* ((class-nodes (append (awesome-tray-get-match-nodes "(class_definition name: (symbol) @x)")
                                    (awesome-tray-get-match-nodes "(class_definition name: (identifier) @x)")))
               (function-nodes (append (awesome-tray-get-match-nodes "(function_definition name: (symbol) @x)")
                                       (awesome-tray-get-match-nodes "(function_definition name: (identifier) @x)")))
               which-belong-info
               which-class-info
               which-func-info)
          (setq which-class-info (catch 'found
                                   (dolist (class-node class-nodes)
                                     (when (and (> (point) (tsc-node-start-position (tsc-get-parent class-node)))
                                                (< (point) (tsc-node-end-position (tsc-get-parent class-node))))
                                       (throw 'found (tsc-node-text class-node)))
                                     )
                                   (throw 'found "")))
          (setq which-func-info (catch 'found
                                  (dolist (function-node function-nodes)
                                    (when (and (> (point) (tsc-node-start-position (tsc-get-parent function-node)))
                                               (< (point) (tsc-node-end-position (tsc-get-parent function-node))))
                                      (throw 'found (tsc-node-text function-node)))
                                    )
                                  (throw 'found "")))
          (setq which-belong-info (string-trim (concat which-class-info " " which-func-info)))
          (if (string-equal which-belong-info "")
              ""
            (format "[%s]" which-belong-info))))
  awesome-tray-belong-cache)

(defun awesome-tray-module-org-pomodoro-info ()
  (with-demoted-errors
      ""
    (if (featurep 'org-pomodoro)
        (let ((state
               (cond ((eq org-pomodoro-state :pomodoro) (concat "[" (org-pomodoro-format-seconds) "]"))
                     ((eq org-pomodoro-state :short-break) (concat "(" (org-pomodoro-format-seconds) ")"))
                     ((eq org-pomodoro-state :long-break) (concat "{" (org-pomodoro-format-seconds) "}"))
                     (t ""))))
          state)
      "")))

(defun awesome-tray-module-pdf-view-page-info ()
  (with-demoted-errors
      ""
    (if (featurep 'pdf-view)
        (let ((state
               (cond ((derived-mode-p 'pdf-view-mode) (format "%d/%d" (eval '(pdf-view-current-page)) (pdf-cache-number-of-pages)))
                     (t ""))))
          state)
      "")))

(defun awesome-tray-module-flymake-info ()
  "A module for showing Flymake state."
  ;; Parts of the code are from doom-modeline package
  (with-demoted-errors
      ""
      (if (and (featurep 'flymake) flymake--state)
          (let* ((known (hash-table-keys flymake--state))
                 (running (flymake-running-backends))
                 (disabled (flymake-disabled-backends))
                 (reported (flymake-reporting-backends))
                 (disabledp (and disabled (null running)))
                 (waiting (cl-set-difference running reported)))
            (when-let
                ((flymake-state
                  (cond
                   (waiting "⏳")
                   ((null known) "❔")
                   (disabledp "❕")
                   (t (let ((.error 0)
                            (.warning 0)
                            (.note 0))
                        (cl-loop
                         with warning-level = (warning-numeric-level :warning)
                         with note-level = (warning-numeric-level :debug)
                         for state being the hash-values of flymake--state
                         do (cl-loop
                             with diags = (flymake--state-diags state)
                             for diag in diags do
                             (let ((severity (flymake--lookup-type-property (flymake--diag-type diag) 'severity
                                                                            (warning-numeric-level :error))))
                               (cond ((> severity warning-level) (cl-incf .error))
                                     ((> severity note-level)    (cl-incf .warning))
                                     (t                          (cl-incf .note))))))
                        (let ((num (+ .error .warning .note)))
                          (if (> num 0)
                              (string-clean-whitespace
                               (string-join
                                (list
                                 (when (> .note 0)
                                   (concat "🔵:" (propertize (number-to-string .note) 'face 'awesome-tray-module-flymake-note)))
                                 (when (> .warning 0)
                                   (concat "🟠:" (propertize (number-to-string .warning) 'face 'awesome-tray-module-flymake-warning)))
                                 (when (> .error 0)
                                   (concat "🔴:" (propertize (number-to-string .error) 'face 'awesome-tray-module-flymake-error))))
                                " "))
                            "🟢")))))))
              flymake-state)))))

(defun awesome-tray-get-match-nodes (match-rule)
  (ignore-errors
    (let* ((query (tsc-make-query tree-sitter-language match-rule))
           (root-node (tsc-root-node tree-sitter-tree))
           (captures (mapcar #'cdr (tsc-query-captures query root-node #'tsc--buffer-substring-no-properties))))
      captures)))

(defun awesome-tray-truncate-string (string length &optional right)
  "Truncate STRING to LENGTH, replacing the surplus with an ellipsis.

If right is non nil, replace to the right"
  (let ((strlen (length string)))
    (if (<= strlen length)
        string
      (setq length (max 0 (- length (length awesome-tray-ellipsis))))
      (if right
          (format "%s%s" (substring string 0 length) awesome-tray-ellipsis)
        (format "%s%s" awesome-tray-ellipsis (substring string (max 0 (- strlen length))))))))

(defun awesome-tray-get-frame-width ()
  "Only calculating a main Frame width, to avoid wrong width when new frame, such as `snails'."
  (if (display-graphic-p)
      (with-selected-frame (car (last (frame-list)))
        (frame-width))
    (frame-width)))

(defun awesome-tray-process-exit-code-and-output (program &rest args)
  "Run PROGRAM with ARGS and return the exit code and output in a list."
  (with-temp-buffer
    (list (apply 'call-process program nil (current-buffer) nil args)
          (buffer-string))))

(defun awesome-tray-current-seconds ()
  (string-to-number (format-time-string "%s")))

;;;###autoload
(define-minor-mode awesome-tray-mode
  "Display text at the end of the echo area."
  :global t
  (if awesome-tray-mode
      (awesome-tray-enable)
    (awesome-tray-disable)))

;;;###autoload
(defun awesome-tray-enable ()
  "Turn on the awesome-tray."
  (interactive)
  ;; Disable any existing awesome-tray to remove conflicts
  (awesome-tray-disable)

  ;; Save mode-line colors when first time.
  ;; Don't change `awesome-tray-mode-line-colors' anymore.
  (unless awesome-tray-mode-line-colors
    (setq awesome-tray-mode-line-colors
          (list (face-attribute 'mode-line :foreground)
                (face-attribute 'mode-line :background)
                (face-attribute 'mode-line :family)
                (face-attribute 'mode-line :box)
                (face-attribute 'mode-line-inactive :foreground)
                (face-attribute 'mode-line-inactive :background)
                (face-attribute 'mode-line-inactive :family)
                (face-attribute 'mode-line-inactive :box)
                )))
  (setq awesome-tray-mode-line-default-height (face-attribute 'mode-line :height))

  ;; Disable mode line.
  (set-face-attribute 'mode-line nil
                      :foreground awesome-tray-mode-line-active-color
                      :background awesome-tray-mode-line-active-color
                      :height awesome-tray-mode-line-height
                      :box nil)
  (set-face-attribute 'mode-line-inactive nil
                      :foreground awesome-tray-mode-line-inactive-color
                      :background awesome-tray-mode-line-inactive-color
                      :height awesome-tray-mode-line-height
                      :box nil
                      :inherit 'unspecified)

  ;; Create overlays in each echo area buffer
  (dolist (buf '(" *Echo Area 0*" " *Echo Area 1*"))
    (with-current-buffer (get-buffer-create buf)
      (remove-overlays (point-min) (point-max))
      (push (make-overlay (point-min) (point-max) nil nil t)
            awesome-tray-overlays)))

  ;; Start the timer to automatically update
  (when awesome-tray-update-interval
    (run-with-timer 0 awesome-tray-update-interval 'awesome-tray-update))

  ;; Add the setup function to the minibuffer hook
  (when awesome-tray-minibuffer
    (add-hook 'minibuffer-setup-hook #'awesome-tray--minibuffer-setup))

  ;; Add git hooks
  (if (or (member "git" awesome-tray-active-modules) (member "git" awesome-tray-essential-modules))
      (dolist (hook awesome-tray-git-update-hooks)
        (add-hook hook 'awesome-tray-git-command-update-cache))))

;;;###autoload
(defun awesome-tray-disable ()
  "Turn off the awesome-tray."
  (interactive)
  ;; Restore mode-line colors.
  (set-face-attribute 'mode-line nil
                      :foreground (nth 0 awesome-tray-mode-line-colors)
                      :background (nth 1 awesome-tray-mode-line-colors)
                      :family (nth 2 awesome-tray-mode-line-colors)
                      :box (nth 3 awesome-tray-mode-line-colors)
                      :height awesome-tray-mode-line-default-height)
  (set-face-attribute 'mode-line-inactive nil
                      :foreground (nth 4 awesome-tray-mode-line-colors)
                      :background (nth 5 awesome-tray-mode-line-colors)
                      :family (nth 6 awesome-tray-mode-line-colors)
                      :box (nth 7 awesome-tray-mode-line-colors)
                      :height awesome-tray-mode-line-default-height)

  ;; Remove awesome-tray overlays
  (mapc 'delete-overlay awesome-tray-overlays)
  (setq awesome-tray-overlays nil)

  ;; Remove text from Minibuf-0
  (with-current-buffer " *Minibuf-0*"
    (delete-region (point-min) (point-max)))

  ;; Cancel the update timer
  (cancel-function-timers #'awesome-tray-update)

  ;; Remove the setup function from the minibuffer hook
  (remove-hook 'minibuffer-setup-hook #'awesome-tray--minibuffer-setup)

  ;; Remove git hooks
  (dolist (hook awesome-tray-git-update-hooks)
    (remove-hook hook 'awesome-tray-git-command-update-cache)))

(defun awesome-tray-set-text (text)
  "Set the text displayed by the awesome-tray to TEXT."
  (let* ((wid (+ (string-width text) awesome-tray-info-padding-right))
         (spc (propertize " " 'cursor 1 'display
                          `(space :align-to (- right-fringe ,wid)))))

    (setq awesome-tray-text (concat spc text))

    ;; Remove any dead overlays from the minibuffer from the beginning of the list
    (while (null (overlay-buffer (car awesome-tray-overlays)))
      (pop awesome-tray-overlays))

    ;; Add the correct text to each awesome-tray overlay
    (dolist (o awesome-tray-overlays)
      (when (overlay-buffer o)
        (overlay-put o 'after-string awesome-tray-text)))

    ;; Display the text in Minibuf-0
    (with-current-buffer " *Minibuf-0*"
      (delete-region (point-min) (point-max))
      (insert awesome-tray-text))))

(defun awesome-tray--minibuffer-setup ()
  "Setup the awesome-tray in the minibuffer."
  (push (make-overlay (point-max) (point-max) nil t t) awesome-tray-overlays)
  (overlay-put (car awesome-tray-overlays) 'priority 1)
  (awesome-tray-update))

(defun awesome-tray-update ()
  "Get new text to be displayed."
  (interactive)
  (let* ((tray-info (awesome-tray-build-active-info))
         (minibuffer-info (current-message))
         (blank-length (- (awesome-tray-get-frame-width)
                          (string-width tray-info)
                          (string-width (if minibuffer-info minibuffer-info "")))))
    (awesome-tray-set-text (if (> blank-length 0) (awesome-tray-build-active-info) (awesome-tray-build-essential-info)))))

(provide 'awesome-tray)

;;; awesome-tray.el ends here
