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
    mhutchie.git-graph
    rust-lang.rust-analyzer
    tamasfe.even-better-toml
    llvm-vs-code-extensions.vscode-clangd
    mkhl.direnv
    vadimcn.vscode-lldb
    ms-dotnettools.csharp
    ms-vscode-remote.remote-ssh
  ];
  userSettings = {
    "git.autofetch" = true;
    "update.mode" = "none";
    "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', 'monospace', monospace";
    "editor.fontLigatures" = true;
    "editor.formatOnSave" = true;
    "editor.formatOnSaveMode" = "modificationsIfAvailable";
    "editor.minimap.autohide" = true;
    "diffEditor.diffAlgorithm" = "advanced";
    "explorer.excludeGitIgnore" = true;
    "markdown.extension.tableFormatter.normalizeIndentation" = true;
    "markdown.extension.toc.orderedList" = false;
    "telemetry.telemetryLevel" = "off";
    "redhat.telemetry.enabled" = false;
    "workbench.startupEditor" = "readme";
    "workbench.enableExperiments" = false;
    "workbench.iconTheme" = "material-icon-theme";
    "rust-analyzer.checkOnSave.command" = "clippy";
    "extensions.autoUpdate" = false;
    "extensions.autoCheckUpdates" = false;
    "\[makefile\]" = {
      "editor.insertSpaces" = false;
      "editor.detectIndentation" = false;
    };
  };
}
