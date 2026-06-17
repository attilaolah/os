{
  lib,
  pkgs,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    settings = let
      # Colours:
      black = "rgba(0, 0, 0, 0)";
      crust = "rgb(17, 17, 27)";
      red = "rgb(243, 139, 168)";
      teal = "rgb(148, 226, 213)";
      text = "rgb(205, 214, 244)";
      subtext = "rgb(186, 194, 222)";

      # Common values:
      monitor = "";
      prefix = "hyprlock";
    in {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 20;
      };

      background = [
        {
          inherit monitor;
          color = crust;
        }
      ];

      input-field = [
        {
          inherit monitor;
          size = "270, 270";
          outline_thickness = 8;
          hide_input = true;
          outer_color = black;
          inner_color = teal;
          fade_on_empty = true;
          fade_timeout = 200;
          placeholder_text = "";
          fail_text = "";
          fail_color = red;
          fail_transition = 50;
          rounding = -1;
          check_color = red;

          position = "0, 0";
          halign = "center";
          valign = "center";
          zindex = 1;
        }
      ];

      image = [
        {
          inherit monitor;
          path = "${./avatar.1024.png}";
          size = 256;
          rounding = -1; # circle
          border_size = 4;
          border_color = teal;
          reload_time = -1;

          position = "0, 0";
          halign = "center";
          valign = "center";
          zindex = 2;
        }
      ];

      label = let
        u = 24;
        asText = {
          color = text;
          font_size = u * 2;
        };
        asSubtext = {
          color = subtext;
          font_size = u;
        };
        defaults = {
          inherit monitor;
          font_family = "monospace";
          valign = "bottom";
        };
        labels = [
          ({
              text = let
                app = pkgs.writeShellApplication {
                  name = "${prefix}-uptime";
                  runtimeInputs = with pkgs; [coreutils gawk gnused];
                  text = ''
                    uptime |
                      cut -d, -f1 |
                      awk -Fup '{ print $NF }' |
                      sed -E 's/\s+/ /g' |
                      tr '[:lower:]' '[:upper:]' |
                      awk '{ print "UP" $ALL }'
                  '';
                };
              in "cmd[update:1000] ${lib.getExe app}";

              position = "48, 64";
              halign = "left";
            }
            // asText)

          ({
              text = let
                app = pkgs.writeShellApplication {
                  name = "${prefix}-load-avg";
                  runtimeInputs = with pkgs; [coreutils];
                  text = ''
                    echo -n "LOAD AVG: "
                    cat /proc/loadavg
                  '';
                };
              in "cmd[update:200] ${lib.getExe app}";

              position = "48, 24";
              halign = "left";
            }
            // asSubtext)

          ({
              text = let
                app = pkgs.writeShellApplication {
                  name = "${prefix}-time";
                  runtimeInputs = with pkgs; [coreutils];
                  text = ''
                    date +"%H:%M"
                  '';
                };
              in "cmd[update:1000] ${lib.getExe app}";

              position = "-48, 64";
              halign = "right";
            }
            // asText)

          ({
              text = let
                app = pkgs.writeShellApplication {
                  name = "${prefix}-date";
                  runtimeInputs = with pkgs; [coreutils];
                  text = ''
                    date +"%a %Y-%m-%d" |
                      tr '[:lower:]' '[:upper:]'
                  '';
                };
              in "cmd[update:1000] ${lib.getExe app}";

              position = "-48, 24";
              halign = "right";
            }
            // asSubtext)
        ];
      in
        map (item: item // defaults) labels;
    };
  };
}
