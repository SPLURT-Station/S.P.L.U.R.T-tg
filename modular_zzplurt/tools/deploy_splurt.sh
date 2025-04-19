#!/bin/bash

# This script will deploy our modular icon assets so iconforge can use them in spritesheet generation
# This includes modular_zzplurt/icons and greyscale json configs

mkdir -p \
    $1/modular_zzplurt/icons \
    $1/modular_zzplurt/code/datums/greyscale/json_configs

cp -r modular_zzplurt/icons/* $1/modular_zzplurt/icons/
cp -r modular_zzplurt/code/datums/greyscale/json_configs/* $1/modular_zzplurt/code/datums/greyscale/json_configs/
