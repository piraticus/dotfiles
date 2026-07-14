{

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0"; # Stable Nixpkgs (use 0.1 for unstable)
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3"; # Determinate 3.*
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{nixpkgs, determinate, zen-browser, ...}:
    let
      username = "tony";
      hostname = "nixos";
      homeDirectory = "/home/${username}";
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        config.allowUnfree = true;
      };
      
    in{
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        specialArgs = { inherit inputs; };  # pass the inputs into the configuration module
        modules = [

          determinate.nixosModules.default
          
          ./configuration.nix
          ./hardware-configuration.nix

          # Additional Modules

        ];
      };
    };
        
}
