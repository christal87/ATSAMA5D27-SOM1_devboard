/*
 * Copyright (c) 2018, Microchip Technology.
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
import SAMBA.Connection.Secure 3.7

/*!
\qmltype SecureConnection
\inherits Connection
\inqmlmodule SAMBA.Connection.Secure
\brief TODO
*/
Connection {
	name: "secure"
	aliases: [ ]
	priority: 3

	/*!
	\qmlpropery bool SecureConnection::usbZLPQuirk
	\brief Enable or disable the USB Zero Packet Length quirk

	The USB Zero Packet Length quirk should enabled on some devices as a
	work-around to a bug in the USB CDC-ACM device driver used by oldest ROM
	codes to handle connections to SAM-BA monitors through USB.
	*/
	property alias usbZLPQuirk: helper.usbZLPQuirk

	/*!
	\qmlproperty string SecureConnection::port
	\brief The port to use for the connection

	For Windows, port have the form "COMxx" where \e xx is the number
	assigned to the port, for example "COM2" or "COM84".

	For Linux, use the device name without its "/dev/" prefix, i.e. for
	"/dev/ttyACM0", use "ttyACM0".
	*/
	property alias port: helper.port

	/*!
	\qmlproperty int SecureConnection::baudRate
	\brief The serial baud rate to use for the connection.

	If the requested baudrate is not supported, the closest supported one
	will be used. When connected directly to the AT91 CDC ACM USB port, the
	baudrate is ignored.
	*/
	property alias baudRate: helper.baudRate

	/*!
	\qmlproperty int SecureConnection::verboseLevel
	\brief The verbose level of the connection.
	*/
	property alias verboseLevel: helper.verboseLevel

	/*!
	\sa Connection::open()
	*/
	function open() {
		helper.open()
	}

	/*!
	\sa Connection::close()
	*/
	function close() {
		helper.close()
	}

	/*!
	\sa Connection::toSecureMonitor()
	*/
	function toSecureMonitor() {
		return true
	}

	/*! \internal */
	function probeDeviceVersion() {
		if (!device.hasMultipleROMVersions || device.activeROMVersion >= 0)
			return

		var version = getDeviceVersion()
		device.setActiveROMVersion(version)
	}

	/*!
	\sa Connection::appletUpload
	*/
	function appletUpload(new_applet)
	{
		applet = undefined

		var codeUrl = new_applet.codeUrl
		codeUrl = codeUrl.replace(/.bin$/, ".cip")

		probeDeviceVersion()
		codeUrl = device.translateSecureAppletUrl(codeUrl)

		var file = File.open(encodeURI(codeUrl), false)
		var appletCode = file.readAll()
		file.close()
		if (!appletCode)
			return false

		if (helper.executeWriteCommand("SAPT", appletCode))
		{
			applet = new_applet
			return true
		}

		print("Could not upload applet (error " + helper.status + ": " + strerror(helper.status) + ")")
		return false
	}

	/*!
	\sa Connection::appletBufferRead
	*/
	function appletBufferRead(length)
	{
		if (!applet)
			return
		if (length > applet.bufferSize)
			return
		if (length == 0)
			return new ArrayBuffer()
		return helper.executeReadCommand("RFIL", length, 10000)
	}

	/*!
	\sa Connection::appletBufferWrite
	*/
	function appletBufferWrite(data)
	{
		if (!applet)
			return false
		if (data.byteLength > applet.bufferSize)
			return false
		if (data.byteLength == 0)
			return true
		return helper.executeWriteCommand("SFIL", data)
	}

	/*!
	\sa Connection::go()
	*/
	function go(address)
	{
		return helper.go()
	}

	/*!
	\sa Connection::waitForMonitor()
	*/
	function waitForMonitor(timeout)
	{
		return helper.waitForMonitor(timeout)
	}

	/*!
	\sa Connection::appletMailboxSend()
	*/
	function appletMailboxSend()
	{
		if (mailbox.length != 32)
			return false

		return helper.executeWriteCommand("SMBX", mailbox.buffer)
	}

	/*!
	\sa Connection::appletMailboxReceive()
	*/
	function appletMailboxReceive(timeout)
	{
		var mailboxData = helper.executeReadCommand("RMBX", 32 * 4, timeout)
		if (typeof mailboxData !== "object" || mailboxData.byteLength != 32 * 4) {
			mailbox = new Uint32Array(32)
			return false
		}

		mailbox = new Uint32Array(mailboxData)
		return true
	}

	/*! \internal */
	function handle_helper_connectionOpened(at91) {
		print("Connection opened.")
		appletConnectionType = at91 ? AppletConnectionType.USB : AppletConnectionType.SERIAL
		connectionOpened()
	}

	/*! \internal */
	function handle_helper_connectionFailed(message) {
		print("Error: " + message)
		connectionFailed(message)
	}

	/*! \internal */
	function handle_helper_connectionClosed() {
		print("Connection closed.")
		connectionClosed()
	}

	SecureConnectionHelper {
		id: helper
		onConnectionOpened: parent.handle_helper_connectionOpened(at91)
		onConnectionFailed: parent.handle_helper_connectionFailed(message)
		onConnectionClosed: parent.handle_helper_connectionClosed()
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function executeCustomCommand(command, direction, filename) {
		if (direction === "read") {
			var response = helper.executeReadCommand(command, 0, 0)
			if (helper.status == 0) {
				if (typeof filename !== "undefined") {
					var file = File.open(filename, true)
					file.write(response)
					file.close()
				} else {
					if (response.byteLength > 0) {
						var buf = new Uint8Array(response)
						var str = ""
						var i = 0
						while (i < buf.length) {
							var c = buf[i++]
							str += ('00' + c.toString(16)).slice(-2)
						}
						print("Response: " + str)
					}
				}
			} else {
				return "Custom command failed (error " + helper.status + ": " + strerror(helper.status) + ")"
			}
		} else if (direction === "write") {
			var file = File.open(filename, false)
			if (file === null)
				return "Custom command failed to open file '" + filename + "'"
			var query = file.readAll()
			file.close()

			if (!helper.executeWriteCommand(command, query))
				return "Custom command failed (error " + helper.status + ": " + strerror(helper.status) + ")"
		} else {
			helper.executeReadCommand(command, 0, 0)
			if (helper.status != 0)
				return "Custom command failed (error " + helper.status + ": " + strerror(helper.status) + ")"
		}
	}

	/*!
	\sa Connection::getDeviceVersion()
	*/
	function getDeviceVersion() {
		return helper.getDeviceVersion()
	}

	/*! \internal */
	function commandLineCommandVersion(args) {
		if (args.length !== 0)
			return "Invalid number of arguments (expected 0)."

		var version = getDeviceVersion()
		if (version.length > 0) {
			print("ROM Version: " + version)
		} else {
			print("Error while requesting ROM version (error " + helper.status + ": " + strerror(helper.status) + ")")
		}
	}

	/*! \internal */
	function commandLineCommandCustom(args) {
		var command
		var direction
		var filename

		switch (args.length) {
		case 3:
			if (args[2].length > 0) {
				filename = args[2]
			}
			// fall-through
		case 2:
			if (args[1].length > 0) {
				direction = args[1]
				if (direction !== "read" && direction !== "write")
					return "Invalid direction argument (expected 'read' or 'write')"
			}
			// fall-through
		case 1:
			command = args[0]
			break
		default:
			return "Invalid number of arguments"
		}

		if (typeof filename !== "undefined" && typeof direction === "undefined")
			return "Direction must be provided when filename argument is present"

		return executeCustomCommand(command, direction, filename)
	}

	/*! \internal */
	function commandLineCommandEnableSecure(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."

		if (device.hasMultipleROMVersions && device.activeROMVersion < 0) {
			var resetApplet = device.applet("reset")

			var appletFilename = encodeURI(resetApplet.codeUrl)
			var file = File.open(appletFilename, false)
			if (file === null)
				return "Failed to open '" + appletFilename + "'"
			var appletCode = file.readAll()
			file.close()

			var version = helper.getDeviceVersionAndReset(resetApplet.codeAddr,
								      resetApplet.mailboxAddr,
								      resetApplet.entryAddr,
								      appletCode)
			device.setActiveROMVersion(version)
		}
		var filename = device.translateInputFileName(args[0])

		var str = executeCustomCommand("WSMD", "write", filename)
		if (device.family !== "sama5d3" || helper.status !== -16)
			return str
	}

	/*! \internal */
	function commandLineCommandWriteCustomerKey(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."

		probeDeviceVersion()
		var filename = device.translateInputFileName(args[0])

		return executeCustomCommand("WCKY", "write", filename)
	}

	/*! \internal */
	function commandLineCommandWriteRSAHash(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."

		probeDeviceVersion()
		var filename = device.translateInputFileName(args[0])

		return executeCustomCommand("WRHA", "write", filename)
	}

	/*! \internal */
	function commandLineCommandNoArgs(cmd, args) {
		if (args.length !== 0)
			return "Invalid number of arguments (expected none)."

		return executeCustomCommand(cmd)
	}

	/*! \internal */
	function commandLineCommandSetPairingMode(args) {
		return commandLineCommandNoArgs("SPAI", args)
	}

	/*! \internal */
	function commandLineCommands() {
		var common_commands = ["version", "custom", "write_customer_key"]
		var device_commands = device.commandLineSecureCommands()
		var commands = common_commands.concat(device_commands)
		var unique_commands = commands.filter(function(elem, index, self) {
			return index == self.indexOf(elem)
		})
		return unique_commands
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (device.hasSecureCommand(command))
			return device.commandLineSecureCommandHelp(command)

		if (command === "version") {
			return ["* version - display the ROM code version",
			        "Syntax:",
			        "    version"]
		}
		else if (command === "custom") {
			return ["* custom - send a custom command to the secure monitor",
			        "Syntax:",
			        "    custom:<command>:[<direction>]:[<file>]"]
		}
		else if (command === "write_customer_key") {
			return ["* write_customer_key - write the customer key into the device",
			        "Syntax:",
			        "    write_customer_key:<file>"]
		}
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (device.hasSecureCommand(command))
			return device.commandLineSecureCommand(command, args)

		if (command === "version")
			return commandLineCommandVersion(args)
		else if (command === "custom")
			return commandLineCommandCustom(args)
		else if (command === "write_customer_key")
			return commandLineCommandWriteCustomerKey(args)
		else
			return "Unknown command."
	}

	/*! \internal */
	function commandLineParse(args) {
		switch (args.length) {
		case 3:
			if (args[2].length > 0) {
				verboseLevel = parseInt(args[2])
				if (isNaN(verboseLevel))
					return "Invalid verbose level (not a number)"
			}
			// fall-through
		case 2:
			if (args[1].length > 0) {
				baudRate = parseInt(args[1])
				if (isNaN(baudRate))
					return "Invalid serial baudrate (not a number)"
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				port = args[0]
			}
			// fall-through
		case 0:
			return
		default:
			return "Invalid number of arguments"
		}
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax:",
		        "    secure:[<port>]:[<baudrate>]:[<verbose>]",
		        "Examples:",
		        "    secure          serial port (will use first AT91 USB if found otherwise first serial port)",
		        "    secure:COM80    serial port on COM80",
		        "    secure:ttyACM0  serial port on /dev/ttyACM0",
		        "    secure:::1      serial port (display communication between sam-ba and the secure SAM-BA monitor of the target)"]
	}

	/*! \internal */
	function strerror(code) {
		var str = device.strerror(code)
		if (typeof str === "string")
			return str

		return "Unknown error"
	}
}
