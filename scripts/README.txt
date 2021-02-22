# UBOOT build scripts

+ rk/                      - rk folder descriptions
+ build.conf               - download and build config
+ download                 - downloader
+ krescue.image.conf.tpl   - krescue image script config
+ make                     - make khadas uboot script wrapper
+ make.inc                 - make sub inc 
+ make_all                 - make all images 
+ make_all_edge            - make EDGE 
+ make_aml_burn_images     - make aml-burn-images VIM1 VIM2 VIM3 VIM3L
+ make_krescue_image       - make kresq image
+ make_post                - make description
+ prepare                  - prepare tc


# Boards

khadas-vim khadas-vim2 khadas-vim3 khadas-vim3l khadas-edge-v-rk3399

# EXAMPLES

    export PATCH_DEBUG=1
    export PATCH_TEST=1

    ./make_all khadas-vim3l
    ./make_all khadas-vim3
    ./make_all khadas-vim2
    ./make_all khadas-vim