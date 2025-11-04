# Neovim Plugins → nixpkgs Mapping

> Baseado em `lazy-lock.json` + `lua/plugins`, alinhado ao nixpkgs (`nixos-unstable` rev 2fb006b87f04c4d3bdf08cfdbc7fab9c13d94a15).
> Situações marcadas como `needs overlay` exigem empacotamento manual ou manutenção via lazy.nvim. Atualize o status conforme novos commits do nixpkgs.

## Ai

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| ollama.nvim | nomnivore/ollama.nvim | `ollama-nvim` | needs overlay | Plugin novo focado em Ollama; embalar via fetchFromGitHub ou usar lazy conforme ambiente. Integra com servidor Ollama local; requer binário `ollama` disponível no PATH. |

## Completion

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| cmp-buffer | hrsh7th/cmp-buffer | `cmp-buffer` | in nixpkgs | Disponível em `pkgs.vimPlugins."cmp-buffer"`. |
| cmp-cmdline | hrsh7th/cmp-cmdline | `cmp-cmdline` | in nixpkgs | Disponível em `pkgs.vimPlugins."cmp-cmdline"`. |
| cmp-nvim-lsp | hrsh7th/cmp-nvim-lsp | `cmp-nvim-lsp` | in nixpkgs | Disponível em `pkgs.vimPlugins."cmp-nvim-lsp"`. |
| cmp-path | hrsh7th/cmp-path | `cmp-path` | in nixpkgs | Disponível em `pkgs.vimPlugins."cmp-path"`. |
| cmp_luasnip | saadparwaiz1/cmp_luasnip | `cmp-luasnip` | in nixpkgs | Disponível em `pkgs.vimPlugins."cmp-luasnip"`. |
| CopilotChat.nvim | CopilotC-Nvim/CopilotChat.nvim | `copilotchat-nvim` | needs overlay | Não embalado no nixpkgs oficial até 2024; manter via lazy ou embalar manualmente. Plugin marcado como `enabled = false`; depende de Copilot (licença proprietária) e Node >= 18. |
| friendly-snippets | rafamadriz/friendly-snippets | `friendly-snippets` | in nixpkgs | Disponível em `pkgs.vimPlugins."friendly-snippets"`. |
| lspkind.nvim | onsails/lspkind.nvim | `lspkind-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."lspkind-nvim"`. |
| LuaSnip | L3MON4D3/LuaSnip | `LuaSnip` | in nixpkgs | Disponível em `pkgs.vimPlugins."LuaSnip"`. |
| nvim-cmp | hrsh7th/nvim-cmp | `nvim-cmp` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-cmp"`. |
| plenary.nvim | nvim-lua/plenary.nvim | `plenary-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."plenary-nvim"`. |

## Core

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| better-escape.nvim | max397574/better-escape.nvim | `better-escape-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."better-escape-nvim"`. |
| Comment.nvim | numToStr/Comment.nvim | `Comment-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."Comment-nvim"`. |
| dressing.nvim | stevearc/dressing.nvim | `dressing-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."dressing-nvim"`. |
| gitsigns.nvim | lewis6991/gitsigns.nvim | `gitsigns-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."gitsigns-nvim"`. |
| lazy.nvim | folke/lazy.nvim | `lazy-nvim` | in nixpkgs | Disponível como `pkgs.vimPlugins.lazy-nvim`; avalie se prefere usar bootstrap local ou pacote do sistema. Caso use pacote do nix, remova bootstrap de download automático. |
| mini.ai | echasnovski/mini.ai | `mini-ai` | in nixpkgs | Disponível em `pkgs.vimPlugins."mini-ai"`. |
| nvim-autopairs | windwp/nvim-autopairs | `nvim-autopairs` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-autopairs"`. |
| nvim-colorizer.lua | NvChad/nvim-colorizer.lua | `nvim-colorizer-lua` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-colorizer-lua"`. |
| nvim-surround | kylechui/nvim-surround | `nvim-surround` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-surround"`. |
| persistence.nvim | folke/persistence.nvim | `persistence-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."persistence-nvim"`. |
| vim-startuptime | dstein64/vim-startuptime | `vim-startuptime` | in nixpkgs | Disponível em `pkgs.vimPlugins."vim-startuptime"`. |
| which-key.nvim | folke/which-key.nvim | `which-key-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."which-key-nvim"`. |

