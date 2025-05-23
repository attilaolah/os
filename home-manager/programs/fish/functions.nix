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
    hyprstart = "uwsm check may-start && exec uwsm start -S hyprland-uwsm.desktop";
    nixpkg-run = "${nix} run nixpkgs#$argv[1] -- $argv[2..]";

    __pad_from_left = ''
      set_color normal
      set_color $argv[1]
      echo -n \u2590
    '';

    __pad_from_left_thin = ''
      set_color normal
      set_color $argv[1]
      echo -n \u2595
    '';

    __pad_from_right = ''
      set_color normal
      set_color $argv[1]
      echo -n \u258d
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
      set -l bg black
      set -l fg white

      if [ -n "$SSH_CLIENT" ]
        set bg blue
        set fg black
      end

      set -l who (whoami)
      set -l host (hostname -s)

      __pad_from_left $bg
      __prompt_segment $bg $fg \uf489" $SHLVL $who"

      if [ "$who" != "$host" ]
        # Skip @host bit if hostname == username
        __prompt_segment $bg $fg "@$host"
      end

      __pad_from_right $bg
    '';

    __show_jobs = ''
      set -l jobs (jobs | ${wc} -l)
      if [ $jobs -ne 0 ]
        __pad_from_left_thin yellow
        __prompt_segment yellow black "$jobs"\ueba2" "
      end
    '';

    __show_retval = ''
      if [ $RETVAL -ne 0 ]
        __pad_from_left_thin red
        __prompt_segment red black "$RETVAL"\uea87" "
      end
    '';

    __show_devenv = ''
      if set -q DEVENV_ROOT
        __pad_from_left yellow
        __prompt_segment yellow black \uf121" "
        __pad_from_right yellow
      else if set -q IN_NIX_SHELL
        __pad_from_left magenta
        __prompt_segment magenta black \uf313" "
        __pad_from_right magenta
      end
    '';

    __show_venv = ''
      if set -q VIRTUAL_ENV
        if [ "$VIRTUAL_ENV_PROJECT-" = "-" ]
          __set_venv_project  # try setting it manually
        end
        __pad_from_left green
        __prompt_segment green black \ued1b" $VIRTUAL_ENV_PROJECT"
        __pad_from_right green
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
        __pad_from_left cyan
        __prompt_segment cyan black \uf418" "(
          echo $prompt |
            ${sed} --regexp-extended \
              --expr 's/[() ]//g' \
              --expr 's|([^/])[a-zA-Z]*/|\1/|' \
              --expr 's|^((./)?[A-Z]+-[0-9]+)-.*|\1|' \
              --expr 's/^(.{16}).*/\1…/' |
            ${tr} '[:upper:]' '[:lower:]'
        )
        __pad_from_right cyan
      end
    '';

    __show_pwd = ''
      __pad_from_left black
      __prompt_segment black white \uea83" "(prompt_pwd)
      __pad_from_right black
    '';

    __show_prompt = ''
      set -l uid (id -u $USER)
      if [ $uid -eq 0 ]
        __prompt_segment red black "#"
      else
        __prompt_segment normal white '$'
      end
    '';

    fish_prompt = ''
      set -g RETVAL $status
      __show_shlvl_user_host
      __show_devenv
      __show_venv
      __show_git_prompt
      __show_pwd
      __show_prompt
      set_color normal
      echo -n " "
    '';

    fish_right_prompt = ''
      __show_retval
      __show_jobs
      set_color normal
    '';
  };
}
