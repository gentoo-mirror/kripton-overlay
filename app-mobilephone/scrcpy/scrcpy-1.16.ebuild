# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

KEYWORDS="~amd64"

SRC_URI="https://github.com/Genymobile/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Genymobile/${PN}/releases/download/v${PV}/${PN}-server-v${PV}"

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://blog.rom1v.com/2018/03/introducing-scrcpy/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND="media-libs/libsdl2[X]
	media-video/ffmpeg"
RDEPEND="${DEPEND}"
PDEPEND=""

src_configure() {
	local emesonargs=(
		-Db_lto=true
		-Dprebuilt_server="${DISTDIR}/${PN}-server-v${PV}"
	)
	meson_src_configure
}
