# Copyright (C) 2017 AIMROM
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

# AIM versioning

PRODUCT_BRAND ?= AIMROM

AIM_BASE_VERSION = System-V3.0

#Good one lol
#ifndef AIM_BUILD_TYPE
#    AIM_BUILD_TYPE := UNOFFICIAL
#endif

ifeq ($(AIM_RELEASE), true)
	#Let's assume BUILD_TYPE is official as AIM_RELEASE checks
	AIM_BUILD_TYPE=OFFICIAL
	#Putting our assumption to check, let's see if it holds up
	ifeq ($(AIM_BUILD_TYPE), OFFICIAL)
		#Don't push vendor/key anywhere. it's maintainer specific
		CURRENT_MD5=$(shell md5 vendor/key/key.pub)
		#Remove existing key.list
		RM_KEY=$(shell rm -rf vendor/aim/config/md5.list)
		#Key list, needs to be updated if keys change
		MD5_LIST=$(shell curl -s https://raw.githubusercontent.com/AIMROM/android_vendor_aim/o/config/md5.list)
		FILTER_MD5=$(filter $(CURRENT_MD5), $(MD5_LIST))
		ifeq ($(FILTER_MD5), $(CURRENT_MD5))
			CHECKS=true
			AIM_BUILD_TYPE := OFFICIAL
		else
			CHECKS=false
			AIM_BUILD_TYPE := UNOFFICIAL
		endif
	endif
else
	AIM_BUILD_TYPE := UNOFFICIAL
endif

# Set all versions
AIM_VERSION := AIM-$(AIM_BASE_VERSION)-$(shell date -u +%Y%m%d)-$(AIM_BUILD_TYPE)-$(AIM_BUILD)

AIM_DISPLAY_VERSION := AIM-$(AIM_BASE_VERSION)-$(AIM_BUILD_TYPE)

AIM_MOD_VERSION := $(AIM_BASE_VERSION)-$(AIM_BUILD_TYPE)

# Overrides
PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.aim.version=$(AIM_VERSION) \
    ro.mod.version=$(AIM_MOD_VERSION)

# Display version
  PRODUCT_PROPERTY_OVERRIDES += \
  ro.aim.display.version=$(AIM_DISPLAY_VERSION)
