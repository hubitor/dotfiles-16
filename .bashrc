
# .bashrc

# User specific aliases and functions


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Platform-specific things
case $( uname -s ) in
    Darwin )
        . .bash_mac ;;
    Linux )
        . .bash_linux ;;
esac


## ���������줿�ե�����Υѡ��ߥå���󤬤Ĥͤ� 644 �ˤʤ�褦�ˤ���
umask 022

## core �ե�������餻�ʤ��褦�ˤ���
ulimit -c 0

## �Ķ��ѿ�������

# man �Ȥ��򸫤�Ȥ��Ϥ��Ĥ� less ��Ȥ���
export PAGER=less
# less �Υ��ơ������Ԥ˥ե�����̾�ȹԿ������޲�%����ɽ������褦�ˤ��롣
# ���ꤹ��ȥ��顼�����������ʤ뤫�饳���ȥ�����
#export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'

# ���դ�
alias diff='colordiff'
alias less='less -R'

# rsync �Ǥ� ssh ��Ȥ�
export RSYNC_RSH=ssh

# backspace
#stty erase "^?"

# "." ���ޥ�ɤǥ����륹����ץȤ�¹Ԥ���Ȥ��Ϻ��𤹤�Τ� PATH �򸡺������ʤ���
shopt -u sourcepath


# PCRE �ߴ�������ɽ����Ȥ�
setopt re_match_pcre

# �ץ��ץȤ�ɽ������뤿�Ӥ˥ץ��ץ�ʸ�����ɾ�����ִ�����
setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'

