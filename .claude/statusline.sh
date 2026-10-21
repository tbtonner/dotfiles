#!/usr/bin/env bash
# Claude Code status line: vim mode · model · dir · git branch + state (Kanagawa colours)
input=$(cat)
{
  IFS= read -r dir
  IFS= read -r model
  IFS= read -r vim_mode
} < <(jq -r '.workspace.current_dir // .cwd, .model.display_name // "", .vim.mode // ""' <<<"$input")

c() { printf '\033[38;2;%sm%s\033[0m' "$1" "$2"; }
violet='149;127;184' green='152;187;108' brred='255;93;98'
yellow='230;195;132' red='228;104;118' gray='114;113;105' aqua='122;168;159'

# Lualine-style vim mode pill: bold dark text on the mode colour, then a powerline arrow (needs a Nerd Font)
mode_pill() {
  local bg
  case $1 in
    NORMAL) bg='126;156;216' ;;
    INSERT) bg='118;148;106' ;;
    VISUAL*) bg='149;127;184' ;;
    REPLACE) bg='195;64;67' ;;
    *) bg='192;163;110' ;;
  esac
  printf '\033[1;38;2;22;22;29;48;2;%sm %s \033[0m\033[38;2;%sm\033[0m ' "$bg" "$1" "$bg"
}

git_segment() {
  git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null || return
  g() { git --no-optional-locks -C "$dir" "$@" 2>/dev/null; }
  local branch staged=0 modified=0 untracked=0 conflicts=0 line x y state="" counts behind ahead
  branch=$(g branch --show-current)
  [[ -z $branch ]] && branch="($(g rev-parse --short HEAD))"

  while IFS= read -r line; do
    x=${line:0:1} y=${line:1:1}
    if [[ $x$y == '??' ]]; then ((untracked++))
    elif [[ $x$y =~ ^(DD|AA|U.|.U)$ ]]; then ((conflicts++))
    else
      [[ $x != ' ' ]] && ((staged++))
      [[ $y != ' ' ]] && ((modified++))
    fi
  done < <(g status --porcelain)

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

  printf ' %s %s%s' "$(c "$gray" '·')" "$(c "$brred" "$branch")" "$state"
}

# git status is slow in big repos, so reuse the git segment for a few seconds; vim mode switches then redraw instantly.
# The cache file's first line is the epoch second it was written (date +%s works with both GNU and BSD date).
cached_git_segment() {
  local ttl=5 now cache stamp seg
  now=$(date +%s)
  cache="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/claude-statusline-git${dir//\//_}"
  if [[ -r $cache ]] && { IFS= read -r stamp && IFS= read -r seg; } <"$cache" && ((now - stamp < ttl)); then
    printf '%s' "$seg"
    return
  fi
  seg=$(git_segment)
  printf '%s\n%s\n' "$now" "$seg" >"$cache" 2>/dev/null
  printf '%s' "$seg"
}

out=""
[[ -n $vim_mode ]] && out=$(mode_pill "$vim_mode")
out+="$(c "$violet" "$model") $(c "$gray" '·') $(c "$green" "${dir/#$HOME/\~}")"
out+=$(cached_git_segment)

printf '%s' "$out"
