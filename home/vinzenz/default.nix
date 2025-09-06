{ pkgs, ... }:
{
  config = {
    users.users.vinzenz = {
      isNormalUser = true;
      name = "vinzenz";
      description = "Vinzenz";
      home = "/home/vinzenz";
      extraGroups = [
        "networkmanager"
        "wheel"
        "games"
        "dialout"
        "podman"
        "nginx"
        "adbusers"
        "kvm"
        "input"
        "video"
      ];
      shell = pkgs.zsh;
      autoSubUidGidRange = true;
    };

    nix.settings.trusted-users = [ "vinzenz" ];

    home-manager.users.vinzenz.imports = [
      ./configuration.nix
      ./editorconfig.nix
      ./fuzzel.nix
      ./git.nix
      ./gnome.nix
      #./niri.nix
      ./ssh.nix
      ./swaylock.nix
      ./vscode.nix
      ./waybar.nix
      ./zsh.nix
    ];

    allowedUnfreePackages = [
      "insync"
      "insync-pkg"

      "rider"
      "pycharm-professional"
      "jetbrains-toolbox"

      "anydesk"

      "vscode-extension-ms-dotnettools-csharp"
    ];
  };
}
