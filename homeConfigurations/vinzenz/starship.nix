{ ... }:
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

      palette = "color_me_surprised";
      palettes.color_me_surprised = {
        "color_r" = "#a30262";
        "color_g" = "#d162a4";
        "color_b" = "#5BCEFA";
        "color_y" = "white";
        "text_r" = "white";
        "text_g" = "black";
        "text_b" = "black";
        "text_y" = "black";
      };

      username = {
        format = "[$user]($style)";
        style_user = "bg:color_r fg:text_r";
        style_root = "bold bg:color_r fg:text_r";
        show_always = true;
        aliases = {
          "vinzenz" = "müde";
        };
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
          "vinzenz-lpt2" = "lpt";
          "vinzenz-pc2" = "pc";
        };
      };
      container = {
        format = "\[$symbol$name\]";
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
        version_format = "$\{raw\}";
      };
      rust = {
        symbol = "󱘗";
        format = "$symbol$version ";
        version_format = "$major.$minor";
      };
      nix_shell = {
        symbol = "";
        format = "$symbol( \($name\))";
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

      palettes = {
        catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
        catppuccin_frappe = {
          rosewater = "#f2d5cf";
          flamingo = "#eebebe";
          pink = "#f4b8e4";
          mauve = "#ca9ee6";
          red = "#e78284";
          maroon = "#ea999c";
          peach = "#ef9f76";
          yellow = "#e5c890";
          green = "#a6d189";
          teal = "#81c8be";
          sky = "#99d1db";
          sapphire = "#85c1dc";
          blue = "#8caaee";
          lavender = "#babbf1";
          text = "#c6d0f5";
          subtext1 = "#b5bfe2";
          subtext0 = "#a5adce";
          overlay2 = "#949cbb";
          overlay1 = "#838ba7";
          overlay0 = "#737994";
          surface2 = "#626880";
          surface1 = "#51576d";
          surface0 = "#414559";
          base = "#303446";
          mantle = "#292c3c";
          crust = "#232634";
        };
        catppuccin_latte = {
          rosewater = "#dc8a78";
          flamingo = "#dd7878";
          pink = "#ea76cb";
          mauve = "#8839ef";
          red = "#d20f39";
          maroon = "#e64553";
          peach = "#fe640b";
          yellow = "#df8e1d";
          green = "#40a02b";
          teal = "#179299";
          sky = "#04a5e5";
          sapphire = "#209fb5";
          blue = "#1e66f5";
          lavender = "#7287fd";
          text = "#4c4f69";
          subtext1 = "#5c5f77";
          subtext0 = "#6c6f85";
          overlay2 = "#7c7f93";
          overlay1 = "#8c8fa1";
          overlay0 = "#9ca0b0";
          surface2 = "#acb0be";
          surface1 = "#bcc0cc";
          surface0 = "#ccd0da";
          base = "#eff1f5";
          mantle = "#e6e9ef";
          crust = "#dce0e8";
        };
        catppuccin_macchiato = {
          rosewater = "#f4dbd6";
          flamingo = "#f0c6c6";
          pink = "#f5bde6";
          mauve = "#c6a0f6";
          red = "#ed8796";
          maroon = "#ee99a0";
          peach = "#f5a97f";
          yellow = "#eed49f";
          green = "#a6da95";
          teal = "#8bd5ca";
          sky = "#91d7e3";
          sapphire = "#7dc4e4";
          blue = "#8aadf4";
          lavender = "#b7bdf8";
          text = "#cad3f5";
          subtext1 = "#b8c0e0";
          subtext0 = "#a5adcb";
          overlay2 = "#939ab7";
          overlay1 = "#8087a2";
          overlay0 = "#6e738d";
          surface2 = "#5b6078";
          surface1 = "#494d64";
          surface0 = "#363a4f";
          base = "#24273a";
          mantle = "#1e2030";
          crust = "#181926";
        };
      };
    };
  };
}
