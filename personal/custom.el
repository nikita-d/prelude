(scroll-bar-mode -1)
(projectile-global-mode)
(exec-path-from-shell-copy-env "PATH")
(exec-path-from-shell-copy-env "PERL5LIB")
(setenv "PERL5LIB" (concat "/local" (getenv "PERL5LIB")))
(set-face-attribute 'default (selected-frame) :height 80)
(set-default-font "Source Code Pro-9")
(set-fontset-font "fontset-default" '(#x0400 . #x0500) "Consolas-9")

;;load cperl, then work around indent issue
(ido-mode 1)
(ido-ubiquitous-mode 1)
(load-library "cperl-mode")
(load-library "projectile")
(defalias 'perl-mode 'cperl-mode)
(defun cperl-backward-to-start-of-continued-exp (lim)
  (goto-char (1+ lim))
  (forward-sexp)
  (beginning-of-line)
  (skip-chars-forward " \t")
  )
(add-hook 'cperl-mode-hook
          (lambda()
            (let ((project-dir (elt (projectile-get-project-directories) 0)))
              (let ((perl-lib-dir (concat project-dir "local/lib"))
                    (perl-bin-dir (concat project-dir "local/bin")))
                (progn (setenv "PERL5LIB" perl-lib-dir (getenv "PERL5LIB"))
                       (setenv "PATH"     perl-bin-dir (getenv "PATH"))
                       (setq cperl-extra-perl-args (concat "-v -Mlocal::lib=" project-dir "local"))
                       (custom-set-variables
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
 '(cperl-brace-offset 0)
 '(cperl-close-paren-offset -2)
 '(cperl-continued-brace-offset 0)
 '(cperl-continued-statement-offset 2)
 '(cperl-extra-newline-before-brace nil)
 '(cperl-extra-newline-before-brace-multiline nil)
 '(cperl-highlight-variables-indiscriminately nil)
 '(cperl-indent-level 2)
 '(cperl-indent-parens-as-block t)
 '(cperl-label-offset -2)
 '(cperl-merge-trailing-else t)
 '(custom-safe-themes (quote ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(standard-indent 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
