# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A fast, inline deduplication filesystem"
HOMEPAGE="http://www.magiksys.net/ddumbfs/"

SRC_URI="http://www.magiksys.net/download/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="
	app-crypt/mhash
	>=sys-fs/fuse-2.8:0
"
RDEPEND="${DEPEND}"
