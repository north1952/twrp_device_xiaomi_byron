#
# Local reconstructed TWRP product definition for Xiaomi byron (sm8750_thales family).
#
# The build tree directory / DEVICE_PATH intentionally stays
# "device/xiaomi/sm8750_thales" so that prebuilt modules gated on
# $(TARGET_DEVICE) == sm8750_thales (see Android.mk) keep building.
#

PRODUCT_PLATFORM := xiaomi_sm8750
DEVICE_PATH := device/xiaomi/sm8750_thales

$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_DEVICE := sm8750_thales
PRODUCT_NAME := twrp_sm8750_thales
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 2605EPN8EC
PRODUCT_MANUFACTURER := Xiaomi

$(call inherit-product, $(DEVICE_PATH)/device.mk)
