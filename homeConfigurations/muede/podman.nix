{
  services.podman = {
    settings = {
      policy = {
        default = [ { type = "reject"; } ];
        transports = {
          docker-daemon = {
            "" = [ { type = "insecureAcceptAnything"; } ];
          };
          docker = {
            "docker.io/library/debian" = [ { type = "insecureAcceptAnything"; } ];
            "docker.io/library/rust" = [ { type = "insecureAcceptAnything"; } ];
          };
        };
      };
    };
  };
}
