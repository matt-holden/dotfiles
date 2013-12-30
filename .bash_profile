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

function dmergedbranches() {
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"

  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    exclude_pattern="(\*?\s+(staging|master|${branch}))"

    echo "Deleting all local branches merged to current branch ${branch}..."
    echo "  .. excluding 'staging' and 'master'"
    git branch --merged ${branch} | grep -E -v ${exclude_pattern} | xargs -n 1 git branch -d

    if [[ $1 == "--remote" ]]; then
      echo "Deleting branches on origin that have been merged to ${branch}"

      exclude_pattern="(\s{2}origin/(staging|master|HEAD|${branch}))" 
      remote_branches=$(git br -r --merged ${branch} | grep -E -v "(\s{2}origin/(staging|master|HEAD|${branch}))" | grep -E "^  origin" | sed s:origin/::)
      echo $remote_branches | xargs -n 1 git push origin --delete
    else 
      echo ""
      echo "(Note, you can pass --remote to delete merged branches from origin.)"
      echo ""
    fi

    echo "Pruning tracking branches that have been removed from origin..."
    git fetch origin -p

  else
    echo "You ain't in no git repo."
  fi
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
 
c_cyan=`tput setaf 6`
c_red=`tput setaf 1`
c_green=`tput setaf 2`
c_sgr0=`tput sgr0`
parse_git_branch ()
{
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        git_status="$(git status 2> /dev/null)"
        branch_pattern="^# On branch ([^${IFS}]*)"
        remote_pattern="# Your branch is (.*) of"
        diverge_pattern="# Your branch and (.*) have diverged"
        # add an else if or two here if you want to get more specific
        if [[ ${git_status} =~ ${remote_pattern} ]]; then
          if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            remote="↑"
          elif [ ${BASH_REMATCH[1]} == "behind" ]]; then
            remote="↓"
          fi
        fi
        if [[ ${git_status} =~ ${diverge_pattern} ]]; then
          remote="↕"
        fi
        if [[ ${git_status} =~ ${branch_pattern} ]]; then
          branch=${BASH_REMATCH[1]}
          echo "${branch}${remote}"
        fi
    else
        return 0
    fi
}
branch_color ()
{
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        git_status="$(git status 2> /dev/null)"
        color=""
        if [[ ${git_status} =~ "working directory clean" ]]; then
            color="${c_green}"
        else
            color=${c_red}
        fi
    else
        return 0
    fi
    echo -ne $color
}
export PS1='[\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]] \W\[${c_sgr0}\]$ '


# Turns off git info in PS1.. to be used on a per-shell basis
function set_normal_prompt {
  export PS1='mfh | \[\033[1;33m\]\W\[\033[0m\]$ '
}

#export PS1='mfh | \[\033[1;33m\]\W\[\033[0m\]$(parse_git_branch)$ '

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

alias gator-test="xctool -workspace Project-Gator/Project-Gator.xcworkspace/ -sdk iphonesimulator -scheme TestDevices-DevData test"