## Diagnostics

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| aerial.nvim | stevearc/aerial.nvim | `aerial-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."aerial-nvim"`. |
| fzf | junegunn/fzf | `fzf` | use pkgs.fzf | Recomendado usar `pkgs.fzf` para fornecer o binário; plugin vim opcional via `vimPlugins.fzf-vim`. Se usar plugin vim, considere `vimPlugins.fzf-vim`; para o binário use `pkgs.fzf`. |
| nvim-bqf | kevinhwang91/nvim-bqf | `nvim-bqf` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-bqf"`. Para suporte fzf, combine com `pkgs.fzf` ou plugin `vimPlugins.fzf-vim`. |
| nvim-web-devicons | nvim-tree/nvim-web-devicons | `nvim-web-devicons` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-web-devicons"`. |
| symbols-outline.nvim | simrat39/symbols-outline.nvim | `symbols-outline-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."symbols-outline-nvim"`. |
| todo-comments.nvim | folke/todo-comments.nvim | `todo-comments-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."todo-comments-nvim"`. |
| trouble.nvim | folke/trouble.nvim | `trouble-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."trouble-nvim"`. |

## Files

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| neo-tree.nvim | nvim-neo-tree/neo-tree.nvim | `neo-tree-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."neo-tree-nvim"`. Depende de `nui.nvim` e `plenary.nvim` (ambos presentes no nixpkgs). |
| nui.nvim | MunifTanjim/nui.nvim | `nui-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."nui-nvim"`. |
| oil.nvim | stevearc/oil.nvim | `oil-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."oil-nvim"`. |
| project.nvim | ahmedkhalf/project.nvim | `project-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."project-nvim"`. |
| telescope-file-browser.nvim | nvim-telescope/telescope-file-browser.nvim | `telescope-file-browser-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-file-browser-nvim"`. |
| telescope.nvim | nvim-telescope/telescope.nvim | `telescope-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-nvim"`. |
| window-picker | s1n7ax/nvim-window-picker | `nvim-window-picker` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-window-picker"`. Declarado com `name = "window-picker"`; no nixpkgs o atributo segue o repo: `vimPlugins."nvim-window-picker"`. |

## Formatting

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| conform.nvim | stevearc/conform.nvim | `conform-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."conform-nvim"`. |
| mason-tool-installer.nvim | WhoIsSethDaniel/mason-tool-installer.nvim | `mason-tool-installer-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."mason-tool-installer-nvim"`. |
| mason.nvim | williamboman/mason.nvim | `mason-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."mason-nvim"`. |
| nvim-lint | mfussenegger/nvim-lint | `nvim-lint` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-lint"`. |

## Lsp

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| lsp_signature.nvim | ray-x/lsp_signature.nvim | `lsp-signature-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."lsp-signature-nvim"`. |
| mason-lspconfig.nvim | williamboman/mason-lspconfig.nvim | `mason-lspconfig-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."mason-lspconfig-nvim"`. |
| neodev.nvim | folke/neodev.nvim | `neodev-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."neodev-nvim"`. |
| nvim-lspconfig | neovim/nvim-lspconfig | `nvim-lspconfig` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-lspconfig"`. |
| nvim-navic | SmiteshP/nvim-navic | `nvim-navic` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-navic"`. |
| schemastore.nvim | b0o/schemastore.nvim | `schemastore-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."schemastore-nvim"`. |

## Navigation

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| flash.nvim | folke/flash.nvim | `flash-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."flash-nvim"`. |
| harpoon | ThePrimeagen/harpoon | `harpoon` | in nixpkgs | Pacote oficial segue branch padrão; caso precise do branch `harpoon2`, faça override de `src`/`rev`. |
| marks.nvim | chentoast/marks.nvim | `marks-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."marks-nvim"`. |
| nvim-spectre | nvim-pack/nvim-spectre | `nvim-spectre` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-spectre"`. |

## Telescope

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| sqlite.lua | kkharji/sqlite.lua | `sqlite-lua` | in nixpkgs | Disponível em `pkgs.vimPlugins."sqlite-lua"`. Precisa do pacote `pkgs.sqlite` disponível para a extensão frecency. |
| telescope-frecency.nvim | nvim-telescope/telescope-frecency.nvim | `telescope-frecency-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-frecency-nvim"`. |
| telescope-fzf-native.nvim | nvim-telescope/telescope-fzf-native.nvim | `telescope-fzf-native-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-fzf-native-nvim"`. Derivação usa CMake; garantir `pkgs.cmake`, `gcc` no ambiente (já listado em `nix/dependencies.nix`). |
| telescope-live-grep-args.nvim | nvim-telescope/telescope-live-grep-args.nvim | `telescope-live-grep-args-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-live-grep-args-nvim"`. |
| telescope-project.nvim | nvim-telescope/telescope-project.nvim | `telescope-project-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-project-nvim"`. |
| telescope-symbols.nvim | nvim-telescope/telescope-symbols.nvim | `telescope-symbols-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-symbols-nvim"`. |
| telescope-ui-select.nvim | nvim-telescope/telescope-ui-select.nvim | `telescope-ui-select-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-ui-select-nvim"`. |
| telescope-undo.nvim | debugloop/telescope-undo.nvim | `telescope-undo-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."telescope-undo-nvim"`. |