# ����Ū�⡼�ɤʤ�Ķ��ѿ� PS1 (�ץ��ץ�ʸ����) �����ꤵ��Ƥ���
# �Ϥ��ʤΤǡ������Ĵ�٤롣
if [[ "$PS1" ]]; then

  # �����������Ū�⡼�ɤ���

  # bash���ץ��������

  # EOF (Ctrl-D) ���Ϥ� 10��ޤǵ��ġ�
  IGNOREEOF=10
  # ����Υ������������ξ��Ϥ����Ⱦǯ���餤���Τ�ĤޤǻĤ롣
  HISTSIZE=50000
  HISTFILESIZE=50000

  # ����ե�������񤭤ǤϤʤ��ɲä��롣
  # ʣ���Υۥ��Ȥ�Ʊ���˥����󤹤뤳�Ȥ�����Τǡ���񤭤���ȴ�����
  shopt -s histappend
  # "!"��Ĥ��ä������Υ��ޥ�ɤ�¹Ԥ���Ȥ���
  # �¹Ԥ���ޤ���ɬ��Ÿ����̤��ǧ�Ǥ���褦�ˤ��롣
  shopt -s histverify
  # ������ִ��˼��Ԥ����Ȥ����ľ����褦�ˤ��롣
  shopt -s histreedit
  # ü���β��̥�������ưǧ����
  shopt -s checkwinsize
  # "@" �Τ��Ȥ˥ۥ���̾���䴰�����ʤ���
  shopt -u hostcomplete
  # �Ĥͤ˥ѥ�̾�Υơ��֥������å����롣
  shopt -s checkhash
  # �ʤˤ����Ϥ��Ƥʤ��Ȥ��ϥ��ޥ��̾���䴰���ʤ���
  # (����㥯������䤬¿���Τǡ�)
  shopt -s no_empty_cmd_completion

  # i: ľ�������� 30���ɽ�����롣������������ϲ�� 1000��򸡺����롣
  # (history ������������ɽ���������¿������Τ�)
  function i {
      if [ "$1" ]; then history 1000 | grep "$@"; else history 30; fi
  }
  # I: ľ�������� 30���ɽ�����롣������������ϲ��Τ��٤Ƥ򸡺����롣
  function I {
      if [ "$1" ]; then history | grep "$@"; else history 30; fi
  }

  # GNU screen �ѤΥ��ޥ�ɡ������� screen �Υ��ơ������Ԥ�ɽ����
  function dispstatus {
      if [[ "$STY" ]]; then echo -en "\033k$1\033\134"; fi
  }

  # ü�����ץ��ץȤ�����

  # �ۥ���̾�ȥ桼��̾����Ƭ 4ʸ����Ȥ��������������Ĺ���Τǡ�
  h2=`expr $HOSTNAME : '\(....\).*'`
  u2=`expr $USER : '\(....\).*'`
  # ���ߤΥۥ��Ȥˤ�äƥץ��ץȤο����Ѥ��롣
  case "$HOSTNAME" in
  ma*)   col=31;;  # ��
  md*)    col=32;;  # ��
  ub*)    col=33;;  # ��
  www.l*)    col=34;;  # ��
  je*)    col=35;;  # �ޥ����
  mo*) col=36;;  # �忧
  *) col=1;; # ����ʳ��Υۥ��ȤǤ϶�Ĵɽ��
  esac
  if [[ "$EMACS" ]]; then
    # emacs �� shell �⡼�ɤǤ�����ʸ����Ȥ�ʤ���ñ�ʥץ��ץ�
    stty -echo nl
    PS1="$u2@$h2\w\$ "
  else
    # �ץ��ץȤ�����
    if [[ "$SHELLTYPE" = session ]]; then
      # ����ü���Ǥ�û���ץ��ץȤˤ��롣
      PS1='$h2$ ';
      unset SHELLTYPE
    else
      PS1="$u2@$h2\[\e[${col}m\]\w[\!]\$\[\e[m\] "
    fi
    # �̾�Υץ��ץ� PS1 �˲ä��� PS0 �Ȥ����ѿ������ꤹ�롣
    # (����� bash �ϲ�����Τ��ʤ������ȤǽҤ٤� px �Ȥ������ޥ�ɤ��Ȥ�)
    # �̾�Υץ��ץȤǤϸ��ߤΥ����ȥǥ��쥯�ȥ�Υե�ѥ�̾��
    # ɽ������褦�ˤʤäƤ��뤬�����줬Ĺ������Ȥ��� PS1 �� PS0 ��
    # ���Ū���ڤ괹���ƻȤ���
    PS0="$u2@$h2:\[\e[${col}m\]\W[\!]\$\[\e[m\] "

    # ü��������
    eval `SHELL=sh tset -sQI`
    stty dec crt erase ^H eof ^D quit ^\\ start ^- stop ^-
  fi

  # ����Ĥ� cd
  # http://www.unixuser.org/~euske/doc/bashtips/cdhist.sh
  . ~/src/dotfiles/cdhist.sh

  # �����ʴؿ�

  # �Ĥͤ�ľ���Υ��ޥ�ɤν�λ���֤�����å������롣
  # �⤷�۾ｪλ�������ϡ����ξ���(����)��ɽ�����롣
  function showexit {
    local s=$?
    dispstatus "${PWD/\/root/~}"
    if [[ $s -eq 0 ]]; then return; fi
    echo "exit $s"
  }
  PROMPT_COMMAND=showexit

  # px: Ĺ���ץ��ץȤ�û���ץ��ץȤ��ڤ괹���롣
  function px {
      local tmp=$PS1; PS1=$PS0; PS0=$tmp;
  }

  # h: csh �ˤ����� which ��Ʊ����
  function h { command -v $1; }

  # wi: whatis ��ά�����ꤵ�줿���ޥ�ɤμ��Τ�ɽ����
  function wi {
    case `type -t "$1"` in
     alias|function) type "$1";;
     file) L `command -v "$1"`;;
     function) type "$1";;
    esac
  }

  # ���߼¹���Υ���֤�ɽ����
  function j { jobs -l; }

  # Perl �Υ��饤�ʡ������
  function P { perl -e 'sub f{'"$*"';}print &f(@ARGV),"\n";'; }

  # Wordnet �򸡺���
  function wng { wn $1 -grepn -grepa -grepv; }

  # ��¿�ʼ�ȴ���ѥ��ޥ�ɡ�
  function tmp { cd ~/tmp; }
  function m { dispstatus Mutt; mutt "$@"; }
  function s { m -f +$1; }

  # SSH ������

  # ���� bashrc ���¹Ԥ���륱������ 3�Ĥ��롣
  #   a. ��⡼�ȥۥ��Ȥ˥����󤷤����ǡ�agent ž����ǽ�ʤȤ���
  #   b. ������ۥ��Ȥ˥����󤷤����ǡ����Ǥ� agent ����ư���Ƥ���Ȥ���
  #   c. ������ۥ��Ȥ˥����󤷤����ǡ��ޤ�agent����ư���Ƥ��ʤ��Ȥ���

  # ssh-agent �ϳƥۥ��ȤˤҤȤĤ�����ư���������ʤ���
  # ��������X ��ȤäƤ���Ķ��Ǥϡ�ʣ���Υ�����ɥ����� agent �˥�������
  # ����ɬ�פ����롣����򤹤뤿��ˡ�ssh-agent ���̿��ѥ����åȤ�
  # �Ĥͤ˷�ޤä���� (~/.ssh/sock.�ۥ���̾) �˺��褦�ˤ��ơ�
  # ������Ĵ�٤�� (SSH_AUTH_SOCK ����ꤷ�� ssh-add ��¹Ԥ���)��
  # agent ����ư���Ƥ��뤫�ɤ����狼��褦�ˤ�������

  # ���� ~/.ssh/agent.log �˻Ĥ���롣
  export SSH_AGENT_LOG=$HOME/.ssh/agent.log

  # �ޤ���ssh-agent ���̿���ǽ���ɤ���������å����롣
  # ���Ǥ� agent ����ư���Ƥ����礫����⡼�ȥۥ��Ⱦ��
  # agent ��ž������Ƥ������ SSH_AUTH_SOCK ���ǽ餫�����ꤵ��Ƥ���
  # �̿���ǽ�ʤϤ���

  # ����� ssh-add -l �ν�λ���֤�Ĵ�٤뤳�Ȥˤ�äƤ����ʤ���
  # ssh-add -l �ϡ�agent �Ȥ��̿�����ǽ�Ǥʤ����Ļ��Ѳ�ǽ�ʸ��������
  # ���ｪλ�� (��λ���� 0)��agent �Ȥ��̿��ϲ�ǽ�������Ѳ�ǽ�ʸ����ʤ����ϡ�
  # ��λ���� 1 �ǰ۾ｪλ���롣agent �Ȥ��̿��ϲ�ǽ�Ǥʤ����� ��λ���� 2 ��
  # �۾ｪλ����Τǡ������Ĵ�٤�Ф褤��
  if ssh-add -l >/dev/null 2>&1; then
      # �̿���ǽ�ǡ��������Ǥˤ��ä���
      #echo "The agent has a key."
      :
  elif [ 2 = "$?" ]; then
      # �Ĥ��˥������ ssh-agent ����ư���Ƥ��뤫�ɤ��������å����롣
      export SSH_AUTH_SOCK=$HOME/.ssh/sock.`hostname`
      if ssh-add -l >/dev/null 2>&1; then
          # ������� agent �����Ǥ˵�ư���Ƥ�����
          #echo "The agent does not have a key."
          :
      elif [ 2 = "$?" -a ! "$SSH_CLIENT" ]; then
          # agent ����ư���Ƥ��ʤ��ä����Τǡ���ư�����롣
          # ���ξ�硢�̿��ѤΥ����åȤϤĤͤ˷�ޤä��ѥ��ˤ��롣
          #echo "Cannot find an agent, launching."
	  rm -f $SSH_AUTH_SOCK
	  eval `ssh-agent -a $SSH_AUTH_SOCK`
	  echo -n `date` : 'ssh-agent started at' `hostname` : $SSH_AUTH_SOCK : $SSH_AGENT_PID >>$SSH_AGENT_LOG
      fi
  fi

  # ����������Ȥ˸����ɲä��륳�ޥ�ɡ�ssh-add �Ǹ������뤫�ɤ���Ĵ�١�
  # �ʤ���Хѥ��ե졼�����׵᤹�롣ssh �Τ����˼�ưŪ�˼¹Ԥ���롣
  function sshon1 {
      if ! (ssh-add -l 2>&1 | grep '(RSA1)' >&2 ); then
          ssh-add -t 60m ~/.ssh/identity &&
	  echo `date` : 'identity is added at' `hostname` >>$SSH_AGENT_LOG
      fi
  }
  function sshon2 {
      if ! (ssh-add -l 2>&1 | grep '(DSA)' >&2 ); then
          ssh-add -t 60m ~/.ssh/id_dsa_orange &&
	  echo `date` : 'id_dsa_orange is added at' `hostname` >>$SSH_AGENT_LOG
      fi
  }

  # �դ���� ssh �Τ����� ssh1 �� ssh2 �Ȥ������ޥ�ɤ�Ȥ���
  # ����ϥ���������Ȥ˸����ʤ���Хѥ��ե졼�����׵ᤷ���ɲä��褦�Ȥ��롣
  alias sshon=sshon2
  function ssh1 { sshon1 && command ssh -1 "$@"; }
  function ssh2 { sshon2 && command ssh -2 "$@"; }

  # wg: ��������ɤοʹԾ����򸫤륳�ޥ�ɡ�
  # Lynx �ǲ�����������ɤ���Ȥ���wget �Υ���Ĥͤ�
  # ~/.wgetlog �� �ɵ�����褦�ˤ��Ƥ��롣
  function wg { tail ~/.wgetlog; }
  function lynx { dispstatus Lynx; command lynx "$@"; }

  # �����ꥢ����

  alias ls='ls -F'
  alias ll='ls -o'   # �Ķ��ˤ�äƤ� -o �Ϥʤ���-l ��Ȥ���
  alias la='ls -lag'
  # grep �Ǥ� LC_CTYPE �ϥ��åȤ��ʤ����٤����顣
  alias g='env -u LC_CTYPE grep -i'
  alias r='env -u LC_CTYPE grep -ir'
  alias G='env -u LC_CTYPE grep'
  alias F='env -u LC_CTYPE fgrep'
  alias c=cat
  # ��ǧ�Ĥ��ե�������rm, mv, cp �ʤɤΤ��֤ʤ����Ϥʤ�٤�������Ȥ���
  # ���ޥ��̾�� rm �� mv �ʤɤ˾�񤭤��ʤ��Τϡ������Υ����ꥢ�������ꤵ��Ƥʤ��Ķ�
  # (root �ʤ�) �Ǥ��ä������� rm �ʤɤ� (-i ���Ĥ��Ƥ�Ȼפä�) �¹Ԥ��Ƥ��ޤ��Τ��ɤ����ᡣ
  alias rmi='rm -i'
  alias mvi='mv -i'
  alias cpi='cp -i'
  alias lld='ls -ld'
  alias ..='cd ..'
  alias 644='chmod 644'
  alias 755='chmod 755'
  alias ox='od -Ax -tx1'
  # rm�ϥ���Ȣ�˰�ư
  #function rm () {
  #  local path
  #  for path in "$@"; do
  #    if [[ "$path" != -* ]]; then
  #      /usr/local/bin/trash "$path"
  #    fi
  #  done
  #}

  # �䴰�����ꡣ���ޤ�ܤ��������ꤷ�Ƥʤ���
  complete -d cd
  complete -c man
  complete -c h
  complete -c wi
  complete -v unset

  if [ -f ~/.bashrc_local ]; then
      . ~/.bashrc_local
  fi

  # mac��ͭ�����ꡣ
  if [ -f ~/.bashrc_mac ]; then
      . ~/.bashrc_mac
  fi
fi

# grunt completion
if [ -f grunt ]; then
  eval "$(grunt --completion=bash)"
fi

# http://www.direnv.net/
eval "$(direnv hook bash)"

# pythonbrew
[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc

# Import virtualenvwrapper
if [ -f ~/.virtualenvwrapper_bashrc ]; then
  source ~/.virtualenvwrapper_bashrc
fi

