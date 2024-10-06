# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Author: Michael Kefeder (m.kefeder@gmail.com)
# Author: Patrik Pfaffenbauer (patrik.pfaffenbauer@p3.co.at)
# Author: Marc Joliet (marcec@gmx.de)
# Author: Jannis Achstetter (kripton@kripserver.net)

EAPI="8"

inherit autotools git-r3

DESCRIPTION="Provides an interface to the EIB / KNX bus"
HOMEPAGE="https://github.com/knxd/knxd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="knxd ft12 tpuart eibnetip eibnetiptunnel eibnetipserver usb java dummy systemd"

DEPEND="
	acct-group/knxd
	acct-user/knxd
	dev-libs/libfmt
	dev-libs/libev
	usb? ( virtual/libusb )
	java? ( virtual/jdk )
"
RDEPEND="${DEPEND}"

EGIT_REPO_URI="https://github.com/knxd/knxd.git"
EGIT_COMMIT="${PV}"

src_prepare() {
	eautoreconf || die "eautotooling failed"
	eapply_user
}

src_configure() {
	econf \
		$(use_enable systemd) \
		$(use_enable ft12) \
		$(use_enable tpuart) \
		$(use_enable eibnetip) \
		$(use_enable eibnetiptunnel) \
		$(use_enable eibnetipserver) \
		$(use_enable usb) \
		$(use_enable java) || die "econf failed"
}

src_compile() {
	emake || die "build of knxd failed"
}

src_install() {
	emake DESTDIR="${D}" install

	einfo "Installing init-script and config"

	newinitd "${FILESDIR}/${PN}-0.14.init" ${PN}

	newconfd "${FILESDIR}/${PN}-0.14.confd" ${PN}

	insinto /etc
	newins "${FILESDIR}/${PN}-0.14.conf" ${PN}.conf
}
