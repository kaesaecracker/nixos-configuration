modulesCfg: {
  config,
  pkgs,
  lib,
  ...
}: let
  enableHomeManager = modulesCfg.enableHomeManager;
in {
  options.my = {
    modulesCfg.enableHomeManager = lib.mkEnableOption "enable home manager";
    enabledUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };

  imports =
    [
      ./vinzenz.nix
      ./ronja.nix
    ]
    ++ lib.optionals enableHomeManager [
      <home-manager/nixos>
    ];

  config = lib.mkIf enableHomeManager {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      sharedModules = [
        # set stateVersion
        {home.stateVersion = "22.11";}
        # make nano the default editor
        {
          home = {
            sessionVariables.EDITOR = "nano";
            file.".nanorc".text = lib.mkDefault ''
              set linenumbers
              set mouse
            '';
          };
        }
        # command line niceness
        {
          programs = {
            command-not-found.enable = true;
            dircolors.enable = true;

            zsh = {
              enable = true;
              enableSyntaxHighlighting = true;
              enableAutosuggestions = true;
              enableVteIntegration = true;
            };
          };
        }
        # common git config
        {
          programs = {
            git = {
              enable = true;
              extraConfig.init.defaultBranch = "main";
            };

            gh = {
              enable = true;
              enableGitCredentialHelper = true;
            };
          };
        }
      ];
    };
  };
}
