EAPI=8

DESCRIPTION="Fragtoo Ronan (light) and Ruby (dark) golden-hour themes and switcher"
HOMEPAGE="https://github.com/andiallen1979/nade-site"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/fragtoo-theme
	doins "${FILESDIR}/ronan.css"
	doins "${FILESDIR}/ruby.css"
	doins "${FILESDIR}/ronan.png"
	doins "${FILESDIR}/ruby.png"

	dobin "${FILESDIR}/fragtoo-theme"

	keepdir /etc/fragtoo-theme
	dosym /usr/share/fragtoo-theme/ruby.css /etc/fragtoo-theme/active.css
}
