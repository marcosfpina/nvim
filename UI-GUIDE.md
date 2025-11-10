# 🎨 Guia Visual do Neovim

## ✨ Novos Recursos Visuais Adicionados

### 🎯 Noice - UI Melhorada
Deixa comandos, mensagens e popups muito mais bonitos.

**Keymaps:**
- `<leader>sn` - Ver mensagens do Noice
- `<leader>snl` - Última mensagem
- `<leader>snh` - Histórico de mensagens
- `<leader>snd` - Descartar todas notificações

### 📊 Scrollbar Visual
Barra de rolagem na lateral direita mostrando:
- 🔴 Erros de diagnóstico
- 🟡 Warnings
- 🔵 Info
- 🟢 Git changes (add/modify/delete)
- 🟠 Posições de busca

### 🔍 Search Highlighting Melhorado
Mostra quantos resultados da busca existem.

**Keymaps:**
- `n` / `N` - Próximo/anterior com contador
- `<leader>l` - Limpar highlights

### 🎯 Indent Scope Animado
Linha vertical animada mostrando o scope atual do código.

### 🧘 Zen Mode
Modo foco para escrever código sem distrações.

**Keymap:**
- `<leader>z` - Ativar/desativar Zen Mode

### 🌈 Color Highlighter
Mostra cores inline no código:
- `#ff0000` - cores hex
- `rgb(255, 0, 0)` - funções CSS
- `red` - nomes de cores

### 📍 Breadcrumbs (Winbar)
Mostra o caminho no código (função › classe › módulo) no topo da janela.

### 🎨 Colorschemes Alternativos

**Trocar tema:**
```vim
:colorscheme catppuccin    " Catppuccin Mocha
:colorscheme rose-pine     " Rose Pine Moon
:colorscheme tokyonight    " Tokyo Night (padrão)
```

## 🎨 Recursos Visuais Existentes

### 📈 Lualine (Statusline)
Barra de status no rodapé com:
- Modo atual
- Branch Git + diff
- Nome do arquivo
- Diagnósticos (erros/warnings)
- LSP ativo
- Posição no arquivo

### 📑 Bufferline
Abas no topo para buffers abertos.

**Keymaps:**
- `<leader>bp` - Escolher buffer
- `<leader>bc` - Escolher buffer para fechar
- `<leader>bl` - Fechar buffers à esquerda
- `<leader>br` - Fechar buffers à direita
- `<leader>b1` até `<leader>b5` - Ir para buffer 1-5

### 🏠 Dashboard
Tela inicial bonita com atalhos.

### 📏 Indent Guides
Linhas verticais mostrando níveis de indentação.

### 📂 Folding Visual
Dobrar código com preview.

**Keymaps:**
- `zR` - Abrir todos folds
- `zM` - Fechar todos folds
- `zp` - Preview do fold sob o cursor

### 🎬 Animações Suaves
- Scroll suave
- Cursor animado
- Resize de janelas animado

### 🔔 Notificações Bonitas
Popups elegantes para mensagens do sistema.

**Keymap:**
- `<leader>un` - Descartar todas notificações
- `<leader>unh` - Ver histórico

### 🪟 Window Maximizer
**Keymap:**
- `<leader>wm` - Maximizar/restaurar janela atual

## 💡 Dicas

1. **Performance:** Todos os plugins são carregados de forma lazy, não afeta o startup
2. **Customização:** Edite `lua/plugins/ui.lua` e `lua/plugins/ui-enhancements.lua`
3. **Ícones:** Certifique-se de ter uma Nerd Font instalada
4. **Transparência:** Para ativar transparência, edite o colorscheme e mude `transparent = true`

## 🎯 Configurações Recomendadas no Terminal

Para melhor experiência visual:
- Use uma Nerd Font (FiraCode Nerd Font, JetBrainsMono Nerd Font, etc.)
- True color habilitado: `set termguicolors` (já ativado)
- Terminal com suporte a 24-bit color

## 🚀 Para Aplicar

1. Feche o Neovim
2. Reabra
3. Execute `:Lazy sync`
4. Aguarde a instalação
5. Reinicie o Neovim

Aproveite sua nova experiência visual! ✨
