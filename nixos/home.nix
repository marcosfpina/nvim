{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ============================================================
  # CORE IDENTITY MATRIX
  # ============================================================
  home = {
    username = "kernelcore";
    homeDirectory = "/home/kernelcore";
    stateVersion = "25.05";

    # ========================================================
    # OPERATIONAL PACKAGES
    # ========================================================
    packages = with pkgs; [
      # ─────────────────────────────────────────────────────
      # Terminal & System Intelligence
      # ─────────────────────────────────────────────────────
      neofetch
      htop
      btop
      tree
      ripgrep
      fd
      bat
      eza
      zoxide
      fzf
      fq
      yazi
      starship

      # ─────────────────────────────────────────────────────
      # Network Reconnaissance
      # ─────────────────────────────────────────────────────
      nmap
      wireshark
      tcpdump
      curl
      wget
      dig
      busybox

      # ─────────────────────────────────────────────────────
      # Development Arsenal
      # ─────────────────────────────────────────────────────
      git
      git-lfs

      vim
      neovim

      #vscode
      #code-cursor
      #jetbrains.idea-ultimate
      #zed-editor

      # ─────────────────────────────────────────────────────
      # Neovim Plugins
      # ─────────────────────────────────────────────────────

      # ─────────────────────────────────────────────────────
      # Package Managers & Python
      # ─────────────────────────────────────────────────────
      uv
      pipx
      python313Packages.python
      python313Packages.torchWithCuda

      # ─────────────────────────────────────────────────────
      # Build Tools
      # ─────────────────────────────────────────────────────
      gcc
      gnumake
      cmake

      # ─────────────────────────────────────────────────────
      # Navigation & Multiplexing
      # ─────────────────────────────────────────────────────
      tmux

      # ─────────────────────────────────────────────────────
      # Environment Management
      # ─────────────────────────────────────────────────────
      nix-direnv
      direnv

      # ─────────────────────────────────────────────────────
      # File Management
      # ─────────────────────────────────────────────────────
      nemo-with-extensions
      nemo-emblems

      # ─────────────────────────────────────────────────────
      # Clipboard & Shell
      # ─────────────────────────────────────────────────────
      xclip
      wl-clipboard
      zsh
      oh-my-zsh

      # ─────────────────────────────────────────────────────
      # File & Archive Operations
      # ─────────────────────────────────────────────────────
      unzip
      zip
      p7zip
      rsync
      rclone 

      # ─────────────────────────────────────────────────────
      # Media & Graphics
      # ─────────────────────────────────────────────────────
      mpv
      vlc
      gimp
      obs-studio
      imagemagick

      # ─────────────────────────────────────────────────────
      # Browser Fleet
      # ─────────────────────────────────────────────────────
      firefox
      brave
      chromium

      # ─────────────────────────────────────────────────────
      # Communication Channels
      # ─────────────────────────────────────────────────────
      discord
      telegram-desktop
      signal-desktop

      # ─────────────────────────────────────────────────────
      # Productivity Suite
      # ─────────────────────────────────────────────────────
      libreoffice
      obsidian

      # ─────────────────────────────────────────────────────
      # System Utilities
      # ─────────────────────────────────────────────────────
      gparted
      bleachbit
      keepassxc

      # ─────────────────────────────────────────────────────
      # Containerization
      # ─────────────────────────────────────────────────────
      docker
      docker-compose

      # ─────────────────────────────────────────────────────
      # Machine Learning
      # ─────────────────────────────────────────────────────
      ollama-cuda
      llama-cpp

      # ─────────────────────────────────────────────────────
      # Nerd Fonts
      # ─────────────────────────────────────────────────────
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.meslo-lg
      nerd-fonts.ubuntu-mono

      # Additional quality fonts
      fira-code
      fira-code-symbols
      jetbrains-mono
      liberation_ttf
      dejavu_fonts
      noto-fonts
      noto-fonts-emoji
    ];
  };

  # ============================================================
  # PROGRAM CONFIGURATIONS
  # ============================================================
  programs = {
    # ========================================================
    # Home Manager
    # ========================================================
    home-manager.enable = true;

    # ========================================================
    # BASH Configuration
    # ========================================================
    bash = {
      enable = true;

      shellAliases = {
        # Navigation with eza
        ll = "eza -la --icons --git";
        la = "eza -la --icons --git";
        lt = "eza --tree --icons --git";
        ls = "eza --icons";

        # System monitoring
        ps = "ps auxf";
        psg = "ps aux | grep -v grep | grep -i -e VSZ -e";
        mkdir = "mkdir -p";
        meminfo = "free -m -l -t";
        cpuinfo = "lscpu";

        # Network diagnostics
        ports = "netstat -tulanp";
        listening = "lsof -i -P | grep LISTEN";

        # Git shortcuts (enhanced)
        gs = "git status";
        ga = "git add";
        gaa = "git add --all";
        gc = "git commit -m";
        gp = "git push origin main";
        gl = "git log --oneline --graph --decorate --all -10";
        gd = "git diff";
        gco = "git checkout";
        gar = "git add remote origin";

        # NixOS management (usando home-manager agora!)
        rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#kernelcore --show-trace";
        build = "home-manager switch --flake ~/.config/NixHM#kernelcore";
        upgrade = "nix flake update ~/.config/home-manager && home-manager switch --flake ~/.config/NixHM#kernelcore";
        clean = "nix-collect-garbage -d && nix-store --gc";
        cleanold = "sudo nix-collect-garbage --delete-older-than 7d";

        # Docker shortcuts
        dps = "docker ps --format 'table {{.Names}}\\t{{.Status}}\\t{{.Ports}}'";
        dimg = "docker images";
        dstop = "docker stop $(docker ps -q)";
        dclean = "docker system prune -af";

        # Security & Privacy
        shred = "shred -vfz -n 3";

        # Quick access
        config = "cd ~/.config";
        dots = "cd ~/.config/NixHM";
        base = "cd ~/Base";
        neo = "cd ~/.config/nvim/";
        dev = "cd ~/dev";

        # Fun stuff
        weather = "curl wttr.in";
        speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -";
      };

      bashrcExtra = ''
        # ====================================================
        # SHELL ENVIRONMENT
        # ====================================================

        # Enhanced history
        export HISTSIZE=10000
        export HISTFILESIZE=20000
        export HISTCONTROL=ignoredups:erasedups
        export HISTTIMEFORMAT="%F %T "
        shopt -s histappend # Append to history, don't overwrite

        # Application defaults
        export EDITOR="nvim"
        export VISUAL="nvim"
        export BROWSER="brave"
        export ANTHROPIC_MODEL="claude-sonnet-4-5-20250929"

        # Security paranoia
        umask 077

        # Better cd behavior
        shopt -s autocd # cd by typing directory name
        shopt -s cdspell # autocorrect typos in path

        # Zoxide integration (smarter cd)
        eval "$(zoxide init bash)"

        # ====================================================
        # CUSTOM PROMPT (Git-aware)
        # ====================================================

        parse_git_branch() {
          git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
        }

        parse_git_dirty() {
          [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
        }

        # Colorful prompt with git status
        export PS1="\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]\$(parse_git_branch)\$(parse_git_dirty)\[\033[00m\]\$ "

        # ====================================================
        # QUALITY OF LIFE FUNCTIONS
        # ====================================================

        # Quick cd up multiple directories
        up() {
          local d=""
          local limit="''${1:-1}"
          for ((i=1; i<=limit; i++)); do
            d="../$d"
          done
          cd "$d" || return
        }

        # Extract any archive
        extract() {
          if [ -f "$1" ]; then
            case "$1" in
              *.tar.bz2)   tar xjf "$1"     ;;
              *.tar.gz)    tar xzf "$1"     ;;
              *.bz2)       bunzip2 "$1"     ;;
              *.rar)       unrar x "$1"     ;;
              *.gz)        gunzip "$1"      ;;
              *.tar)       tar xf "$1"      ;;
              *.tbz2)      tar xjf "$1"     ;;
              *.tgz)       tar xzf "$1"     ;;
              *.zip)       unzip "$1"       ;;
              *.Z)         uncompress "$1"  ;;
              *.7z)        7z x "$1"        ;;
              *)           echo "'$1' cannot be extracted via extract()" ;;
            esac
          else
            echo "'$1' is not a valid file"
          fi
        }

        # Quick backup
        backup() {
          cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
        }

        # ====================================================
        # LOAD DOMAIN-SPECIFIC ALIASES
        # ====================================================

        # GPU aliases
        if [ -f ~/.config/NixHM/aliases/gpu.sh ]; then
          source ~/.config/NixHM/aliases/gpu.sh
        fi

        # GCloud aliases
        if [ -f ~/.config/NixHM/aliases/gcloud.sh ]; then
          source ~/.config/NixHM/aliases/gcloud.sh
        fi

        # AI-Docker Inference aliases
        if [ -f ~/.config/NixHM/aliases/multimodal.sh ]; then
          source ~/.config/NixHM/aliases/multimodal.sh
        fi

        # Welcome message
        echo "⚡ Welcome back, $(whoami)! Ready to hack? 🚀"
      '';
    };

    # ========================================================
    # Git Configuration
    # ========================================================
    git = {
      enable = true;
      userName = "marcosfpina";
      userEmail = "sec@voidnxlabs.com";

      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        pull.rebase = false;

        # Security configurations
        user.signingkey = "5606AB430E95F5AD";
        commit.gpgsign = true;

        # Performance optimizations
        core.preloadindex = true;
        core.fscache = true;
        gc.auto = 256;

        # Better diffs
        diff.algorithm = "histogram";

        # Colorful output
        color.ui = true;
      };

      aliases = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        df = "diff";
        lg = "log --oneline --graph --decorate --all";
        lol = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        amend = "commit --amend --no-edit";
        undo = "reset --soft HEAD^";
      };
    };

    # ========================================================
    # Tmux Configuration
    # ========================================================
    tmux = {
      enable = true;
      terminal = "screen-256color";
      keyMode = "vi";
      mouse = true;

      extraConfig = ''
        # Prefix key
        unbind C-b
        set -g prefix C-a
        bind C-a send-prefix

        # Split panes with intuitive keys
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        # Easy pane navigation
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Reload config
        bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

        # Status bar
        set -g status-position bottom
        set -g status-bg black
        set -g status-fg white
        set -g status-left '#[fg=green,bold]#H #[fg=blue]| '
        set -g status-right '#[fg=yellow]#(uptime | cut -d "," -f 1) #[fg=white]| %H:%M'
        set -g status-interval 60

        # Window status
        setw -g window-status-current-style 'fg=black bg=green bold'

        # Start windows at 1, not 0
        set -g base-index 1
        setw -g pane-base-index 1
      '';
    };

    # ========================================================
    # Eza (Modern ls replacement)
    # ========================================================
    eza = {
      enable = true;
      enableBashIntegration = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--long"
      ];
    };

    # ========================================================
    # Fzf (Fuzzy finder)
    # ========================================================
    fzf = {
      enable = true;
      enableBashIntegration = true;

      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--height 40%"
        "--border"
        "--layout=reverse"
        "--preview 'bat --color=always {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];

      colors = {
        bg = "#1e1e1e";
        "bg+" = "#2e2e2e";
        fg = "#d4d4d4";
        "fg+" = "#ffffff";
      };
    };

    # ========================================================
    # Ripgrep (Better grep)
    # ========================================================
    ripgrep = {
      enable = true;
      arguments = [
        "--max-columns=150"
        "--max-columns-preview"
        "--smart-case"
        "--hidden"
        "--glob=!.git/*"
      ];
    };

    # ========================================================
    # Bat (Better cat with syntax highlighting)
    # ========================================================
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        pager = "less -FR";
      };
    };

    # ========================================================
    # Zoxide (Smarter cd)
    # ========================================================
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  # ============================================================
  # SERVICES
  # ============================================================
  services = {
    # GPG agent
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      maxCacheTtl = 7200;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };

  # ============================================================
  # XDG DIRECTORIES
  # ============================================================
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };

    # XDG MIME associations
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "application/pdf" = "firefox.desktop";
        "image/png" = "gimp.desktop";
        "image/jpeg" = "gimp.desktop";
      };
    };
  };

  # ============================================================
  # GTK THEME
  # ============================================================
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # ============================================================
  # FONTS
  # ============================================================
  fonts.fontconfig.enable = true;

  # ============================================================
  # DOTFILES & CONFIG FILES
  # ============================================================
  home.file = {
    # Vim configuration
    ".vimrc".text = ''
      syntax on
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase

      " Security
      set noswapfile
      set nobackup
      set noundofile

      " Quality of life
      set mouse=a
      set clipboard=unnamedplus

      " Better colors
      set termguicolors
    '';

    # Neovim init (simple config)
    ".config/nvim/init.lua".text = ''
            --[[
      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
      ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

      Production-Grade Neovim Configuration
      Optimized for Performance, Reliability, and Maintainability

      Author: Advanced Neovim User
      Repository: https://github.com/VoidNxSEC/nvim
      Last Updated: 2025

      Features:
      - Intelligent module loading with dependency management
      - Production-grade error handling and recovery
      - Performance profiling and monitoring
      - Environment-aware configuration
      - Graceful degradation strategies
      - Comprehensive logging infrastructure
      - Health check system
      - Development mode support
      --]]

      --------------------------------------------------------------------------------
      -- BOOTSTRAP: Pre-initialization and Environment Detection
      --------------------------------------------------------------------------------

      -- Performance tracking
      local bootstrap_start = vim.loop.hrtime()

      -- Global configuration state
      _G.nvim_config = {
        version = "2.0.0",
        start_time = bootstrap_start,
        environment = {
          is_nixos = vim.fn.executable("nix") == 1 or vim.env.NIX_PATH ~= nil,
          is_wsl = vim.fn.has("wsl") == 1,
          is_ssh = vim.env.SSH_CONNECTION ~= nil,
          is_dev_mode = vim.env.NVIM_DEV_MODE == "1",
        },
        state = {
          core_loaded = false,
          plugins_loaded = false,
          errors = {},
          warnings = {},
        },
        metrics = {
          module_load_times = {},
        },
      }

      -- Early leader key setup (must be done before any mappings)
      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"

      --------------------------------------------------------------------------------
      -- LOGGING INFRASTRUCTURE
      --------------------------------------------------------------------------------

      local log_levels = {
        TRACE = 0,
        DEBUG = 1,
        INFO = 2,
        WARN = 3,
        ERROR = 4,
        FATAL = 5,
      }

      local log_level = _G.nvim_config.environment.is_dev_mode and log_levels.DEBUG or log_levels.INFO

      _G.log = {
        trace = function(msg, data)
          if log_level <= log_levels.TRACE then
            vim.notify("[TRACE] " .. msg, vim.log.levels.TRACE, { title = "Neovim Config" })
            if data then print(vim.inspect(data)) end
          end
        end,
        debug = function(msg, data)
          if log_level <= log_levels.DEBUG then
            vim.notify("[DEBUG] " .. msg, vim.log.levels.DEBUG, { title = "Neovim Config" })
            if data then print(vim.inspect(data)) end
          end
        end,
        info = function(msg)
          if log_level <= log_levels.INFO then
            vim.notify("[INFO] " .. msg, vim.log.levels.INFO, { title = "Neovim Config" })
          end
        end,
        warn = function(msg)
          if log_level <= log_levels.WARN then
            vim.notify("[WARN] " .. msg, vim.log.levels.WARN, { title = "Neovim Config" })
            table.insert(_G.nvim_config.state.warnings, { time = os.date("%Y-%m-%d %H:%M:%S"), msg = msg })
          end
        end,
        error = function(msg, err)
          if log_level <= log_levels.ERROR then
            vim.notify("[ERROR] " .. msg, vim.log.levels.ERROR, { title = "Neovim Config" })
            table.insert(_G.nvim_config.state.errors, { time = os.date("%Y-%m-%d %H:%M:%S"), msg = msg, err = err })
          end
        end,
        fatal = function(msg, err)
          vim.notify("[FATAL] " .. msg, vim.log.levels.ERROR, { title = "Neovim Config" })
          table.insert(_G.nvim_config.state.errors, { time = os.date("%Y-%m-%d %H:%M:%S"), msg = msg, err = err, fatal = true })
        end,
      }

      --------------------------------------------------------------------------------
      -- MODULE LOADER WITH PROFILING AND ERROR RECOVERY
      --------------------------------------------------------------------------------

      ---@class ModuleLoader
      ---@field load fun(module: string, opts: table?): boolean, any
      local ModuleLoader = {}

      ---Load a module with comprehensive error handling and profiling
      ---@param module_name string The module to load (e.g., "core.options")
      ---@param opts table? Optional configuration { required: boolean, description: string, retry: boolean }
      ---@return boolean success, any result
      function ModuleLoader.load(module_name, opts)
        opts = opts or {}
        local description = opts.description or module_name
        local required = opts.required or false
        local retry_on_failure = opts.retry or false

        _G.log.debug("Loading module: " .. description)

        local start_time = vim.loop.hrtime()
        local success, result = pcall(require, module_name)
        local end_time = vim.loop.hrtime()
        local load_time = (end_time - start_time) / 1e6 -- Convert to milliseconds

        -- Store metrics
        _G.nvim_config.metrics.module_load_times[module_name] = load_time

        if success then
          _G.log.debug(string.format("✓ Loaded %s (%.2fms)", description, load_time))
          return true, result
        else
          local error_msg = string.format("Failed to load %s: %s", description, result)

          if required then
            _G.log.fatal(error_msg, result)
            -- For critical modules, we might want to show a more prominent error
            vim.api.nvim_err_writeln("CRITICAL ERROR: " .. error_msg)
          else
            _G.log.error(error_msg, result)
          end

          -- Retry logic for non-critical modules
          if retry_on_failure and not required then
            _G.log.warn("Attempting retry for " .. description)
            vim.defer_fn(function()
              pcall(require, module_name)
            end, 1000)
          end

          return false, result
        end
      end

      ---Load multiple modules in sequence
      ---@param modules table Array of module configurations
      ---@return boolean all_success
      function ModuleLoader.load_sequence(modules)
        local all_success = true
        for _, mod_config in ipairs(modules) do
          local success = ModuleLoader.load(mod_config.module, mod_config.opts)
          if not success and (mod_config.opts and mod_config.opts.required) then
            all_success = false
            break
          end
        end
        return all_success
      end

      --------------------------------------------------------------------------------
      -- HEALTH CHECK SYSTEM
      --------------------------------------------------------------------------------

      local HealthCheck = {
        checks = {},
        passed = 0,
        failed = 0,
        warnings = 0,
      }

      ---Register a health check
      ---@param name string Name of the check
      ---@param check_fn function Function that returns boolean and optional message
      function HealthCheck.register(name, check_fn)
        table.insert(HealthCheck.checks, { name = name, fn = check_fn })
      end

      ---Run all health checks
      function HealthCheck.run_all()
        _G.log.debug("Running health checks...")

        for _, check in ipairs(HealthCheck.checks) do
          local success, result = pcall(check.fn)
          if success and result then
            HealthCheck.passed = HealthCheck.passed + 1
            _G.log.trace("✓ Health check passed: " .. check.name)
          else
            HealthCheck.failed = HealthCheck.failed + 1
            _G.log.warn("✗ Health check failed: " .. check.name .. " - " .. tostring(result))
          end
        end

        if HealthCheck.failed > 0 then
          _G.log.warn(string.format("Health checks: %d passed, %d failed", HealthCheck.passed, HealthCheck.failed))
        else
          _G.log.debug(string.format("All health checks passed (%d)", HealthCheck.passed))
        end
      end

      -- Register basic health checks
      HealthCheck.register("Vim API availability", function()
        return vim.api ~= nil
      end)

      HealthCheck.register("Standard paths", function()
        return vim.fn.stdpath("config") ~= nil and vim.fn.stdpath("data") ~= nil
      end)

      HealthCheck.register("Clipboard support", function()
        return vim.fn.has("clipboard") == 1
      end)

      --------------------------------------------------------------------------------
      -- CORE MODULE INITIALIZATION
      --------------------------------------------------------------------------------

      _G.log.info("Initializing Neovim configuration v" .. _G.nvim_config.version)
      _G.log.debug("Environment: " .. vim.inspect(_G.nvim_config.environment))

      -- Run health checks
      HealthCheck.run_all()

      -- Define core modules to load
      local core_modules = {
        {
          module = "core.options",
          opts = { required = true, description = "Core options and settings" }
        },
        {
          module = "core.keymaps",
          opts = { required = true, description = "Core keymaps" }
        },
        {
          module = "core.autocmds",
          opts = { required = false, description = "Core autocommands" }
        },
      }

      -- Load core modules
      _G.log.info("Loading core modules...")
      local core_success = ModuleLoader.load_sequence(core_modules)

      if core_success then
        _G.nvim_config.state.core_loaded = true
        _G.log.info("✓ Core modules loaded successfully")
      else
        _G.log.fatal("Failed to load critical core modules")
      end

      --------------------------------------------------------------------------------
      -- UTILITIES INITIALIZATION
      --------------------------------------------------------------------------------

      local utils_success, utils = ModuleLoader.load("core.utils", {
        description = "Core utilities",
        required = false,
      })

      if utils_success then
        _G.utils = utils
      else
        -- Provide minimal fallback utilities
        _G.utils = {
          notify = function(msg, level)
            vim.notify(msg, level or vim.log.levels.INFO)
          end,
          is_available = function(plugin)
            local ok, _ = pcall(require, plugin)
            return ok
          end,
        }
        _G.log.warn("Using fallback utilities")
      end

      --------------------------------------------------------------------------------
      -- PLUGIN MANAGER INITIALIZATION
      --------------------------------------------------------------------------------

      _G.log.info("Initializing plugin manager...")

      local lazy_success = ModuleLoader.load("core.lazy", {
        description = "Plugin manager (lazy.nvim)",
        required = false,
      })

      if not lazy_success then
        if _G.nvim_config.environment.is_nixos then
          _G.log.info("Running in NixOS mode without lazy.nvim (managed by system)")
        else
          _G.log.warn("Plugin manager not available - running in minimal mode")
        end
      end

      --------------------------------------------------------------------------------
      -- PLUGIN CONFIGURATIONS
      --------------------------------------------------------------------------------

      _G.log.info("Loading plugin configurations...")

      local plugins_success = ModuleLoader.load("plugins", {
        description = "Plugin configurations",
        required = false,
      })

      if plugins_success then
        _G.nvim_config.state.plugins_loaded = true
        _G.log.info("✓ Plugin configurations loaded")
      else
        if _G.nvim_config.environment.is_nixos then
          _G.log.info("Plugin configurations handled by NixOS")
        else
          _G.log.warn("Plugin configurations not loaded")
        end
      end

      --------------------------------------------------------------------------------
      -- POST-INITIALIZATION AND FINALIZATION
      --------------------------------------------------------------------------------

      -- Calculate total startup time
      local bootstrap_end = vim.loop.hrtime()
      local total_time = (bootstrap_end - bootstrap_start) / 1e6 -- Convert to milliseconds

      _G.nvim_config.metrics.total_startup_time = total_time

      -- Log startup summary
      _G.log.info(string.format("Configuration loaded in %.2fms", total_time))

      if _G.nvim_config.environment.is_dev_mode then
        _G.log.debug("Module load times:")
        for module, time in pairs(_G.nvim_config.metrics.module_load_times) do
          _G.log.debug(string.format("  %s: %.2fms", module, time))
        end
      end

      -- Provide status command for users
      vim.api.nvim_create_user_command("NvimConfigStatus", function()
        local lines = {
          "Neovim Configuration Status",
          "Version: " .. _G.nvim_config.version,
          "",
          "Environment:",
          "  NixOS: " .. tostring(_G.nvim_config.environment.is_nixos),
          "  WSL: " .. tostring(_G.nvim_config.environment.is_wsl),
          "  SSH: " .. tostring(_G.nvim_config.environment.is_ssh),
          "  Dev Mode: " .. tostring(_G.nvim_config.environment.is_dev_mode),
          "",
          "State:",
          "  Core Loaded: " .. tostring(_G.nvim_config.state.core_loaded),
          "  Plugins Loaded: " .. tostring(_G.nvim_config.state.plugins_loaded),
          "  Errors: " .. #_G.nvim_config.state.errors,
          "  Warnings: " .. #_G.nvim_config.state.warnings,
          "",
          string.format("Startup Time: %.2fms", _G.nvim_config.metrics.total_startup_time),
        }

        if #_G.nvim_config.state.errors > 0 then
          table.insert(lines, "")
          table.insert(lines, "Recent Errors:")
          for _, err in ipairs(_G.nvim_config.state.errors) do
            table.insert(lines, "  [" .. err.time .. "] " .. err.msg)
          end
        end

        if #_G.nvim_config.state.warnings > 0 then
          table.insert(lines, "")
          table.insert(lines, "Recent Warnings:")
          for _, warn in ipairs(_G.nvim_config.state.warnings) do
            table.insert(lines, "  [" .. warn.time .. "] " .. warn.msg)
          end
        end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

        local width = 80
        local height = math.min(#lines + 2, vim.o.lines - 4)
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          col = (vim.o.columns - width) / 2,
          row = (vim.o.lines - height) / 2,
          style = "minimal",
          border = "rounded",
          title = " Neovim Config Status ",
          title_pos = "center",
        })

        vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
      end, { desc = "Show Neovim configuration status" })

      -- Success message
      if #_G.nvim_config.state.errors == 0 then
        _G.log.info("✅ Neovim configuration initialized successfully")
      else
        _G.log.warn(string.format("⚠️  Neovim started with %d errors", #_G.nvim_config.state.errors))
        _G.log.warn("Run :NvimConfigStatus for details")
      end

      -- Defer non-critical initialization to improve perceived startup time
      vim.defer_fn(function()
        -- Any deferred initialization can go here
        _G.log.debug("Deferred initialization complete")
      end, 100)


    '';

    # Desktop entry
    ".local/share/applications/htop.desktop".text = ''
      [Desktop Entry]
      Name=htop
      Comment=Interactive process viewer
      Exec=gnome-terminal -- htop
      Icon=utilities-system-monitor
      Type=Application
      Categories=System;Monitor;
    '';

    # GPU aliases (source file)
    ".config/NixHM/aliases/gpu.sh".source = ./aliases/gpu.sh;

    # GCloud aliases (source file)
    ".config/NixHM/aliases/gcloud.sh".source = ./aliases/gcloud.sh;

    # Local AI inference (source file)
    ".config/NixHM/aliases/multimodal.sh".source = ./aliases/multimodal.sh;

    # Starship prompt config (optional alternative to bash prompt)
    ".config/starship.toml".text = ''
      format = """
      [┌───────────────────>](bold green)
      [│](bold green)$directory$git_branch$git_status
      [└─>](bold green) """

      [directory]
      style = "blue"

      [git_branch]
      symbol = " "
      style = "red"

      [git_status]
      style = "red"
    '';
  };

  # ============================================================
  # SESSION VARIABLES
  # ============================================================
  home.sessionVariables = {
    # Editor & Browser
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "brave";
    TERMINAL = "gnome-terminal";

    # Python/Pipx
    PIPX_HOME = "${config.home.homeDirectory}/.local/share/pipx";
    PIPX_BIN_DIR = "${config.home.homeDirectory}/.local/bin";
    PIPX_MAN_DIR = "${config.home.homeDirectory}/.local/share/man";

    # Development
    GOPATH = "${config.home.homeDirectory}/go";

    # Security
    GNUPGHOME = "${config.home.homeDirectory}/.gnupg";

    # Anthropic
    ANTHROPIC_MODEL = "claude-sonnet-4-5-20250929";

    # XDG compliance
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
  };

  # ============================================================
  # SESSION PATH
  # ============================================================
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/go/bin"
  ];
}
