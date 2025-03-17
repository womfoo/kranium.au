let
  inherit (inputs.nixpkgs)
    haskellPackages
    stdenv
    glibcLocales
    buildPlatform
    lib
    ;
  siteSrc = (inputs.self + /src);
in
rec {
  site = haskellPackages.callCabal2nix "site" siteSrc { }; # works
  site-shell = haskellPackages.shellFor {
    buildInputs = with haskellPackages; [
      fourmolu
      cabal-install
    ];
    packages = ps: [ site ];
  };
  site-generated = stdenv.mkDerivation {
    name = "html";
    src = siteSrc;

    LANG = "en_US.UTF-8";
    LOCALE_ARCHIVE = lib.optionalString (
      buildPlatform.libc == "glibc"
    ) "${glibcLocales}/lib/locale/locale-archive";

    buildInputs = [ glibcLocales ];
    installPhase = ''
      ${site}/bin/site build
      mkdir -p $out/
      cp -av _site/* $out/
    '';
  };
}
