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

/*! \internal */
BootConfigApplet {
	property int bcpPacketWords
	property int uhcpPacketWords
	property int sbcpPacketWords

	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"readBootCfg"; code:0x34 },
		AppletCommand { name:"writeBootCfg"; code:0x35 },
		AppletCommand { name:"invalidateBootCfg"; code:0x38 },
		AppletCommand { name:"lockBootCfg"; code:0x39 },
		AppletCommand { name:"refreshBootCfg"; code:0x40 },
		AppletCommand { name:"resetEmulSRAM"; code:0x41 }
	]

	// parameter indexes must match applet index argument
	configParams: [ "BSCR", "BCP-EMUL", "BCP-OTP", "UHCP-EMUL", "UHCP-OTP", "SBCP-EMUL", "SBCP-OTP" ]

	/*! \internal */
	function bscrFromText(text) {
	}

	/*! \internal */
	function bscrToText(value) {
	}

	/*! \internal */
	function bcpFromText(text) {
	}

	/*! \internal */
	function bcpToText(value) {
	}

	/*! \internal */
	function uhcpFromText(text) {
	}

	/*! \internal */
	function uhcpToText(value) {
	}

	/*! \internal */
	function sbcpFromText(text) {
	}

	/*! \internal */
	function sbcpToText(value) {
	}

	/*! \internal */
	function readBootCfg(index) {
		var value = callReadBootCfg(index)

		if (index === 0)
			return value

		var packetLen
		switch (index) {
		case BootCfgOTPC.BCP_EMUL:
		case BootCfgOTPC.BCP_OTP:
			packetLen = bcpPacketWords * 4
			break
		case BootCfgOTPC.UHCP_EMUL:
		case BootCfgOTPC.UHCP_OTP:
			packetLen = uhcpPacketWords * 4
			break
		case BootCfgOTPC.SBCP_EMUL:
		case BootCfgOTPC.SBCP_OTP:
			packetLen = sbcpPacketWords * 4
			break;
		}

		var data = connection.appletBufferRead(packetLen)
		if (typeof data !== "object" || data.byteLength !== packetLen)
			throw new Error("Read Boot Config command failed (Boot Config Packet transfer failed)")

		return new Uint32Array(data)
	}

	/*! \internal */
	function writeBootCfg(index, value) {
		if (index !== 0 && !connection.appletBufferWrite(value.buffer))
			throw new Error("Write Boot Config command file (Boot Config Packet transfer failed)")

		callWriteBootCfg(index, value)
	}

	/* -------- Configuration Parameters Handling -------- */

	/*! \internal */
	function configValueFromText(index, text) {
		switch (index) {
		case BootCfgOTPC.BSCR:
			return bscrFromText(text)
		case BootCfgOTPC.BCP_EMUL:
		case BootCfgOTPC.BCP_OTP:
			return bcpFromText(text)
		case BootCfgOTPC.UHCP_EMUL:
		case BootCfgOTPC.UHCP_OTP:
			return uhcpFromText(text)
		case BootCfgOTPC.SBCP_EMUL:
		case BootCfgOTPC.SBCP_OTP:
			return sbcpFromText(text)
		}
	}

	/*! \internal */
	function configValueToText(index, value) {
		switch (index) {
		case BootCfgOTPC.BSCR:
			return bscrToText(value)
		case BootCfgOTPC.BCP_EMUL:
		case BootCfgOTPC.BCP_OTP:
			return bcpToText(value)
		case BootCfgOTPC.UHCP_EMUL:
		case BootCfgOTPC.UHCP_OTP:
			return uhcpToText(value)
		case BootCfgOTPC.SBCP_EMUL:
		case BootCfgOTPC.SBCP_OTP:
			return sbcpToText(value)
		}
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands() {
		return [ "readcfg", "writecfg", "invalidatecfg", "lockcfg", "refreshcfg", "resetemul" ]
	}

	/*! \internal */
	function commandLineCommandWriteBootConfig(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"
		var param = args[0]

		// get index
		var index = configParamIndex(param)
		if (index < 0)
			return "Unknown configuration parameter"

		// value
		var value = configValueFromText(index, args[1])
		if (typeof value === "undefined")
			return "Invalid value parameter"
		var text = configValueToText(index, value)
		if (typeof text === "string")
			print("Setting " + configParams[index] + " to " + text)
		writeBootCfg(index, value)
	}

	/*!
		\qmlmethod void BootConfigOTPCApplet::invalidateBootCfg(int index)
		\brief Invalidate the boot configuration

		Invalidate the packet in the OTPC User Area given by \a index.

		Throws an \a Error if an error occured during the applet command.
	*/
	function invalidateBootCfg(index) {
		var cmd = command("invalidateBootCfg")
		if (cmd) {
			var status = connection.appletExecute(cmd, [index])
			if (status !== 0)
				throw new Error("Invalidate Boot Config command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Invalidate Boot Config' command")
		}
	}

	/*! \internal */
	function commandLineCommandInvalidateBootConfig(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (exepcted 1)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"
		var param = args[0]

		// get index
		var index = configParamIndex(param)
		if (index < 1)
			return "Unknown configuration parameter"

		invalidateBootCfg(index)
	}

	/*!
		\qmlmethod void BootConfigOTPCApplet::lockBootCfg(int index)
		\brief Lock the boot configuration

		Lock the packet in the OTPC User Area given by \a index.

		Throws an \a Error if an error occured during the applet command.
	*/
	function lockBootCfg(index) {
		var cmd = command("lockBootCfg")
		if (cmd) {
			var status = connection.appletExecute(cmd, [index])
			if (status !== 0)
				throw new Error("Lock Boot Config command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Lock Boot Config' command")
		}
	}

	/*! \internal */
	function commandLineCommandLockBootConfig(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (exepcted 1)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"
		var param = args[0]

		// get index
		var index = configParamIndex(param)
		if (index < 1)
			return "Unknown configuration parameter"

		lockBootCfg(index)
	}

	/*!
		\qmlmethod void BootConfigOTPCApplet::refreshBootCfg(int index)
		\brief Refresh OTPC packets in User Area.

		Enable/disable the OTPC emulation mode according to \a index and
		make the OTPC scan and refresh packets in User Area.

		Throws an \a Error if an error occured during the applet command.
	*/
	function refreshBootCfg(index) {
		var cmd = command("refreshBootCfg")
		if (cmd) {
			var status = connection.appletExecute(cmd, [index])
			if (status !== 0)
				throw new Error("Refresh Boot Config command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Refresh Boot Config' command")
		}
	}

	/*! \internal */
	function commandLineCommandRefreshBootConfig(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"

		var index
		if (args[0].toUpperCase() === "OTP")
			index = BootCfgOTPC.REFRESH_OTP
		else if (args[0].toUpperCase() === "EMUL")
			index = BootCfgOTPC.REFRESH_EMUL
		else
			return "Unknown configuration parameter"

		refreshBootCfg(index)
	}

	/*!
		\qmlmethod void BootConfigAppletOTPC::resetEmulSRAM()
		\brief Reset to zero the User Area of the OTPC emulation mode SRAM.

		Throws an \a Error if an error occured during the applet command.
	*/
	function resetEmulSRAM() {
		var cmd = command("resetEmulSRAM")
		if (cmd) {
			var status = connection.appletExecute(cmd, [])
			if (status !== 0)
				throw new Error("Reset Emulation SRAM command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Reset Emulation SRAM' command")
		}
	}

	/*! \internal */
	function commandLineCommandResetEmulSRAM(args) {
		if (args.length !== 0)
			return "Invalid number of arguments (expected 0)."

		resetEmulSRAM()
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (command === "readcfg")
			return commandLineCommandReadBootConfig(args)
		else if (command === "writecfg")
			return commandLineCommandWriteBootConfig(args)
		else if (command === "invalidatecfg")
			return commandLineCommandInvalidateBootConfig(args)
		else if (command === "lockcfg")
			return commandLineCommandLockBootConfig(args)
		else if (command === "refreshcfg")
			return commandLineCommandRefreshBootConfig(args)
		else if (command === "resetemul")
			return commandLineCommandResetEmulSRAM(args)
		else
			return "Unknown command."
	}
}
