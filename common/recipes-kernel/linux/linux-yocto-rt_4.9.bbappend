require linux-yocto-common_4.9.inc
KBRANCH_amdx86 ?= "standard/preempt-rt/base"
SRCREV_machine_amdx86 ?= "b6f5c933ce66e4a00412bb5c5691a2ab4187c979"
SRC_URI_append_amdx86 = " file://x86-asm-Move-status-from-thread_struct-to-thread_inf-linux-yocto-rt.patch"
