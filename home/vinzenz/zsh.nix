{ config, ... }:
{
  initExtra = ''
    eval "$(direnv hook zsh)";
    export PATH=$PATH:/home/vinzenz/.cargo/bin
  '';

  shellAliases = {
    my-apply = "sudo nixos-rebuild boot";
    my-switch = "sudo nixos-rebuild switch";
    my-update = "sudo nixos-rebuild boot --upgrade";
    my-pull = "git -C ~/Repos/nixos-configuration pull --rebase";
    my-fmt = "alejandra .";
    my-test = "sudo nixos-rebuild test";
    my-direnvallow = "echo \"use nix\" > .envrc && direnv allow";
    my-ip4 = "ip addr show | grep 192";
  };

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
      "docker"
      "systemadmin"
    ];
  };
}
