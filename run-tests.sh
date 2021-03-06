#!/bin/sh -eu

echo "Attempting startup..."

EMACS=${EMACS:-emacs}

command -v "$EMACS" >/dev/null || {
  >&2 echo "Can't find GNU Emacs in your PATH"
  exit 1
}

[ -n "${1-}" ] && {
  [ "$1" = -d ] || [ "$1" = --debug ] && {
    shift
    export DEBUG=1
  }
}

tpl='(let ((debug-on-error t)
          (url-show-status nil)
          (user-emacs-directory default-directory)
          (user-init-file (expand-file-name "init.el"))
          (load-path (delq default-directory load-path)))
      (load-file user-init-file)
      (run-hooks (quote after-init-hook)))'

${EMACS} \
    --no-window-system \
    --batch \
    --eval "$tpl"

t="$(mktemp elisp-files.XXX)"

find site-lisp -type f -name '*.el' > "$t"
echo init.el >> "$t"

while IFS= read -r file
do
  ${EMACS} \
    -Q --batch --eval "(checkdoc-file \"$file\")"
done < "$t"
rm "$t"

echo "Startup successful"
