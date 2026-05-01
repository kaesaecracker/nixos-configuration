{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.users.muede.enable = lib.mkEnableOption "muede user account";

  config = lib.mkIf config.my.users.muede.enable {
    users.users.muede = {
      isNormalUser = true;
      uid = 1000;
      name = "muede";
      description = "müde";
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

    nix.settings.trusted-users = [ "muede" ];

    allowedUnfreePackages = [
      "rider"
      "pycharm-professional"
      "jetbrains-toolbox"

      "anydesk"

      "vscode-extension-ms-dotnettools-csharp"

      "claude-code"
    ];
  };
}
