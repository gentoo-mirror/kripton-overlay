# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

COMMITHASH="215daa291d1e9f1ead93563abae9ebda2a61a0e7"

## Real upstream is at https://gitlab.xiph.org/xiph/postfish but
## https://github.com/ePirat/Postfish has some nice work regarding gtk+ deprecations

DESCRIPTION="A digital audio post-processing, restoration, filtering and mixdown tool"
HOMEPAGE="https://gitlab.xiph.org/xiph/postfish"
SRC_URI="https://github.com/ePirat/Postfish/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/Postfish-${COMMITHASH}"

RDEPEND="sci-libs/fftw:3.0
	x11-libs/gtk+:2
	media-libs/libao"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_compile() {
	emake ETCDIR="${EPREFIX}"/etc/postfish CC="$(tc-getCC)"
}

src_install() {
	# make install links binary again, using helpers instead
	dobin postfish
	#doman postfish.1
	insinto /etc/postfish
	doins postfish-gtkrc postfish-wisdomrc
	dodoc README.md
}
