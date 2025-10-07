nixos/
├── flake.lock
├── flake.nix
├── hosts
│   └── kernelcore
│       ├── configuration.nix
│       ├── default.nix
│       ├── hardware-configuration.nix
│       └── home
│           ├── aliases
│           │   ├── gcloud.sh
│           │   ├── gpu.sh
│           │   └── multimodal.sh
│           └── home.nix
├── lib
│   ├── packages.nix
│   ├── shell.nix.backup
│   └── shells.nix
├── modules
│   ├── containers
│   │   ├── docker.nix
│   │   └── nixos-containers.nix
│   ├── debug
│   │   ├── debug-init.nix
│   │   └── test-init.nix
│   ├── development
│   │   ├── environments.nix
│   │   └── jupyter.nix
│   ├── hardware
│   │   ├── intel.nix
│   │   └── nvidia.nix
│   ├── programs
│   │   └── default.nix
│   ├── security
│   │   ├── boot.nix
│   │   ├── hardening.nix
│   │   └── network.nix
│   ├── services
│   │   └── default.nix
│   ├── system
│   │   ├── memory.nix
│   │   ├── nix.nix
│   │   └── services.nix
│   └── virtualization
│       └── vms.nix
├── sec
│   ├── hardening.nix
│   └── user-password
└── secrets
    ├── api.yaml
    ├── aws.yaml
    ├── database.yaml
    ├── github.yaml
    ├── prod.yaml
    ├── ssh-keys
    │   ├── dev.yaml
    │   ├── production.yaml
    │   └── staging.yaml
    └── ssh.yaml

19 directories, 40 files