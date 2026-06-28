{
  hostnm,
  ...
}:
# NOTE: this will be changes to a more modular layout, for now, this is a simple default config
{
  config = {
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    networking = {
      # NOTE: If hostname is changed, be sure to match it on flake.nix and in the shell alias in
      # 	~/nix-config/modules/home/shell/zsh.nix
      networkmanager.enable = true;
      hostName = "${hostnm}"; # sets HOSTNAME

      # for dns issues i keep running into
      nameservers = [
        "8.8.8.8" # google
        "1.1.1.1" # Coudflare
      ]; # end of nameservers

      # Configure network proxy if necessary
      #proxy.default = "http://user:password@proxy:port/";
      #proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # [firewall shii]
      firewall = {
        enable = true;
        allowedTCPPorts = [ 53317 ]; # LocalSend
        allowedUDPPorts = [
          53317
          5353
        ]; # LocalSend + mDNS

        # [For KDE Connect / Phone integration Un comment if needed]
        allowedTCPPortRanges = [
          {
            from = 53317;
            to = 53320;
          }
        ]; # end of TCP port ranges

        allowedUDPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ]; # end of UDP port ranges

        # [interfaces to trust]
        trustedInterfaces = [
          "virbr0" # virtual bridge for vms
        ];
      }; # end of firewall
    }; # end of networking

    # [for the dynamic seaching that other distros use.]
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    }; # end of avahi
  }; # end of config
}
