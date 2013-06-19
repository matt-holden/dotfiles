function funmerged {
local quote="'"
local merged_list=$(git st -s | egrep '^(U.|.U)' | awk -v q="'" '{print q (substr($0, index($0,$2))) q}')
if [ -z "$merged_list" ]
then
  echo "Nothing to merge."
else
  echo $merged_list | xargs mvim -p -c Gdiff
fi
}
function dunmerged {
  local quote="'"
  local merged_list=$(git st -s | egrep '^(U.|.U)' | awk -v q="'" '{print q (substr($0, index($0,$2))) q}')
  echo $merged_list | xargs git add -f
}

alias pg="cd ~/Development/Project-Gator/"
alias hitch="cd ~/Development/hitch/"
alias qf="cd ~/Development/quickfit"
alias gitkall="gitk --all 2> /dev/null &"
alias chatwoman="cd ~/Development/misc/chatwoman"
alias nodebox="cd ~/Development/nodebox"

alias jenkins="java -jar /usr/local/opt/jenkins/libexec/jenkins.war"

export PBX=MindBodyPOS.xcodeproj/project.pbxproj

export EDITOR=vim
export SVN_EDITOR=vim

# Enable Vim Keybindings in bash
set -o vi

#Cool stuff
alias ls="ls -G"

#PS1  (aka prompt)

# this the the simple "mfh" prompt:
# export PS1="mfh | \W\$ "

# this is the cool git -enabled prompt

# http://henrik.nyh.se/2008/12/git-dirty-prompt
# http://www.simplisticcomplexity.com/2008/03/13/show-your-git-branch-name-in-your-prompt/
#   username@Machine ~/dev/dir[master]$   # clean working directory
#   username@Machine ~/dev/dir[master*]$  # dirty working directory
 
function parse_git_dirty {
  [[ -z $(git status -s 2> /dev/null | tail -n1) ]] || echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
# Turns off git info in PS1.. to be used on a per-shell basis
function set_normal_prompt {
  export PS1='mfh | \[\033[1;33m\]\W\[\033[0m\]$ '
}

export PS1='mfh | \[\033[1;33m\]\W\[\033[0m\]$(parse_git_branch)$ '

###############################

#RVM STUFF
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

PATH="/usr/local/bin:$PATH"
PATH="$PATH:/usr/local/go/bin"

#Node binary path -- prepend per homebrew's suggestion
PATH="/usr/local/share/npm/bin:$PATH"

#heroku
PATH="/usr/local/heroku/bin:$PATH"

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

GIT_BASH_COMPLETION="/usr/local/Cellar/git/1.8.1.3/etc/bash_completion.d/git-completion.bash"
if [ -f $GIT_BASH_COMPLETION ]; then
  source $GIT_BASH_COMPLETION
fi

