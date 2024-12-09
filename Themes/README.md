
# Multi-Skin Theme Installer

This repository provides an installer script to easily set up, switch, or remove themes for your Klipper configuration.

## Usage

### Installing a Skin

1. Clone the repository to your local machine:

   ```bash
   cd ~
   git clone https://github.com/ArmoredTurtle/Art-Themes.git  
   ```

2. Run the installer script:

   ```bash
   cd Art-Themes/Themes
   ./install-skin.sh
   ```

3. Choose a skin from the list when prompted. If a theme is already installed, you'll have the option to update it with the selected skin.

### Changing Skins
2. Run the installer script:

   ```bash
   cd Art-Themes/Themes
   ./install-skin.sh
   ```

3. Choose a skin from the list when prompted. Your skin will be updated with the one you select.

### Uninstalling the Theme

To remove the current theme:

   ```bash
   cd Art-Themes/Themes
   ./install-skin.sh -u
   ```

This will remove the `.theme` folder in your Klipper configuration directory.

---

Enjoy your custom Armored Turtle Theme!

### Updates

Add the following to moonraker.conf if you would like to get updates to the skins
```
[update_manager client AT_Themes]
type: git_repo
path: ~/Art-Themes
origin: https://github.com/ArmoredTurtle/Art-Themes.git
primary_branch: main
is_system_service: False
```