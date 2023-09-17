{pkgs, ...}: let
  wg_port = 51820;
in {
  imports = [
    (import ./modules {
      hostName = "hetzner-vpn1";
      enableHomeManager = false;
    })
  ];

  config = {
    my = {
      enabledUsers = ["vinzenz"];
      server.enable = true;
    };

    # TODO change to user "vinzenz" when tested
    users.users.root.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdYqY3Y1/f1bsAi5Qfyr/UWuX9ixu96IeAlhoQaJkbf''
    ];

    environment = {
      systemPackages = with pkgs; [iptables wireguard-tools];
    };

    # wireguard server for public ip
    # enable NAT
    networking.nat.enable = true;
    networking.nat.externalInterface = "eth0";
    networking.nat.internalInterfaces = ["wg0"];
    networking.firewall = {
      allowedUDPPorts = [wg_port];
    };

    networking.wireguard.interfaces = {
      # "wg0" is the network interface name. You can name the interface arbitrarily.
      wg0 = {
        # Determines the IP address and subnet of the server's end of the tunnel interface.
        ips = ["10.100.0.1/32"];

        # The port that WireGuard listens to. Must be accessible by the client.
        listenPort = wg_port;

        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';

        # This undoes the above command
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';

        # Path to the private key file
        privateKeyFile = "/root/wireguard/keys/private";

        peers = [
          # List of allowed peers.
          {
            # Phone
            publicKey = "/sjNk9rXaMdrCHD2kmut1AXD1UhF1xcZ4ju+EmFGcCk=";
            # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
            allowedIPs = ["10.100.0.2/32"];
          }
          {
            # vinzenz-lpt
            publicKey = "D/6431f8oJ61C5vjjEIpY5Rc750oK4yVh9B/32q4xAE=";
            # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
            allowedIPs = ["10.100.0.3/32"];
          }
        ];
      };
    };
  };
}
