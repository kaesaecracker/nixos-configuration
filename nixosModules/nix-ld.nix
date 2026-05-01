{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.nixLd.enable = lib.mkEnableOption "nix-ld for running unpatched dynamic binaries";

  config = lib.mkIf config.my.nixLd.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        zstd
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd
        icu
      ];
    };
  };
}
