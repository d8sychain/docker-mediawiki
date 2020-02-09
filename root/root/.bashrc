HOST='\033[02;36m\]\h'; HOST=' '$HOST
TIME='\033[01;31m\]\t \033[01;32m\]'
LOCATION=' \033[01;33m\]`pwd | sed "s#\(/[^/]\{1,\}/[^/]\{1,\}/[^/]\{1,\}/\).*\(/[^/]\{1,\}/[^/]\{1,\}\)/\{0,1\}#\1_\2#g"`'
PROMPT=' \[\033[00m\]\n\$ '
PS1=$TIME$USER$HOST$LOCATION$PROMPT
PS2='\[\033[01;36m\]>'

alias maintenance='bash /maintenance'
alias test='bash /config/test'

export EDITOR=nano