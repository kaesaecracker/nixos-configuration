{ config, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      ## Apps
      telegram-desktop
      kdiff3
    ];

    programs = {
      home-manager.enable = true;

      zsh = {
        history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
          expireDuplicatesFirst = true;
        };

        oh-my-zsh = {
          enable = true;
          theme = "agnoster";
          plugins = [
            "git"
            "sudo"
            "systemadmin"
          ];
        };
        shellAliases = {
          myos-update = ''echo "Enter sudo password" && sudo nixos-rebuild boot --flake git+https://git.berlin.ccc.de/vinzenz/nixos-configuration.git --show-trace --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json'';
          myos-apply = ''echo "Enter sudo password" && sudo nixos-rebuild switch --flake .# --show-trace --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json'';
        };
      };

      git = {
        userName = "Ronja Spiegelberg";
        userEmail = "ronja.spiegelberg@gmail.com";

        extraConfig = {
          pull.ff = "only";
          merge.tool = "kdiff3";
        };
      };

      chromium = {
        enable = true;
        extensions = [
          {
            # ublock origin
            id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          }
          {
            id = "dcpihecpambacapedldabdbpakmachpb";
            updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
          }
        ];
      };
    };
  };
}
