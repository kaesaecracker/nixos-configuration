{
  config,
  pkgs,
  ...
}: {
  # override insync build version
  nixpkgs.config.packageOverrides = pkgs: {
    my = import (builtins.fetchTarball https://github.com/kaesaecracker/nixpkgs/archive/db254c650b7f5b6657c6579afba1568f7f997195.tar.gz) {
      config = config.nixpkgs.config;
    };
  };

  # Define user account
  users.users.vinzenz = {
    isNormalUser = true;
    description = "Vinzenz Schroeter";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBAPIkGWVEt4..." ];
  };

  # home manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.vinzenz = {
    config,
    pkgs,
    ...
  }: {
    #imports = [ "${builtins.fetchTarball https://github.com/schuelermine/xhmm/archive/1608fa757cbd8fb4f11435a50610e44de3fc2223.tar.gz}/console/nano.nix" ];

    home = {
      username = "vinzenz";
      homeDirectory = "/home/vinzenz";
      stateVersion = "22.11";
      #editor = "nano";

      sessionVariables = {
        EDITOR = "nano";
      };

      packages = with pkgs; [
        firefox
        htop
        btop
        iotop
        radeontop
        powerline
        powerline-fonts
        thefuck
        keepassxc
        steam
        wine-staging
        nix-zsh-completions
        tldr
        my.insync-v3
        jetbrains.rider
        alejandra
        # gnome-secrets
        amberol
        dotnet-sdk_7
        # gnome workbench
        tdesktop
        lutris
      ];

      file.".nanorc".text = ''
        set linenumbers
        set mouse
      '';
    };

    services = {
      kdeconnect = {
        enable = true;
        indicator = true;
      };
    };

    programs = {
      home-manager.enable = true;
      zsh = {
        enable = true;
        shellAliases = {
          my-update = "sudo nixos-rebuild switch";
          my-config = "sudo nano /etc/nixos/configuration.nix";
          my-fmt = "sudo alejandra /etc/nixos/configuration.nix";
        };
        history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
        };
        oh-my-zsh = {
          enable = true;
          theme = "agnoster";
          plugins = ["git" "sudo" "docker" "systemadmin" "thefuck" "nix-zsh-completions"];
        };
      };

      git = {
        enable = true;
        userName = "Vinzenz Schroeter";
        userEmail = "vinzenz.f.s@gmail.com";

        #package = pkgs.gitFull;
        #config.credential.helper = "libsecret";

        aliases = {
          prettylog = "log --pretty=oneline --graph";
        };
        extraConfig = {
          pull = {
            ff = "only";
          };
          init = {
            defaultBranch = "main";
          };
        };
      };

      vscode = {
        enable = true;
        package = pkgs.vscodium;
        enableUpdateCheck = false;
        extensions = [pkgs.vscode-extensions.bbenoist.nix];
        userSettings = {
          "files.insertFinalNewline" = true;
          "[nix]" = {
            "editor.tabSize" = 2;
          };
        };
      };
    };
  };
}
