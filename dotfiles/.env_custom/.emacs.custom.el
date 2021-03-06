;; -------
;; COLORS
;; -------
(add-to-list 'default-frame-alist '(foreground-color . "black"))
(add-to-list 'default-frame-alist '(background-color . "white"))

;; -------
;; EDITING 
;; -------
(global-set-key (kbd "C-?") 'help-command)  
(global-set-key (kbd "M-?") 'mark-paragraph)  
(global-set-key (kbd "C-h") 'delete-backward-char)  
(global-set-key (kbd "C-?") 'backward-kill-word)
;; BACKSPACE should delete backward & DEL should delete forward
(normal-erase-is-backspace-mode 0)
;; show line & column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; ---------------------------------
;; Package within Emacs Installation 
;; ---------------------------------
;; First time emacs load may take some time
;; as the packages are fetched and installed.
(when (>= emacs-major-version 24)
  (require 'package)
  ; list the packages you want
  ; ORY ein causing issues; (setq package-list '(auto-complete ein elpy iedit scala-mode sbt-mode))
  (setq package-list '(auto-complete elpy go-mode iedit scala-mode sbt-mode))

  ; list the repositories containing them
  (setq
   package-archives
   '(
     ("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "https://stable.melpa.org/packages/")
    )
   )
    
  ; initialize package
  (package-initialize)
  ; fetch the list of packages available
  (unless package-archive-contents
    (package-refresh-contents))
  ; install the missing packages
  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package))))
;; ------------------------------------
;; Programming Language Specific Hooks
;; ------------------------------------
;; CSCOPE
;; Load cscope support
; ORY xscope causing issues; (require 'xcscope)
; ORY (setq cscope-do-not-update-database t)

;; Next-Error function is bound to "C-x `": remap if necessary
;; (global-set-key (kbd "M-'") 'next-error)

;; By default files ending in .h are treated as c files rather than c++ files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Style - use in c++ mode
(c-add-style "my-style" 
	     '("stroustrup"
 	       (indent-tabs-mode . nil)        ; use spaces rather than tabs
 	       (c-basic-offset . 4)            ; indent by four spaces
 	       (c-offsets-alist . ((inline-open . 0)  ; custom indentation rules
 				   (brace-list-open . 0)
				   (statement-case-open . +)))))

(defun my-c++-mode-hook ()
  (c-set-style "my-style")        ; use my-style defined above
  (auto-fill-mode)         
  (c-toggle-auto-hungry-state 1))

;; (add-hook 'c++-mode-hook 'my-c++-mode-hook)
;; Customise C++ mode key bindings using entries like:
;; (define-key c++-mode-map "\C-ct" 'some-function-i-want-to-call)

;; Google C style
(add-to-list 'load-path "~/dotfiles/.env_custom/" t)
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; OCTAVE
;; Begin Using Octave Mode: 
;; https://www.gnu.org/software/octave/doc/interpreter/Using-Octave-Mode.html
(autoload 'octave-mode "octave-mod" nil t)
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))
;; Tun on abbrevs, auto-fill, and font-lock
(add-hook 'octave-mode-hook
    (lambda()
        (abbrev-mode 1)
        (auto-fill-mode 1)
        (if (eq window-system 'x)
            (font-lock-mode 1))))

;; SCALA
(add-hook 'scala-mode-hook '(lambda ()
  ;; (require 'whitespace)

  ;; clean-up whitespace at save
  ;; (make-local-variable 'before-save-hook)
  ;; (add-hook 'before-save-hook 'whitespace-cleanup)

  ;; turn on highlight. To configure what is highlighted, customize
  ;; the *whitespace-style* variable. A sane set of things to
  ;; highlight is: face, tabs, trailing
  ;; (whitespace-mode)

  ;; Bind the 'newline-and-indent' command to RET (aka 'enter'). This
  ;; is normally also available as C-j. The 'newline-and-indent'
  ;; command has the following functionality: 1) it removes trailing
  ;; whitespace from the current line, 2) it create a new line, and 3)
  ;; indents it.  An alternative is the
  ;; 'reindent-then-newline-and-indent' command.
  (local-set-key (kbd "RET") 'newline-and-indent)

  ;; Alternatively, bind the 'newline-and-indent' command and
  ;; 'scala-indent:insert-asterisk-on-multiline-comment' to RET in
  ;; order to get indentation and asterisk-insertion within multi-line
  ;; comments.
  ;; (local-set-key (kbd "RET") '(lambda ()
  ;;   (interactive)
  ;;   (newline-and-indent)
  ;;   (scala-indent:insert-asterisk-on-multiline-comment)))

  ;; Bind the backtab (shift tab) to
  ;; 'scala-indent:indent-with-reluctant-strategy command. This is usefull
  ;; when using the 'eager' mode by default and you want to "outdent" a
  ;; code line as a new statement.
  (local-set-key (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)

  ;; sbt-find-definitions is a command that tries to find (with grep)
  ;; the definition of the thing at point.
  (local-set-key (kbd "M-.") 'sbt-find-definitions)
  
  ;; use sbt-run-previous-command to re-compile your code after changes
  (local-set-key (kbd "C-x '") 'sbt-run-previous-command)
  ;; and other bindings here
))

;; SBT
(add-hook 'sbt-mode-hook '(lambda ()
  ;; compilation-skip-threshold tells the compilation minor-mode
  ;; which type of compiler output can be skipped. 1 = skip info
  ;; 2 = skip info and warnings.
  (setq compilation-skip-threshold 1)

  ;; Bind C-a to 'comint-bol when in sbt-mode. This will move the
  ;; cursor to just after prompt.
  (local-set-key (kbd "C-a") 'comint-bol)

  ;; Bind M-RET to 'comint-accumulate. This will allow you to add
  ;; more than one line to scala console prompt before sending it
  ;; for interpretation. It will keep your command history cleaner.
  (local-set-key (kbd "M-RET") 'comint-accumulate)
))

;; GO
(add-hook 'go-mode-hook (lambda ()
  ;; If you want to automatically run `gofmt' before 
  ;; saving a file
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq tab-width 2)
  (setq indent-tabs-mode 1)
  ;; If you want to use `godef-jump' instead of etags 
  ;; (or similar), consider binding godef-jump to `M-.', 
  ;; which is the default key for `find-tag':
  ;; Please note that godef is an external dependency. 
  ;; You can install it with
  ;; go get code.google.com/p/rog-go/exp/cmd/godef
  ;; (local-set-key (kbd "M-.") #'godef-jump)))
  ;; If you're looking for even more integration with Go, namely
  ;; on-the-fly syntax checking, auto-completion and snippets, it is
  ;; recommended that you look at goflymake
  ;; (https://github.com/dougm/goflymake), gocode
  ;; (https://github.com/nsf/gocode) and yasnippet-go
  ;; (https://github.com/dominikh/yasnippet-go)
))

;; Python Hook
(add-hook 'python-mode-hook (lambda ()
  (setq python-indent-offset 2)
  (setq python-indent 2)
  (setq python-guess-indent . nil)
  (setq indent-tabs-mode . nil)
  (setq tab-width 2)
))

;; Python ELPY
(require 'json)
(require 'elpy)
(elpy-enable)
(global-set-key [?\C-<] 'elpy-nav-backward-block)
(global-set-key [?\C->] 'elpy-nav-forward-block)
(global-set-key [M-right] 'elpy-nav-forward-indent)
(global-set-key [C-M-right] 'elpy-nav-move-iblock-right)

;; Fixing bug:
;; (a) elpy key binding snippet expansion
;; (a) key binding in iedit mode
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
(define-key global-map (kbd "C-c o") 'iedit-mode)

;; iPYTHON NOTEBOOK
; ORY elpy with iPython5 causing issues; (elpy-use-ipython)
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
	                  "jupyter")
;; IPython 5 has a new terminal interface, which is not compatible
;; with Emacs' inferior shells. Fix it, add the --simple-prompt
; ORY (setq python-shell-interpreter "ipython"
; ORY       python-shell-interpreter-args "--simple-prompt -i")
;; iPYTHON NOTEBOOK
; ORY (require 'ein)
; ORY (global-set-key "\C-ce" 'ein:notebooklist-open)
; ORY (set-variable 'ein:use-auto-complete-superpack t)

;; Emacs ORG Mode: display latex images
(setq org-latex-create-formula-image-program 'dvipng)
