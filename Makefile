ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WINDIRMODE
WINDIRMODE_FILES = Tweak.xm
WINDIRMODE_CFLAGS = -fobjc-arc
WINDIRMODE_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
