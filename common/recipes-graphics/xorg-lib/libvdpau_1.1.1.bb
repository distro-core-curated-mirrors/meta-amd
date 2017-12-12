DESCRIPTION = "Implements VDPAU library"
HOMEPAGE = "http://people.freedesktop.org"
LICENSE = "MIT"
DEPENDS = "xtrans libx11 libxext libice libsm libxscrnsaver libxt \
	   libxmu libxpm libxau libxfixes libxcomposite libxrender \
	   libxcursor libxdamage libfontenc libxfont libxft libxi \
	   libxinerama libxrandr libxres libxtst libxv libxvmc \
	   libxxf86dga libxxf86vm libdmx libpciaccess libxkbfile \
	   dri2proto \
	   "
LIC_FILES_CHKSUM = "file://COPYING;md5=83af8811a28727a13f04132cc33b7f58"

SRC_URI = "http://people.freedesktop.org/~aplattner/vdpau/libvdpau-${PV}.tar.gz"
SRC_URI[md5sum] = "ac8b21012035c04fd1ec8a9ae6934264"
SRC_URI[sha256sum] = "5fe093302432ef05086ca2ee429c789b7bf843e166d482d166e56859b08bef55"

inherit autotools pkgconfig

S = "${WORKDIR}/libvdpau-${PV}"

FILES_${PN} += "${libdir}/vdpau/libvdpau_nouveau${SOLIBS} \
		${libdir}/vdpau/libvdpau_r600${SOLIBS} \
		${libdir}/vdpau/libvdpau_radeonsi${SOLIBS} \
		${libdir}/vdpau/libvdpau_trace${SOLIBS} \
	       "

FILES_${PN}-dev += "${libdir}/vdpau/libvdpau_nouveau${SOLIBSDEV} \
		    ${libdir}/vdpau/libvdpau_nouveau.la \
		    ${libdir}/vdpau/libvdpau_r600${SOLIBSDEV} \
		    ${libdir}/vdpau/libvdpau_r600.la \
		    ${libdir}/vdpau/libvdpau_radeonsi${SOLIBSDEV} \
		    ${libdir}/vdpau/libvdpau_radeonsi.la \
		    ${libdir}/vdpau/libvdpau_trace${SOLIBSDEV} \
		    ${libdir}/vdpau/libvdpau_trace.la \
		   "

FILES_${PN}-dbg += "${libdir}/vdpau/.debug"

EXTRA_OECONF += "--enable-dri2"
