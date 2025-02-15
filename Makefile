RIME_ROOT = $(CURDIR)

sharedir = $(DESTDIR)/usr/share
bindir = $(DESTDIR)/usr/bin

.PHONY: all thirdparty xcode clean\
librime librime-static install-librime uninstall-librime \
release debug test install uninstall install-debug uninstall-debug \
install-static uninstall-static

all: release

thirdparty:
	make -f thirdparty.mk

thirdparty/%:
	make -f thirdparty.mk $(@:thirdparty/%=%)

xcode:
	make -f xcode.mk

xcode/%:
	make -f xcode.mk $(@:xcode/%=%)

clean:
	rm -Rf build build-static debug

librime: release
install-librime: install
uninstall-librime: uninstall

librime-static:
	cmake . -Bbuild-static \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_STATIC=ON \
	-DBUILD_SHARED_LIBS=OFF
	cmake --build build-static

release:
	cmake . -Bbuild \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_MERGED_PLUGINS=OFF
	cmake --build build

merged-plugins:
	cmake . -Bbuild-static \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_SHARED_LIBS=OFF \
	-DBUILD_MERGED_PLUGINS=ON
	cmake --build build-static

debug:
	cmake . -Bdebug \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Debug
	cmake --build debug

install:
	cmake --build build --target install

install-static:
	cmake --build build-static --target install

install-debug:
	cmake --build debug --target install

uninstall:
	cmake --build build --target uninstall

uninstall-debug:
	cmake --build debug --target uninstall

uninstall-static:
	cmake --build build-static --target uninstall

test: release
	(cd build/test; ./rime_test)

test-debug: debug
	(cd debug/test; ./rime_test)
