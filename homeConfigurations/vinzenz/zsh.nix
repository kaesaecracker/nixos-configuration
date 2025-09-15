{ config, pkgs, ... }:
{
  config.programs.zsh = {
    initContent = ''
      # eval "$(direnv hook zsh)";
      export PATH=$PATH:/home/vinzenz/.cargo/bin

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      source ${./.zsh/p10k.zsh}
    '';
    enableCompletion = true;

    shellAliases = {
      myos-rebuild-boot = "sudo nixos-rebuild boot --flake .# --show-trace --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json";
      myos-rebuild-switch = "sudo nixos-rebuild switch --flake .# --show-trace --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json";

      s = "nix-shell -p";

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
        "systemadmin"
        "battery"
        "dotnet"
        "rust"
        "tailscale"
      ];
    };
  };
}
