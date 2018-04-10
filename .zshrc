export LANG=ja_JP.UTF-8
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

function history-all { history -E 1 } 

# enable interactive_comments
setopt interactive_comments

#zmv 
autoload -Uz zmv
alias zmv='noglob zmv -W'

## 補完機能の強化
if (( ! ${fpath[(I)/usr/local/share/zsh/site-functions]} )); then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi
autoload -U compinit
compinit -U

## プロンプトの設定
autoload colors
colors

case ${UID} in
0)
  PROMPT="[%{${fg[blue]}%}%n@%m%{${reset_color}%}] %{${fg[blue]}%}#%{${reset_color}%} "
  PROMPT2="%B%{${fg[blue]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[blue]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  RPROMPT="%{${fg[blue]}%}[%/]%{${reset_color}%}"
  ;;
*)
  PROMPT="[%n@%m] %{${fg[green]}%}#%{${reset_color}%} "
  PROMPT2="%B%{${fg[green]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[green]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  RPROMPT="%{${fg[green]}%}[%/]%{${reset_color}%}"
  ;;
esac

## コアダンプサイズを制限
limit coredumpsize 102400

## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr

## 色を使う
setopt prompt_subst

## ビープを鳴らさない
setopt nobeep

## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume

## 補完候補を一覧表示
setopt auto_list

## 補完候補を詰めて表示
setopt list_packed

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

## cd 時に自動で push
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

## TAB で順に補完候補を切り替える
setopt auto_menu

## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## =command を command のパス名に展開する
setopt equals

## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst

## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify

# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

## 出力時8ビットを通す
setopt print_eight_bit

## ヒストリを共有
setopt share_history

## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1


## 補完候補の色づけ
#eval `dircolors`
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## Deal with Large case as small case 
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'

## Kill Completion can select process by casor
zstyle ':completion:*:processes' menu yes select=2

## ディレクトリ名だけで cd
setopt auto_cd

## カッコの対応などを自動的に補完
setopt auto_param_keys

## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

## スペルチェック
setopt correct

## completion incremental
source ~/.zsh/plugin/incr*.zsh

## cpmpletion git
#source ~/.zsh/plugin/git-completion.zsh

## If you empty enter, We will execute ls 
# via http://d.hatena.ne.jp/kei_q/20110406/1302091565
alls() {
  zle accept-line
  if [[ -z "$BUFFER" ]]; then
    echo ''
    ls -a
  fi
}
zle -N alls
bindkey "\C-m" alls

# display buffer-stack
# via http://d.hatena.ne.jp/kei_q/20110308/1299594629
show_buffer_stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line
}
zle -N show_buffer_stack
bindkey "^[q" show_buffer_stack


## エイリアス
setopt complete_aliases

case "${OSTYPE}" in
freebsd*|darwin*)
alias ls="ls -G -w"
;;
linux*)
alias ls="ls --color"

;;
esac
alias la="ls -la"
alias lf="ls -F"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"
alias diff='colordiff'

## 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash

## 検索
export TEXT_BROWSER=w3m

# for less coloring
export LESS='-R'
export LESSOPEN='| /usr/bin/src-hilite-lesspipe.sh %s'

## zsh 4.3.10  
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

#extract any files
function extract() {
    case $1 in
        *.tar.gz|*.tgz) tar xzvf $1 ;;
        *.tar.xz) tar Jxvf $1 ;;
        *.zip) unzip $1 ;;
        *.lzh) lha e $1 ;;
        *.tar.bz2|*.tbz) tar xjvf $1 ;;
        *.tar.Z) tar zxvf $1 ;;
        *.gz) gzip -dc $1 ;;
        *.bz2) bzip2 -dc $1 ;;
        *.Z) uncompress $1 ;;
        *.tar) tar xvf $1 ;;
        *.arj) unarj $1 ;;
    esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

#for scala
export SCALA_HOME=$HOME/local/scala-2.9.1.final/
export PATH=$PATH:$SCALA_HOME/bin:/sbin:/usr/sbin

#up
source ~/.zsh/command/up.sh

fpath=(~/.zsh/completion ${fpath})

# if you want cd parent directory, you type "^".
function cdup() {
echo
cd ..
zle reset-prompt
}
zle -N cdup
bindkey '\^' cdup

function _space2p20
{
    echo $@ |sed -e "s/ /%20/g"
}

function _space2plus
{
    echo $@ | sed -e "s/ /+/g"
}

function google
{
    ${TEXT_BROWSER} "http://www.google.co.jp/search?q="`_space2plus $@`"&hl=ja"
}

function ydic
{
    ${TEXT_BROWSER} "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p="`_space2plus $@`"&stype=0&dtyp
e=2"
}

function technorati
{
    ${TEXT_BROWSER} http://www.technorati.com/search/`_space2p20 $@`"?language=ja"
}

function wikipedia
{
    ${TEXT_BROWSER} http://ja.wikipedia.org/wiki/`_space2p20 $@`
}

