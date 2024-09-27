{
  lib,
  pkgs,
  ...
}: let
  grep = lib.getExe pkgs.gnugrep;
  nix = lib.getExe pkgs.nix;
  sed = lib.getExe pkgs.gnused;
  tr = lib.getExe' pkgs.coreutils "tr";
  wc = lib.getExe' pkgs.coreutils "wc";
in {
  programs.fish.functions = {
    nixpkg-run = "${nix} run nixpkgs#$argv[1] -- $argv[2..]";

    __prompt_space = ''
      set_color normal
      echo -n -s " "
    '';

    __prompt_segment = ''
      # Get colours
      set -l bg $argv[1]
      set -l fg $argv[2]

      # Set 'em
      set_color -b $bg
      set_color $fg

      # Print text
      if [ -n "$argv[3]" ]
        echo -n -s $argv[3]
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
      set -l jobs (jobs | ${wc} -l)
      if [ $jobs -ne 0 ]
        __prompt_space
        __prompt_segment yellow black "$jobs"\ueba2" "
      end
    '';

    __show_retval = ''
      if [ $RETVAL -ne 0 ]
        __prompt_space
        __prompt_segment red black "$RETVAL"\uea87" "
      end
    '';

    __show_venv = ''
      if set -q VIRTUAL_ENV
        __prompt_space
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

    __show_git_prompt = ''
      set -l prompt (fish_git_prompt)
      if test -n "$prompt"
        __prompt_space
        __prompt_segment cyan black \ue65d(
          echo $prompt |
            ${sed} --regexp-extended \
              --expr 's/[()]//g' \
              --expr 's|([^/])[a-zA-Z]*/|\1/|' \
              --expr 's|^((./)?[A-Z]+-[0-9]+).*|\1|' \
              --expr 's/^(.{16}).*/\1…/' |
            ${tr} '[:upper:]' '[:lower:]'
        )
      end
    '';

    __show_pwd = ''
      __prompt_space
      __prompt_segment black white \uea83" "(prompt_pwd)
    '';

    __show_prompt = ''
      set -l uid (id -u $USER)
      if [ $uid -eq 0 ]
        __prompt_space
        __prompt_segment red black "#"
      else
        __prompt_space
        __prompt_segment normal white '$'
      end
    '';

    fish_prompt = ''
      set -g RETVAL $status
      __show_shlvl_user_host
      __show_venv
      __show_git_prompt
      __show_pwd
      __show_prompt
      __prompt_space
      set_color normal
    '';

    fish_right_prompt = ''
      __show_retval
      __show_jobs
      set_color normal
    '';
  };
}
