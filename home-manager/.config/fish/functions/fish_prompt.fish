function prompt_segment -d "Function to show a segment"
  # Get colors
  set -l bg $argv[1]
  set -l fg $argv[2]

  # Set 'em
  set_color -b $bg
  set_color $fg

  # Print text
  if [ -n "$argv[3]" ]
    echo -n -s $argv[3]
  end
end

function show_shlvl_user_host -d "Show the shell level, username and host"
  set -l bg white
  set -l fg black

  if [ -n "$SSH_CLIENT" ]
    set bg blue  # indicator for remote sessions
  end

  set -l who (whoami)
  set -l host (hostname -s)

  prompt_segment $bg $fg \uf489" $SHLVL $who"

  if [ "$who" != "$host" ]
    # Skip @host bit if hostname == username
    prompt_segment $bg $fg "@$host"
  end
end

function show_shlvl -d "Show the current shell level"
  prompt_segment $bg black ":$SHLVL"
end

function show_jobs -d "Show the number of background jobs"
  set -l jobs $(jobs | wc -l)
  if [ $jobs -ne 0 ]
    prompt_segment normal normal " "
    prompt_segment yellow black \ueba2" $jobs"
  end
end

function show_retval -d "Show process failures (return value)"
  if [ $RETVAL -ne 0 ]
    prompt_segment normal normal " "
    prompt_segment red black "$RETVAL⏎"
  end
end

function show_venv -d "Show Python active virtual env"
  if set -q VIRTUAL_ENV
    prompt_segment normal normal " "
    if [ "$VIRTUAL_ENV_PROJECT-" = "-" ]
      _set_venv_project  # try setting it manually
    end
    prompt_segment yellow black \ued1b" $VIRTUAL_ENV_PROJECT"
  end
end

function _set_venv_project --on-variable VIRTUAL_ENV
  if test -e "$VIRTUAL_ENV/pyvenv.cfg"
    set -g VIRTUAL_ENV_PROJECT (
      grep "^prompt\s*=\s*" "$VIRTUAL_ENV/pyvenv.cfg" |
      sed \
        -e "s/^prompt\s*=\s*//" \
        -e "s/\(.*\)-py\([[:digit:]]\.*[[:digit:]]*\)/\2:\1/"
    )
  else if test -e "$VIRTUAL_ENV/.project"
    set -g VIRTUAL_ENV_PROJECT (cat "$VIRTUAL_ENV/.project")
  end
end

function show_pwd -d "Show the current directory"
  set -l pwd
  if [ (string match -r '^'"$VIRTUAL_ENV_PROJECT" $PWD) ]
    set pwd (string replace -r '^'"$VIRTUAL_ENV_PROJECT"'($|/)' '≫ $1' $PWD)
  else
    set pwd (prompt_pwd)
  end
  prompt_segment normal blue " $pwd "
end

function show_prompt -d "Shows prompt with cue for privilege"
  set -l uid (id -u $USER)
  if [ $uid -eq 0 ]
    prompt_segment red black "#"
  else
    prompt_segment normal white '$'
  end
  prompt_segment normal normal " "
end

function fish_prompt
  set -g RETVAL $status
  show_shlvl_user_host
  show_venv
  show_jobs
  show_retval
  show_pwd
  show_prompt
  set_color normal
end
