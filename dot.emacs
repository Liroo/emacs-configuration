(load "~/.emacs.d/std.el")
(load "~/.emacs.d/std_comment.el")
(setq mac-option-modifier 'meta) ; set alt-key to meta
(setq mac-escape-modifier nil) ; set esc-key to nil
;;(load "~/.emacs.d/header2.el")

;;(add-hook 'write-file-hooks 'auto-update-file-header)
;;(add-hook 'emacs-lisp-mode-hook 'auto-make-header)
;;(add-hook 'c-mode-common-hook 'auto-make-header)
;;(add-hook 'python-mode-hook 'auto-make-header)
;;(add-hook 'c++-mode-hook 'auto-make-header)

(if (file-exists-p "~/.myemacs") 
    (load-file "~/.myemacs"))

; Create Header Guards with f12
(global-set-key [f12] 
		'(lambda () 
		   (interactive)
		   (if (buffer-file-name)
		       (let*
			   ((fName (upcase (file-name-nondirectory (file-name-sans-extension buffer-file-name))))
			    (ifDef (concat "#ifndef " fName "_" (upcase (file-name-nondirectory (file-name-extension buffer-file-name))) "_\n# define " 
					   fName "_" (upcase (file-name-nondirectory (file-name-extension buffer-file-name))) "_\n"))
			    (begin (point-marker))
			    )
			 (progn
					; If less then 5 characters are in the buffer, insert the class definition
			   (if (< (- (point-max) (point-min)) 5 )
			       (progn
				 (insert "\nclass " (capitalize fName) "{\n\tpublic:\n// CTOR DTOR\n" (capitalize fName) 
					 "();\n~" (capitalize fName) "();\n" (capitalize fName) "(const " (capitalize fName) " &);\n"
					 (capitalize fName) " &operator=(const " (capitalize fName) " &);\n\nprivate:\n\n};\n")
				 (goto-char (point-min))
				 (next-line-nomark 3)
				 (setq begin (point-marker))
				 )
			     )
			   
					;Insert the Header Guard
			   (goto-char (point-min))
			   (insert ifDef)
			   (goto-char (point-max))
			   (insert "\n#endif" " /* !" fName "_" (upcase (file-name-nondirectory (file-name-extension buffer-file-name))) "_ */")
			   (goto-char begin))
			 )
					;else
		     (message (concat "Buffer " (buffer-name) " must have a filename"))
		     )
		   )
		)

