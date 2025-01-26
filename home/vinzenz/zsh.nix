{ config, ... }:
{
  initExtra = ''
    eval "$(direnv hook zsh)";
    export PATH=$PATH:/home/vinzenz/.cargo/bin
  '';

  enableCompletion = true;

  shellAliases = {
    my-apply = "sudo nixos-rebuild boot --flake";
    my-switch = "sudo nixos-rebuild switch --flake";
    my-update = "sudo nixos-rebuild boot --upgrade --flake";
    my-pull = "git -C ~/Repos/nixos-configuration pull --rebase"; 
    my-test = "sudo nixos-rebuild test";
    my-direnvallow = "echo \"use nix\" > .envrc && direnv allow";
    my-ip4 = "ip addr show | grep 192";
    deadnix = "nix run github:astro/deadnix -- ";
    statix = "nix run git+https://git.peppe.rs/languages/statix -- ";
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
