# nixos-configuration

Personal NixOS configuration for all machines. Devices are declared in `devices.nix`, per-device configs live in `nixosConfigurations/<name>/`, and shared modules in `nixosModules/`.

## Distributed builds

Machines are configured to act as build servers / binary caches for each other in devices.nix.

### Onboarding a device as a build client

1. Generate a key pair on the device:

   ```sh
   sudo ssh-keygen -t ed25519 -f /etc/nix/distributed-build-key -N "" -C "$(hostname)-nix-builds" && sudo cat /etc/nix/distributed-build-key.pub
   ```

2. Add the public key to the device entry in `devices.nix`:

   ```nix
   distributedBuilds.clientPublicKey = "ssh-ed25519 AAAA... <hostname>-nix-builds";
   ```

3. Rebuild all build machines so they pick up the new authorized key.

### Adding a build server

1. Add to its entry in `devices.nix`:

   ```nix
   distributedBuilds.isBuilder = true;
   distributedBuilds.hostPublicKey = "ssh-ed25519 AAAA..."; # from: ssh-keyscan -t ed25519 "$(hostname)"
   ```

2. Generate a store signing key on the builder:

   ```sh
   sudo nix key generate-secret --key-name "$(hostname)" | sudo tee /etc/nix/signing-key.sec | sudo nix key convert-secret-to-public
   ```

3. Add the printed public key to `devices.nix`:

   ```nix
   distributedBuilds.storeSigningPublicKey = "<hostname>:<base64...>";
   ```

4. Rebuild all machines so they trust the new signing key.
