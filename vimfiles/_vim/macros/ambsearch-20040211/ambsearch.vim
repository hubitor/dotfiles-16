" vim:set ts=8 sts=2 sw=2 tw=0 fdm=marker:
"
" ambsearch.vim - Ambiguous character search
"
" Author:      MURAOKA Taro <koron@tka.att.ne.jp>
" Last Change: 11-Feb-2004.

scriptencoding cp932

" Japanese Description:
" �T�v:
"   f,F,t,T�ɂ�錟���ŞB���Ȍ������������܂��B������������f�ŊȒP�ɓ��{���
"   �����ł���Ƃ������Ƃł��B��:
"	fk	�J�[�\�������́uk�����������v�̂ǂꂩ�Ɉړ�
"   omap�����Ă���̂łقƂ�ǂ�vi�R�}���h�ɑg�ݍ��킹�ė��p���邱�Ƃ��\��
"   ���B��:
"	d2ft	�J�[�\��������2�ڂ́ut�����ĂƁv�̂ǂꂩ�܂ł��폜
"   �܂�vi���g����ł����Ƃ��y���Ƃ���Ɏ肪�͂��A�Ƃ����킯�ł��B
"
" �C���X�g�[��:
"   �ȉ������s���X�N���v�g��ǂݍ��݂܂��B
"	:source ambsearch.vim
"   �������̓v���O�C���f�B���N�g���ɒu���ċN�����ɓǂݍ��ނ��Ƃ��\�ł��B�B
"
" �ݒ���@:
"   �ǂ̃L�[�ɂǂ̌��������Q�����蓖�Ă邩�́A�ȉ��̕��@�Őݒ�̕ύX���\��
"   ���B����:
"	:let g:ambsearch_for_{key} = '{characters}'
"   {key}���L�[�ɁA{character}�ɕ����Q��ݒ肵�܂��B��:
"	:let g:ambsearch_for_a = '�����������A�C�E�G�I'
"	" a �ŕ������A�Љ��������̃A�s����������
"   �A�� :help /\w �Ƀ}�b�`���Ȃ��L�[�ɂ��ẮA�L�[���̂��̂ł͂Ȃ�����
"   �R�[�h�Ŏw�肷��K�v������܂��B��:
"	:let g:ambsearch_for_46 = '�A�C��B�D�'
"	" . �ŋ�Ǔ_�S�Ă���������
"
"   �f�t�H���g�œ��{��̕��͓�����������̂ɕK�v�Ǝv����ݒ�͂��Ă���܂��B
"   ���ۂ̓��e�͂��̃t�@�C���̌㔼���Q�Ƃ��Ă��������B���������̃f�t�H���g��
"   ��ؗ��p�������Ȃ��ꍇ�́A���̃v���O�C����ǂݍ��ޑO�Ɏ��̕ϐ���ݒ肵��
"   ��������:
"	:let g:ambsearch_default_disable = 1
"
" ���̃v���O�C����Ǎ��݂����Ȃ�����.vimrc�Ɏ��̂悤�ɏ����Ă�������:
"	:let ambsearch_plugin_disable = 1

if exists('g:ambsearch_plugin_disable') && g:ambsearch_plugin_disable
  finish
endif

let s:debug = 0

let ambsearch_dot = -1
let s:basedir = expand('<sfile>:p:h')
let s:last_char_0 = ''
let s:last_char_1 = ''
let s:last_dir_0 = 0
let s:last_dir_1 = 0
let s:last_exclusive_0 = 0
let s:last_exclusive_1 = 0
let s:last_count_0 = 0
let s:last_count_1 = 0

function! s:GetFirstChar(line, ncol, charlist)
  let mx = '\V\C\(\['.a:charlist.']\)'
  let line = substitute(strpart(a:line, a:ncol - 1), '^.', '', '')
  return matchstr(line, mx)
endfunction

function! s:GetLastChar(line, ncol, charlist)
  let mx = '\V\C\^\.\*\(\['.a:charlist.']\)'
  let line = strpart(a:line, 0, a:ncol - 1)
  return substitute(matchstr(line, mx), mx, '\1', '')
endfunction

function! s:GetCharlist(char, key)
  let charlist = a:char
  if exists('g:ambsearch_for_'.a:key)
    let charlist = charlist.g:ambsearch_for_{a:key}
  endif
  return escape(charlist, '\[^')
endfunction

