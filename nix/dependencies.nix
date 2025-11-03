{ pkgs }:
{
  # Essential dependencies
  essential = with pkgs; [
    ripgrep
    fd
    git
  ];

  # Build tools
  build = with pkgs; [
    gcc
    gnumake
    cmake
  ];

  # Optional tools
  optional = with pkgs; [
    nodejs
    tree-sitter
    sqlite
    curl
    wget
  ];

  # Language servers (can be extended)
  lsp = with pkgs; [
    lua-language-server
    nil # Nix LSP
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    pyright
    rust-analyzer
  ];
}
