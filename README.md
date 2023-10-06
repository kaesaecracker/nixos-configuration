# nixos-configuration

```
/
├── modules
│  ├── desktop
│  ├── hardware (includes hostname.nix)
│  └── users
└── hostname.nix (imports modules)
```

When adding a new host: `ln -s ./new-devicename.nix /etc/nixos/configuration.nix`

Use `sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager` to add home manager support.