function! s:GenerateChar(char)
  return strlen(a:char) == 1 ? a:char : nr2char(a:char)
endfunction

function! s:GenerateKey(char)
  let char = strlen(a:char) == 1 ? a:char : nr2char(a:char)
  if char !~ '^\w$'
    return char2nr(char)
  else
    return char
  endif
endfunction

" @param dir 1 for forward, 0 for backward.
function! s:JumpToNextChar(char, dir)
  let ncol = col('.')
  let char = s:GenerateChar(a:char)
  let key = s:GenerateKey(char)
  let charlist = s:GetCharlist(char, key)
  if a:dir
    let target = s:GetFirstChar(getline('.'), ncol, charlist)
  else
    let target = s:GetLastChar(getline('.'), ncol, charlist)
  endif
  if target.'X' == 'X'
    let target = char
  endif
  execute 'normal! '.(a:dir ? 'f' : 'F').target
  return 1
endfunction

function! s:JumpToChar(dir, char, exclusive, is_omap)
  if exists('g:ambsearch_dot') && g:ambsearch_dot >= 0
    if g:ambsearch_dot > 0
      let ncount = g:ambsearch_dot
    elseif s:last_count_{a:is_omap} >  0
      let ncount = s:last_count_{a:is_omap}
    else
      let ncount = 1
    endif
  else
    let ncount = v:count1
  endif
  let s:last_count_{a:is_omap} = ncount
  let startcol = col('.')
  let i = 0
  while i < ncount
    if !s:JumpToNextChar(a:char, a:dir)
      break
    endif
    let i = i + 1
  endwhile
  if startcol != col('.')
    if a:exclusive
      execute 'normal! '.(a:dir ? 'h' : 'l')
    endif
    if a:dir && a:is_omap
      let prevcol = col('.')
      silent! normal! l
      if prevcol == col('.')
	normal! $ 
      endif
    endif
    return 1
  else
    return 0
  endif
endfunction

function! s:SearchGetchar(dir, exclusive, is_omap, is_vmap)
  if exists('g:ambsearch_dot') && g:ambsearch_dot >= 0
    if s:last_char_{a:is_omap}.'X' == 'X'
      execute "normal! \<ESC>"
      return 0
    endif
    if a:is_vmap
      normal! gv
    endif
    let retval = s:JumpToChar(a:dir, s:last_char_{a:is_omap}, s:last_exclusive_{a:is_omap}, a:is_omap)
    return retval
  else
    let char = getchar()
    let s:last_char_{a:is_omap} = char
    let s:last_dir_{a:is_omap} = a:dir
    let s:last_exclusive_{a:is_omap} = a:exclusive
    if a:is_vmap
      normal! gv
    endif
    return s:JumpToChar(a:dir, char, a:exclusive, a:is_omap)
  endif
endfunction

function! s:SearchRepeat(dir, is_omap, is_vmap)
  if s:last_char_{a:is_omap}.'X' != 'X'
    let dir = a:dir ? s:last_dir_{a:is_omap} : !s:last_dir_{a:is_omap}
    if a:is_vmap
      normal! gv
    endif
    return s:JumpToChar(dir, s:last_char_{a:is_omap}, s:last_exclusive_{a:is_omap}, a:is_omap)
  else
    execute "normal! \<ESC>"
    return 0
  endif
endfunction

if s:debug
  nnoremap . :<C-U>let g:ambsearch_dot=v:count<CR>:exe 'norm!'.(g:ambsearch_dot>1?g:ambsearch_dot :'').'.'<CR>:let g:ambsearch_dot=-1<CR>
  nnoremap f :<C-U>call <SID>SearchGetchar(1, 0, 0, 0)<CR>
  nnoremap F :<C-U>call <SID>SearchGetchar(0, 0, 0, 0)<CR>
  nnoremap t :<C-U>call <SID>SearchGetchar(1, 1, 0, 0)<CR>
  nnoremap T :<C-U>call <SID>SearchGetchar(0, 1, 0, 0)<CR>
  nnoremap ; :<C-U>call <SID>SearchRepeat(1, 0, 0)<CR>
  nnoremap , :<C-U>call <SID>SearchRepeat(0, 0, 0)<CR>
  onoremap f :call <SID>SearchGetchar(1, 0, 1, 0)<CR>
  onoremap F :call <SID>SearchGetchar(0, 0, 1, 0)<CR>
  onoremap t :call <SID>SearchGetchar(1, 1, 1, 0)<CR>
  onoremap T :call <SID>SearchGetchar(0, 1, 1, 0)<CR>
  onoremap ; :call <SID>SearchRepeat(1, 1, 0)<CR>
  onoremap , :call <SID>SearchRepeat(0, 1, 0)<CR>
  vnoremap f :<C-U>call <SID>SearchGetchar(1, 0, 0, 1)<CR>
  vnoremap F :<C-U>call <SID>SearchGetchar(0, 0, 0, 1)<CR>
  vnoremap t :<C-U>call <SID>SearchGetchar(1, 1, 0, 1)<CR>
  vnoremap T :<C-U>call <SID>SearchGetchar(0, 1, 0, 1)<CR>
  vnoremap ; :<C-U>call <SID>SearchRepeat(1, 0, 1)<CR>
  vnoremap , :<C-U>call <SID>SearchRepeat(0, 0, 1)<CR>
