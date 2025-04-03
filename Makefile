#*******************************************************************************
#   Ledger App
#   (c) 2017 Ledger
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

APP_LOAD_PARAMS = --curve ed25519
APP_LOAD_PARAMS += --path "44'/508'"
APP_LOAD_PARAMS += $(COMMON_LOAD_PARAMS)

VARIANT_PARAM = COIN
VARIANT_VALUE = eGLD

APPNAME      = "MultiversX"
APPVERSION_M = 1
APPVERSION_N = 1
APPVERSION_P = 0
APPVERSION   = $(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)

# App source files
APP_SOURCE_PATH  += src
APP_SOURCE_PATH  += deps/ledger-zxlib/include deps/ledger-zxlib/src deps/uint256

# App icon
ifeq ($(TARGET_NAME),TARGET_NANOS)
    ICONNAME = icons/nanos_app_multiversx.gif
else ifeq ($(TARGET_NAME),TARGET_STAX)
    ICONNAME = icons/stax_app_multiversx.gif
else ifeq ($(TARGET_NAME),TARGET_FLEX)
    ICONNAME = icons/flex_app_multiversx.gif
else
    ICONNAME = icons/nanox_app_multiversx.gif
endif

DEFINES += JSMN_STRICT=1


########################################
# App communication interfaces         #
########################################
ENABLE_BLUETOOTH = 1

########################################
#         NBGL custom features         #
########################################
ENABLE_NBGL_QRCODE = 1

################
# Default rule #
################
all: default

############
# Platform #
############
DEFINES   += HAVE_SPRINTF

# U2F
SDK_SOURCE_PATH += lib_u2f
DEFINES   += HAVE_U2F HAVE_IO_U2F
DEFINES   += U2F_PROXY_MAGIC=\"eGLD\"

DEFINES   += UNUSED\(x\)=\(void\)x
DEFINES   += APPVERSION=\"$(APPVERSION)\"

# Enabling debug PRINTF
# DEBUG = 1

CFLAGS   += -O3 -Os
LDFLAGS  += -O3 -Os

display-params:
	echo "APP PARAMS"
	echo "$(shell printf '\\"%s\\" ' $(APP_LOAD_PARAMS))"

release: all
	export APP_LOAD_PARAMS_EVALUATED="$(shell printf '\\"%s\\" ' $(APP_LOAD_PARAMS))"; \
	cat load-template.sh | envsubst > load.sh
	chmod +x load.sh
	tar -zcf elrond-ledger-app-$(APPVERSION).tar.gz load.sh bin/app.hex
	rm load.sh

#add dependency on custom makefile filename
dep/%.d: %.c Makefile

include $(BOLOS_SDK)/Makefile.standard_app
