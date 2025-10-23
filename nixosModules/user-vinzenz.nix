{ pkgs, ... }:
{
  users.users.vinzenz = {
    isNormalUser = true;
    name = "vinzenz";
    description = "müde";
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

  allowedUnfreePackages = [
    "rider"
    "pycharm-professional"
    "jetbrains-toolbox"

    "anydesk"

    "vscode-extension-ms-dotnettools-csharp"
  ];
}
