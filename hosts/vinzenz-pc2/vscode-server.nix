{pkgs, ...}: {
  services.openvscode-server = {
    enable = true;
    telemetryLevel = "off";
    port = 8542;
    host = "100.125.93.127"; # tailscale
    withoutConnectionToken = true;
    extraPackages = with pkgs; [nodejs git gh direnv];
  };

  networking = {
    firewall = {
      allowedTCPPorts = [8542 8543 8544 80];
    };
  };
}
