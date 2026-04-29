{ pkgs, ... }:
{
  imports = [ ../damocles/claude-container.nix ];

  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    # Path written into sshd_config as a string — not read at eval time.
    # Key can be rotated without a rebuild.
    authorizedKeysFiles = [ "/persist/damocles-ssh/id_ed25519.pub" ];
  };

  environment.systemPackages = with pkgs; [

  ];
}
