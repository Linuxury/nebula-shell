# Nebula Shell

*Your desktop, illuminated.*

A cosmic Quickshell desktop shell for Hyprland, inspired by the beauty of deep-space nebulae. Colors shift with your wallpaper through matugen — your wallpaper is the star, the UI is the illuminated cloud.

> **Status:** Phase 1 — Skeleton. Active development.

## Features

- **Dynamic theming** — Matugen integration pulls colors from your wallpaper
- **Curated base palette** — Catppuccin Mocha as the default "nebula" theme
- **Preset cosmic themes** — Pulsar (Tokyo Night), Supernova (One Dark), Void (Gruvbox)
- **Multi-monitor** — Automatic per-screen shell instances
- **Modular design** — Components built independently, swap freely

## Project Structure

```
nebula-shell/
├── shell.qml           # Entry point
├── Theme.qml           # Base color definitions
├── Matugen.qml         # Dynamic color loader
├── components/
│   ├── Bar.qml         # Nebula Core (Phase 2)
│   ├── Dock.qml        # Accretion Disk (Phase 3)
│   ├── Launcher.qml    # Stellar Nursery (Phase 4)
│   ├── Sidebar.qml     # Event Horizon Panel (Phase 5)
│   ├── Notifications.qml # Solar Flares (Phase 4)
│   ├── OSD.qml         # Pulsar Pills (Phase 4)
│   └── LockScreen.qml  # Event Horizon (Phase 7)
├── themes/
│   ├── nebula.json     # Catppuccin Mocha base
│   ├── pulsar.json     # Tokyo Night
│   ├── supernova.json  # One Dark
│   └── void.json       # Gruvbox Dark
└── flake.nix           # Nix flake for packaging
```

## Installation

### NixOS (flake input)

Add to your `flake.nix`:

```nix
nebula-shell = {
  url = "github:Linuxury/nebula-shell";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Then in your Hyprland module:

```nix
environment.systemPackages = [ inputs.nebula-shell.packages.${pkgs.system}.default ];
```

Symlink to Quickshell config:

```nix
home.file.".config/quickshell".source = "${inputs.nebula-shell}/.";
```

### Manual

```bash
git clone https://github.com/Linuxury/nebula-shell.git ~/.config/quickshell
```

## Usage

```bash
qs                          # Start Quickshell with nebula-shell
qs ipc call globalIPC ...   # IPC commands (future)
```

## Cosmic Naming Convention

| Nebula Concept | Shell Feature |
|---|---|
| Gas clouds illuminated by stars | Matugen colors from wallpaper |
| Nebula regions (core, halo, rim) | UI zones (bar, sidebar, notifications) |
| Accretion disk | Dock |
| Solar flares | Notifications |
| Stellar nursery | Launcher |
| Event horizon | Lock screen |
| Pulsar | System tray / update badge |
| Dark matter | Transparent/blur regions |

## Roadmap

- [x] Phase 1 — Skeleton: shell.qml, Theme.qml, services, matugen pipeline
- [ ] Phase 2 — Bar: left/center/right widgets
- [ ] Phase 3 — Dock: pinned + running apps
- [ ] Phase 4 — Launcher + Notifications + OSD
- [ ] Phase 5 — Sidebar / Control Center
- [ ] Phase 6 — Workspace Overview
- [ ] Phase 7 — Lock Screen + Login Manager
- [ ] Phase 8 — Screenshot tool, polish, multi-monitor

## Requirements

- [Quickshell](https://quickshell.org) (Qt6/QML shell toolkit)
- [Hyprland](https://hyprland.org) (Wayland compositor)
- [matugen](https://github.com/InioX/matugen) (optional, for dynamic colors)
- `qt6Packages.qt5compat` (for blur effects)
- `JetBrainsMono Nerd Font`

## License

MIT