else
  nnoremap <silent> . :<C-U>let g:ambsearch_dot=v:count<CR>:exe 'norm!'.(g:ambsearch_dot>1?g:ambsearch_dot :'').'.'<CR>:let g:ambsearch_dot=-1<CR>
  nnoremap <silent> f :<C-U>call <SID>SearchGetchar(1, 0, 0, 0)<CR>
  nnoremap <silent> F :<C-U>call <SID>SearchGetchar(0, 0, 0, 0)<CR>
  nnoremap <silent> t :<C-U>call <SID>SearchGetchar(1, 1, 0, 0)<CR>
  nnoremap <silent> T :<C-U>call <SID>SearchGetchar(0, 1, 0, 0)<CR>
  nnoremap <silent> ; :<C-U>call <SID>SearchRepeat(1, 0, 0)<CR>
  nnoremap <silent> , :<C-U>call <SID>SearchRepeat(0, 0, 0)<CR>
  onoremap <silent> f :call <SID>SearchGetchar(1, 0, 1, 0)<CR>
  onoremap <silent> F :call <SID>SearchGetchar(0, 0, 1, 0)<CR>
  onoremap <silent> t :call <SID>SearchGetchar(1, 1, 1, 0)<CR>
  onoremap <silent> T :call <SID>SearchGetchar(0, 1, 1, 0)<CR>
  onoremap <silent> ; :call <SID>SearchRepeat(1, 1, 0)<CR>
  onoremap <silent> , :call <SID>SearchRepeat(0, 1, 0)<CR>
  vnoremap <silent> f :<C-U>call <SID>SearchGetchar(1, 0, 0, 1)<CR>
  vnoremap <silent> F :<C-U>call <SID>SearchGetchar(0, 0, 0, 1)<CR>
  vnoremap <silent> t :<C-U>call <SID>SearchGetchar(1, 1, 0, 1)<CR>
  vnoremap <silent> T :<C-U>call <SID>SearchGetchar(0, 1, 0, 1)<CR>
  vnoremap <silent> ; :<C-U>call <SID>SearchRepeat(1, 0, 1)<CR>
  vnoremap <silent> , :<C-U>call <SID>SearchRepeat(0, 0, 1)<CR>
endif

function! AmbsearchInit()
  let i = 32
  while i < 127
    let key = s:GenerateKey(nr2char(i))
    if exists('g:ambsearch_for_'.key)
      unlet g:ambsearch_for_{key}
    endif
    let i = i + 1
  endwhile
endfunction

function! AmbsearchAdd(char, charlist)
  let key = s:GenerateKey(a:char)
  if !exists('g:ambsearch_for_'.key)
    let curstr = a:char.a:charlist
  else
    let curstr = a:char.g:ambsearch_for_{key}.a:charlist
  endif
  while 1
    let oldstr = curstr
    let curstr = substitute(curstr, '\m\(.\)\(.\{-}\)\1', '\1\2', '')
    if curstr."X" == oldstr."X"
      break
    endif
  endwhile
  let g:ambsearch_for_{key} = substitute(curstr, '^.', '', '')
  return 1
endfunction

function! AmbsearchLoad(filename)
  let filepath = s:basedir.'/ambsearch/'.a:filename.'.vim'
  if filereadable(filepath)
    execute 'source '.filepath
  endif
  execute 'runtime! ambsearch/'.a:filename.'.vim'
  return 1
endfunction

" Set default character list.
if exists('g:ambsearch_default_disable') && g:ambsearch_default_disable
  finish
endif
call AmbsearchLoad('default')
