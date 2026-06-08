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
import SAMBA.Device.SAMA7G5 3.7

/*!
	\qmltype SAMA7G5
	\inqmlmodule SAMBA.Device.SAMA7G5
	\brief Contains chip-specific information about SAMA7G5 device.

	This QML type contains configuration, applets and tools for supporting
	the SAMA7G5 device.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.

	\section2 External RAM Applet

	This applet is in charge of configuring the external RAM.

	The Low-Level applet must have been initialized first.

	The only supported command is "init".
*/
Device {
	family: "sama7g5"

	name: "sama7g5"

	aliases: [ ]

	description: "SAMA7G5 series"

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAMA7G5Config
	*/
	property alias config: config

	applets: [
		SAMA7G5BootConfigApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-bootconfig_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},
		LowlevelPresetApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevel_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},
		NANDFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
			nandHeaderHelp: "For information on the NAND header values, please refer to Boot Strategies chapter from SAMA7G5 datasheet."
		},
		SAMA7G5PairingModeApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-pairingmode_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
			connectionType: connectionTypeSecureOnly
		},
		QSPIFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-qspiflash_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},
		ReadUniqueIDApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-readuniqueid_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},
		ResetApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-reset_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},
		SDMMCApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},
		SerialFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sama7g5-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
        },
        SetGPIOApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-setgpio_sama7g5-generic_sram.bin")
            codeAddr: 0x100000
            mailboxAddr: 0x100004
            entryAddr: 0x100000
        }

	]

	/*!
		\brief Initialize the SAMA7G5 device using the current connection.

		This method calls checkDeviceID.
	*/
	function initialize() {
	}

	/*!
		\brief List SAMA7G5 specific commands for its secure SAM-BA monitor
	*/
	function commandLineSecureCommands() {
		return ["write_rsa_hash", "enable_pairing"]
	}

	/*!
		\brief Show help for monitor commands supported by a SecureConnection
	*/
	function commandLineSecureCommandHelp(command) {
		if (command === "write_rsa_hash") {
			return ["* write_rsa_hash - write the RSA hash into the device",
			        "Syntax:",
			        "    write_rsa_hash:<file>"]
		}
		if (command === "enable_pairing") {
			return ["* enable_pairing - enable pairing mode",
				"Syntax:",
				"    enable_pairing"]
		}
	}

	/*!
		\brief Handle monitor commands through a SecureConnection

		Handle secure commands specific to the secure SAM-BA monitor
		of SAMA7G5 devices.
	*/
	function commandLineSecureCommand(command, args) {
		if (command === "write_rsa_hash")
			return connection.commandLineCommandWriteRSAHash(args)
		if (command === "enable_pairing")
			return connection.commandLineCommandSetPairingMode(args)
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
			return "Fuse Secure Mode error"
		case -17:
			return "RSA Hash not written"
		case -18:
			return "RSA Hash already written"
		case -19:
			return "OTP write error"
		case -20:
			return "Expand Mode already written"
		}
	}

	SAMA7G5Config {
		id: config
	}
}
