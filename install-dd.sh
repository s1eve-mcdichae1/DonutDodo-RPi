#!/bin/bash

SCRIPTDIR="$(dirname "$0")"
SCRIPTDIR="$(cd "$SCRIPTDIR" && pwd)"
readonly SCRIPTDIR

MODE="install"
case "${1,,}" in
    -r|--remove)
        MODE="remove"
        shift
        ;;
esac
readonly MODE

RPS_HOME="$HOME/RetroPie-Setup"
[[ -n "$1" ]] && RPS_HOME="$1"
readonly RPS_HOME

readonly VENDOR="PixelGames"
readonly MODULE="donutdodo"
readonly SECTION="ports"

readonly INSTALL_DIR="$RPS_HOME/ext/$VENDOR"
readonly SCRIPT="$INSTALL_DIR/scriptmodules/$SECTION/$MODULE.sh"

readonly GAMEDIR="$HOME/RetroPie/roms/ports/DonutDodo"

if [[ ! -d "$RPS_HOME" ]]; then
    echo -e "Error: RetroPie-Setup directory $RPS_HOME does not exist. Please input the location of RetroPie-Setup, ex:\n\n    bash ./$(basename "$0") [-r] /home/pi/RetroPie-Setup\n\nAborting."
    exit
fi

case "$MODE" in
    install)
        echo "Copying scriptmodule $SECTION/$MODULE.sh to $INSTALL_DIR"
        mkdir -p "$INSTALL_DIR"
        cp -rfp "$SCRIPTDIR/scriptmodules" "$INSTALL_DIR" && echo -e "...done.\n"

        echo "Executing: sudo $RPS_HOME/retropie_packages.sh donutdodo"
        sudo "$RPS_HOME/retropie_packages.sh" donutdodo && echo -e "...RetroPie module installation complete.\n"

        if [[ -d "$GAMEDIR" ]]; then
            echo "Copying gamedata files to $GAMEDIR (this may take a few moments...)"
            if cp -rfp "$SCRIPTDIR/gamedata/"* "$GAMEDIR"; then
                chmod +x "$GAMEDIR/DonutDodo.pi" && echo -e "...done.\n"
            fi
        else
            echo -e "Game directory $GAMEDIR not found. Please copy the gamedata files to your roms directory under ports/DonutDodo.\n"
        fi
        ;;
    remove)
        echo "Executing: sudo $RPS_HOME/retropie_packages.sh donutdodo remove"

        if sudo "$RPS_HOME/retropie_packages.sh" donutdodo remove; then
            echo "Removing scriptmodule $SCRIPT..."
            rm -f "$SCRIPT" && echo -e "...done.\n"
        fi

        if [[ ! -d "$INSTALL_DIR" ]]; then
            echo -e "Module directory $INSTALL_DIR not found. Nothing to remove.\n\nAborting."
            exit
        fi

        if [[ -z "$(find "$INSTALL_DIR" -type f)" ]]; then
            echo "No scriptmodules remain. Removing empty directory $INSTALL_DIR."
            rm -rf "$INSTALL_DIR" && echo -e "...done.\n"
        fi
        ;;
esac
