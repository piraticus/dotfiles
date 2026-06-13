{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "everforest-emacs-theme";
  version = "0.0";

  src = fetchFromGitHub {
    owner = "theorytoe";
    repo = "everforest-emacs";
    rev = "ba61a881b5d57810eef76baae01c951d1e6c2ceb";
    hash = "sha256-p8D27i5EZp37QVi9IffJqXnnFxUaaAc9BfzIzrje66U=";
  };

  dontBuild = true;
  dontFixup = true;
  dontPatch = true;

  installPhase = ''
                 runHook preInstall
                 mkdir -p $out/share/themes/emacs-everforest

                 cp -r ./* $out/share/themes/emacs-everforest

                 runHook postInstall                      
  
                 '';
}
