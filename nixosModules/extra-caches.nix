{ lib, config, ... }:
{
  options.my.extraCaches.enable = lib.mkEnableOption "extra Nix binary caches";

  config = lib.mkIf config.my.extraCaches.enable {
    nix.settings = {
      substituters = [
        # keep-sorted start
        "https://cache.lix.systems"
        "https://cache.nixos.org/"
        "https://niri.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
        # keep-sorted end
      ];
      trusted-public-keys = [
        # keep-sorted start
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        # keep-sorted end
      ];
    };
  };
}
