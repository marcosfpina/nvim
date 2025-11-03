{
  description = "Production-Grade Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # System dependencies required for full functionality
        systemDependencies = with pkgs; [
          # Core tools
          ripgrep # Live grep in Telescope
          fd # Fast file finding
          git # Version control

          # Build tools for native extensions
          gcc
          gnumake
          cmake

          # Optional but recommended
          nodejs # For many LSP servers
          tree-sitter # Syntax parsing
          sqlite # Frecency database
        ];

        # Neovim with custom configuration
        neovimConfigured = pkgs.neovim.override {
          configure = {
            customRC = ''
              lua << EOF
              -- Set up paths
              vim.g.mapleader = " "
              vim.g.maplocalleader = "\\"

              -- Source main config
              dofile("${self}/init.lua")
              EOF
            '';
          };
        };

        # Create a wrapped neovim with all dependencies
        neovimWrapped = pkgs.writeShellScriptBin "nvim" ''
          export PATH="${pkgs.lib.makeBinPath systemDependencies}:$PATH"
          exec ${neovimConfigured}/bin/nvim "$@"
        '';

      in
      {
        # Default package
        packages.default = neovimWrapped;

        # Explicit package
        packages.neovim = neovimWrapped;

        # Development shell with all tools
        devShells.default = pkgs.mkShell {
          buildInputs = [ neovimWrapped ] ++ systemDependencies;

          shellHook = ''
            echo "🚀 Neovim Development Environment"
            echo "   Run 'nvim' to start"
            echo "   Config: ${self}"
            echo ""
            echo "Available tools:"
            echo "  - ripgrep (rg)"
            echo "  - fd"
            echo "  - git"
            echo "  - gcc, make, cmake"
          '';
        };

        # Formatter
        formatter = pkgs.nixpkgs-fmt;

        # Apps
        apps.default = {
          type = "app";
          program = "${neovimWrapped}/bin/nvim";
        };
      }
    );
}
