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
    {
      home-manager = {
        extraSpecialArgs = specialArgs;
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      time.timeZone = "Europe/Berlin";

      home-manager.sharedModules = [
        { home.stateVersion = "22.11"; }
        # keep-sorted start
        self.homeModules.git
        self.homeModules.gnome-extensions
        self.homeModules.nano
        self.homeModules.templates
        self.homeModules.zsh-basics
        self.homeModules.zsh-powerlevel10k
        # keep-sorted end
      ];

      home-manager.users = home-manager-users;
    }

    # keep-sorted start
    home-manager.nixosModules.home-manager
    self.nixosModules.en-de
    self.nixosModules.firmware-updates
    self.nixosModules.gnome
    self.nixosModules.kdeconnect
    self.nixosModules.modern-desktop
    self.nixosModules.niri
    self.nixosModules.nix-ld
    self.nixosModules.pkgs-unstable
    self.nixosModules.pkgs-vscode-extensions
    self.nixosModules.quiet-boot
    self.nixosModules.stylix
    servicepoint-cli.nixosModules.default
    servicepoint-simulator.nixosModules.default
    servicepoint-tanks.nixosModules.default
    stylix.nixosModules.stylix
    # keep-sorted end
  ];
}
