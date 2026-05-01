{ pkgs, ... }:
{
  imports = [
    # keep-sorted start
    ./editorconfig.nix
    ./element.nix
    ./fonts.nix
    ./fuzzel.nix
    ./git.nix
    ./gnome.nix
    ./niri.nix
    ./podman.nix
    ./ssh.nix
    ./starship.nix
    ./swayidle.nix
    #./swaylock.nix
    #./swaync.nix
    ./vscode.nix
    # ./waybar.nix
    # ./wlogout.nix
    ./zsh.nix
    # keep-sorted end
  ];

  config = {
    programs = {
      home-manager.enable = true;
      fzf.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
      };

      eza = {
        enable = true;
        git = true;
        icons = "auto";
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
      };

      pay-respects = {
        enable = true;
        enableZshIntegration = true;
      };

      chromium.enable = true;
      nova-shell = {
        enable = true;
        theme = {
          fontSize = 14;
        };
        #modules.backgroundOverlay.enable = false;
        #modules.screenCorners.enable = false;
      };
    };

    home.packages = with pkgs; [
      # keep-sorted start
      arduino
      arduino-cli
      arduino-ide
      claude-code
      dconf2nix
      foliate
      fractal
      geary
      gnome-terminal
      gparted
      icu
      jetbrains-toolbox
      kdiff3
      keepassxc
      lutris
      nextcloud-client
      onefetch
      servicepoint-cli
      servicepoint-simulator
      tailscale
      telegram-desktop
      thunderbird
      vlc
      wireguard-tools
      wirelesstools
      # keep-sorted end
    ];

    home.file = {
      "idea.properties".text = "idea.filewatcher.executable.path = ${pkgs.fsnotifier}/bin/fsnotifier";
    };

    services = {
      trayscale.enable = true;
      poweralertd.enable = true;
    };
  };
}
