{
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      DNSOverTLS = "true";
      # Cloudflare DNS with the hostname for certificate verification.
      FallbackDNS = [
        "1.0.0.1#one.one.one.one"
        "1.1.1.1#one.one.one.one"
      ];
    };
  };
}
