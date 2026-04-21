{
  home-manager-users,
  self,
  home-manager,
  servicepoint-cli,
  servicepoint-simulator,
  servicepoint-tanks,
  stylix,
  specialArgs,
  ...
}:
{
  imports = [
    # keep-sorted start
    home-manager.nixosModules.home-manager
    self.nixosModules.en-de
    self.nixosModules.firmware-updates
    self.nixosModules.gnome
    self.nixosModules.kdeconnect
    self.nixosModules.modern-desktop
    self.nixosModules.niri
    self.nixosModules.nix-ld
    self.nixosModules.pkgs-vscode-extensions
    self.nixosModules.quiet-boot
    self.nixosModules.stylix
    servicepoint-cli.nixosModules.default
    servicepoint-simulator.nixosModules.default
    servicepoint-tanks.nixosModules.default
    stylix.nixosModules.stylix
    # keep-sorted end
  ];

  config = {
    home-manager = {
      extraSpecialArgs = specialArgs;
      useGlobalPkgs = true;
      useUserPackages = true;
      users = home-manager-users;
      sharedModules = [
        { home.stateVersion = "22.11"; }
        # keep-sorted start
        self.homeModules.git
        self.homeModules.gnome-extensions
        self.homeModules.nano
        self.homeModules.templates
        self.homeModules.zsh-basics
        # keep-sorted end
      ];
    };

    time.timeZone = "Europe/Berlin";

    # on desktops, keep the device useable interactively during expensive builds
    nix = {
      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";
    };
  };
}
