/*
 * Copyright (c) 2019, Microchip.
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

Device {
	family: "pic32cxmt"

	name: "pic32cxmt"

	aliases: [ ]

	description: "PIC32CXMT series"

	property alias config: config

	applets: [
		PIC32CXMTInternalFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-internalflash_pic32cxmt-generic_sram.bin")
			codeAddr: 0x20000000
			mailboxAddr: 0x20000008
			entryAddr: 0x20000000
		}
	]

	function initialize() {
	}

	/*!
		\brief List PIC32CXMT specific commands for its secure SAM-BA monitor
	*/
	function commandLineSecureCommands() {
		return ["disable_jtag", "enable_secure_boot_mode", "enable_secure_boot_mode_disable_monitor", "reset"]
	}

	/*!
		\brief Show help for monitor commands supported by a SecureConnection
	*/
	function commandLineSecureCommandHelp(command) {
		if (command === "disable_jtag") {
			return ["* disable_jtag - permanently disable JTAG port",
				"Syntax:",
				"    disable_jtag"]
		}
		if (command === "enable_secure_boot_mode") {
			return ["* enable_secure_boot_mode - enable the secure boot mode by setting GPNVM[8:5] to 1010b",
				"Syntax:",
				"    enable_secure_boot_mode"]
		}
		if (command === "enable_secure_boot_mode_disable_monitor") {
			return ["* enable_secure_boot_mode_disable_monitor - enable the secure boot mode and disable the secure SAM-BA monitor by setting GPNVM[8:5] to 1100b",
				"Syntax:",
				"    enable_secure_boot_mode_disable_monitor"]
		}
		if (command === "reset") {
			return ["* reset - reset the device",
				"Syntax:",
				"    reset"]
		}
	}

	/*!
		\brief Handle monitor commands through a SecureConnection

		Handle secure commands specific to the secure SAM-BA monitor
		of PIC32CXMT devices.
	*/
	function commandLineSecureCommand(command, args) {
		if (command === "disable_jtag")
			return connection.commandLineCommandNoArgs("SJTD", args)
		if (command === "enable_secure_boot_mode")
			return connection.commandLineCommandNoArgs("SSEC", args)
		if (command === "enable_secure_boot_mode_disable_monitor")
			return connection.commandLineCommandNoArgs("SSNM", args)
		if (command === "reset")
			return connection.commandLineCommandNoArgs("CRST", args)
	}

	/*! \internal */
	function strerror(code) {
		switch (code) {
		case 0:
			return "OK"
		case -1:
			return "Command parsing error"
		case -2:
			return "Operation code field size error"
		case -3:
			return "Address field size error"
		case -4:
			return "Invalid command length"
		case -5:
			return "Memory ID field size error"
		case -6:
			return "Read/Write field size error"
		case -7:
			return "Unknown operation code"
		case -8:
			return "Customer Key length error"
		case -9:
			return "Customer Key not written"
		case -10:
			return "Customer Key already written"
		case -11:
			return "CMAC Authentication error"
		case -12:
			return "AES-CBC Decryption error"
		case -13:
			return "Key Derivation error"
		case -14:
			return "Fuse Write Disabled"
		case -15:
			return "Bootstrap File size error"
		case -16:
			return "Flash UID read error"
		case -17:
			return "RSA Hash not written"
		case -18:
			return "RSA Hash already written"
		case -19:
			return "Flash User Page write error"
		case -20:
			return "Sign Mode already written"
		case -21:
			return "RSA blob address error"
		case -22:
			return "RSA blob size error"
		case -23:
			return "RSA blob offset error"
		case -24:
			return "RSA blob digest error"
		case -25:
			return "Data Transfer error"
		case -26:
			return "Invalid argument/payload error"
		}
	}

	PIC32CXMTConfig {
		id: config
	}
}
