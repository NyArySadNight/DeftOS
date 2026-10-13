
# >>> DeftOS fastfetch >>>
# Interactive terminals only, once per shell tree; skipped when output is piped.
if [[ $- == *i* && -t 1 && -z "${DEFTOS_FETCH_DONE:-}" ]] && command -v fastfetch >/dev/null 2>&1; then
    export DEFTOS_FETCH_DONE=1
    fastfetch
fi
# <<< DeftOS fastfetch <<<
