{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.my.desktop.ronja;
in {
  options.my.desktop.ronja = {
    enable = lib.mkEnableOption "user ronja";
  };

  config = lib.mkIf cfg.enable {
    # Define user account
    users.users.ronja = {
      isNormalUser = true;
      description = "Ronja Spiegelberg";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
    };

    # home manager
    home-manager.users.ronja = {
      config,
      pkgs,
      ...
    }: {
      home = {
        username = "ronja";
        homeDirectory = "/home/ronja";
        stateVersion = "22.11";

        sessionVariables = {
          EDITOR = "nano";
        };

        packages = with pkgs; [
          ## Apps
          steam
          telegram-desktop
          powerline
          powerline-fonts
          lutris
          kdiff3
          wineWowPackages.stagingFull
          wineWowPackages.fonts
          winetricks

          (lutris.override {
            extraPkgs = pkgs: [
              # List package dependencies here
            ];
            extraLibraries = pkgs: [
              # List library dependencies here
            ];
          })
        ];

        file.".nanorc".text = ''
          set linenumbers
          set mouse
        '';
      };

      programs = {
        home-manager.enable = true;

        firefox.enable = true;
        command-not-found.enable = true;
        dircolors.enable = true;
        htop.enable = true;

        zsh = {
          enable = true;

          enableSyntaxHighlighting = true;
          enableAutosuggestions = true;
          enableVteIntegration = true;

          history = {
            size = 10000;
            path = "${config.xdg.dataHome}/zsh/history";
            expireDuplicatesFirst = true;
          };

          oh-my-zsh = {
            enable = true;
            theme = "agnoster";
            plugins = ["git" "sudo" "systemadmin"];
          };
        };

        git = {
          enable = true;
          userName = "Ronja Spiegelberg";
          userEmail = "ronja.spiegelberg@gmail.com";

          extraConfig = {
            pull.ff = "only";
            init.defaultBranch = "main";
            merge.tool = "kdiff3";
          };
        };

        gh = {
          enable = true;
          enableGitCredentialHelper = true;
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
  };
}
