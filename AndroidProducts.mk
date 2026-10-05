#
# Copyright (C) 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/twrp_sm8750_thales.mk

# V9: bp2a == android-16.0.0_r1 (the tag locked by the twrp-16.0 manifest
# default.xml). ap2a is the Android 14/15 era release config and was a
# mis-pick in V1-V8. TWRP twrp-16.0 documents BP2A explicitly
# (MissMyTime/twrp_device_sm8850 docs/BUILD.md has a "Wrong lunch target"
# section warning against non-BP2A targets).
COMMON_LUNCH_CHOICES := \
    twrp_sm8750_thales-bp2a-eng
