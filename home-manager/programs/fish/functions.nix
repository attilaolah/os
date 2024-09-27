{
  lib,
  pkgs,
  ...
}: let
  echo = lib.getExe' pkgs.coreutils "echo";
  grep = lib.getExe pkgs.gnugrep;
  nix = lib.getExe pkgs.nix;
  sed = lib.getExe pkgs.gnused;
in {
  programs.fish.functions = {
    nixpkg-run = "${nix} run nixpkgs#$argv[1] -- $argv[2..]";

    __prompt_segment = ''
      # Get colours
      set -l bg $argv[1]
      set -l fg $argv[2]

      # Set 'em
      set_color -b $bg
      set_color $fg

      # Print text
      if [ -n "$argv[3]" ]
        ${echo} -n -s $argv[3]
      end
    '';

    __show_shlvl_user_host = ''
      set -l bg white
      set -l fg black

      if [ -n "$SSH_CLIENT" ]
        set bg blue  # indicator for remote sessions
      end

      set -l who (whoami)
      set -l host (hostname -s)

      __prompt_segment $bg $fg \uf489" $SHLVL $who"

      if [ "$who" != "$host" ]
        # Skip @host bit if hostname == username
        __prompt_segment $bg $fg "@$host"
      end
    '';

    __show_jobs = ''
      set -l jobs $(jobs | wc -l)
      if [ $jobs -ne 0 ]
        __prompt_segment normal normal " "
        __prompt_segment yellow black \ueba2" $jobs"
      end
    '';

    __show_retval = ''
      if [ $RETVAL -ne 0 ]
        __prompt_segment normal normal " "
        __prompt_segment red black "$RETVAL⏎"
      end
    '';

    __show_venv = ''
      if set -q VIRTUAL_ENV
        __prompt_segment normal normal " "
        if [ "$VIRTUAL_ENV_PROJECT-" = "-" ]
          __set_venv_project  # try setting it manually
        end
        __prompt_segment yellow black \ued1b" $VIRTUAL_ENV_PROJECT"
      end
    '';

    __set_venv_project = {
      onVariable = "VIRTUAL_ENV";
      body = ''
        if test -e "$VIRTUAL_ENV/pyvenv.cfg"
          set -g VIRTUAL_ENV_PROJECT (
            ${grep} "^prompt\s*=\s*" "$VIRTUAL_ENV/pyvenv.cfg" |
            ${sed} \
              -e "s/^prompt\s*=\s*//" \
              -e "s/\(.*\)-py\([[:digit:]]\.*[[:digit:]]*\)/\2:\1/"
          )
        else if test -e "$VIRTUAL_ENV/.project"
          set -g VIRTUAL_ENV_PROJECT (cat "$VIRTUAL_ENV/.project")
        end
      '';
    };

    __show_pwd = ''
      __prompt_segment normal blue " "(prompt_pwd)
    '';

    __show_prompt = ''
      set -l uid (id -u $USER)
      if [ $uid -eq 0 ]
        __prompt_segment normal normal " "
        __prompt_segment red black "#"
      else
        __prompt_segment normal white ' $'
      end
      __prompt_segment normal normal " "
    '';

    fish_prompt = ''
      set -g RETVAL $status
      __show_shlvl_user_host
      __show_venv
      __show_jobs
      __show_retval
      __show_pwd
      __show_prompt
      set_color normal
    '';
  };
}
