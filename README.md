# New Game Project 2

A 2D platformer game built with **Godot Engine 4.7** and **GDScript**, featuring precise platforming mechanics, multiple challenging levels, enemy encounters, and a star-based rating system.

---

## Game Description

New Game Project 2 is a fast-paced 2D platformer where players navigate through increasingly difficult levels, collecting coins, defeating enemies, and racing against the clock to achieve the best possible time. The game emphasizes tight controls, satisfying movement, and replayability through its three-star rating system.

---

## Key Features

### Gameplay Mechanics
- **Responsive Platforming** - Smooth character movement with variable jump height, run acceleration, and precise air control
- **Health System** - 3-heart health system with invincibility frames after taking damage
- **Collectibles** - Coins scattered throughout levels; collect all to complete the level
- **Power-ups** - Heart pickups (waffls) restore health when collected
- **Timer & Star Ratings** - Each level has par times for 3-star, 2-star, and 1-star ratings
- **Enemy Stomp Mechanics** - Defeat enemies by jumping on them from above; rewards bonus time

### Enemies
- **Green Slime** - Basic enemy, 1 HP, standard speed
- **Red Slime** - Variant with different visual appearance, same behavior
- **Patrol AI** - Enemies patrol platforms using raycasts, turning at edges

### Levels
| Level | Scene | 3-Star Time | 2-Star Time |
|-------|-------|-------------|-------------|
| Level 1 | `level_1.tscn` | 90s | 120s |
| Level 2 | `level_2.tscn` | 135s | 165s |

Levels unlock sequentially - earn at least 1 star to unlock the next level.

### UI & Systems
- **Main Menu** - Play, Quit, Music/SFX toggles
- **Level Select** - Visual level cards showing best stars/time
- **HUD** - Real-time timer, coin counter, health hearts
- **Pause Menu** - Resume, Restart, Return to Level Select
- **Game Over / Level Complete** - Animated panels with star rewards
- **Settings Persistence** - Best times, stars, and audio preferences saved locally

### Technical Features
- **Autoload Singletons** - Music, Settings, Levels managers
- **Touch Controls** - On-screen buttons for mobile play
- **Resolution Independent** - Canvas stretch mode with aspect preservation
- **Custom Input Map** - Keyboard (WASD/Arrows + Space) and gamepad support

---

## Technologies Used

| Category | Technology |
|----------|------------|
| **Engine** | Godot Engine 4.7 (Forward Plus renderer) |
| **Language** | GDScript |
| **Audio** | Custom bus layout, OGG/WAV assets |
| **Fonts** | PixelOperator8 (Regular & Bold) |
| **Input** | Custom input actions (Jump, L_move, R_move) |
| **Physics** | 2D Physics (CharacterBody2D, Area2D, RayCast2D) |
| **Animation** | AnimationPlayer, AnimatedSprite2D, Tweens |
| **UI** | Control nodes (HBoxContainer, VBoxContainer, Button, Label, etc.) |

---

## Screenshots

| Main Menu | Level Select | Gameplay | Game Over |
|-----------|--------------|----------|-----------|
| ![Main Menu](ScreenShot/Screenshot%20(1).png) | ![Level Select](ScreenShot/Screenshot%20(2).png) | ![Gameplay](ScreenShot/Screenshot%20(3).png) | ![Game Over](ScreenShot/Screenshot%20(4).png) |

---

## Project Structure

