# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A tool for inspecting RP2040 binaries and interacting with RP2040 devices."
HOMEPAGE="https://github.com/raspberrypi/picotool"

SRC_URI="https://github.com/raspberrypi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

DEPEND="virtual/libusb:1"
BDEPEND="${DEPEND}
	dev-embedded/pico-sdk
	virtual/pkgconfig"
RDEPEND="${DEPEND}"

src_prepare() {
	export PICO_SDK_PATH=/opt/raspberrypi/pico-sdk/
	cmake_src_prepare
}

src_install() {
	dobin "${BUILD_DIR}/picotool"
}
