{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    <home-manager/nixos>
  ];

  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users = {
        ronja = lib.mkIf (builtins.elem "ronja" config.my.enabledUsers) (import ./ronja-home.nix);
        vinzenz = lib.mkIf (builtins.elem "vinzenz" config.my.enabledUsers) (import ./vinzenz-home.nix);
      };

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
