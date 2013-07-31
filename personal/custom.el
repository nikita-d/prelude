(scroll-bar-mode -1)

(exec-path-from-shell-copy-env "PATH")
(exec-path-from-shell-copy-env "PERL5LIB")
(set-face-attribute 'default (selected-frame) :height 80)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cperl-electric-parens-mark nil)
 '(cperl-extra-perl-args "-Ilib -MModern::Perl=2013")
 '(cperl-highlight-variables-indiscriminately t)
 '(cperl-indent-parens-as-block t)
 '(cperl-mode-hook (quote (er/add-cperl-mode-expansions))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
