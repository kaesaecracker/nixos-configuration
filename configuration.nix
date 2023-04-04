# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # enable home manager
    <home-manager/nixos>
  ];

  nixpkgs.config = {
    # override insync build version
    packageOverrides = pkgs: {
      my = import (builtins.fetchTarball https://github.com/kaesaecracker/nixpkgs/archive/db254c650b7f5b6657c6579afba1568f7f997195.tar.gz) {
        config = config.nixpkgs.config;
      };
    };

    allowUnfree = true;
  };

  boot = {
    # supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  networking = {
    hostName = "vinzenz-lpt";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  services = {
    xserver = {
      # Enable the X11 windowing system / wayland depending on DE
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      layout = "de";
      xkbVariant = "";

      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      permitRootLogin = "no";
    };

    gnome = {
      tracker-miners.enable = false;
      tracker.enable = false;
    };
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "22.11"; # Did you read the comment?

    # enable auto updates
    autoUpgrade.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "00:30";
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  environment = {
    # List packages installed in system profile.
    systemPackages = with pkgs; [
      #  The Nano editor is also installed by default
    ];

    # remove gnome default apps
    gnome.excludePackages = with pkgs.gnome; [
      cheese # photo booth
      epiphany # web browser
      evince # document viewer
      geary # email client
      seahorse # password manager
      gnome-clocks
      gnome-maps
      gnome-weather
      gnome-music
      pkgs.gnome-connections
    ];
  };

  # Define user account
  users.users.vinzenz = {
    isNormalUser = true;
    description = "Vinzenz Schroeter";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBAPIkGWVEt4..." ];
  };

  # home manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.vinzenz = {
    config,
    pkgs,
    ...
  }: {
    #imports = [ "${builtins.fetchTarball https://github.com/schuelermine/xhmm/archive/1608fa757cbd8fb4f11435a50610e44de3fc2223.tar.gz}/console/nano.nix" ];

    home = {
      username = "vinzenz";
      homeDirectory = "/home/vinzenz";
      stateVersion = "22.11";
      #editor = "nano";

      sessionVariables = {
        EDITOR = "nano";
      };

      packages = with pkgs; [
        firefox
        htop
        btop
        iotop
        radeontop
        powerline
        powerline-fonts
        thefuck
        keepassxc
        steam
        wine-staging
        nix-zsh-completions
        tldr
        my.insync-v3
        jetbrains.rider
        alejandra
        gnome-secrets
        amberol
        dotnet-sdk_7
        # gnome workbench
        tdesktop
        lutris
      ];

      file.".nanorc".text = ''
        set linenumbers
        set mouse
      '';
    };

    services = {
      kdeconnect = {
        enable = true;
        indicator = true;
      };
    };

    programs = {
      home-manager.enable = true;
      zsh = {
        enable = true;
        shellAliases = {
          my-update = "sudo nixos-rebuild switch";
          my-config = "sudo nano /etc/nixos/configuration.nix";
          my-fmt = "sudo alejandra /etc/nixos/configuration.nix";
        };
        history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
        };
        oh-my-zsh = {
          enable = true;
          theme = "agnoster";
          plugins = ["git" "sudo" "docker" "systemadmin" "thefuck" "nix-zsh-completions"];
        };
      };

      git = {
        enable = true;
        userName = "Vinzenz Schroeter";
        userEmail = "vinzenz.f.s@gmail.com";

        #package = pkgs.gitFull;
        #config.credential.helper = "libsecret";

        aliases = {
          prettylog = "log --pretty=oneline --graph";
        };
        extraConfig = {
          pull = {
            ff = "only";
          };
          init = {
            defaultBranch = "main";
          };
        };
      };

      vscode = {
        enable = true;
        package = pkgs.vscodium;
        enableUpdateCheck = false;
        extensions = [pkgs.vscode-extensions.bbenoist.nix];
      };
    };
  };
}
