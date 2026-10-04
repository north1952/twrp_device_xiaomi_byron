# TWRP Device Tree for Xiaomi 17 Max (byron)

Device tree for building Team Win Recovery Project (TWRP) for the Xiaomi 17 Max
(`byron`, model `2605EPN8EC`).

## Device Information

| Property     | Value                                          |
| ------------ | ---------------------------------------------- |
| Device       | Xiaomi 17 Max                                  |
| Codename     | byron                                          |
| Model        | 2605EPN8EC                                     |
| Manufacturer | Xiaomi                                         |
| Platform     | Qualcomm SM8850 / sm8750_thales family (canoe) |
| Architecture | arm64                                          |
| System base  | Android 17 (SDK 37) / HyperOS 4                |

## Provenance — how this tree was produced

This tree is a derivative of the Xiaomi 17 series device trees published by
[antocorvo3000](https://github.com/antocorvo3000/twrp-xiaomi-17-series)
specifically the `twrp_device_xiaomi_popsicle` tree (Xiaomi 17 Pro Max), which
shares the SM8850 platform with byron. Adaptations for byron:

* Product / lunch kept at the upstream-proven `twrp_sm8750_thales` naming with
  the tree living at `device/xiaomi/sm8750_thales`, so the
  `$(TARGET_DEVICE) == sm8750_thales` gate in `Android.mk` (which builds the
  `hostfs_tool` prebuilt) keeps working.
* `PRODUCT_MODEL` set to `2605EPN8EC` (byron).
* Popsicle-specific touch firmware blobs removed from
  `recovery/root/odm/firmware/` (goodix / synaptics per-device images).
* `recovery.fstab` `/data` entry carries byron's stock
  `fileencryption=ice` + `metadata_encryption=ice` (taken from the official
  `recovery.fstab` extracted from the device).
* `prebuilt/Image` and `prebuilt/dtb.img` replaced with the kernel and dtb
  extracted from **byron's own Android 17 (SDK 37) `boot.img`**.
* `recovery/root/.../init.recovery.qcom.rc` and the ODM variant script
  adjusted for byron.

## Prebuilt blobs

| File                       | Size       | Source                                                     |
| -------------------------- | ---------- | ---------------------------------------------------------- |
| `prebuilt/Image`           | 21,339,168 | byron `boot.img` kernel (ARM64, `6.12.69-android16-6-g586bfab1b9c5`) |
| `prebuilt/dtb.img`         | 20,237,792 | byron `boot.img` `kernel_dtb`                              |
| `prebuilt/dlkm/msm_drm.ko` | 6,594,608  | **placeholder** — inherited from the popsicle tree         |
| `prebuilt/hostfs_tool`     | 7,747,096  | inherited from the popsicle tree                           |

> ⚠️ `prebuilt/dlkm/msm_drm.ko` is the popsicle module and has **not** been
> rebuilt against byron's kernel. It is included so the recovery ramdisk
> assembles. If the display does not come up, replace this first (extract
> `msm_drm.ko` from byron's `vendor_boot.img` / `vendor_dlkm`).

## Building

```
repo init --depth=1 -u https://github.com/TWRP-Test/platform_manifest_twrp_aosp -b twrp-16.0
repo sync -j8 --force-sync
git clone https://github.com/north1952/twrp_device_xiaomi_byron -b main device/xiaomi/sm8750_thales
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_sm8750_thales-eng
mka recoveryimage
```

Output: `out/target/product/sm8750_thales/recovery.img`

## Status

**Compiled from source; NOT verified on real hardware.** Treat as
experimental. For brick rescue, the stock `recovery.img` remains the reliable
fallback.

### Notes on the decrypt runtime (inherited from upstream)

The decrypt path (`system/vold/Decrypt.cpp`) carries the upstream fix for an
AES-256-GCM authentication-tag handling bug in the synthetic-password unwrap
path — see `patches/0001-vold-fix-synthetic-password-gcm.patch`.

### Known issue (inherited from upstream)

Flashing a ROM update can leave a running recovery unable to mount storage
until recovery is rebooted (stale `dm-linear` mappings for the dynamic "super"
partitions). Not byron-specific.

## Credits

* [antocorvo3000](https://github.com/antocorvo3000/twrp-xiaomi-17-series) — the
  Xiaomi 17 series TWRP device trees this is derived from.
* Team Win Recovery Project (TWRP)
* Android Open Source Project (AOSP)

## License

Apache License 2.0, following the upstream repository this is derived from.
