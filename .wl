(setq wl-demo nil)
(setq wl-interactive-exit t)
(setq wl-interactive-send t)
(setq wl-stay-folder-window t)
(setq pgg-scheme 'gpg)
(setq wl-message-truncate-lines t)
(setq wl-summary-width 120)

(setq wl-summary-incorporate-marks '("N" "U" "!" "A" "F" "$"))
(setq wl-prefetch-threshold nil)
(setq wl-message-buffer-prefetch-threshold nil)	; fetch everything 1
(setq wl-prefetch-confirm nil)			; fetch everything 2
(setq wl-use-scoring nil)
(setq wl-user-mail-address-list (quote ("ich@kaoskinder.de" "tim@boese-ban.de" "tim@we-are-teh-b.org")))
(setq wl-from "Tim Schumacher <tim@we-are-teh-b.org>")
(setq wl-organization "Secret Conspiracy")
(setq wl-local-domain "we-are-teh-b.org")
(setq wl-fcc "%INBOX/Sent")
(setq wl-subscribed-mailing-list (quote ("news@bdp.org" "emms-help@gnu.org" "wl-en@lists.airs.net" "gentoo-server@lists.gentoo.org" "jdev@jabber.org")))

(setq wl-message-ignored-field-list
      '(
	".*Received:" 
	".*Path:" 
	".*Id:" 
	"^References:"
	"^Replied:" 
	"^Errors-To:"
	"^Lines:" 
	"^Sender:" 
	".*Host:" 
	"^Xref:"
	"^Content-Type:" 
	"^Precedence:"
	"^Status:" 
	"^X.*:" 
	"^MIME.*:"
	"^In-Reply-To:" 
	"^Content-Transfer-Encoding:"
	"^List-.*:"
	)
      )

(setq wl-message-visible-field-list '("^Message-Id:" "^User-Agent:"))

;; SSL settings

;; Only needed because emacs doesnt seem to handle path under win32 right

(when win32p (setq ssl-program-name "C:/OpenSSL/bin/openssl.exe"))

;; Serversettings

(setq elmo-imap4-default-server "localhost")
(setq elmo-imap4-default-port 9930)
(setq elmo-imap4-default-authenticate-type 'cram-md5) ; CRAM-MD5
(setq elmo-imap4-default-user "tim.we-are-teh-b.org")
(setq elmo-imap4-default-stream-type 'ssl)

(setq wl-smtp-posting-server "localhost")
(setq wl-smtp-authenticate-type "cram-md5")
(setq wl-smtp-posting-user "tim.we-are-teh-b.org")
(setq wl-smtp-posting-port 3500)

(setq elmo-nntp-default-server "localhost")
(setq elmo-nntp-default-port 9988)
;; (setq elmo-nntp-default-user "tim")
(setq wl-nntp-posting-server "localhost")
(setq wl-message-id-domain "we-are-teh-b.org")

   
(setq elmo-msgdb-extra-fields
      '("x-ml-name"
        "reply-to"
        "sender"
        "mailing-list"
	"List-Id"
	"X-Mailer"
        "newsgroups"))



(setq wl-draft-config-alist
      '(
	((string-match "GMane" wl-draft-parent-folder)
         (lambda () 
           (setq wl-nntp-posting-server "news.gmane.org")
           (setq wl-nntp-posting-port 119)))
	((string-match "Usernet" wl-draft-parent-folder)
	 (lambda ()
	   (setq wl-nntp-posting-server "news.cnntp.org")
	   (setq wl-nntp-posting-port 119)))
	))

;; Expire old mail…

(setq wl-expire-alist
      '(("^\\%INBOX/otr$"  (date 14) remove)
        ("^\\%INBOX/Verteiler/gentoo/gentoo-announce" (date 14) remove)
        ("^\\%INBOX/Verteiler/gentoo/gentoo-server" (date 14) remove)
        ("^\\%INBOX/Verteiler/jdev" (date 14) remove)
        ("^\\%INBOX/Verteiler/kvirc" (date 14) remove)
        ("^\\%INBOX/Verteiler/opengroupware" (date 14) remove)
	("^\\%INBOX/Benachrichtigungen" (date 3) remove)
	("^\\%INBOX/Verteiler/php classes" (date 14) remove)
	("^\\%INBOX/Verteiler/Gnupp-Anwenderforum" (date 14) remove)
	("^\\%INBOX/Verteiler/zsh" (date 14) remove)
;        ("^\\%INBOX/Verteiler" (date 14) remove) ; Just a small example...
        ))

(add-hook 'wl-summary-prepared-pre-hook 'wl-summary-expire)

;; Misc stuff

(autoload 'fill-flowed "flow-fill")

(add-hook 'mime-display-text/plain-hook
  (lambda ()
    (when (string= "flowed"
  (cdr (assoc "format"
      (mime-content-type-parameters
(mime-entity-content-type entity)))))
      (fill-flowed))))

(setq default-mime-charset "utf-8")

;; do not split attachments!

(setq mime-edit-split-message nil)


;; Auto Refile

(setq wl-refile-rule-alist
      '(("List-Id"
         ("<conkeror.mozdev.org>" . "%INBOX/Verteiler/conkeror")
	 ("news.thueringen.listi.jpberlin.de" . "%INBOX/Verteiler/thurbdpnews")
	 ("help-emacs-windows.gnu.org" . "%INBOX/Verteiler/Help-Emacs-Windows")
	 ("thueringen-vernetzung.listi.jpberlin.de" . "%INBOX/Verteiler/thurvern")
         ("^Elisp" . "+elisp"))
      (("To" "Cc")
	("chaostreffs@lists.ccc.de" . "%INBOX/Verteiler/chaostreffs"))
      (("X-Mailer")
       ("Redmine" . "%INBOX/Bugs"))
      (("From")
       ("quassel@quassel-irc.org" . "%INBOX/Bugs"))
      ))

(setq wl-summary-auto-refile-skip-marks nil)

;; LongLine mode for viewing mails in wanderlust

;; (setq mime-view-mode-hook
;;       '(lambda ()
;; 	 (longlines-mode 1)
;; 	 ))

;; Autofillmode for composing mails in wanderlust, so no more long crapy lines like this ;)

(setq mime-edit-mode-hook
      '(lambda ()
	 (auto-fill-mode 1)
	 ))


