{ lib, ... }:
{
  config.programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      add_newline = true;
      format =
        "[](fg:color_r)[$username $os $hostname ($container )](bg:color_r fg:text_r)[ ](fg:color_r bg:color_g)"
        + "[$directory ](bg:color_g fg:text_g)[ ](fg:color_g bg:color_b)"
        + "([(\\[$git_state$git_branch$git_commit$git_status\\] )"
        + "$all](bg:color_b fg:text_b))[](fg:color_b bg:color_y)"
        + "([ $cmd_duration$status](bg:color_y fg:text_y))[](fg:color_y)"
        + "$line_break$character ";

      # TODO: replace with base16 theme
      palette = lib.mkForce "color_me_surprised";
      palettes.color_me_surprised = {
        "color_r" = "#a30262";
        "color_g" = "#d162a4";
        "color_b" = "#5BCEFA";
        "color_y" = "#4a6bb1";
        "text_r" = "white";
        "text_g" = "black";
        "text_b" = "black";
        "text_y" = "white";
      };

      username = {
        format = "[$user]($style)";
        style_user = "bg:color_r fg:text_r";
        style_root = "bold bg:color_r fg:text_r";
        show_always = true;
      };
      os = {
        disabled = false;
        format = "$symbol";
      };
      hostname = {
        disabled = false;
        ssh_only = false;
        format = "$hostname";
        ssh_symbol = "";
        aliases = {
          "muede-lpt2" = "lpt";
          "muede-pc2" = "pc";
        };
      };
      container = {
        format = "[$symbol$name]";
      };
      directory = {
        format = "$path[( $read_only)]($read_only_style)";
        truncate_to_repo = true;
        truncation_symbol = "…/";
        read_only = "󰌾";
        read_only_style = "fg:color_r bg:green";
        home_symbol = "";
        substitutions = {
          "Documents" = "󰈙";
          "Downloads" = "";
          "Music" = "󰝚";
          "Pictures" = "";
          "Developer" = "󰲋";
        };
      };

      git_state = {
        style = "fg:text_b bg:color_b";
      };
      git_branch = {
        style = "fg:text_b bg:color_b";
        format = "[$symbol $branch(:$remote_branch) ]($style)";
        symbol = "";
      };
      git_commit = {
        format = "[$hash$tag ]($style)";
        style = "fg:text_b bg:color_b";
        tag_symbol = "";
      };
      git_status = {
        format = "[$all_status$ahead_behind]($style)";
        style = "fg:text_b bg:color_b";
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
      };

      package = {
        symbol = "󰏗";
        format = "$symbol$version ";
        version_format = "\${raw}";
      };
      rust = {
        symbol = "󱘗";
        format = "$symbol$version ";
        version_format = "$major.$minor";
      };
      nix_shell = {
        symbol = "";
        format = "$symbol( ($name))";
      };

      status = {
        disabled = false;
        format = "[$symbol$status_common_meaning$status_signal_name$status_maybe_int]($style)";
        map_symbol = true;
        pipestatus = true;
        style = "bg:color_y fg:text_y";
      };
      cmd_duration = {
        format = "󱦟 $duration ";
      };

      character = {
        success_symbol = "[](bold)";
        error_symbol = "[✗](bold fg:color_r)";
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
      perl.symbol = "";
      php.symbol = "";
      pijul_channel.symbol = "";
      pixi.symbol = "󰏗";
      python.symbol = "";
      rlang.symbol = "󰟔";
      ruby.symbol = "";
      scala.symbol = "";
      swift.symbol = "";
      zig.symbol = "";
      gradle.symbol = "";
    };
  };
}
