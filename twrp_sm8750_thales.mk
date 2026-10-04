#
# Local reconstructed TWRP product definition for Xiaomi byron (sm8750_thales family).
#
# The build tree directory / DEVICE_PATH intentionally stays
# "device/xiaomi/sm8750_thales" so that prebuilt modules gated on
# $(TARGET_DEVICE) == sm8750_thales (see Android.mk) keep building.
#

# The manifest's prebuilt CrashRecovery module SDK declares a
# systemserverclasspath_fragment whose contents ("service-crashrecovery") must
# also be listed by the product. Without this, Soong aborts while generating
# out/soong/build.twrp_sm8750_thales.ninja with:
#   module "prebuilt_com.android.crashrecovery-systemserverclasspath-fragment"
#   variant "android_common": [service-crashrecovery] in contents must also be
#   declared in PRODUCT_APEX_SYSTEM_SERVER_JARS
# Recovery has no system server, so this list would otherwise stay empty.
PRODUCT_APEX_SYSTEM_SERVER_JARS += service-crashrecovery

PRODUCT_PLATFORM := xiaomi_sm8750
DEVICE_PATH := device/xiaomi/sm8750_thales

$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_DEVICE := sm8750_thales
PRODUCT_NAME := twrp_sm8750_thales
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 2605EPN8EC
PRODUCT_MANUFACTURER := Xiaomi

$(call inherit-product, $(DEVICE_PATH)/device.mk)
