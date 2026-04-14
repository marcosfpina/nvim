• Perfeito — como você já tem o nixpkgs (ou pode baixá‑lo) basta consultar o generated.nix para recuperar os hashes oficiais e acabar com os
fakeSha256. Aqui vão alguns jeitos práticos:

- Buscar direto no arquivorg 'ollama-nvim' /caminho/para/nixpkgs/pkgs/applications/editors/vim/plugins/generated.nix -nA4 | sed -n '1,6p'
  O bloco traz rev, sha256, date etc. Repita para cada plugin.
  O bloco traz rev, sha256, date etc. Repita para cada plugin.
- nix eval (sem abrir o arquivo)
  Se o canal já está disponível no sistema:nix eval --raw 'nixpkgs#vimPlugins.ollama-nvim.src.rev'
  nix eval --raw 'nixpkgs#vimPlugins.ollama-nvim.src.outputHash'Isso extrai direto do atributo, sem precisar ler o generated.nix.
- Automatizar via scriptpython - <<'PY'
  import json, subprocess
  plugins = \["ollama-nvim", "copilotchat-nvim"]
  for name in plugins:
  rev = subprocess.check\_output(
  \["nix", "eval", "--raw", f'nixpkgs#vimPlugins.{name}.src.rev']
  ).decode().strip()
  sha = subprocess.check\_output(
  \["nix", "eval", "--raw", f'nixpkgs#vimPlugins.{name}.src.outputHash']
  ).decode().strip()
  print(f"{name}: {rev}  {sha}")
  PYTroque a lista conforme necessário.

Depois é só substituir os placeholders do overlay — exemplo:

ollama-nvim = prev.vimUtils.buildVimPlugin {
pname = "ollama.nvim";
version = "2024-03-29";
src = prev.fetchFromGitHub {
owner = "nomnivore";
repo = "ollama.nvim";
rev = "45e58779fecde7ac5b8f62800bbe7180d4b48507";
sha256 = "sha256-…";
};
};

Assim o build do módulo (/etc/nixos/modules/packages/\*) fica 100 % consistente com o nixpkgs oficial, sem necessidade de rodar nix build para
descobrir hash. Se precisar, posso montar um script que percorre todo o inventário e atualiza o overlay automaticamente.

› Por favor, os que ja estão no nix e os que não estão, vou estar fazendo um fork, via git, em bulk

• Segue o inventário em duas listas, já pronto para o fork em massa:

No nixpkgs (pkgs.vimPlugins disponíveis) // Here, let's package every pkgs.vimPlugins with the following packages, standard in a module for more dinamic approach, enabling the flake input module for be imported on Nix root flake.
Comment.nvim, LuaSnip, aerial.nvim, better-escape.nvim, bufdelete.nvim, bufferline.nvim, cmp-buffer, cmp-cmdline, cmp-nvim-lsp, cmp-path,
cmp\_luasnip, conform.nvim, dashboard-nvim, diffview\.nvim, dressing.nvim, flash.nvim, friendly-snippets, gitsigns.nvim, harpoon (branch padrão),
indent-blankline.nvim, lazy.nvim, lsp\_signature.nvim, lspkind.nvim, lualine.nvim, marks.nvim, mason-lspconfig.nvim, mason-tool-installer.nvim,
mason.nvim, mini.ai, mini.animate, neo-tree.nvim, neodev.nvim, neogit, neoscroll.nvim, nui.nvim, nvim-autopairs, nvim-bqf, nvim-cmp, nvim-
colorizer.lua, nvim-lint, nvim-lspconfig, nvim-navic, nvim-notify, nvim-spectre, nvim-surround, nvim-treesitter, nvim-treesitter-context, nvim-
treesitter-textobjects, nvim-ts-autotag, nvim-ts-context-commentstring, nvim-ufo, nvim-web-devicons, oil.nvim, persistence.nvim, plenary.nvim,
project.nvim, promise-async, rainbow-delimiters.nvim, schemastore.nvim, sqlite.lua, statuscol.nvim, symbols-outline.nvim, telescope-file-
browser.nvim, telescope-frecency.nvim, telescope-fzf-native.nvim, telescope-live-grep-args.nvim, telescope-project.nvim, telescope-symbols.nvim,
telescope-ui-select.nvim, telescope-undo.nvim, telescope.nvim, todo-comments.nvim, toggleterm.nvim, tokyonight.nvim, trouble.nvim, vim-maximizer,
vim-startuptime, which-key.nvim, window-picker.

Ainda fora do nixpkgs (precisam de overlay/empacotamento próprio)

- nomnivore/ollama.nvim
- CopilotC-Nvim/CopilotChat.nvim (e, se habilitar, o backend zbirenbaum/copilot.lua continua fora por licença)

Pacotes auxiliares já no nixpkgs

- fzf como binário (pkgs.fzf), com plugin Vim opcional (vimPlugins.fzf-vim).
- Dependências nativas (cmake/gcc/sqlite/tree-sitter) permanecem em pkgs.

O arquivo docs/nix-neovim-plugins.md agrupa por categoria e indica os atributos/observações caso queira sincronizar automaticamente com seu fork. Se
for preparar um overlay em lote, basta iterar sobre a seção “needs overlay” para gerar os fetchFromGitHub.

<https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/vim/plugins/generated.nix#L10495>
<https://github.com/nvim-neotest/neotest-python>
<https://github.com/NvChad/NvChad?tab=readme-ov-file>
