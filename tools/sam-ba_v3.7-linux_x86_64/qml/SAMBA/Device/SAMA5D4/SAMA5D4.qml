/*
 * Copyright (c) 2015-2016, Atmel Corporation.
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
import SAMBA.Device.SAMA5D4 3.7

/*!
	\qmltype SAMA5D4
	\inqmlmodule SAMBA.Device.SAMA5D4
	\brief Contains chip-specific information about SAMA5D4 device.

	This QML type contains configuration, applets and tools for supporting
	the SAMA5D4 device.

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
	all HSMCI peripherals present on the SAMA5D4 device (see SAMA5D4Config
	for configuration information).

	Supported commands are "init", "read" and "write".

	\section2 SerialFlash Applet

	This applet is used to flash AT25 serial flash memories. It supports
	all SPI peripherals present on the SAMA5D4 device (see SAMA5D4Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section2 NAND Applet

	This applet is used to flash NAND memories (see SAMA5D4Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section1 Configuration

	When creating an instance of the SAMA5D4 type, some configuration can
	be supplied. The configuration parameters are then used during applet
	initialization where relevant.

	\section2 Preset Board selection

	A set of pre-configured values can be selected by instanciating
	sub-classes of SAMA5D4.  The following preset boards are available:

	\table
	\header \li Command-Line Name \li QML Name        \li Board Name
	\row    \li sama5d4-ek        \li SAMA5D4EK       \li SAMA5D4x-MB
	\row    \li sama5d4-xplained  \li SAMA5D4Xplained \li SAMA5D4 Xplained Ultra
	\endtable

	\section2 Custom configuration

	Each configuration value can be set individually.  Please see
	SAMA5D4Config for details on the configuration values.

	For example, the following QML snipplet configures a device using SPI1
	on I/O set 2 and Chip Select 3 at 33Mhz:

	\qml
	SAMA5D4 {
		config {
			serialflash {
				instance: 1
				ioset: 2
				chipSelect: 3
				freq: 33
			}
		}
	}
	\endqml
*/
Device {
	family: "sama5d4"

	name: "sama5d4"

	aliases: [ "sama5d41", "sama5d42", "sama5d43", "sama5d44" ]

	description: "SAMA5D4x series"

	usb_zlp_quirk: true

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAMA5D4Config
	*/
	property alias config: config

	applets: [
		LowlevelApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevel_sama5d4-generic_sram.bin")
			codeAddr: 0x200000
			mailboxAddr: 0x200004
			entryAddr: 0x200000
		},
		ExtRamApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-extram_sama5d4-generic_sram.bin")
			codeAddr: 0x200000
			mailboxAddr: 0x200004
			entryAddr: 0x200000
		},
		SDMMCApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sama5d4-generic_sram.bin")
			codeAddr: 0x200000
			mailboxAddr: 0x200004
			entryAddr: 0x200000
		},
		SerialFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sama5d4-generic_sram.bin")
			codeAddr: 0x200000
			mailboxAddr: 0x200004
			entryAddr: 0x200000
		},
		NANDFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sama5d4-generic_sram.bin")
			codeAddr: 0x200000
			mailboxAddr: 0x200004
			entryAddr: 0x200000
			nandHeaderHelp: "For information on the NAND header values, please refer to Boot Strategies chapter from SAMA5D4 datasheet."
		},
		ResetApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-reset_sama5d4-generic_sram.bin")
			codeAddr: 0x200000
			mailboxAddr: 0x200004
			entryAddr: 0x200000
		}
	]

	/*!
		\brief Initialize the SAMA5D4 device using the current connection.

		This method calls checkDeviceID.
	*/
	function initialize() {
		checkDeviceID()
	}

	/*!
		\brief Checks that the device is a SAMA5D4.

		Reads CHIPID_CIDR register using the current connection and display
		a warning if its value does not match the expected value for SAMA5D4.
	*/
	function checkDeviceID() {
		// read CHIPID_CIDR register
		var cidr = connection.readu32(0xfc069040)
		// Compare cidr using mask to skip revision field.
		if (((cidr & 0xffffffe0) >>> 0) !== 0x8a5c07c0)
			print("Warning: Invalid CIDR, no known SAMA5D4 chip detected!")
	}

	/*!
		\brief List SAMA5D4 specific commands for its secure SAM-BA monitor
	*/
	function commandLineSecureCommands() {
		return ["enable_secure", "disable_monitor", "disable_jtag", "set_fuse_full_lock", "disable_secure_debug"]
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
		if (command === "set_fuse_full_lock") {
			return ["* set_fuse_full_lock - fuse area totally lock",
				"Syntax:",
		"    set_fuse_full_lock"]
		}
		if (command === "disable_secure_debug") {
			return ["* disable_secure_debug - disable secure debug",
				"Syntax:",
				"    disable_secure_debug"]
		}
	}

	/*!
		\brief Handle monitor commands through a SecureConnection

		Handle secure commands specific to the secure SAM-BA monitor
		of SAMA5D4 devices.
	*/
	function commandLineSecureCommand(command, args) {
		if (command === "enable_secure")
			return connection.commandLineCommandEnableSecure(args)
		if (command === "disable_monitor")
			return connection.commandLineCommandNoArgs("SFDM", args)
		if (command === "disable_jtag")
			return connection.commandLineCommandNoArgs("SFTG", args)
		if (command === "set_fuse_full_lock")
			return connection.commandLineCommandNoArgs("SFFL", args)
		if (command === "disable_secure_debug")
			return connection.commandLineCommandNoArgs("SFSD", args)
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
			return "Secure Boot mode cannot be enabled"
		}
	}

	SAMA5D4Config {
		id: config
	}
}
