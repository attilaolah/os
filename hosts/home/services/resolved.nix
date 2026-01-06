{
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    # Point to Google + Cloudflare with the hostname for certificate verification.
    extraConfig = ''
      DNS=8.8.8.8#dns.google 8.8.4.4#dns.google
      FallbackDNS=1.1.1.1#one.one.one.one 1.0.0.1#one.one.one.one
    '';
  };
}
