require linux-yocto-6.6.inc

PR := "${INC_PR}.0"

SRCREV_machine = "0ccfb8e07e797d57830f3008028de56e22de6e0b"

inherit kernel

do_configure() {
   :;
}

#S = "${WORKDIR}"

# Ensure that the kernel modules are installed under /usr/lib/modules instead of /lib/modules
do_install:append() {
    # Ensure the installation directory exists
    install -d ${D}/usr/lib/modules/${KERNEL_VERSION}/

    # Install modules
    oe_runmake INSTALL_MOD_PATH=${D}/usr modules_install

	 # Remove unnecessary files
    rm -rf ${D}/usr/lib/modules/${KERNEL_VERSION}/Module.symvers
    rm -rf ${D}/usr/lib/modules/${KERNEL_VERSION}/modules.*.bin
    rm -rf ${D}/usr/lib/modules/${KERNEL_VERSION}/modules.alias
    rm -rf ${D}/usr/lib/modules/${KERNEL_VERSION}/modules.dep
    rm -rf ${D}/usr/lib/modules/${KERNEL_VERSION}/modules.devname
    rm -rf ${D}/usr/lib/modules/${KERNEL_VERSION}/modules.symbols
    rm -rf ${D}/usr/lib/modules/6.6.26-amd-standard/modules.softdep
}

# Declare a package for the kernel modules
#PACKAGES += "${KERNEL_PACKAGE_NAME}-modules ${KERNEL_PACKAGE_NAME}-dbg"

# Include kernel modules and other necessary files
FILES:${KERNEL_PACKAGE_NAME}-modules = "\
    /lib/modules/${KERNEL_VERSION}/kernel/* \
    /lib/modules/${KERNEL_VERSION}/modules.builtin \
    /lib/modules/${KERNEL_VERSION}/modules.order \
    /lib/modules/${KERNEL_VERSION}/modules.builtin.modinfo \
    /lib/modules/${KERNEL_VERSION}/build \
    /boot \
"
# Include /boot and kernel-related files in the main package
FILES:${PN} += "\
    /boot \
    /usr/lib/modules/${KERNEL_VERSION}/kernel/crypto/*.ko \
    /usr/lib/modules/${KERNEL_VERSION}/kernel/lib/*.ko \
    /usr/lib/modules/${KERNEL_VERSION}/kernel/net/**/*.ko \
    /usr/lib/modules/${KERNEL_VERSION}/kernel/fs/**/*.ko \
"

EXTRA_OEMAKE += "INSTALL_MOD_STRIP=1"

INSANE_SKIP:${PN} += "already-stripped"

VIRTUAL-RUNTIME_init_manager = "systemd"

# Append to your local.conf or create a bbappend file
EXTRA_IMAGECMD_ext4 = "cp -a"
# Disable hard linking in image deployment
IMAGE_POSTPROCESS_COMMAND:remove = "create_symlink_links;"
IMAGE_POSTPROCESS_COMMAND:append = "cp -a ${IMAGE_ROOTFS}/* ${DEPLOY_DIR_IMAGE}/;"

PREFERRED_PROVIDER_virtual/kernel = "linux-yocto"
