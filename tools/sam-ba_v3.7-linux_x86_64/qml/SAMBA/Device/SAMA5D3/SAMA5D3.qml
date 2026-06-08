/*
 * Copyright (c) 2016, Atmel Corporation.
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
import SAMBA.Device.SAMA5D3 3.7

/*!
	\qmltype SAMA5D3
	\inqmlmodule SAMBA.Device.SAMA5D3
	\brief Contains chip-specific information about SAMA5D3 device.

	This QML type contains configuration, applets and tools for supporting
	the SAMA5D3 device.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.

	\section2 Low-Level Applet

	This applet is in charge of configuring the device clocks.

	The only supported command is "init".

	\section2 External RAM Applet

	This applet is in charge of configuring the external RAM.

	The Low-Level applet must have been initialized first.

	The only supported command is "init".

	Note: The external RAM is not needed for correct operation of the other
	applets. It is only provided as a way to upload and run user programs
	from external RAM.

	\section2 SDMMC Applet

	This applet is used to read/write SD/MMC and e.MMC devices. It supports
	all HSMCI peripherals present on the SAMA5D3 device (see SAMA5D3Config
	for configuration information).

	Supported commands are "init", "read" and "write".

	\section2 SerialFlash Applet

	This applet is used to flash AT25 serial flash memories. It supports
	all SPI peripherals present on the SAMA5D3 device (see SAMA5D3Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section2 NAND Applet

	This applet is used to flash NAND memories (see SAMA5D2Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section1 Configuration

	When creating an instance of the SAMA5D3 type, some configuration can
	be supplied. The configuration parameters are then used during applet
	initialization where relevant.

	\section2 Board selection

	A set of pre-configured values can be selected by instanciating
	sub-classes of SAMA5D3.  The following preset boards are available:

	\table
	\header \li Command-Line Name \li QML Name        \li Board Name
	\row    \li sama5d3-ek        \li SAMA5D3EK       \li SAMA5D3x-MB
	\row    \li sama5d3-xplained  \li SAMA5D3Xplained \li SAMA5D3 Xplained
	\endtable

	\section2 Custom configuration

	Each configuration value can be set individually.  Please see
	SAMA5D3Config for details on the configuration values.

	For example, the following QML snipplet configures a device using SPI1
	on I/O set 2 and Chip Select 3 at 33Mhz:

	\qml
	SAMA5D3 {
		config {
			serialflash {
				instance: 1
				ioset: 1
				chipSelect: 3
				freq: 33
			}
		}
	}
	\endqml
*/
Device {
	family: "sama5d3"

	name: "sama5d3"

	aliases: [ "sama5d31", "sama5d33", "sama5d34", "sama5d35", "sama5d36" ]

	description: "SAMA5D3x series"

	usb_zlp_quirk: true

	hasMultipleROMVersions: true

	/*! \internal */
	readonly property int oldKeys: 0

	/*! \internal */
	readonly property int newKeys: 1

	/*! \internal */
	function setActiveROMVersion(version) {
		if ((version === "v2.0 Jul  4 2012 18:16:45") ||
		    (version === "v2.1 Oct 19 2012 17:38:58")) {
			activeROMVersion = oldKeys
		} else if (version === "v2.2 Jun  8 2020 08:28:41") {
			activeROMVersion = newKeys
			usb_zlp_quirk = false
			if (connection.toSecureMonitor())
				connection.usbZLPQuirk = usb_zlp_quirk
		}
	}

	/*! \internal */
	function translateSecureAppletUrl(codeUrl) {
		if (activeROMVersion === newKeys)
			codeUrl = codeUrl.replace(/.cip$/, "_nk.cip")
		return codeUrl
	}

	/*! \internal */
	function translateInputFileName(filename) {
		if (activeROMVersion === newKeys)
			filename = filename.replace(/.cip$/, "_nk.cip")
		return filename
	}

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAMA5D3Config
	*/
	property alias config: config

	applets: [
		LowlevelApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevel_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		ExtRamApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-extram_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		SDMMCApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		SerialFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		NANDFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
			nandHeaderHelp: "For information on the NAND header values, please refer to Boot Strategies chapter from SAMA5D3 datasheet."
		},
		ResetApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-reset_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		}
	]

	/*!
		\brief Initialize the SAMA5D3 device using the current connection.

		This method calls checkDeviceID.
	*/
	function initialize() {
		checkDeviceID()
	}

	/*!
		\brief Checks that the device is a SAMA5D3.

		Reads CHIPID_CIDR register using the current connection and display
		a warning if its value does not match the expected value for SAMA5D3.
	*/
	function checkDeviceID() {
		// read CHIPID_CIDR register
		var cidr = connection.readu32(0xffffee40)
		// Compare cidr using mask to skip revision field.
		if (((cidr & 0xfffffffe) >>> 0) !== 0x8a5c07c2)
			print("Warning: Invalid CIDR, no known SAMA5D3 chip detected!")
		// read CHIPID_EXID register
		var exid = connection.readu32(0xffffee44)
		switch (exid) {
			case 0x00444300:
			case 0x00414300:
			case 0x00414301:
			case 0x00584300:
			case 0x00004301:
				break;
			default:
				print("Warning: Invalid EXID, no known SAMA5D3 chip detected!")
				break;
		}
	}

	/*!
		\brief List SAMA5D3 specific commands for its secure SAM-BA monitor
	*/
	function commandLineSecureCommands() {
        return ["enable_secure", "disable_monitor", "disable_jtag", "disable_fuse_write"]
	}

	/*!
		\brief Show help for monitor commands supported by a SecureConnection
	*/
	function commandLineSecureCommandHelp(command) {
		if (command === "enable_secure") {
			return ["* enable_secure - enable secure mode",
			        "Syntax:",
			        "    enable_secure:<file>"]
		}
		if (command === "disable_monitor") {
			return ["* disable_monitor - disable the secure SAM-BA monitor",
				"Syntax:",
				"    disable_monitor"]
		}
		if (command === "disable_jtag") {
			return ["* disable_jtag - permanently disable JTAG port",
				"Syntax:",
				"    disable_jtag"]
		}
		if (command === "disable_fuse_write") {
			return ["* disable_fuse_write - disable write into fuses",
				"Syntax:",
				"    disable_fuse_write"]
		}
	}

	/*!
		\brief Handle monitor commands through a SecureConnection

		Handle secure commands specific to the secure SAM-BA monitor
		of SAMA5D3 devices.
	*/
	function commandLineSecureCommand(command, args) {
		if (command === "enable_secure")
			return connection.commandLineCommandEnableSecure(args)
		if (command === "disable_monitor")
			return connection.commandLineCommandNoArgs("SMDI", args)
		if (command === "disable_jtag")
			return connection.commandLineCommandNoArgs("SFTG", args)
		if (command === "disable_fuse_write")
			return connection.commandLineCommandNoArgs("SFWR", args)
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
			return "Secure Boot mode enabled"
		case -17:
			return "Secure Boot mode cannot be enabled"
		}
	}

	SAMA5D3Config {
		id: config
	}
}
