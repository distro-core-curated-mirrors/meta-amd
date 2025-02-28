FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCREV_amd = "b9b19162ee3f8d68be76b71adf2a290cbb675660"
LIC_FILES_CHKSUM_amd = "file://docs/license.html;md5=6a23445982a7a972ac198e93cc1cb3de"
PV_amd = "11.0.8+git${SRCPV}"
DEPENDS_append_amd = " libvdpau libomxil python-mako-native libdrm nettle"
GALLIUMDRIVERS_append_amd = ",r300,r600,radeonsi"
GALLIUMDRIVERS_LLVM_amd = "r300,svga${@',${GALLIUMDRIVERS_LLVM33}' if ${GALLIUMDRIVERS_LLVM33_ENABLED} else ',nouveau'}"
PACKAGECONFIG_append_amd = " xvmc gallium r600 gallium-llvm"

PACKAGECONFIG_append_radeon = " va"
PACKAGECONFIG_append_amdgpu = " va"
LIBVA_PLATFORMS  = "libva"
LIBVA_PLATFORMS .= "${@bb.utils.contains('DISTRO_FEATURES', 'x11', ' libva-x11', '', d)}"
LIBVA_PLATFORMS .= "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', ' libva-wayland', '', d)}"
LIBVA_PLATFORMS .= "${@bb.utils.contains('DISTRO_FEATURES', 'opengl', ' libva-gl', '', d)}"
PACKAGECONFIG[va] = "--enable-va,--disable-va,libva"
RDEPENDS_mesa-megadriver += "${@bb.utils.contains('PACKAGECONFIG', 'va', '${LIBVA_PLATFORMS}', '', d)}"

MESA_LLVM_RELEASE_amd = "3.7.1"

SRC_URI_amd = "\
			git://anongit.freedesktop.org/git/mesa/mesa;branch=11.0 \
			file://0001-st-omx-h264-fix-corruption-when-scaling-matrix-prese.patch \
			file://0002-st-omx-Remove-trailing-spaces.patch \
			file://0003-st-omx-dec-Correct-the-timestamping.patch \
			file://0004-st-omx-Avoid-segfault-in-deconstructor-if-constructo.patch \
			file://0005-st-omx-enc-Correct-the-timestamping.patch \
			file://0006-st-omx-enc-Modularize-the-Encoding-task.patch \
			file://0007-st-omx-enc-Support-framerate-conversion.patch \
"

EXTRA_OECONF_append_amd = " \
		 --disable-dri3 \
		 --enable-vdpau \
		 --enable-osmesa \
		 --enable-xa \
		 --enable-glx \
		 --enable-omx \
		 --enable-r600-llvm-compiler \
		 --enable-llvm-shared-libs \
		 --with-omx-libdir=${libdir}/bellagio \
		"

EXTRA_OECONF_append_amdfalconx86 = " \
		 --disable-xvmc \
		 --enable-texture-float \
		"

# Package all the libXvMC gallium extensions together
# they provide the shared lib libXvMCGallium and splitting
# them up creates trouble in rpm packaging
PACKAGES =+ "libxvmcgallium-${PN} libxvmcgallium-${PN}-dev"
FILES_libxvmcgallium-${PN} = "${libdir}/libXvMC*${SOLIBS}"
FILES_libxvmcgallium-${PN}-dev = "${libdir}/libXvMC*${SOLIBSDEV} \
                               ${libdir}/libXvMC*.la"

PACKAGES =+ "libvdpau-${PN} libvdpau-${PN}-dev"
FILES_libvdpau-${PN} = "${libdir}/vdpau/libvdpau*${SOLIBS}"
FILES_libvdpau-${PN}-dev = "${libdir}/vdpau/libvdpau*${SOLIBSDEV} \
                            ${libdir}/vdpau/libvdpau*.la"
FILES_${PN}-dbg += "${libdir}/vdpau/.debug"

PACKAGES =+ "libxatracker-${PN} libxatracker-${PN}-dev"
FILES_libxatracker-${PN} = "${libdir}/libxatracker${SOLIBS}"
FILES_libxatracker-${PN}-dev = "${includedir}/xa_tracker.h \
                                ${includedir}/xa_composite.h \
                                ${includedir}/xa_context.h \
                                ${libdir}/pkgconfig/xatracker.pc \
                                ${libdir}/libxatracker${SOLIBSDEV} \
                                ${libdir}/libxatracker.la \
                                "

#
# libomx files are non-versioned so we put *.so directly in the
# main package as opposed to the -dev package.
#
PACKAGES =+ "libomx-${PN} libomx-${PN}-dev"
FILES_libomx-${PN} = "${libdir}/bellagio/libomx_*.so"
FILES_libomx-${PN}-dev = "${libdir}/bellagio/libomx_*.la"
FILES_${PN}-dbg += "${libdir}/bellagio/.debug"

# Set DRIDRIVERS with anonymous python so we can effectively
# override the _append_x86-64 assignement from mesa.inc.
python __anonymous () {
    d.setVar("DRIDRIVERS_amd", "radeon")
}

# We'll need to setup some symlinks for the va enabled
# video driver to work properly in case va is enabled
# so skip the .so symlink checks.
INSANE_SKIP_${PN}-megadriver += "${@bb.utils.contains('PACKAGECONFIG', 'va', 'dev-so', '', d)}"

# Install override from mesa.inc
do_install_append_amd() {
	cp ${S}/include/EGL/eglplatform.h ${D}${includedir}/EGL/eglplatform.h

	# Create symlinks for the gallium drivers to be able to play
	# through the va enabled driver by default.
	if ${@bb.utils.contains('PACKAGECONFIG','va','true','false',d)}; then
		gallium_drivers=$(echo ${GALLIUMDRIVERS} | sed 's/,/ /g')
		for gdriver in ${gallium_drivers}; do
			ln -sf ${libdir}/dri/gallium_drv_video.so ${D}${libdir}/dri/${gdriver}_drv_video.so
		done
	fi
}
