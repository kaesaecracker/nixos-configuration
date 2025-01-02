{ pkgs, ... }:
{
  enable = true;
  package = pkgs.vscodium;
  enableUpdateCheck = false;
  extensions = with pkgs.vscode-extensions; [
    bbenoist.nix
    ms-python.python
    kamadorueda.alejandra
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
    "diffEditor.diffAlgorithm" = "advanced";
    "explorer.excludeGitIgnore" = true;
    "markdown.extension.tableFormatter.normalizeIndentation" = true;
    "markdown.extension.toc.orderedList" = false;
    "rust-analyzer.checkOnSave.command" = "clippy";

    "\[makefile\]" = {
      "editor.insertSpaces" = false;
      "editor.detectIndentation" = false;
    };
  };
}
