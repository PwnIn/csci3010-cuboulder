# some useful commands for your .bashrc to make things more colorful (if you want)
alias egrep="egrep --color"
alias grep="grep --color"
alias ls="ls -G"  # colorized ls

# A decent stack exchange on color codes: https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt
# Recommendation: define named variables, then use those variables

# For example, this is the color reset code
RESET="\033[0m"
DEFAULT_COLOR="\033[01;31m"
GIT_STATUS_CLEAN="\033[0;31m"
GIT_STATUS_DIRTY="\033[38;5;95m"
GIT_STATUS_NEW="\033[00;31"
USER_WHITE="\033[0;37m"
USER_CYAN="\033[0;87m"


function COLOR_OUT {
    local git_status="$(git status 2> /dev/null)"  # redirect stderr to /dev/null -- we just need it in this variable

    #echo $git_status # will help you decide what strings to test for, remove it later

    echo -ne "Xingyu Zhou" # as an example, see how echoing text here changes your prompt

    # insert strings to test for in the if statements below
    # example of using an "and" (&&)
    # =~ means "contains"
    # ! means "not"
    # be very very careful of spacing in bash-land!
    # the following if statements are examples -- fill them in, rearrange them, etc to your
    # hearts content 

    if [[ ! $git_status =~ "Working directory clean" ]]; then
      echo -ne $GIT_STATUS_DIRTY
    elif [[ $git_status =~ "Your branch is ahead of" ]]; then
      echo -ne $GIT_STATUS_NEW
    elif [[ $git_status =~ "Nothing to commit" ]]; then
      echo -ne $GIT_STATUS_CLEAN
    else
      echo -ne $USER_CYAN
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
PS1="\[$USER_WHITE\]\n[\W]"          # base of your PS 1
PS1+="\[\$(COLOR_OUT)\]"        # indicates git status
PS1+="\$(git_branch)"           # prints current branch
PS1+="\[$DEFAULT_COLOR\] blah \$\[$RESET\] " # prints out "blah $" -- change this!
#echo $PS1

# don't forget to export it at the end!
# make sure that you run source ~/.bashrc to see the changes from your PS1!
export PS1