/*
 * Copyright (c) 2020, Microchip.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

import QtQuick 2.3
import SAMBA 3.7
import SAMBA.Applet 3.7
import SAMBA.Device.PIC32CXMT 3.7

/*! \internal */
InternalFlashApplet {
	userSignaturePages: 64
	userSignatureBlockPages: 8

	/*! \internal */
	function gpnvmFromText(text) {
		return GPNVM.fromText(text)
	}

	/*! \internal */
	function gpnvmToText(value) {
		return GPNVM.toText(value)
	}

	/*! \internal */
	function wpmrFromText(text) {
		return WPMR.fromText(text)
	}

	/*! \internal */
	function wpmrToText(value) {
		return WPMR.toText(value)
	}

	/*! \internal */
	function usrFromText(text) {
		return USR.fromText(text)
	}

	/*! \internal */
	function usrToText(value) {
		return USR.toText(value)
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "getgpnvm") {
			return ["* getgpnvm - get GPNVM bits",
				"Syntax:",
				"    getgpnvm:[<mask>]",
				"Examples:",
				"    getgpnvm               get all GPNVMs",
				"    getgpnvm:0x1e0         get GPNVM[8:5] only",
				"    getgpnvm:SBS_MASK      get GPNVM[8:5] only",
				"",
				"<mask> value can be either a number or a sequence of tokens separated by commas:",
				"    SECURITY               (GPNVM[0]   = 1b)    : Security bit",
				"    BMS                    (GPNVM[1]   = 1b)    : Bank Swap",
				"    EFL_MASK               (GPNVM[4:2] = 111b)  : Erase Flash Lock mask",
				"    EFL                    (GPNVM[4:2] != 0b)   : Erase Flash Lock set",
				"    SBS_MASK               (GPNVM[8:5] = 1111b) : System Boot Selection",
				"    SAMBA_MONITOR          (GPNVM[8:5] = 0000b) : SAM-BA monitor selected",
				"    STANDARD_BOOT          (GPNVM[8:5] = 0011b) : Boot from internal flash in standard boot mode selected",
				"    SECURE_SAMBA_MONITOR   (GPNVM[8:5] = 1001b) : secure SAM-BA monintor selected",
				"    SECURE_BOOT            (GPNVM[8:5] = 1010b) : Boot from internal flash in secure boot mode (w/ monitor fall-back) selected",
				"    SECURE_BOOT_NO_MONITOR (GPNVM[8:5] = 1100b) : Boot from internal flash in secure boot mode (w/o monitor fall-back) selected",
				"",
				"Please refer to the 'ROM Code and Boot Strategies' section of the PIC32CXMT datasheet."]
		} else if (command === "setgpnvm") {
			return ["* setgpnvm - set GPNVM bits",
				"Syntax:",
				"    setgpnvm:<value>:[<mask>]",
				"Examples:",
				"    setgpnvm:0x1                     set GPNMV[0] to 1b, clear all other GPNVMs",
				"    setgpnvm:0x0:0x1                 clear GPNVM[0]",
				"    setgpnvm:0x060:0x1e0             set GPNVM[8:5] to 0011b",
				"    setgpnvm:STANDARD_BOOT:SBS_MASK  set GPNVM[8:5] to 0011b",
				"",
				"<value> and <mask> values can be either numbers or sequences of tokens separated by commas:",
				"    SECURITY               (GPNVM[0]   = 1b)    : Security bit",
				"    BMS                    (GPNVM[1]   = 1b)    : Bank Swap",
				"    EFL_MASK               (GPNVM[4:2] = 111b)  : Erase Flash Lock mask",
				"    EFL                    (GPNVM[4:2] != 0b)   : Erase Flash Lock set",
				"    SBS_MASK               (GPNVM[8:5] = 1111b) : System Boot Selection",
				"    SAMBA_MONITOR          (GPNVM[8:5] = 0000b) : SAM-BA monitor selected",
				"    STANDARD_BOOT          (GPNVM[8:5] = 0011b) : Boot from internal flash in standard boot mode selected",
				"    SECURE_SAMBA_MONITOR   (GPNVM[8:5] = 1001b) : secure SAM-BA monintor selected",
				"    SECURE_BOOT            (GPNVM[8:5] = 1010b) : Boot from internal flash in secure boot mode (w/ monitor fall-back) selected",
				"    SECURE_BOOT_NO_MONITOR (GPNVM[8:5] = 1100b) : Boot from internal flash in secure boot mode (w/o monitor fall-back) selected",
				"",
				"Please refer to the 'ROM Code and Boot Strategies' section of the PIC32CXMT datasheet."]
		} else if (command === "getwpmr") {
			return ["* getwpmr - get Write Protect Mode Register (EEFC_WPMR)",
				"Syntax:",
				"    getwpmr:[<mask>]",
				"Examples:",
				"    getwpmr                get EEFC_WPMR",
				"    getwpmr:0x0000ff00     get bits 15:8 of EEFC_WPMR",
				"    getwpmr:USRWP          get bit 4 of EEFC_WPMR",
				"",
				"<mask> value can be either a number or a sequence of tokens separated by commas:",
				"    WPEN    : bit 0 of EEFC_WPMR",
				"    GPNVMWP : bit 1 of EEFC_WPMR",
				"    LOCKWP  : bit 2 of EEFC_WPMR",
				"    ERASEWP : bit 3 of EEFC_WPMR",
				"    USRWP   : bit 4 of EEFC_WPMR",
				"    ERASEWL : bit 7 of EEFC_WPMR",
				"",
				"Please refer to the 'Secure Embedded Flash Controller (SEFC)' section of the PIC32CXMT datasheet."]
		} else if (command === "setwpmr") {
			return ["* setwpmr - set Write Protect Mode Register (EEFC_WPMR)",
				"Syntax:",
				"    setwpmr:<value>:[<mask>]",
				"Examples:",
				"    setwpmr:0x00000101:0x01000101 set bits 0 and 8, clear bit 24 of EEFC_WPMR",
				"    setwpmr:0:USRWP               clear bit 4 of EEFC_WPMR",
				"",
				"<value> and <mask> values can be either numbers or sequences of tokens separated by commas:",
				"    WPEN    : bit 0 of EEFC_WPMR",
				"    GPNVMWP : bit 1 of EEFC_WPMR",
				"    LOCKWP  : bit 2 of EEFC_WPMR",
				"    ERASEWP : bit 3 of EEFC_WPMR",
				"    USRWP   : bit 4 of EEFC_WPMR",
				"    ERASEWL : bit 7 of EEFC_WPMR",
				"",
				"Please refer to the 'Secure Embedded Flash Controller (SEFC)' section of the PIC32CXMT datasheet."]
		} else if (command === "getusr") {
			return ["* getusr - get User Signature Rights Register (EEFC_USR)",
				"Syntax:",
				"    getusr:[<mask>]",
				"Examples:",
				"    getusr                 get EEFC_USR",
				"    getusr:0x0000ff00      get bits 15:8 of EEFC_USR",
				"    getuser:RDENUSB_MASK   get bits 7:0 of EEFC_USR",
				"",
				"<mask> value can be either a number or a sequence of tokens seperated by commas:",
				"    RDENUSB_MASK  : (0xff << 0)",
				"    RDENUSBx      : (0x01 << (x + 0)) with x in [0..7]",
				"    WRENUSB_MASK  : (0xff << 8)",
				"    WRENUSBx      : (0x01 << (x + 8)) with x in [0..7]",
				"    PRIVUSB_MASK  : (0xff << 16)",
				"    PRIVUSBx      : (0x01 << (x + 16) with x in [0..7]",
				"    LOCKUSRB_MASK : (0xff << 24)",
				"    LOCKUSRBx     : (0x01 << (x + 24)) with x in [0..7]",
				"",
				"Please refer to the 'Secure Embedded Flash Controller (SEFC)' section of the PIC32CXMT datasheet."]
		} else if (command === "setusr") {
			return ["* setusr - set User Signature Rights Register (EEFC_USR)",
				"Syntax:",
				"    setsur:<value>:[<mask>]",
				"Examples:",
				"    setwp:0x00000101:0x01000101 set bits 0 and 8, clear bit 24 of EEFC_USR",
				"    setwp:RDENUSB0,RDENUSB_MASK set bits 7:0 of EEFC_USR to 00000001b",
				"",
				"<value> and <mask> values can be either numbers or sequences of tokens seperated by commas:",
				"    RDENUSB_MASK  : (0xff << 0)",
				"    RDENUSBx      : (0x01 << (x + 0)) with x in [0..7]",
				"    WRENUSB_MASK  : (0xff << 8)",
				"    WRENUSBx      : (0x01 << (x + 8)) with x in [0..7]",
				"    PRIVUSB_MASK  : (0xff << 16)",
				"    PRIVUSBx      : (0x01 << (x + 16) with x in [0..7]",
				"    LOCKUSRB_MASK : (0xff << 24)",
				"    LOCKUSRBx     : (0x01 << (x + 24)) with x in [0..7]",
				"",
				"Please refer to the 'Secure Embedded Flash Controller (SEFC)' section of the PIC32CXMT datasheet."]
		} else if (command === "eraseup") {
			return ["* eraseup - erase all or part of the User Signature pages",
				"Syntax:",
				"    eraseup:[<addr>]:[<length>]",
				"Examples:",
				"    eraseup              erase all User Signature pages",
				"    eraseup:0x200        erase from 0x200 (2nd page) to the end",
				"    eraseup:0x200:0x200  erase from 0x200 to 0x400 [0x200 - 0x400[",
				"    eraseup::0x1000      erase from 0 to 0x1000 (4KB / 8 pages)"]
		} else if (command === "readup") {
			return ["* readup - read from User Signature pages into a file",
				"Syntax:",
				"    readup:<filename>:[<addr>]:[<length>]",
				"Examples:",
				"    readup:pages.bin              read all User Signature pages into pages.bin",
				"    readup:tail.bin:0x200         read from 0x200 (2nd page) to the end into tail.bin",
				"    readup:page0.bin::0x200       read range [0 - 0x200[ into page0.bin",
				"    readup:page1.bin:0x200:0x200  read range [0x200 - 0x400[ into page1.bin"]
		} else if (command === "writeup") {
			return ["* writeup - write User Signature pages",
				"Syntax:",
				"    writeup:<filename>:[<addr>]",
				"Examples:",
				"    writeup:page0.bin        write 'page0.bin' at offset 0 (1st page)",
				"    writeup:page1.bin:0x200  write 'page1.bin' at offset 0x200 (2nd page)"]
		} else if (command === "verifyup") {
			return ["*verifyup - verify User Signature pages",
				"Syntax:",
				"    verifyup:<filename>:[<addr>]",
				"Examples:",
				"    verifyup:page0.bin        compare the content of the 1st page with page0.bin",
				"    verifyup:page1.bin:0x200  compare the content of the 2nd page with page1.bin"]
		} else {
			return defaultCommandLineCommandHelp(command)
		}
	}
}
