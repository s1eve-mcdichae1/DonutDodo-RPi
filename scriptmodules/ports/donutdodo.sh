#!/usr/bin/env bash

# Installation scriptmodule for use with RetroPie
# For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://retropie.org.uk/forum
#

rp_module_id="donutdodo"
rp_module_desc="A classic 1983 style arcade game"
rp_module_help="Copy DonutDodo.pck and .pi to $romdir/ports/DonutDodo\n\nMake sure DonutDodo.pi is made executable (chmod +x DonutDodo.pi)"
rp_module_license="PROP"
rp_module_section="exp"
rp_module_flags="!all rpi"

function install_bin_donutdodo() {
    touch "$md_inst/retropie.pkg"
}

function configure_donutdodo() {
    addPort "$md_id" "donutdodo" "Donut Dodo - Classic Arcade Action" "$romdir/ports/DonutDodo/DonutDodo.pi"
    mkRomDir "ports/DonutDodo"
    moveConfigDir "$home/.local/share/DonutDodoArcade" "$md_conf_root/donutdodo"
}
