# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg-utils

DESCRIPTION="GPS data editor and analyzer"
HOMEPAGE="https://github.com/viking-gps/viking/"
IUSE="doc +exif libexif geoclue gps +magic mapnik nls oauth sqlite"
SRC_URI="
	https://github.com/viking-gps/${PN}/archive/${P}.tar.gz
	doc? ( https://github.com/viking-gps/${PN}/releases/download/${P}/${PN}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMONDEPEND="
	app-arch/bzip2
	>=dev-tcltk/expect-5.45.4
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nettle
	net-misc/curl
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	geoclue? ( >=app-misc/geoclue-2.4.4:2.0 )
	gps? ( >=sci-geosciences/gpsd-3.20 )
	exif? ( libexif? ( media-libs/libexif ) !libexif? ( media-libs/gexiv2 ) )
	magic? ( sys-apps/file )
	mapnik? ( sci-geosciences/mapnik )
	oauth? ( net-libs/liboauth )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${COMMONDEPEND}
	sci-geosciences/gpsbabel
"
DEPEND="${COMMONDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	dev-util/gtk-doc-am
	app-text/rarian
	dev-libs/libxslt
	virtual/pkgconfig
	sys-devel/gettext
"

PATCHES=( "${FILESDIR}/${P}-no-common.patch" )

src_unpack()
{
	default

	# fix wrong named root directory
	mv ${PN}-${P} ${P}
}

src_prepare()
{
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-deprecations \
		--with-libcurl \
		--with-expat \
		--enable-google \
		--enable-nettle \
		--enable-terraserver \
		--enable-expedia \
		--enable-openstreetmap \
		--enable-bluemarble \
		--enable-geonames \
		--enable-geocaches \
		--disable-dem24k \
		$(use_enable exif geotag) \
		$(use_with libexif ) \
		$(use_enable geoclue) \
		$(use_enable gps realtime-gps-tracking) \
		$(use_enable magic) \
		$(use_enable mapnik) \
		$(use_enable nls) \
		$(use_enable oauth) \
		$(use_enable sqlite mbtiles )
}

src_install() {
	default
	if use doc; then
		dodoc "${DISTDIR}"/${PN}.pdf
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
