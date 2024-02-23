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
    jetbrains-remote-server = lib.mkEnableOption "setup jetbrais IDE installs so -remote-dev-server can be started";
    objective-c = lib.mkEnableOption "Objective-C with GNUStep";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.native
      {
        environment.systemPackages = with pkgs; [
          cmake
          gnumake
          gcc
          gdb
          llvmPackages_latest.llvm
          llvmPackages.clangUseLLVM
        ];
      })
    (lib.mkIf cfg.dotnet {
      environment = {
        systemPackages = with pkgs; [
          dotnet-sdk_8

          zlib
          zlib.dev
          openssl
          icu
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
    (lib.mkIf cfg.jetbrains-remote-server {
      environment.systemPackages = with pkgs.jetbrains; [
        jdk # required for all of them
        rider
        clion
        pycharm-professional
      ];
      my.allowUnfreePackages = [
        "rider"
        "clion"
        "pycharm-professional"
      ];
    })
    (lib.mkIf cfg.objective-c {
      environment.systemPackages =
        (with pkgs.gnustep; [
          gui
          make
          gorm
          base
          back
          system_preferences
          projectcenter
          libobjc
          gworkspace
        ])
        ++ (with pkgs; [
          clang-tools
          clang
          gnumake
        ]);
    })
  ];
}
