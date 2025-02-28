SUMMARY = "VA-API support to GStreamer"
DESCRIPTION = "gstreamer-vaapi consists of a collection of VA-API \
based plugins for GStreamer and helper libraries: `vaapidecode', \
`vaapiconvert', and `vaapisink'."

REALPN = "gstreamer-vaapi"
FILESPATH = "${@base_set_filespath(["${FILE_DIRNAME}/${REALPN}", "${FILE_DIRNAME}/${REALPN}"], d)}"

LICENSE = "LGPLv2.1+"
LIC_FILES_CHKSUM = "file://COPYING.LIB;md5=4fbd65380cdd255951079008b364516c"

DEPENDS = "libva"

SRC_URI = "http://www.freedesktop.org/software/vaapi/releases/${REALPN}/${REALPN}-${PV}.tar.bz2 \
           file://install-tests.patch"

S = "${WORKDIR}/${REALPN}-${PV}"

inherit autotools pkgconfig gtk-doc

PACKAGES =+ "${PN}-tests"

EXTRA_OECONF += "--disable-builtin-libvpx"

PACKAGECONFIG ??= "drm \
                   ${@base_contains("DISTRO_FEATURES", "opengl x11", "glx", "", d)} \
                   ${@base_contains("DISTRO_FEATURES", "wayland", "wayland", "", d)} \
                   ${@base_contains("DISTRO_FEATURES", "x11", "x11", "", d)}"

PACKAGECONFIG[drm] = "--enable-drm,--disable-drm,udev libdrm"
PACKAGECONFIG[glx] = "--enable-glx,--disable-glx,virtual/mesa"
PACKAGECONFIG[egl] = "--enable-egl,--disable-egl,gstreamer-gl-1.0"
PACKAGECONFIG[wayland] = "--enable-wayland,--disable-wayland,wayland"
PACKAGECONFIG[x11] = "--enable-x11,--disable-x11,virtual/libx11 libxrandr libxrender"

FILES_${PN} += "${libdir}/gstreamer-*/*.so"
FILES_${PN}-dbg += "${libdir}/gstreamer-*/.debug"
FILES_${PN}-dev += "${libdir}/gstreamer-*/*.la ${libdir}/gstreamer-*/*.a"
FILES_${PN}-tests = "${bindir}/*"
