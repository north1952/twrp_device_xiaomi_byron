#!/system/bin/sh
# combined_v26 multi-device variant/UI script.
# Keeps combined_v26 runtime behavior and applies only per-variant overlays.

set -e

variant="$(getprop ro.boot.hardware.sku)"
[ -n "$variant" ] || variant="$(getprop ro.product.device)"
log_file="/tmp/recovery.log"

log_msg() {
    echo "combined_v26 variant-script: $1" | tee -a "$log_file" >/dev/null
}

set_vibrator_props() {
    resetprop ro.odm.mm.vibrator.audio_haptic_support "true"
    resetprop ro.odm.mm.vibrator.resonant_frequency "$1"
    resetprop ro.odm.mm.vibrator.slide_effect_protect_time "$2"
    resetprop ro.odm.mm.vibrator.sys_path "$3"
    resetprop ro.odm.mm.vibrator.device_type "$4"
    resetprop ro.vendor.mm.vibrator.sys_path "/sys/class/qcom-haptics"
}

copy_tree_contents() {
    src="$1"
    dst="$2"
    if [ -d "$src" ]; then
        cp -rf "$src/." "$dst/" 2>/dev/null || true
    fi
}

ui_version=""
model=""

case "$variant" in
"pudding")
    model="Xiaomi 17"
    ui_version="antocorvo3000_pudding"
    resetprop ro.twrp.device_version "$ui_version"
    resetprop ro.twrp.version "3.7.1_16-$ui_version"
    resetprop ro.twrp.target.devices "antocorvo3000_combined_v26"
    resetprop ro.twrp.y_offset "116"
    resetprop ro.twrp.h_offset "-116"
    resetprop ro.odm.mm.vibrator.lowPowerMode "true"
    resetprop vendor.display.enable_spr "1"
    resetprop ro.keymint "thales"
    set_vibrator_props "170" "35" "/sys/class/qcom-haptics" "agm"
    ;;

"pandora")
    model="Xiaomi 17 Pro"
    ui_version="antocorvo3000_pandora"
    resetprop ro.twrp.device_version "$ui_version"
    resetprop ro.twrp.version "3.7.1_16-$ui_version"
    resetprop ro.twrp.target.devices "antocorvo3000_combined_v26"
    resetprop ro.twrp.y_offset "116"
    resetprop ro.twrp.h_offset "-116"
    resetprop ro.odm.mm.vibrator.lowPowerMode "true"
    resetprop vendor.display.enable_spr "1"
    resetprop vendor.display.enable_spr_bypass "0"
    resetprop vendor.display.enable_spr_bypass_secondary "1"
    resetprop ro.keymint "nxp"
    set_vibrator_props "170" "35" "/sys/class/qcom-haptics" "agm"
    ;;

"byron")
    model="Xiaomi 17 Pro Max"
    ui_version="antocorvo3000_byron"
    resetprop ro.twrp.device_version "$ui_version"
    resetprop ro.twrp.version "3.7.1_16-$ui_version"
    resetprop ro.twrp.target.devices "antocorvo3000_combined_v26"
    resetprop ro.twrp.y_offset "116"
    resetprop ro.twrp.h_offset "-116"
    resetprop ro.odm.mm.vibrator.cirrus "true"
    resetprop ro.odm.mm.vibrator.lowPowerMode "true"
    resetprop vendor.display.enable_spr "0"
    resetprop vendor.display.enable_spr_bypass "1"
    resetprop vendor.display.enable_spr_bypass_secondary "1"
    resetprop ro.keymint "nxp"
    set_vibrator_props "130" "20" "/sys/bus/i2c/drivers/cs40l26/13-0043" "agm"
    ;;

"nezha")
    model="Xiaomi 17 Ultra"
    ui_version="antocorvo3000_nezha"
    resetprop ro.twrp.device_version "$ui_version"
    resetprop ro.twrp.version "3.7.1_16-$ui_version"
    resetprop ro.twrp.target.devices "antocorvo3000_combined_v26"
    resetprop ro.twrp.y_offset "116"
    resetprop ro.twrp.h_offset "-116"
    resetprop ro.odm.mm.vibrator.lowPowerMode "true"
    resetprop vendor.display.enable_spr "0"
    resetprop vendor.display.enable_spr_bypass "1"
    resetprop vendor.display.enable_spr_bypass_secondary "1"
    resetprop ro.keymint "thales"
    set_vibrator_props "170" "20" "/sys/class/qcom-haptics" "agm"
    ;;

*)
    log_msg "unknown variant: $variant; leaving runtime untouched"
    exit 0
    ;;
esac

echo "$ui_version" >/config/usb_gadget/g1/strings/0x409/product 2>/dev/null || true
resetprop vendor.usb.product_string "$ui_version"
mkdir -p /usbotg

device_props="
ro.build.product
ro.product.device
ro.product.odm.device
ro.product.vendor.device
ro.product.product.device
ro.product.system_ext.device
ro.product.system.device
ro.product.bootimage.device
ro.product.name
ro.product.odm.name
ro.product.vendor.name
ro.product.product.name
ro.product.system_ext.name
ro.product.system.name
"

model_props="
ro.product.model
ro.product.odm.model
ro.product.vendor.model
ro.product.product.model
ro.product.system_ext.model
ro.product.system.model
"

for prop in $device_props; do
    resetprop "$prop" "$variant"
done

for prop in $model_props; do
    resetprop "$prop" "$model"
done

copy_tree_contents "/odm/variant/$variant/odm" "/odm"
copy_tree_contents "/odm/variant/$variant/vendor" "/vendor"
copy_tree_contents "/odm/variant/$variant/system" "/system"
chmod -R 755 /odm/bin/* 2>/dev/null || true
chmod -R 755 /odm/bin/hw/* 2>/dev/null || true
chmod -R 755 /vendor/bin/* 2>/dev/null || true
chmod -R 755 /vendor/bin/hw/* 2>/dev/null || true
setprop twrp.variant.detected "$variant"
setprop twrp.variant.files_copied "1"

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 0.5
done
sleep 3
stop odm.vibratorfeature-hal-service
stop odm.touch_report
sleep 1
start odm.vibratorfeature-hal-service
start odm.touch_report

log_msg "Applied $ui_version for $model ($variant)"
exit 0
