{
  description = "Scripts";
  outputs = {self, nixpkgs}:
    let
      inherit (nixpkgs.lib) genAttrs;
      systems = ["x86_64-linux"];

      overlay = final: prev:{
        makeNewApp = final.callPackage ./makeNewApp.nix {};
      };

      packages = genAttrs systems (system:
        let
          makeNewApp = (import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            }).makeNewApp;
        in { inherit makeNewApp; default = makeNewApp; });

      nixosModule = {pkgs, ...}: {
        nixpkgs.overlays = [self.overlays.default];
        environment.systemPackages = [pkgs.makeNewApp];
      };
    in{
      inherit packages overlay nixosModule;

      nixosModules.default = nixosModule;

      overlays.default = overlay;

      apps = genAttrs systems (system:
        {
          tracealyzer = {
            type = "app";
            program = "${packages}.${system}/bin/makeNewApp";
          };
        });
    };
}
