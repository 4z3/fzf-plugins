__fzf_history__() (
  shopt -u nocaseglob nocasematch
  edit_key=${FZF_CTRL_R_EDIT_KEY:-enter}
  exec_key=${FZF_CTRL_R_EXEC_KEY:-ctrl-x}
  if selected=$(
    HISTTIMEFORMAT= history |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS --tac --sync -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --expect=$edit_key,$exec_key +m" $(__fzfcmd) |
    command grep "^\\($exec_key$\\|$edit_key$\\| *[0-9]\\)")
  then
    key=${selected%%$'\n'*}
    line=${selected#*$'\n'}

    result=$(
      if [[ $- =~ H ]]; then
        sed 's/^ *\([0-9]*\)\** .*/!\1/' <<< "$line"
      else
        sed 's/^ *\([0-9]*\)\** *//' <<< "$line"
      fi
    )

    case $key in
      $edit_key) result=$result$__fzf_edit_suffix__;;
      $exec_key) result=$result$__fzf_exec_suffix__;;
    esac

    echo "$result"
  else
    # Ensure that no new line gets produced by CTRL-X CTRL-P.
    echo "$__fzf_edit_suffix__"
  fi
)

__fzf_edit_suffix__=#FZFEDIT#
__fzf_exec_suffix__=#FZFEXEC#

__fzf_rebind_ctrl_x_ctrl_p__() {
  if test "${READLINE_LINE: -${#__fzf_edit_suffix__}}" = "$__fzf_edit_suffix__"; then
    READLINE_LINE=${READLINE_LINE:0:-${#__fzf_edit_suffix__}}
    bind '"\C-x\C-p": ""'
  elif test "${READLINE_LINE: -${#__fzf_exec_suffix__}}" = "$__fzf_exec_suffix__"; then
    READLINE_LINE=${READLINE_LINE:0:-${#__fzf_exec_suffix__}}
    bind '"\C-x\C-p": accept-line'
  fi
}

bind '"\C-x\C-p": ""'
bind -x '"\C-x\C-o": __fzf_rebind_ctrl_x_ctrl_p__'

if [[ ! -o vi ]]; then
  bind '"\C-r": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^\C-x\C-o\C-x\C-p"'
else
  bind '"\C-r": "\C-x\C-addi`__fzf_history__`\C-x\C-e\C-x\C-r\C-x^\C-x\C-a$a\C-x\C-o\C-x\C-p"'
fi
