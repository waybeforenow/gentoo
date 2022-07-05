# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Ncurses SIP Messages flow viewer"
HOMEPAGE="https://github.com/irontec/sngrep"
SRC_URI="https://github.com/irontec/sngrep/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eep gnutls pcre ssl unicode"

# In next release, libpcre -> libpcre2
DEPEND="
	net-libs/libpcap
	sys-libs/ncurses:=[unicode(+)?]
	ssl? (
		!gnutls? ( dev-libs/openssl:= )
		gnutls? ( net-libs/gnutls:= )
	)
	pcre? ( dev-libs/libpcre )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-bashisms.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-ipv6

		$(use_enable eep)
		$(use_enable unicode)
		$(use_with pcre)
		$(use_with ssl $(usex gnutls gnutls openssl))
	)

	econf "${myeconfargs[@]}"
}
