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
    ./swaylock.nix
    ./swaync.nix
    ./vscode.nix
    ./waybar.nix
    ./wlogout.nix
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

      quickshell = {
        enable = true;
        systemd.enable = true;
        #activeConfig = "~/.config/";
      };
    };

    home.packages = with pkgs; [
      keepassxc
      nextcloud-client
      thunderbird
      fractal
      telegram-desktop

      wireguard-tools
      wirelesstools
      tailscale

      kdiff3
      jetbrains-toolbox

      vlc
      lutris

      arduino
      arduino-ide
      arduino-cli

      servicepoint-cli
      servicepoint-simulator

      icu

      foliate

      dconf2nix

      gnome-terminal
    ];

    home.file = {
      "idea.properties".text = "idea.filewatcher.executable.path = ${pkgs.fsnotifier}/bin/fsnotifier";
      ".config/quickshell" = {
        source = ./.config/quickshell;
        recursive = true;
      };
    };

    home.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    services = {
      trayscale.enable = true;
      poweralertd.enable = true;
    };
  };
}
