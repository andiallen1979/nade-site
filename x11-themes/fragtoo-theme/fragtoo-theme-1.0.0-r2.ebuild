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

	insinto /usr/share/wallpapers/Ronan
	newins "${FILESDIR}/ronan-metadata.json" metadata.json
	insinto /usr/share/wallpapers/Ronan/contents/images
	newins "${FILESDIR}/ronan.png" 1280x800.png

	insinto /usr/share/wallpapers/Ruby
	newins "${FILESDIR}/ruby-metadata.json" metadata.json
	insinto /usr/share/wallpapers/Ruby/contents/images
	newins "${FILESDIR}/ruby.png" 1280x800.png

	insinto /usr/share/wallpapers/Fragtoo
	newins "${FILESDIR}/fragtoo-metadata.json" metadata.json
	insinto /usr/share/wallpapers/Fragtoo/contents/images
	newins "${FILESDIR}/ronan.png" 1280x800.png
	insinto /usr/share/wallpapers/Fragtoo/contents/images_dark
	newins "${FILESDIR}/ruby.png" 1280x800.png

	dobin "${FILESDIR}/fragtoo-theme"

	keepdir /etc/fragtoo-theme
	dosym /usr/share/fragtoo-theme/ruby.css /etc/fragtoo-theme/active.css
}
