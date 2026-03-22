# Nebula Shell

*Your desktop, illuminated.*

A cosmic Quickshell desktop shell for Hyprland, inspired by the beauty of deep-space nebulae. Colors shift with your wallpaper through matugen — your wallpaper is the star, the UI is the illuminated cloud.

## Features

- **Dynamic theming** — Matugen integration pulls colors from your wallpaper
- **Curated base palette** — Catppuccin Mocha as the default "nebula" theme
- **Preset cosmic themes** — Pulsar (Tokyo Night), Supernova (One Dark), Void (Gruvbox)
- **Multi-monitor** — Automatic per-screen shell instances
- **Modular design** — Components built independently, swap freely

## Project Structure

```
nebula-shell/
├── shell.qml                    # Entry point (PanelWindow per screen)
├── Matugen.qml                  # Dynamic color loader (FileView + watchChanges)
├── modules/
│   ├── Theme.qml                # Base color definitions (Singleton)
│   ├── GlobalStates.qml         # UI state singleton (sidebar, launcher, DND, dock, lock)
│   └── Icons.qml                # Material Symbols font loader + icon map
├── components/
│   ├── Bar.qml                  # Nebula Core — left/center/right bar layout
│   ├── Dock.qml                 # Accretion Disk — pinned + running apps (bottom)
│   ├── Launcher.qml             # Stellar Nursery — app search popup
│   ├── Notifications.qml        # Solar Flares — toast notifications
│   ├── OSD.qml                  # Pulsar Pills — volume/brightness overlay
│   ├── Sidebar.qml              # Event Horizon Panel — control center
│   ├── WorkspaceOverview.qml    # 2×5 grid of workspaces
│   ├── LockScreen.qml           # Event Horizon — lock screen
│   ├── Screenshot.qml           # Screenshot tool (full, selection, window)
│   ├── bar/
│   │   ├── BarButton.qml        # Generic hoverable button
│   │   ├── LauncherButton.qml   # Opens launcher
│   │   ├── Workspaces.qml       # 3 persistent workspace buttons
│   │   ├── Clock.qml            # Clock + calendar tooltip
│   │   ├── Audio.qml            # Pipewire volume + mute
│   │   ├── SystemTray.qml       # System tray icons
│   │   └── Media.qml            # MPRIS player controls (conditional)
│   └── dock/
│       └── DockApp.qml          # Individual dock app icon + running indicator
├── assets/
│   └── fonts/
│       └── MaterialSymbolsOutlined.woff2
├── scripts/
│   └── powermenu.sh             # Power menu (Lock/Logout/Suspend/Reboot/Shutdown)
├── services/
│   └── Services.qml             # System integrations (placeholder)
├── themes/
│   ├── nebula.json              # Catppuccin Mocha base
│   ├── pulsar.json              # Tokyo Night
│   ├── supernova.json           # One Dark
│   └── void.json                # Gruvbox Dark
└── flake.nix                    # Nix flake for packaging
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

## Requirements

- [Quickshell](https://quickshell.org) (Qt6/QML shell toolkit)
- [Hyprland](https://hyprland.org) (Wayland compositor)
- [matugen](https://github.com/InioX/matugen) (optional, for dynamic colors)
- `qt6Packages.qt5compat` (for blur effects)
- `JetBrainsMono Nerd Font`

## License

MIT
