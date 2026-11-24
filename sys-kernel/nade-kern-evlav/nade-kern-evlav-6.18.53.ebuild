# Copyright 2026 NadeOS
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Valve SteamOS Neptune 6.18 kernel sources (clean evlav repack)"
HOMEPAGE="https://github.com/andiallen1979/nade-site"
SRC_URI="https://github.com/andiallen1979/nade-site/releases/download/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="618"
KEYWORDS="~amd64"
IUSE="symlink"
RESTRICT="binchecks strip mirror test"

RDEPEND="
	sys-devel/bc
	dev-util/pahole
	virtual/libelf
"

S="${WORKDIR}/linux-${PV}-evlav"

src_prepare() {
	default

	echo "-2" > localversion.10-pkgrel || die
	echo "-evlav-618" > localversion.20-pkgname || die

	einfo "Merging Valve config.x86_64 + config-neptune into .config..."
	cp config.x86_64 .config || die
	scripts/kconfig/merge_config.sh -m config.x86_64 config-neptune || die "merge_config.sh failed"
}

src_compile() { :; }

src_install() {
	local dest="/usr/src/linux-${PV}-evlav"
	dodir "${dest}"
	cp -a "${S}/." "${ED}${dest}/" || die "Failed to install kernel sources"
}

pkg_postinst() {
	if use symlink; then
		ln -sfn "linux-${PV}-evlav" "${EROOT}/usr/src/linux" || die
	fi
	einfo "Nade evlav kernel sources installed to /usr/src/linux-${PV}-evlav"
	einfo "Valve's merged config is pre-staged at /usr/src/linux-${PV}-evlav/.config"
}