## Terminal

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| diffview.nvim | sindrets/diffview.nvim | `diffview-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."diffview-nvim"`. |
| neogit | NeogitOrg/neogit | `neogit` | in nixpkgs | Disponível em `pkgs.vimPlugins."neogit"`. |
| toggleterm.nvim | akinsho/toggleterm.nvim | `toggleterm-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."toggleterm-nvim"`. |

## Treesitter

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| nvim-treesitter | nvim-treesitter/nvim-treesitter | `nvim-treesitter` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-treesitter"`. |
| nvim-treesitter-context | nvim-treesitter/nvim-treesitter-context | `nvim-treesitter-context` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-treesitter-context"`. |
| nvim-treesitter-textobjects | nvim-treesitter/nvim-treesitter-textobjects | `nvim-treesitter-textobjects` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-treesitter-textobjects"`. |
| nvim-ts-autotag | windwp/nvim-ts-autotag | `nvim-ts-autotag` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-ts-autotag"`. |
| nvim-ts-context-commentstring | JoosepAlviste/nvim-ts-context-commentstring | `nvim-ts-context-commentstring` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-ts-context-commentstring"`. |
| rainbow-delimiters.nvim | HiPhish/rainbow-delimiters.nvim | `rainbow-delimiters-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."rainbow-delimiters-nvim"`. |

## Ui

| Plugin | Repositório | nixpkgs (`vimPlugins`) | Status | Observações |
| --- | --- | --- | --- | --- |
| bufdelete.nvim | famiu/bufdelete.nvim | `bufdelete-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."bufdelete-nvim"`. |
| bufferline.nvim | akinsho/bufferline.nvim | `bufferline-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."bufferline-nvim"`. |
| dashboard-nvim | nvimdev/dashboard-nvim | `dashboard-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."dashboard-nvim"`. |
| indent-blankline.nvim | lukas-reineke/indent-blankline.nvim | `indent-blankline-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."indent-blankline-nvim"`. |
| lualine.nvim | nvim-lualine/lualine.nvim | `lualine-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."lualine-nvim"`. |
| mini.animate | echasnovski/mini.animate | `mini-animate` | in nixpkgs | Disponível em `pkgs.vimPlugins."mini-animate"`. |
| neoscroll.nvim | karb94/neoscroll.nvim | `neoscroll-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."neoscroll-nvim"`. |
| nvim-notify | rcarriga/nvim-notify | `nvim-notify` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-notify"`. |
| nvim-ufo | kevinhwang91/nvim-ufo | `nvim-ufo` | in nixpkgs | Disponível em `pkgs.vimPlugins."nvim-ufo"`. |
| promise-async | kevinhwang91/promise-async | `promise-async` | in nixpkgs | Disponível em `pkgs.vimPlugins."promise-async"`. |
| statuscol.nvim | luukvbaal/statuscol.nvim | `statuscol-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."statuscol-nvim"`. |
| tokyonight.nvim | folke/tokyonight.nvim | `tokyonight-nvim` | in nixpkgs | Disponível em `pkgs.vimPlugins."tokyonight-nvim"`. |
| vim-maximizer | szw/vim-maximizer | `vim-maximizer` | in nixpkgs | Disponível em `pkgs.vimPlugins."vim-maximizer"`. |

## Exemplos de Integração

### Flake/Home Manager

```nix
{
  programs.neovim = {
    enable = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      comment-nvim
      nvim-treesitter
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-nvim-lsp
      cmp-luasnip
      luasnip
      telescope-nvim
      telescope-fzf-native-nvim
      neo-tree-nvim
      nvim-window-picker
      # …
    ];
  };
}
```

### Overlays para plugins ausentes

```nix
final: prev: {
  vimPlugins = prev.vimPlugins // {
    ollama-nvim = prev.vimUtils.buildVimPlugin {
      pname = "ollama.nvim";
      version = "2024-03-29";
      src = prev.fetchFromGitHub {
        owner = "nomnivore";
        repo = "ollama.nvim";
        rev = "45e58779fecde7ac5b8f62800bbe7180d4b48507";
        sha256 = prev.lib.fakeSha256;
      };
    };
  };
}
```

> Ajuste `rev`/`sha256` sempre que atualizar o plugin. Para `CopilotChat.nvim`, siga o mesmo padrão, lembrando de ativar `allowUnfree = true`.
