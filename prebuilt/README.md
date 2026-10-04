Prebuilt blobs for the Xiaomi 17 Max (byron) recovery build.

| File                       | Size       | Source                                                        |
| -------------------------- | ---------- | ------------------------------------------------------------- |
| `Image`                    | 21,339,168 | byron `boot.img` — ARM64 kernel, raw (`0x644d5241` @ offset 56) |
| `dtb.img`                  | 20,237,792 | byron `boot.img` — `kernel_dtb` (FDT `d00dfeed`)                |
| `dlkm/msm_drm.ko`          | 6,855,496  | byron `vendor_boot.img` vendor ramdisk (`lib/modules/msm_drm.ko`) |
| `hostfs_tool`              | 7,747,096  | carries over from the popsicle tree                            |

Kernel identification string:

```
6.12.69-android16-6-g586bfab1b9c5-abogki536749445-4k (kleaf@build-host)
(Android (14043575, +pgo,+bolt,+lto,+mlgo, ...))
```

This matches the kernel version reported by the retail device, confirming the
`Image`/`dtb.img` pair came from byron's own Android 17 (SDK 37) `boot.img`
and not from another 17-series device.

Sources of the originals on the build host:

- `images/boot.img` (byron, Android 17 / SDK 37)
  -> `magiskboot unpack` -> `kernel` (= `prebuilt/Image`)
                          -> `kernel_dtb` (= `prebuilt/dtb.img`)

`dlkm/msm_drm.ko` has been replaced with byron's own module, extracted from the
`vendor_boot` partition of the official Android 17 (SDK 37) OTA package
(`byron-ota_full-OS4.0.0.22.XAFCNXM-user-17.0-*.zip`, `post-sdk-level=37`,
`pre-device=byron`) with `payload-dumper-go`. md5 `2218a6b580709687b5018c7c19d77b93`.

Touch / NFC / haptics modules listed in `TW_LOAD_VENDOR_MODULES` are **not**
bundled here (matching the upstream tree's design) — TWRP loads those from the
device's own vendor / vendor_dlkm partition at runtime.
