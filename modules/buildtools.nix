{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.buildtools;
  isDesktop = config.my.desktop.enable;
  dotnetPackage = with pkgs.unstable; (dotnetCorePackages.combinePackages [
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
    android = lib.mkEnableOption "android development";
    python = lib.mkEnableOption "generic python 3";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.native {
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

    (lib.mkIf cfg.js {
      environment.systemPackages = with pkgs; [
        nodejs
      ];
    })

    (lib.mkIf cfg.rust {
      environment.systemPackages = with pkgs; [
        rustup
        musl
      ];
    })

    (lib.mkIf cfg.jetbrains-remote-server {
      my.buildtools.dotnet = true;
      my.buildtools.native = true;
      my.buildtools.python = true;
    })

    (lib.mkIf cfg.objective-c {
      my.buildtools.native = true;
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
        ]);
    })

    (lib.mkIf cfg.android {
      environment.systemPackages = with pkgs; [
        android-tools
        android-udev-rules
      ];
    })

    (lib.mkIf cfg.python {
      environment.systemPackages = with pkgs; [python3 python3Packages.pip];
    })
  ];
}
