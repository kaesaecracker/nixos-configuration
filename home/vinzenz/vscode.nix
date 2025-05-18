{ pkgs, lib, ... }:
{
  config = {
    home.sessionVariables.NIXOS_OZONE_WL = "1";
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        ms-python.python
        editorconfig.editorconfig
        yzhang.markdown-all-in-one
        redhat.vscode-yaml
        pkief.material-icon-theme
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        vadimcn.vscode-lldb
        ms-dotnettools.csharp
        ms-vscode-remote.remote-ssh
        RoweWilsonFrederiskHolme.wikitext
        davidanson.vscode-markdownlint
      ];
      userSettings = {
        "files.autoSave" = "afterDelay";
        "files.autoSaveWhenNoErrors" = true;
        "files.autoSaveWorkspaceFilesOnly" = true;

        "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnSaveMode" = "modificationsIfAvailable";
        "editor.minimap.autohide" = true;

        "workbench.startupEditor" = "readme";
        "workbench.enableExperiments" = false;
        "workbench.iconTheme" = "material-icon-theme";

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

        "nix.formatterPath" = "${lib.getBin pkgs.nixfmt-rfc-style}/bin/nixfmt";

        "\[makefile\]" = {
          "editor.insertSpaces" = false;
          "editor.detectIndentation" = false;
        };

        "\[nix\]" = {
          "editor.formatOnSave" = false;
        };
      };
    };
  };
}
