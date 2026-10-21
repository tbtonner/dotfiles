" Syntax for Claude Code transcript dumps (ctrl+o then v). The dump is the rendered screen, so markdown fences and
" emphasis are already gone; this highlights the transcript's own structure instead.
if exists("b:current_syntax")
  finish
endif

" Multi-line prompts end at the next top-level marker, so highlight from the top.
syn sync fromstart

" Inline items, used in replies and inside prompts.
syn match ccUrl /https\?:\/\/[^ )>"']\+/
syn match ccTicket /\<\u\{2,}-\d\+\>/
syn match ccPath /\<[[:alnum:]_.-]\+\/[[:alnum:]_.\/-]*\.\a\+\(:\d\+\)\?/
syn match ccListMarker /^\s\+\zs\(\d\+\.\|[-•]\)\ze /

" Banner at the top of the dump.
syn match ccBanner /\%<4l.*/

" Your prompts: the ❯ line and its indented continuation lines.
syn region ccPrompt start=/^❯ / end=/\n\ze[●✻※❯]/ contains=ccPromptMarker,ccCollapsed,ccUrl
syn match ccPromptMarker /^❯/ contained

" Claude's replies and tool calls, e.g. ● Update(path/to/file.go).
syn match ccReplyMarker /^●/
" Lookbehinds, because ccReplyMarker has already consumed the start of the line.
syn match ccToolCall /\(^● \)\@<=\u\w*\ze(.*)$/
syn match ccToolArgs /\(^● \u\w*(\)\@<=.*\ze)$/
syn match ccToolResult /^\s\+⎿ .*/
syn match ccCollapsed /^\s\+.*(ctrl+o to expand)$/

" Diffs shown under Update/Write tool calls: line number, then +, - or a space.
syn match ccDiffLineNr /^\s\{4,}\d\+\ze \( \|$\)/
syn match ccDiffAdd /^\s\{4,}\d\+ +.*/
syn match ccDiffDel /^\s\{4,}\d\+ -.*/

" Turn footers and recaps.
syn match ccStatus /^✻ .*/
syn region ccRecap start=/^※ / end=/^$/

hi def link ccBanner Comment
hi def link ccPrompt String
hi def link ccPromptMarker Special
hi def link ccReplyMarker Identifier
hi def link ccToolCall Function
hi def link ccToolArgs Directory
hi def link ccToolResult Comment
hi def link ccCollapsed Comment
hi def link ccDiffLineNr LineNr
hi def link ccDiffAdd diffAdded
hi def link ccDiffDel diffRemoved
hi def link ccStatus Comment
hi def link ccRecap Comment
hi def link ccUrl Underlined
hi def link ccTicket Constant
hi def link ccPath Directory
hi def link ccListMarker Special

let b:current_syntax = "cctranscript"
