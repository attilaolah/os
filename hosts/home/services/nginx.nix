{pkgs, ...}: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    package = pkgs.nginxQuic;

    virtualHosts."localhost" = {
      serverAliases = ["[::1]" "127.0.4.43" "home"];
      sslCertificate = "/etc/tls/tls.crt";
      sslCertificateKey = "/etc/tls/tls.key";
      forceSSL = true;
      kTLS = true;
      quic = true;

      locations."/" = {
        proxyPass = "http://[::1]:8080";
        proxyWebsockets = true;
      };
    };
  };
}
