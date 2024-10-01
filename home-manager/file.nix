{lib, ...}: {
  home.file = {
    ".sops.yaml".text = lib.generators.toYAML {} {
      creation_rules = [
        {pgp = "BF2E475974D388E0E30C960407E6C0643FD142C3";}
      ];
    };
    ".ssh/config".text = ''
      # Force GPG-agent's pinentry to use the current tmux pane.
      Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
    '';
  };
}
