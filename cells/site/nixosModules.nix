let
  currentSite = "kranium.au";
  legacySite = "gikos.net";
in
{
  default.services.nginx.virtualHosts = {
    "${currentSite}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".root = inputs.cells.site.packages.site-generated;
    };
    "${legacySite}" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        # keep the old posts available but dont redirect
        "/posts" = {
          root = inputs.cells.site.packages.site-generated;
          extraConfig = ''
            try_files $uri $uri/ =404;
          '';
        };
        "/" = {
          extraConfig = ''
            return 301 https://${currentSite}$request_uri;
          '';
        };
      };
    };
    "www.${legacySite}" = {
      forceSSL = true;
      enableACME = true;
      globalRedirect = "https://${currentSite}";
    };
  };
}
