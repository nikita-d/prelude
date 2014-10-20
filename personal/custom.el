(scroll-bar-mode -1)
(projectile-global-mode)
;; (setenv "PERL5LIB" (concat "./lib ./inc ./local/lib/perl5" (getenv "PERL5LIB")))
(set-face-attribute 'default (selected-frame) :height 80)
(set-frame-font "Input Mono-8")
;; (set-fontset-font "fontset-default" '(#x0400 . #x0500) "Consolas-9")

;;load cperl, then work around indent issue
(ido-mode 1)
(ido-ubiquitous-mode 1)
(load-library "cperl-mode")
(load-library "projectile")
(load-library "perlbrew")
(defalias 'perl-mode 'cperl-mode)

(defun cperl-backward-to-start-of-continued-exp (lim)
  (goto-char (1+ lim))
  (forward-sexp)
  (beginning-of-line)
  (skip-chars-forward " \t")
  )

(defun perl-local-lib-paths (lib-dir-list)
  (mapconcat (lambda(x)(format "-Mlocal::lib=%s" x)) lib-dir-list " "))

(defun cleanup-env-path (env-var split-regex)
  (let ((env-value (exec-path-from-shell-copy-env env-var)))
    (let ((env-value-list (cl-remove-duplicates (split-string env-value split-regex)
                                                :test (lambda(x y)(string= x y)))))
      (mapcar (lambda(x) (format "%s" (string-trim x))) env-value-list))))

(require 'cperl-mode)
(require 'perlbrew)
(require 'flycheck)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(standard-indent 2))

(flycheck-define-checker perl-carton
  "A Perl syntax checker using the Perl interpreter. See URL `http://www.perl.org'."
  :command ("carton" "exec" "perl" (eval (mapcar (lambda(x)(format "-I./%s" x)) '("inc" "lib"))) "-w" "-c" source)
  :error-patterns
  ((error line-start (minimal-match (message))
          " at " (file-name) " line " line
          (or "." (and ", " (zero-or-more not-newline))) line-end))
  :modes (perl-mode cperl-mode)
  :next-checkers (perl-perlcritic))

(add-hook 'cperl-mode-hook
          (lambda()
            (let ((project-dir (elt (projectile-get-project-directories) 0)))
              (let ((perl-lib-dir-list (cl-remove-duplicates (mapcar (lambda(x)(format "%s%s" project-dir (string-trim x)))
                                                                     '("inc" "lib" "local/lib/perl5"))
                                                             :test (lambda (x y) (string= x y))))
                    (perl-bin-dir-list (cl-remove-duplicates (mapcar (lambda(x)(format "%s%s" project-dir (string-trim x)))
                                                                     '("bin" "local/bin"))
                                                             :test (lambda (x y) (string= x y))))
                    (env-path-list (cleanup-env-path "PATH" ":"))
                    (env-perlbrew-path (elt  (cleanup-env-path "LOCAL_ROOT" ":") 0))
                    (env-perl5lib-list (cleanup-env-path "PERL5LIB" "\s*:\s*")))
                (progn
                  ;; (setenv "PERL5LIB" (mapconcat (lambda(x)(format "%s" x)) (list perl-lib-dir-list env-perl5lib-list) ":"))
                  ;; (setenv "PATH"     (mapconcat (lambda(x)(format "%s" x)) perl-bin-dir-list ":"))
                  (custom-set-variables
                   '(default-directory project-dir)
                   '(cperl-extra-perl-args (concat "-v " (perl-local-lib-paths perl-lib-dir-list) " "))
                   '(cperl-highlight-variables-indiscriminately nil)
                   '(cperl-indent-parens-as-block t)
                   '(cperl-indent-level 2)
                   '(cperl-close-paren-offset -2)
                   '(cperl-brace-offset 0)
                   '(cperl-continued-brace-offset 0)
                   '(cperl-label-offset -2)
                   '(cperl-continued-statement-offset 2)
                   '(cperl-extra-newline-before-brace nil)
                   '(cperl-extra-newline-before-brace-multiline nil)
                   '(cperl-merge-trailing-else t)
                   )
                  (setq standard-indent 2)
                  (setq default-directory (elt (projectile-get-project-directories) 0))
                  (setq perlbrew-dir env-perlbrew-path)
                  (perlbrew-switch (exec-path-from-shell-copy-env "PERLBREW_PERL"))
                  (cperl-set-style "CPerl")
                  (flycheck-select-checker 'perl-carton)
                  (flycheck-mode t))))))

(load-theme 'solarized-dark t nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
