{
  description = "home sweet home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # coleção de shells (definido abaixo em lib/shells.nix)
      shells = import ./lib/shells.nix { inherit pkgs; };
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;

      # nix develop .#python, .#cuda, .#infra, etc.
      devShells.${system} = shells;

      # imagens Docker e utilidades de build (definido abaixo em lib/packages.nix)
      #packages.${system} = import ./lib/packages.nix { inherit pkgs self; };

      # checks que o CI pode rodar (fmt, flake check, builds importantes)
      #checks.${system} = {
        #fmt = pkgs.runCommand "fmt-check" { buildInputs = [ pkgs.nixfmt ]; } ''
          #nixfmt --check ${self}
          #touch $out
        #'';
        #iso = self.packages.${system}.iso;
        #vm = self.packages.${system}.vm-image;
        #docker-app = self.packages.${system}.images.app;
      #};

      nixosConfigurations = {
        kernelcore = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/kernelcore/hardware-configuration.nix
            ./hosts/kernelcore/configuration.nix

            ./modules/services/default.nix
            ./modules/system/memory.nix
            ./modules/system/nix.nix
            ./modules/system/services.nix

            ./modules/security/hardening.nix
            ./modules/security/network.nix
            ./modules/security/boot.nix

            ./modules/hardware/nvidia.nix

            ./modules/development/environments.nix
            ./modules/development/jupyter.nix

            ./modules/containers/docker.nix
            ./modules/containers/nixos-containers.nix
            ./modules/virtualization/vms.nix
            ./sec/hardening.nix

            # sops-nix (necessário p/ secrets no sistema)
            sops-nix.nixosModules.sops

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kernelcore = import ./hosts/kernelcore/home/home.nix;
              home-manager.backupFileExtension = "rescue";
            }
          ];
        };

        kernelcore-iso = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (
              { modulesPath, ... }:
              {
                imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
              }
            )
            ./hosts/kernelcore
          ];
        };
      };

      #packages.${system} = (self.packages.${system} or { }) // {
      #packages.${system} = {
        #vm-image = self.nixosConfigurations.kernelcore.config.system.build.vm;
        #iso = self.nixosConfigurations.kernelcore-iso.config.system.build.isoImage;
      #};
    };
}
