#!/usr/bin/env bash
# Claude Code status line: model · dir · git branch + state (Kanagawa colours)
input=$(cat)
dir=$(jq -r '.workspace.current_dir // .cwd' <<<"$input")
model=$(jq -r '.model.display_name // empty' <<<"$input")

c() { printf '\033[38;2;%sm%s\033[0m' "$1" "$2"; }
violet='149;127;184' green='152;187;108' brred='255;93;98'
yellow='230;195;132' red='228;104;118' gray='114;113;105' aqua='122;168;159'

out="$(c "$violet" "$model") $(c "$gray" '·') $(c "$green" "${dir/#$HOME/\~}")"

if git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null; then
  g() { git --no-optional-locks -C "$dir" "$@" 2>/dev/null; }
  branch=$(g branch --show-current)
  [[ -z $branch ]] && branch="($(g rev-parse --short HEAD))"

  staged=0 modified=0 untracked=0 conflicts=0
  while IFS= read -r line; do
    x=${line:0:1} y=${line:1:1}
    if [[ $x$y == '??' ]]; then ((untracked++))
    elif [[ $x$y =~ ^(DD|AA|U.|.U)$ ]]; then ((conflicts++))
    else
      [[ $x != ' ' ]] && ((staged++))
      [[ $y != ' ' ]] && ((modified++))
    fi
  done < <(g status --porcelain)

  state=""
  ((staged))    && state+=" $(c "$green" "+$staged")"
  ((modified))  && state+=" $(c "$yellow" "~$modified")"
  ((untracked)) && state+=" $(c "$gray" "?$untracked")"
  ((conflicts)) && state+=" $(c "$red" "!$conflicts")"

  if counts=$(g rev-list --left-right --count '@{upstream}...HEAD'); then
    read -r behind ahead <<<"$counts"
    ((ahead))  && state+=" $(c "$aqua" "↑$ahead")"
    ((behind)) && state+=" $(c "$red" "↓$behind")"
  else
    state+=" $(c "$gray" 'no upstream')"
  fi

  out+=" $(c "$gray" '·') $(c "$brred" "$branch")$state"
fi

printf '%s' "$out"
