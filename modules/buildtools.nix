{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.buildtools;
  dotnetPackage = with pkgs; (dotnetCorePackages.combinePackages [
    dotnet-sdk_8
  ]);
in {
  options.my.buildtools = {
    native = lib.mkEnableOption "include native build tools";
    dotnet = lib.mkEnableOption "include dotnet build tools";
    rust = lib.mkEnableOption "include rust build tools";
    jetbrains-remote-server = lib.mkEnableOption "setup jetbrais IDE installs so -remote-dev-server can be started";
    objective-c = lib.mkEnableOption "Objective-C with GNUStep";
    js = lib.mkEnableOption "node stuff";
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
          dotnetPackage

          zlib
          zlib.dev
          openssl
          icu
          icu.dev

          # native aot
          gcc
          libunwind
        ];
        variables = {
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        };
      };
      programs.nix-ld.libraries = with pkgs; [
        # native aot
        libunwind
        icu
        zlib
        zlib.dev
        openssl
        icu
        icu.dev
        dotnetPackage
      ];
    })
    (lib.mkIf (cfg.dotnet || config.my.desktop.enable) {
      environment = {
        systemPackages = with pkgs; [
          unstable.jetbrains.jdk
          unstable.jetbrains.rider
        ];
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
    (lib.mkIf cfg.js {
      environment.systemPackages = with pkgs; [
        nodejs
      ];
    })
  ];
}
