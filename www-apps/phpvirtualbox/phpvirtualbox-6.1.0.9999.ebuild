# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 readme.gentoo-r1 webapp

MY_PV="$(ver_rs 2 '-')"
MY_P="${PN}.${MY_PV}"

DESCRIPTION="Web-based administration for VirtualBox in PHP"
HOMEPAGE="https://github.com/phpvirtualbox/phpvirtualbox/"
#SRC_URI="https://github.com/phpvirtualbox/phpvirtualbox/archive/develop.zip -> ${P}.zip"

EGIT_REPO_URI="https://github.com/phpvirtualbox/phpvirtualbox"
EGIT_BRANCH="develop"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/php[session,unicode,soap,gd]
	virtual/httpd-php:*
"
DEPEND="app-arch/unzip
	app-admin/webapp-config"

pkg_postinst() {
	webapp_pkg_postinst
}

src_install() {
	local DISABLE_AUTOFORMATTING="true"
	local DOC_CONTENTS=$(sed -e "s;@@FILESDIR@@;${FILESDIR};" \
	                         -e "s;@@SLOT@@;${SLOT};" "${FILESDIR}/README.gentoo")

	webapp_src_preinst

	dodoc CHANGELOG.txt LICENSE.txt README.md
	rm -f CHANGELOG.txt LICENSE.txt README.md

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/config.php-example
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php-example

	webapp_src_install
	if has_version app-emulation/virtualbox[vboxwebsrv] || \
		has_version app-emulation/virtualbox-bin[vboxwebsrv]
	then
		newinitd "${FILESDIR}"/vboxinit-initd vboxinit
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	webapp_pkg_postinst
	readme.gentoo_print_elog
}
