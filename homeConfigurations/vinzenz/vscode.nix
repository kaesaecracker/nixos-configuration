{ pkgs, lib, ... }:
{
  config = {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        enableUpdateCheck = false;
        extensions =
          with pkgs.nix-vscode-extensions.open-vsx;
          [
            # keep-sorted start
            catppuccin.catppuccin-vsc-icons
            davidanson.vscode-markdownlint
            editorconfig.editorconfig
            jnoortheen.nix-ide
            llvm-vs-code-extensions.vscode-clangd
            mkhl.direnv
            ms-python.python
            muhammad-sammy.csharp
            redhat.vscode-yaml
            rust-lang.rust-analyzer
            tamasfe.even-better-toml
            yzhang.markdown-all-in-one
            # keep-sorted end
          ]
          ++ (with pkgs.vscode-extensions; [
            vadimcn.vscode-lldb
            RoweWilsonFrederiskHolme.wikitext
            ms-dotnettools.csharp
          ]);
        userSettings = {
          "files.autoSave" = "afterDelay";
          "files.autoSaveWhenNoErrors" = true;
          "files.autoSaveWorkspaceFilesOnly" = true;

          "editor.fontLigatures" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnSaveMode" = "modificationsIfAvailable";
          "editor.minimap.autohide" = true;
          "editor.mouseWheelZoom" = true;
          "terminal.integrated.mouseWheelZoom" = true;

          "workbench.startupEditor" = "readme";
          "workbench.enableExperiments" = false;
          "workbench.iconTheme" = "catppuchin-mocha";

          "update.mode" = "none";
          "extensions.autoUpdate" = false;
          "extensions.autoCheckUpdates" = false;

          "telemetry.telemetryLevel" = "off";
          "redhat.telemetry.enabled" = false;

          "git.autofetch" = true;
          "git.path" = "${lib.getBin pkgs.git}/bin/git";
          "diffEditor.diffAlgorithm" = "advanced";
          "explorer.excludeGitIgnore" = false;
          "markdown.extension.tableFormatter.normalizeIndentation" = true;
          "markdown.extension.toc.orderedList" = false;

          "rust-analyzer.checkOnSave.command" = "clippy";

          "nix.formatterPath" = "${lib.getBin pkgs.nixfmt-tree}/bin/nixfmt-tree";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "${lib.getBin pkgs.nil}/bin/nil";
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "${lib.getBin pkgs.nixfmt-tree}/bin/nixfmt-tree" ];
              };
            };
          };

          "dotnetAcquisitionExtension.sharedExistingDotnetPath" =
            "${lib.getBin pkgs.dotnetCorePackages.sdk_9_0}/bin/dotnet";

          "\[makefile\]" = {
            "editor.insertSpaces" = false;
            "editor.detectIndentation" = false;
          };

          "\[nix\]" = {
            "editor.formatOnSave" = false;
          };

          "\[css\]" = {
            "editor.formatOnSave" = false;
          };
        };
      };
    };
  };
}
