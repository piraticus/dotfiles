{
  stdenvNoCC,
  fetchurl
}:
stdenvNoCC.mkDerivation {
  pname = "zen";
  version = "1.21.3b";
  
  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz";
    hash = "";
  };

  dontBuild = true;
  dontFixup = true;
  dontPatch = true;

  installPhase = ''
                 runHook preInstall
                 mkdir -p $out/

                 mv ./* $out/

                 runHook postInstall                      
  
                 '';
}
