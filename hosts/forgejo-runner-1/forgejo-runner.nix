{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      forgejo-runner
    ];

    # https://wiki.nixos.org/wiki/Forgejo

    services.gitea-actions-runner = {
      package = pkgs.forgejo-actions-runner;
      instances.default = {
        enable = true;
        name = "cccb";
        url = "https://git.berlin.ccc.de";
        # Obtaining the path to the runner token file may differ
        # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
        tokenFile = "/etc/forgejo-runner/registration_token";
        labels = [
          "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:rust-24.04"
          "ubuntu-24.04:docker://ghcr.io/catthehacker/ubuntu:rust-24.04"
        ];
        settings = {
          container.network = "bridge";
        };
      };
    };
  };
}
