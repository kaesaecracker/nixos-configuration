{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.buildtools;
in {
  options.my.buildtools = {
    native = lib.mkEnableOption "include native build tools";
    dotnet = lib.mkEnableOption "include dotnet build tools";
    rust = lib.mkEnableOption "include rust build tools";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.native
      {
        environment.systemPackages = with pkgs; [
          cmake
          gnumake
          gcc
          gdb
        ];
      })
    (lib.mkIf cfg.dotnet {
      environment = {
        systemPackages = with pkgs; [
          dotnet-sdk_8
        ];
        variables = {
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        };
      };
    })
    (lib.mkIf cfg.rust {
      environment.systemPackages = with pkgs; [
        cargo
        rustc
        rustfmt
        clippy
        cargo-generate
      ];
    })
  ];
}
