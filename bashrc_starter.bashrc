# some useful commands for your .bashrc to make things more colorful (if you want)
alias egrep="egrep --color"
alias grep="grep --color"
alias ls="ls -G"  # colorized ls

# A decent stack exchange on color codes: https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt
# Recommendation: define named variables, then use those variables

# For example, this is the color reset code
RESET="\033[0m"
DEFAULT_COLOR="\033[01;31m"
GIT_STATUS_CLEAN_GREEN="\033[0;32m"
GIT_STATUS_DIRTY_RED="\033[0;31m"
GIT_STATUS_NEW_CYAN="\033[0;87m"
USER_BLUE="\033[0;34m"
USER_WHITE="\033[0;37m"

function git_indicator {
    local git_status="$(git status 2> /dev/null)"  
    
    if [[ ! $git_status =~ "working tree clean" ]]; then
      echo -ne $GIT_STATUS_DIRTY_RED
    elif [[ $git_status =~ "Your branch is ahead of" ]]; then
      echo -ne $GIT_STATUS_NEW_CYAN
    elif [[ $git_status =~ "nothing to commit" ]]; then
      echo -ne $GIT_STATUS_CLEAN_GREEN
    else
      echo -ne $USER_BLUE
    fi
}

function git_branch {
    local git_status="$(git status 2> /dev/null)"
    local on_branch="On branch ([^${IFS}]*)"
    local on_commit="HEAD detached at ([^${IFS}]*)"

    if [[ $git_status =~ $on_branch ]]; then
          local branch=${BASH_REMATCH[1]}
          echo "($branch)"
    elif [[ $git_status =~ $on_commit ]]; then
          local commit=${BASH_REMATCH[1]}
          echo "($commit)"
    fi
}

# edit to your heart's content
PS1="\[$USER_WHITE\]Xingyu Zhou\n[\W]"          # base of your PS 1
PS1+="\[\$(git_indicator)\]"        # indicates git status
PS1+="\$(git_branch)"           # prints current branch
PS1+="\[$DEFAULT_COLOR\]\$\[$RESET\] " # prints out "blah $" -- change this!
# don't forget to export it at the end!
# make sure that you run source ~/.bashrc to see the changes from your PS1!
export PS1