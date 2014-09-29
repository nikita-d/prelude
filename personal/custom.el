(scroll-bar-mode -1)
(projectile-global-mode)
(exec-path-from-shell-copy-env "PATH")
(exec-path-from-shell-copy-env "PERL5LIB")
;; (setenv "PERL5LIB" (concat "./lib ./inc ./local/lib/perl5" (getenv "PERL5LIB")))
(set-face-attribute 'default (selected-frame) :height 80)
(set-default-font "Input Mono Light-10")
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

(let ((perl-lib-dir (mapcar (lambda(x)(concat "project_dir/" x)) '("inc" "lib"))))
  (print perl-lib-dir))
(add-hook 'cperl-mode-hook
          (lambda()
            (let ((project-dir (elt (projectile-get-project-directories) 0)))
              (let ((perl-lib-dir (mapcar (lambda(x)(concat project-dir x " "))
                                          '("inc" "lib" "local/lib/perl5")))
                    (perl-bin-dir (mapcar (lambda(x)(concat project-dir x " "))
                                          '("bin" "local/bin")))
                    (env-path (exec-path-from-shell-copy-env "PATH"))
                    (env-perlbrew (exec-path-from-shell-copy-env "LOCAL_ROOT"))
                    (env-perl5lib (exec-path-from-shell-copy-env "PERL5LIB")))
                (progn (setenv "PERL5LIB" (mapconcat 'identity perl-lib-dir ":"))
                       (setenv "PATH"     (mapconcat 'identity perl-bin-dir ":"))
                       (flycheck-define-checker perl
                         "A Perl syntax checker using the Perl interpreter.

See URL `http://www.perl.org'."
                         :command ("carton exec perl" "-w" "-c" source)
                         :error-patterns
                         ((error line-start (minimal-match (message))
                                 " at " (file-name) " line " line
                                 (or "." (and ", " (zero-or-more not-newline))) line-end))
                         :modes (perl-mode cperl-mode)
                         :next-checkers (perl-perlcritic))
                       (custom-set-variables
                        '(default-directory project-dir)
                        '(perlbrew-dir env-perlbrew)
                        '(cperl-extra-perl-args (concat "-v" " " (mapcar (lambda(x) (concat " " "-Ilocal::lib=" project-dir x)) perl-lib-dir)))
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
                       (setq cperl-indent-level 2)
                       (cperl-set-style "CPerl")
                       )))
            ))


(load-theme 'solarized-dark t nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(standard-indent 2)
 (custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  ))
