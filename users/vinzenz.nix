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
      ];
      shell = pkgs.zsh;
      autoSubUidGidRange = true;
    };

    allowedUnfreePackages = [
      "vscode-extension-ms-vscode-remote-remote-ssh"
      "insync"
      "insync-pkg"

      "rider"
      "pycharm-professional"
      "jetbrains-toolbox"

      "anydesk"
    ];
  };
}
