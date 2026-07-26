let
  currentSite = "kranium.au";
in
{
  default.services.nginx.virtualHosts = {
    "${currentSite}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".root = inputs.cells.site.packages.site-generated;
    };
    "www.${currentSite}" = {
      forceSSL = true;
      enableACME = true;
      globalRedirect = currentSite;
    };
  };
}
