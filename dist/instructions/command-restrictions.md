
1. Heredocs / here-strings – `cat <<EOF`, `cat <<'EOF'`, `cat <<-"EOF"`, `<<<`, etc.
2. Inline Python invocations – `python -c '...'`, `python <<'PY'`, `python - <<'PY'` (or any language with here-doc input).
3. Inline Node.js/Perl/Ruby/Awk – `node -e ...`, `perl -0pi -e ...`, `ruby -e ...`, `awk '... { ... }' file > file.tmp`.
4. Inline cat with command substitution – `cat <<EOF > file` (same as heredoc), `cat >file <<EOF`, etc.
5. Any other command that pipes literal multi-line content directly into a shell interpreter – for example `sh <<'SCRIPT'`, `bash <<EOF`, or `envsubst <<EOF`.

