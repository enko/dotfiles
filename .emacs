;; .emacs by 0xAFFE ;;


;; Takes a timer to look how long it takes emacs to load
(setq emacs-load-start-time (current-time))


;; Some constants to do cross server/os stuff done
(defconst win32p
    (eq system-type 'windows-nt)
  "Are we running on a WinTel system?")

(defconst linuxp
    (or (eq system-type 'gnu/linux)
        (eq system-type 'linux))
  "Are we running on a GNU/Linux system?")

(defconst linux-x-p
    (eq window-system 'x)
  "Are we running under X on a GNU/Linux system?")

(defconst username 
  (when linuxp (getenv "USERNAME") (getenv "USER"))
  "The user of the emacs")

(defconst hostname
  (when linuxp (getenv "HOSTNAME") (getenv "HOSTNAME"))
  "The hostname of the running box")


;; All functions needed by .emacs

(defun insert-quotes (&optional arg)
  (interactive "P")
  (insert-pair arg ?\" ?\"))

(defun insert-singlequotes (&optional arg)
  (interactive "P")
  (insert-pair arg ?\' ?\'))

(defun openTodoList() 
  (interactive) 
  (find-file "~/daten/.todo.org")
  )

(defun assignckeys ()
  (interactive) 
  (define-key c-mode-map "\"" 'insert-quotes)
  (define-key c-mode-map "\'" 'insert-singlequotes)
  )




;; All the requires needed by me
;;(add-to-list 'load-path "~/.emacs.d/g-client/")
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/color-theme")
(add-to-list 'load-path "~/.emacs.d/bbdb/lisp")


;; W3M Path
(when win32p (setq w3m-command "C:/cygwin/bin/w3m.exe"))


;; Requires

(require 'c-sig)
(require 'color-theme)
(color-theme-initialize)
(require 'calendar)
(require 'highlight-current-line)
;; (require 'yasnippet-bundle)
(require 'php-mode)
(load-file "~/.emacs.d/color-theme-colorful-obsolescence.el")

;; JS2 Setup

(autoload 'js2-mode "js2" nil t)                                                
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)) 


;; nxhtml setup
(load "~/.emacs.d/nxhtml/autostart.el")

(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 'submode-colored
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)
(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . eruby-nxhtml-mumamo))


(tabkey2-mode 1)

;; Rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)
(setq rinari-tags-file-name "TAGS")
 
;; wanderlust setup

;; (setq mel-b-ccl-module nil)
;; (setq base64-external-encoder '("mimencode"))
;; (setq base64-external-decoder '("mimencode" "-u"))

(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

(autoload 'wl-user-agent-compose "wl-draft" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))


;; bbdb setup

(require 'bbdb-wl)
(bbdb-initialize)
;;; ;; enable pop-ups
(setq bbdb-use-pop-up t)
;;; ;; auto collection
(setq bbdb/mail-auto-create-p nil)
;;; ;; exceptional folders against auto collection
;; (setq bbdb-wl-ignore-folder-regexp "%INBOX/")
(setq signature-use-bbdb t)
(setq bbdb-north-american-phone-numbers-p nil)
;;; ;; shows the name of bbdb in the summary
;;(setq wl-summary-from-function 'bbdb-wl-from-func)
;;; ;; automatically add mailing list fields
;;; (add-hook 'bbdb-notice-hook 'bbdb-auto-notes-hook)
;;; (setq bbdb-auto-notes-alist '(("X-ML-Name" (".*$" ML 0))))

;; CEDET

;; * This turns on which-func support (Plus all other code helpers)
;; (semantic-load-enable-excessive-code-helpers)

(add-hook 'c-mode-common-hook 'assignckeys)
(add-hook 'python-mode-common-hook 'assignckeys)
(add-hook 'c++-mode-common-hook 'assignckeys)

;; nice copy and paste

(when (and (getenv "DISPLAY")
           (executable-find "xclip"))
  (setq interprogram-cut-function
        (lambda (text &optional rest)
          (let ((process-connection-type nil))
            (let ((proc (start-process "xclip" "*Messages*" (executable-find "xclip"))))
              (process-send-string proc text)
              (process-send-eof proc))))
        interprogram-paste-function
        (lambda ()
          (shell-command-to-string "xclip -o"))))


;; Kalender Setup

(european-calendar)
(setq calendar-week-start-day 1
      calendar-day-name-array
      ["Sonntag" "Montag" "Dienstag" "Mittwoch" 
       "Donnerstag" "Freitag" "Samstag"]
      calendar-month-name-array
      ["Januar" "Februar" "März" "April" "Mai" 
       "Juni" "Juli" "August" "September" 
       "Oktober" "November" "Dezember"])

;; Dynabbrev

(global-set-key (kbd "<backtab>") 'dabbrev-expand)
(define-key minibuffer-local-map (kbd "<backtab>") 'dabbrev-expand)
(setq dabbrev-case-fold-search t)

;; starting Server, only needed on linux, the win32 version does this already

(when linuxp
  (server-start))

;; Keybindings


(global-set-key "\C-xg" 'goto-line)
(global-set-key "\C-x\C-o" 'browse-url-at-point)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-ct" 'openTodoList)



;; Some custom settings

;; Displays the marked text in another color
(setq transient-mark-mode t)

;; wraps long lines at the end of the buffer
(setq truncate-lines t)

(setq display-time-24hr-format t)

;; Shows the time in the infoline
(setq display-time-mode t)

;; Displays the column next to the line in the infoline
(setq column-number-mode t)

;; Displays the size of the buffer in the infoline
(setq size-indication-mode t)

;; disable startup message
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message "enko")

;; format the title-bar to always include the buffer name
(setq frame-title-format "emacs - %b")

;; show a menu only when running within X (save real estate when
;; in console)
(menu-bar-mode (if window-system 1 -1))

;; turn off the toolbar
;;; (if linux-x-p ((if (>= emacs-major-version 21)
;;;     (tool-bar-mode -1))))

;; better backup

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/daten/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups


(color-theme-charcoal-black)

(ido-mode 1)

(modify-frame-parameters (selected-frame) 
  '((alpha . 90)))

(defvar find-file-root-prefix (if (featurep 'xemacs) "/[sudo/root@localhost]" "/sudo:root@localhost:" )
  "*The filename prefix used to open a file with `find-file-root'.")

(defvar find-file-root-history nil
  "History list for files found using `find-file-root'.")

(defvar find-file-root-hook nil
  "Normal hook for functions to run after finding a \"root\" file.")

;; Insert doublequotes and set the pointer in the middle

(global-set-key "\M-'" 'insert-singlequotes)
(global-set-key "\M-\"" 'insert-quotes)

;; Unicode foo

(setq keyboard-coding-system (quote utf-8))
(setq current-language-environment "UTF-8")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(TeX-output-view-style (quote (("^dvi$" ("^landscape$" "^pstricks$\\|^pst-\\|^psfrag$") "%(o?)dvips -t landscape %d -o && gv %f") ("^dvi$" "^pstricks$\\|^pst-\\|^psfrag$" "%(o?)dvips %d -o && gv %f") ("^dvi$" ("^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "^landscape$") "%(o?)xdvi %dS -paper a4r -s 0 %d") ("^dvi$" "^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "%(o?)xdvi %dS -paper a4 %d") ("^dvi$" ("^a5\\(?:comb\\|paper\\)$" "^landscape$") "%(o?)xdvi %dS -paper a5r -s 0 %d") ("^dvi$" "^a5\\(?:comb\\|paper\\)$" "%(o?)xdvi %dS -paper a5 %d") ("^dvi$" "^b5paper$" "%(o?)xdvi %dS -paper b5 %d") ("^dvi$" "^letterpaper$" "%(o?)xdvi %dS -paper us %d") ("^dvi$" "^legalpaper$" "%(o?)xdvi %dS -paper legal %d") ("^dvi$" "^executivepaper$" "%(o?)xdvi %dS -paper 7.25x10.5in %d") ("^dvi$" "." "%(o?)xdvi %dS %d") ("^pdf$" "." "okular %o %(outpage)") ("^html?$" "." "netscape %o"))))
 '(bbdb-file "~/daten/.bbdb")
 '(browse-url-browser-function (quote browse-url-firefox))
 '(diary-file "~/daten/.diary")
 '(elmo-msgdb-directory "~/daten/.elmo")
 '(flyspell-default-dictionary "deutsch")
 '(nxhtml-load t)
 '(nxhtml-skip-welcome t)
 '(org-agenda-files (quote ("/home/enko/daten/.todo.org" "/home/enko/daten/.cal.org")))
 '(org-agenda-start-on-weekday nil)
 '(org-lowest-priority 90)
 '(sgml-xml-mode t)
 '(which-function-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(highlight-current-line-face ((t (:background "dark green")))))

(when (require 'time-date nil t)
  (message "Emacs startup time: %d seconds." (time-to-seconds (time-since emacs-load-start-time))))

