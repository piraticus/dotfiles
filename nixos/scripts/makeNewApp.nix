{
  stdenv
, makeWrapper
}:
let
  version = "0.1";
in
stdenv.mkDerivation {
  inherit version;
  pname = "makeNewApp";

  src = ./src;

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  preferLocalBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    
  ];

  installPhase = ''
                 mkdir -p $out/bin
                 mv * $out

                 makeWrapper $out/create_app.sh $out/bin/makeNewApp
                 '';
}
