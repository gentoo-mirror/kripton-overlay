# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Pico SDK (C/C++) for RP2040-based devices such as the RaspberryPi Pico"
HOMEPAGE="https://github.com/raspberrypi/${PN}"

# We clone via git since we need to fetch the submodules
EGIT_REPO_URI="${HOMEPAGE}"
EGIT_COMMIT="${PV}"
EGIT_SUBMODULES=( tinyusb lib/tinyusb/tools/uf2 lib/tinyusb/lib/lwip lib/lwip lib/cyw43-driver )

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	# Not sure if /opt is the best place but it's mainly
	# "source code" for an embedded system, not for the host
	dodir /opt/raspberrypi/${P}
	# Remove all .git folders (including in submodules)
	# Drop output since there are some "folder not found" errors I don't understand
	find "${S}" -type d -name ".git" -exec rm -rf '{}' \; > /dev/null 2> /dev/null
	# Copy over everything not yet deleted
	cp -R "${S}" "${D}/opt/raspberrypi/" || die "Install failed!"
	mv "${D}/opt/raspberrypi/${P}" "${D}/opt/raspberrypi/${PN}" || die "Install failed!"
}

pkg_postinst() {
	elog "This ebuild only contains the files from the pico-sdk as they are found on github."
	elog "It does not contain the toolchain (compiler for the ARM Cortex-M0 core of the rp2040)."
	elog "You can either install the compiler using some binary download from ARM OR"
	elog "use Gentoo's great sys-devel/crossdev tool to compile the cross-compiler yourself."
	elog "If doing so, use \"arm-none-eabi\" as target."
	elog ""
	elog "You should also set the environment variable PICO_SDK_PATH to /opt/raspberrypi/${PN}"
	elog "so that pico-sdk based projects know where to find the pico-sdk"
}
