{ ... }:
{
  config.programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      add_newline = true;
      format =
        "[](fg:color_a)[$username ](bg:color_a fg:text_a)[ ](fg:color_a bg:color_b)"
        + "[$os $hostname ($container )](bg:color_b fg:text_b)[ ](fg:color_b bg:color_c)"
        + "[$directory ](bg:color_c fg:text_c)[ ](fg:color_c bg:color_d)"
        + "([$all ](bg:color_d fg:text_d))"
        + "[ ](fg:color_d)"
        + "$cmd_duration"
        + "$line_break$character$status > ";

      palette = "color_me_surprised";
      palettes.color_me_surprised = {
        "color_a" = "red";
        "color_b" = "yellow";
        "color_c" = "green";
        "color_d" = "blue";
        "text" = "white";
        "text_a" = "white";
        "text_b" = "black";
        "text_c" = "black";
        "text_d" = "white";
      };

      character = {
        success_symbol = "[](bold fg:green)";
        error_symbol = "[✗](bold fg:color_a)";
      };
      directory = {
        format = "$path[$read_only]($read_only_style)";
        truncate_to_repo = true;
        truncation_symbol = ".../";
        read_only = "󰌾";
        read_only_style = "fg:color_a bg:green";
        home_symbol = "";
        substitutions = {
          "Documents" = "󰈙";
          "Downloads" = "";
          "Music" = "󰝚";
          "Pictures" = "";
          "Developer" = "󰲋";
        };
      };
      hostname = {
        disabled = false;
        ssh_only = false;
        format = "$hostname";
        ssh_symbol = "";
      };
      username = {
        format = "$user";
        show_always = true;
      };
      git_status = {
        ahead = "⇡$count";
        behind = "⇣$count";
        deleted = "x";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
      };
      status = {
        disabled = false;
        format = "[$symbol$status_common_meaning$status_signal_name$status_maybe_int]($style)";
        map_symbol = true;
        pipestatus = true;
        symbol = "🔴";
      };
      os = {
        disabled = false;
        format = "$symbol";
      };
      cmd_duration = {
        format = "[󱦟 $duration]($style)";
      };

      # icons
      c.symbol = "";
      aws.symbol = " ";
      buf.symbol = "";
      bun.symbol = "";
      cpp.symbol = "";
      cmake.symbol = "";
      conda.symbol = "";
      crystal.symbol = "";
      dart.symbol = "";
      deno.symbol = "";
      docker_context.symbol = "";
      elixir.symbol = "";
      elm.symbol = "";
      fennel.symbol = "";
      fossil_branch.symbol = "";
      gcloud.symbol = " ";
      git_branch.symbol = "";
      git_commit.tag_symbol = " ";
      golang.symbol = "";
      guix_shell.symbol = "";
      haskell.symbol = "";
      haxe.symbol = "";
      hg_branch.symbol = "";
      java.symbol = "";
      julia.symbol = "";
      kotlin.symbol = "";
      lua.symbol = "";
      memory_usage.symbol = "󰍛";
      meson.symbol = "󰔷";
      nim.symbol = "󰆥";
      nix_shell.symbol = "";
      nodejs.symbol = "";
      ocaml.symbol = "";
      os.symbols = {
        Alpaquita = "";
        Alpine = "";
        AlmaLinux = "";
        Amazon = "";
        Android = "";
        Arch = "";
        Artix = "";
        CachyOS = "";
        CentOS = "";
        Debian = "";
        DragonFly = "";
        Emscripten = "";
        EndeavourOS = "";
        Fedora = "";
        FreeBSD = "";
        Garuda = "󰛓";
        Gentoo = "";
        HardenedBSD = "󰞌";
        Illumos = "󰈸";
        Kali = "";
        Linux = "";
        Mabox = "";
        Macos = "";
        Manjaro = "";
        Mariner = "";
        MidnightBSD = "";
        Mint = "";
        NetBSD = "";
        NixOS = "";
        Nobara = "";
        OpenBSD = "󰈺";
        openSUSE = "";
        OracleLinux = "󰌷";
        Pop = "";
        Raspbian = "";
        Redhat = "";
        RedHatEnterprise = "";
        RockyLinux = "";
        Redox = "󰀘";
        Solus = "󰠳";
        SUSE = "";
        Ubuntu = "";
        Unknown = "";
        Void = "";
        Windows = "󰍲";
      };
      package.symbol = "󰏗";
      perl.symbol = "";
      php.symbol = "";
      pijul_channel.symbol = "";
      pixi.symbol = "󰏗";
      python.symbol = "";
      rlang.symbol = "󰟔";
      ruby.symbol = "";
      rust.symbol = "󱘗";
      scala.symbol = "";
      swift.symbol = "";
      zig.symbol = "";
      gradle.symbol = "";

    };
  };
}
