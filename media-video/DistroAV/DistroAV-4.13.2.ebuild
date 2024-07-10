# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV="${PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="OBS plugin to integrate with the NDI SDK (formerly named obs-ndi)"
HOMEPAGE="https://github.com/DistroAV/DistroAV"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt6"

DEPEND="
	qt6? (
		dev-qt/qtbase:6
	)
        !qt6? (
		dev-qt/qtcore:5
	)
	>=media-video/obs-studio-28
	~media-video/ndi-sdk-bin-5.5.3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Patch the correct path to the NDI library into the source
	sed -e "s:/usr/lib:/usr/lib64:g" \
		-i "src/plugin-main.cpp" || die

	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

src_install() {
	insinto /usr/lib64/obs-plugins
	doins "../${MY_P}_build/obs-ndi.so"

	insinto "/usr/share/obs/obs-plugins/obs-ndi"
	doins -r "data/locale"

	dodoc README.md
}
