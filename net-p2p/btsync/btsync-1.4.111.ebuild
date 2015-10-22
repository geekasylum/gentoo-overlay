# Distributed under the terms of the GNU General Public License v3
# Authors: Horea Christian, Robert Walker

EAPI=5

inherit eutils pax-utils user flag-o-matic multilib autotools pam systemd versionator

DESCRIPTION="Sync files & folders using BitTorrent protocol"
HOMEPAGE="http://www.bittorrent.com/sync"
SRC_URI="
	amd64? ( http://syncapp.bittorrent.com/${PV}/${PN}_x64-${PV}.tar.gz )
	x86?   ( http://syncapp.bittorrent.com/${PV}/${PN}_i386-${PV}.tar.gz )
	ppc?   ( http://syncapp.bittorrent.com/${PV}/${PN}_powerpc-${PV}.tar.gz )
	arm?   ( http://syncapp.bittorrent.com/${PV}/${PN}_arm-${PV}.tar.gz )"

RESTRICT="mirror strip"
LICENSE="BitTorrent"
SLOT="0"
KEYWORDS="amd64 x86 arm ppc"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="/opt/${PN}/"

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 "/opt/${PN}" "${PN}" --system
}

src_prepare() {
	${S}/${PN} --dump-sample-config > ${PN}.conf || die 'Could not dump sample config'
	sed -i "s/My Sync Device/Gentoo Linux ($(hostname))/" "${PN}.conf"
	sed -i 's|// "pid_file"|   "pid_file"|' "${PN}.conf"
	sed -i 's|// "storage_path"|   "storage_path"|' "${PN}.conf"
	sed -i 's|/var/run|/run|' "${PN}.conf"
	sed -i "s|/home/user|$(egethome ${PN})|" "${PN}.conf"
}

src_install() {
	dodoc LICENSE.TXT

    # OpenRC Init/Conf files
	newconfd "${FILESDIR}/conf.d/${PN}-${PV}" "/${PN}"
	newinitd "${FILESDIR}/init.d/${PN}-${PV}" "/${PN}"

    # Binary
	exeinto "/opt/bin/"
	doexe "${PN}"

	# Config
	insinto "/etc"
	doins "${PN}.conf"

	# Storage path, set in config
	dodir "$(egethome ${PN})/.sync"
	fowners "${PN}":"${PN}" "$(egethome ${PN})/.sync"
}

pkg_postinst() {
	einfo "Auto-generated configuration file is located at /etc/${PN}.conf"
	einfo ""
	einfo "Ensure you open the following ports in your firewall:"
	einfo " btsync.conf specified sync listening port (UDP/TCP)"
	einfo " port 3838 (UDP) for DHT tracking"
	einfo ""
	einfo "WebUI listens on: 0.0.0.0:8888 (Configurable)"
}