```
new-game-project-2/
├── assets/
│   ├── fonts/          # PixelOperator8 fonts
│   ├── music/          # Background music (time_for_adventure.mp3)
│   ├── sounds/         # SFX (jump, coin, hurt, explosion, power_up)
│   └── sprites/        # Heart texture, other sprites
├── scenes/
│   ├── level_1.tscn    # Level 1 scene
│   ├── level_2.tscn    # Level 2 scene
│   ├── level_free.tscn # Free play / test level
│   ├── player.tscn     # Player character (Astra)
│   ├── player0.tscn    # Alternative player variant
│   ├── slime.tscn      # Green slime enemy
│   ├── slime_red.tscn  # Red slime enemy
│   ├── coin.tscn       # Coin collectible
│   ├── waffl.tscn      # Heart pickup
│   ├── platform.tscn   # Platform template
│   ├── kill_zone.tscn  # Death zone / stomp detector
│   ├── main_menu.tscn  # Main menu UI
│   ├── level_select.tscn # Level selection screen
│   ├── game.tscn       # Main game scene (contains Gamemanager, HUD, Player)
│   ├── music.tscn      # Music player autoload
│   └── cloud.tscn      # Background decoration
├── scripts/
│   ├── game-manager.gd     # Core game logic (timer, health, coins, level flow)
│   ├── levels.gd           # Level definitions & unlock logic
│   ├── settings.gd         # Persistent settings (audio, best times/stars)
│   ├── player_0.gd         # Player movement & animation
│   ├── astra.gd            # Alternative player script
│   ├── slime.gd            # Base slime enemy behavior
│   ├── slime_red.gd        # Red slime variant
│   ├── coin.gd             # Coin pickup logic
│   ├── waffl.gd            # Heart pickup logic
│   ├── kill_zone.gd        # Stomp detection & death zones
│   ├── main_menu.gd        # Main menu UI logic
│   ├── level_select.gd     # Level select UI logic
│   ├── star_icon.gd        # Animated star display
│   ├── timer.gd            # Timer display component
│   ├── touch_controls.gd   # Mobile touch input
│   └── character_body_2d.gd # Base character physics
├── project.godot           # Godot project configuration
├── export_presets.cfg      # Export templates
├── icon.svg                # Application icon
└── README.md               # This file
```

---

## How to Run the Project

### Prerequisites
- **Godot Engine 4.7+** (Standard or .NET version)
  - Download from [godotengine.org](https://godotengine.org/download)

### Steps

1. **Clone or download** this repository
2. **Open Godot Engine**
3. Click **Import** → Browse to the project folder → Select `project.godot`
4. Click **Run Project** (F5) or press the **Play** button in the top-right

### Exporting Builds
1. Open **Project → Export...**
2. Add export templates if not already installed (Editor → Manage Export Templates)
3. Configure presets (Windows, Linux, macOS, Web, Android, iOS)
4. Click **Export Project...**

---

## Controls

| Action | Keyboard | Gamepad | Touch |
|--------|----------|---------|-------|
| Move Left | `A` / `←` | Left Stick / D-Pad Left | Left Button |
| Move Right | `D` / `→` | Left Stick / D-Pad Right | Right Button |
| Jump | `Space` / `W` / `↑` | A / Cross / South | Jump Button |
| Pause | `Esc` | Start / Options | Pause Button (top-right) |

---

## Git & GitHub Guide

### Initialize Local Repository

```bash
# Navigate to project folder
cd path/to/new-game-project-2

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: New Game Project 2 - Godot 4.7 platformer"
```

### Connect to GitHub

```bash
# Create a new repository on GitHub (via web UI), then:
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Rename default branch to main (optional but recommended)
git branch -M main

# Push to GitHub
git push -u origin main
```

### Standard Workflow

```bash
# Check status
git status

# Stage changes
git add .                    # Stage all changes
git add path/to/file.gd      # Stage specific file

# Commit changes
git commit -m "Descriptive message: what changed and why"

# Pull latest changes (before pushing)
git pull origin main

# Push changes
git push origin main
```

### Useful Commands

```bash
# View commit history
git log --oneline -10

# View differences
git diff                    # Unstaged changes
git diff --staged           # Staged changes

# Create feature branch
git checkout -b feature/new-enemy-type

# Switch branches
git checkout main
git checkout feature/new-enemy-type

# Merge feature branch
git checkout main
git merge feature/new-enemy-type

# Delete merged branch
git branch -d feature/new-enemy-type

# Stash uncommitted changes temporarily
git stash
git stash pop
```

### .gitignore (Already Included)

The project includes a `.gitignore` tailored for Godot projects:

```gitignore
# Godot-specific
.godot/
*.uid
*.translation
export_presets.cfg

# OS/Editor
.DS_Store
Thumbs.db
*.swp
*.swo
*~

# Exports
*.exe
*.pck
*.zip
```

---

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details (add one if needed).

---

## Credits

- **Engine**: Godot Engine contributors
- **Font**: PixelOperator by Jayvee Enaguas
- **Music**: "Time for Adventure" (royalty-free)
- **Sound Effects**: Various royalty-free sources

---

## Support

For issues, suggestions, or contributions, please open an issue on the GitHub repository.

---

*Built with ❤️ using Godot Engine*