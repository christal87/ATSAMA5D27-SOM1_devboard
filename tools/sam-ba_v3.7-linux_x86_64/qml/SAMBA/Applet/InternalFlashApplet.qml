/*
 * Copyright (c) 2017, Atmel Corporation.
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

/*! \internal */
Applet {
	property int userSignaturePages: 0
	property int userSignatureBlockPages: 0

	property int userSignatureSize: userSignaturePages * pageSize
	property int userSignatureBlockSize: userSignatureBlockPages * pageSize

	name: "internalflash"
	description: "Internal Flash"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 },
		AppletCommand { name:"getGPNVM"; code:0x34 },
		AppletCommand { name:"setGPNVM"; code:0x35 },
		AppletCommand { name:"getWPMR"; code:0x38 },
		AppletCommand { name:"setWPMR"; code:0x39 },
		AppletCommand { name:"getUSR"; code:0x40 },
		AppletCommand { name:"setUSR"; code:0x41 },
		AppletCommand { name:"eraseUserSignaturePages"; code:0x42 },
		AppletCommand { name:"readUserSignaturePages"; code:0x43 },
		AppletCommand { name:"writeUserSignaturePages"; code:0x44 }
	]

	function prepareBootFile(file) {
		// nothing to do here
	}

	/*! \internal */
	function buildInitArgs() {
		var config = device.config.internalflash

		if (typeof config.instance === "undefined")
			config.instance = 0

		var args = defaultInitArgs()
		args.push(config.instance)
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args)	{
		if (args.length > 1)
			return "Invalid number of arguments."

		var config = device.config.internalflash

		if (args.length >= 1) {
			if (args[0].length > 0) {
				config.instance = Utils.parseInteger(args[0])
				if (isNaN(config.instance))
					return "Invalid Flash Controller instance (not a number)."
			}
		}

		return true
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: internalflash:[<instance>]",
			"Parameters:",
			"    instance   Flash controller instance",
			"Examples:",
			"    internalflash      use default board settings",
			"    internalflash:1    select Flash Controller 1 (SEFC1)"]
	}

	/*! \internal */
	function commandLineCommands() {
		var commands = []
		commands.push("erase")
		commands.push("read")
		commands.push("verify")
		commands.push("write")
		commands.push("eraseup")
		commands.push("readup")
		commands.push("verifyup")
		commands.push("writeup")
		commands.push("getgpnvm")
		commands.push("setgpnvm")
		commands.push("getwpmr")
		commands.push("setwpmr")
		commands.push("getusr")
		commands.push("setusr")
		return commands
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "getgpnvm") {
			return ["* getgpnvm - get GPNVM bits",
				"Syntax:",
				"    getgpnvm:[<mask>]",
				"Examples:",
				"    getgpnvm               get all GPNVMs",
				"    getgpnvm:0x1e0         get GPNVM[8:5] only"]
		} else if (command === "setgpnvm") {
			return ["* setgpnvm - set GPNVM bits",
				"Syntax:",
				"    setgpnvm:<value>:[<mask>]",
				"Examples:",
				"    setgpnvm:0x1           set GPNMV[0] to 1b, clear all other GPNVMs",
				"    setgpnvm:0x0:0x1       clear GPNVM[0]",
				"    setgpnvm:0x060:0x1e0   set GPNVM[8:5] to 0011b"]
		} else if (command === "getwpmr") {
			return ["* getwpmr - get Write Protect Mode Register (EEFC_WPMR)",
				"Syntax:",
				"    getwpmr:[<mask>]",
				"Examples:",
				"    getwpmr                get EEFC_WPMR",
				"    getwpmr:0x0000ff00     get bits 15:8 of EEFC_WPMR"]
		} else if (command === "setwpmr") {
			return ["* setwpmr - set Write Protect Mode Register (EEFC_WPMR)",
				"Syntax:",
				"    setwpmr:<value>:[<mask>]",
				"Examples:",
				"    setwpmr:0x00000101:0x01000101 set bits 0 and 8, clear bit 24 of EEFC_WPMR"]
		} else if (command === "getusr") {
			return ["* getusr - get User Signature Rights Register (EEFC_USR)",
				"Syntax:",
				"    getusr:[<mask>]",
				"Examples:",
				"    getusr                 get EEFC_USR",
				"    getusr:0x0000ff00      get bits 15:8 of EEFC_USR"]
		} else if (command === "setusr") {
			return ["* setusr - set User Signature Rights Register (EEFC_USR)",
				"Syntax:",
				"    setsur:<value>:[<mask>]",
				"Examples:",
				"    setwp:0x00000101:0x01000101 set bits 0 and 8, clear bit 24 of EEFC_USR"]
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

	/*! \internal */
	function gpnvmFromText(text) {
	}

	/*! \internal */
	function gpnvmToText(value) {
	}

	/*! \internal */
	function getGPNVM(mask) {
		var status, cmd

		cmd = command("getGPNVM")
		status = connection.appletExecute(cmd, [mask])
		if (status !== 0)
			throw new Error("Cannot read GPNVM values (status = " + status + ")")

		var value = connection.appletMailboxRead(1)
		if (isNaN(value) || typeof value === "undefined")
			throw new Error("Cannot read GPNVM values")

		return value
	}

	/*! \internal */
	function commandLineCommandGetGPNVM(args) {
		var mask = 0xffffffff

		switch (args.length) {
		case 1:
			if (args[0].length > 0) {
				mask = Utils.parseInteger(args[0])
				if (isNaN(mask))
					mask = gpnvmFromText(args[0])
				if (isNaN(mask) && typeof mask === "undefined")
					return "Invalid mask parameter"
			}
			// fall-through
		case 0:
			break
		default:
			return "Invalid number of arguments (expected 0 or 1)."
		}

		var value = getGPNVM(mask)
		var text = gpnvmToText(value)
		if (typeof text === "undefined")
			print("GPNVM = " + Utils.hex(value, 8))
		else
			print("GPNVM = " + Utils.hex(value, 8) + " / " + text)
	}

	/*! \internal */
	function setGPNVM(value, mask) {
		var status, cmd

		cmd = command("setGPNVM")
		status = connection.appletExecute(cmd, [mask, value])
		if (status !== 0)
			throw new Error("Cannot write GPNVM values (status = " + status + ")")
	}

	/*! \internal */
	function commandLineCommandSetGPNVM(args) {
		var value, mask = 0xffffffff

		switch (args.length) {
		case 2:
			if (args[1].length > 0) {
				mask = Utils.parseInteger(args[1])
				if (isNaN(mask))
					mask = gpnvmFromText(args[1])
				if (isNaN(mask) && typeof mask === "undefined")
					return "Invalid mask parameter"
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				value = Utils.parseInteger(args[0])
				if (isNaN(value))
					value = gpnvmFromText(args[0])
				if (isNaN(value) && typeof value === "undefined")
					return "Invalid value parameter"
			} else {
				return "Invalid value parameter (empty)"
			}
			break
		default:
			return "Invalid number of arguments (expected 1 or 2)."
		}

		setGPNVM(value, mask)
	}

	/*! \internal */
	function wpmrFromText(text) {
	}

	/*! \internal */
	function wpmrToText(value) {
	}

	/*! \internal */
	function getWPMR(mask) {
		var status, cmd

		cmd = command("getWPMR")
		status = connection.appletExecute(cmd, [mask])
		if (status !== 0)
			throw new Error("Cannot read EEFC_WPMR (status = " + status + ")")

		var value = connection.appletMailboxRead(1)
		if (isNaN(value) || typeof value === "undefined")
			throw new Error("Cannot read EEFC_WPMR")

		return value
	}

	/*! \internal */
	function commandLineCommandGetWPMR(args) {
		var mask = 0xffffffff

		switch (args.length) {
		case 1:
			if (args[0].length > 0) {
				mask = Utils.parseInteger(args[0])
				if (isNaN(mask))
					mask = wpmrFromText(args[0])
				if (isNaN(mask) && typeof mask === "undefined")
					return "Invalid mask parameter"
			}
			// fall-through
		case 0:
			break
		default:
			return "Invalid number of arguments (expected 0 or 1)."
		}

		var value = getWPMR(mask)
		var text = wpmrToText(value)
		if (typeof text === "undefined")
			print("EEFC_WPMR = " + Utils.hex(value, 8))
		else
			print("EEFC_WPMR = " + Utils.hex(value, 8) + " / " + text)
	}

	/*! \internal */
	function setWPMR(value, mask) {
		var status, cmd

		cmd = command("setWPMR")
		status = connection.appletExecute(cmd, [mask, value])
		if (status !== 0)
			throw new Error("Cannot write EEFC_WPMR (status = " + status + ")")
	}

	/*! \internal */
	function commandLineCommandSetWPMR(args) {
		var value, mask = 0xffffffff

		switch (args.length) {
		case 2:
			if (args[1].length > 0) {
				mask = Utils.parseInteger(args[1])
				if (isNaN(mask))
					mask = wpmrFromText(args[1])
				if (isNaN(mask) && typeof mask === "undefined")
					return "Invalid mask parameter"
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				value = Utils.parseInteger(args[0])
				if (isNaN(value))
					value = wpmrFromText(args[0])
				if (isNaN(value) && typeof value === "undefined")
					return "Invalid value parameter"
			} else {
				return "Invalid value parameter (empty)"
			}
			break
		default:
			return "Invalid number of arguments (expected 1 or 2)."
		}

		setWPMR(value, mask)
	}

	/*! \internal */
	function usrFromText(text) {
	}

	/*! \internal */
	function usrToText(value) {
	}

	/*! \internal */
	function getUSR(mask) {
		var status, cmd

		cmd = command("getUSR")
		status = connection.appletExecute(cmd, [mask])
		if (status !== 0)
			throw new Error("Cannot read EEFC_USR (status = " + status + ")")

		var value = connection.appletMailboxRead(1)
		if (isNaN(value) || typeof value === "undefined")
			throw new Error("Cannot read EEFC_USR")

		return value
	}

	/*! \internal */
	function commandLineCommandGetUSR(args) {
		var mask = 0xffffffff

		switch (args.length) {
		case 1:
			if (args[0].length > 0) {
				mask = Utils.parseInteger(args[0])
				if (isNaN(mask))
					mask = usrFromText(args[0])
				if (isNaN(mask) && typeof mask === "undefined")
					return "Invalid mask parameter"
			}
			// fall-through
		case 0:
			break
		default:
			return "Invalid number of arguments (expected 0 or 1)."
		}

		var value = getUSR(mask)
		var text = usrToText(value)
		if (typeof text === "undefined")
			print("EEFC_USR = " + Utils.hex(value, 8))
		else
			print("EEFC_USR = " + Utils.hex(value, 8) + " / " + text)
	}

	/*! \internal */
	function setUSR(value, mask) {
		var status, cmd

		cmd = command("setUSR")
		status = connection.appletExecute(cmd, [mask, value])
		if (status !== 0)
			throw new Error("Cannot write EEFC_USR (status = " + status + ")")
	}

	/*! \internal */
	function commandLineCommandSetUSR(args) {
		var value, mask = 0xffffffff

		switch (args.length) {
		case 2:
			if (args[1].length > 0) {
				mask = Utils.parseInteger(args[1])
				if (isNaN(mask))
					mask = usrFromText(args[1])
				if (isNaN(mask) && typeof mask === "undefined")
					return "Invalid mask parameter"
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				value = Utils.parseInteger(args[0])
				if (isNaN(value))
					value = usrFromText(args[0])
				if (isNaN(value) && typeof value === "undefined")
					return "Invalid value parameter"
			} else {
				return "Invalid value parameter (empty)"
			}
			break
		default:
			return "Invalid number of arguments (expected 1 or 2)."
		}

		setUSR(value, mask)
	}

	/*! \internal */
	function callEraseUserSignaturePages(pageOffset, length) {
		var cmd = command("eraseUserSignaturePages")
		var args = [ pageOffset, length ]
		var status = connection.appletExecute(cmd, args)
		if (status === 0)
			return connection.appletMailboxRead(0)
		else
			throw new Error("Could not erase User Signature Pages at address " +
					Utils.hex(pageOffset * pageSize, 8) +
					" (status: " + status + ")")
	}

	/*! \internal */
	function eraseUserSignaturePages(offset, size) {
		if (typeof offset === "undefined") {
			offset = 0
		} else {
			if ((offset & (userSignatureBlockSize - 1)) !== 0)
				throw new Error("Offset is not aligned to the User Signature Block size (" + userSignatureBlockSize + " bytes)")
			offset /= pageSize
		}

		// no size supplied, do a full erase
		if (size === undefined) {
			size = userSignaturePages - offset
		} else {
			if ((size & (userSignatureBlockSize - 1)) !== 0)
				throw new Error("Size is not aligned to the User Signature Block Size (" + userSignatureBlockSize + " bytes)")
			size /= pageSize
		}

		if ((offset + size) > userSignaturePages)
			throw new Error("Requested erase region overflows User Signature Pages")

		var end = offset + size
		while (offset < end) {
			var count = callEraseUserSignaturePages(offset, userSignatureBlockPages)
			if (count !== userSignatureBlockPages)
				throw new Error("Cannot erase " + userSignatureBlockSize + " bytes at address " +
						Utils.hex(offset * pageSize, 8))
			var percent = 100 * (1 - ((end - offset - count) / size))
			print("Erased " + (count * pageSize) + " bytes at address " +
			      Utils.hex(offset * pageSize, 8) + " (" + percent.toFixed(2) + "%)")
			offset += count
		}
	}

	/*! \internal */
	function commandLineCommandEraseUserSignaturePages(args) {
		var addr, length

		switch (args.length) {
		case 2:
			if (args[1].length !== 0) {
				length = Utils.parseInteger(args[1])
				if (isNaN(length))
					return "Invalid length parameter (not a number)."
			}
			// fall-through
		case 1:
			if (args[0].length !== 0) {
				addr = Utils.parseInteger(args[0])
				if (isNaN(addr))
					return "Invalid address parameter (not a number)."
			}
			// fall-through
		case 0:
			break
		default:
			return "Invalid number of arguments (expected 0, 1 or 2)."
		}

		if (typeof addr === "undefined")
			addr = 0
		if (typeof length === "undefined")
			length = userSignatureSize - addr

		try {
			eraseUserSignaturePages(addr, length)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function callReadUserSignaturePages(pageOffset, length) {
		var remaining, args, status, pagesRead, data, cmd

		if (pageOffset + length > userSignaturePages) {
			remaining = userSignaturePages - pageOffset
			throw new Error("Cannot read past end of User Signature pages, only " +
			(remaining * pageSize) +
			" bytes remaining at offset " +
			Utils.hex(pageOffset * pageSize, 8) +
			" (requested " + (length * pageSize) +
			" bytes)")
		}

		cmd = command("readUserSignaturePages")
		args = [ pageOffset, length ]
		status = connection.appletExecute(cmd, args)
		if (status !== 0)
			throw new Error("Failed to read User Signature pages at address " +
					Utils.hex(pageOffset * pageSize, 8) +
					" (status: " + status + ")")
		pagesRead = connection.appletMailboxRead(0)
		if (pagesRead !== length)
			throw new Error("Could not read pages at address "
					+ Utils.hex(pageOffset * pageSize, 8)
					+ " (applet returned success but did not return enough data)")
		data = connection.appletBufferRead(pagesRead * pageSize)
		if (typeof data === "undefined" || data.byteLength < pagesRead * pageSize)
			throw new Error("Could not read User Signature pages at address "
					+ Utils.hex(pageOffset * pageSize, 8)
					+ " (read from applet buffer failed)")

		return data
	}

	/*! \internal */
	function readUserSignaturePages(offset, size, fileName) {
		var file = File.open(fileName, true)
		if (!file)
			throw new Error("Could not write file '" + fileName + "'")

		try {
			var remaining = size
			while (remaining > 0) {
				var firstPage = Math.floor(offset / pageSize)
				var lastPage = Math.ceil((offset + remaining) / pageSize)

				/* read as much as the buffer can fit, and at least one page */
				var count = Math.max(1, Math.min(lastPage - firstPage, bufferPages))

				/* read pages from the applet */
				var result = callReadUserSignaturePages(firstPage, count)
				if (result.byteLength < count * pageSize)
					count = result.byteLength / pageSize

				if (count !== 0) {
					/* compute offset and length of data */
					var readOffset = offset - firstPage * pageSize
					var readLength = Math.min(remaining, count * pageSize - readOffset)

					/* write data to output file */
					var written = file.write(result.slice(readOffset, readOffset + readLength))
					if (written !== readLength)
						throw new Error("Could not write to file '" + fileName + "'")

					/* update progression percentage and display it */
					var percent = 100 * (1  - ((remaining - readLength) / size))
					print("Read " + readLength + " bytes at address " +
					      Utils.hex(offset, 8) + " (" + percent.toFixed(2) + "%)")

					/* finally, update the offset and remaining bytes counters */
					offset += readLength
					remaining -= readLength
				}
			}
		}
		finally {
			file.close()
		}
	}

	/*! \internal */
	function commandLineCommandReadUserSignaturePages(args) {
		var filename, addr, length

		if (args.length < 1)
			return "Invalid number of arguments (expected at least 1)."
		if (args.length > 3)
			return "Invalid number of arguments (expected at most 3)."

		// filename (required)
		if (args[0].length === 0)
			return "Invalid file name parameter (empty)"
		filename = args[0]

		if (args.length >= 2) {
			// address (optional)
			if (args[1].length !== 0) {
				addr = Utils.parseInteger(args[1])
				if (isNaN(addr))
					return "Invalid address parameter (not a number)."
			}
		}

		if (args.length >= 3) {
			// length (optional)
			if (args[2].length !== 0) {
				length = Utils.parseInteger(args[2])
				if (isNaN(length))
					return "Invalid length parameter (not a number)."
			}
		}

		if (typeof addr === "undefined")
			addr = 0
		if (typeof length === "undefined")
			length = userSignatureSize - addr

		try {
			readUserSignaturePages(addr, length, filename)
		} catch (err) {
			return err.message
		}
	}

	/*! \internal */
	function callWriteUserSignaturePages(pageOffset, data) {
		var length, remaining, args, status, pagesWritten, cmd

		cmd = command("writeUserSignaturePages")
		if ((data.byteLength & (pageSize - 1)) !== 0)
			throw new Error("Invalid write data buffer length " +
					"(must be a multiple of page size)")
		length = data.byteLength / pageSize
		if (pageOffset + length > userSignaturePages) {
			remaining = userSignaturePages - pageOffset
			throw new Error("Cannot write past end of User Signature pages, only " +
					(remaining * pageSize) +
					" bytes remaining at offset " +
					Utils.hex(pageOffset * pageSize, 8) +
					" (requested " + (length * pageSize) +
					" bytes)")
		}
		if (!connection.appletBufferWrite(data))
			throw new Error("Could not write pages at address "
					+ Utils.hex(pageOffset * pageSize, 8)
					+ " (write to applet buffer failed)")
		args = [ pageOffset, length ]
		status = connection.appletExecute(cmd, args)
		if (status !== 0)
			throw new Error("Failed to write pages at address " +
					Utils.hex(pageOffset * pageSize, 8) +
					" (status: " + status + ")")
		pagesWritten = connection.appletMailboxRead(0)
		if (pagesWritten !== length)
			throw new Error("Could not write pages at address " +
					Utils.hex(pageOffset * pageSize, 8) +
					" (applet returned success but did not write enough data)")
		return pagesWritten
	}

	/*! \internal */
	function writeUserSignaturePages(offset, fileName) {
		var file = File.open(fileName, false)
		if (!file)
			throw new Error("Could not read from file '" + fileName + "'")

		offset = prepareForWrite(offset, file, false)
		offset /= pageSize

		try {
			var size = file.size() / pageSize

			var current = 0
			var percent
			var remaining = size
			var cmd = command("writeUserSignaturePages")
			while (remaining > 0) {
				file.seek(current * pageSize)
				var count = Math.min(remaining, bufferPages)
				var data = file.read(count * pageSize)
				var pagesWritten = callWriteUserSignaturePages(offset, data)
				if (pagesWritten < count)
					count = pagesWritten

				percent = 100 * (1 - ((remaining - count) / size))
				print("Wrote " + (count * pageSize) + " bytes at address " +
				      Utils.hex(offset * pageSize, 8) +
				      " (" + percent.toFixed(2) + "%)")

				current += count
				offset += count
				remaining -= count
			}
		}
		finally {
			file.close()
		}
	}

	/*! \internal */
	function verifyUserSignaturePages(offset, fileName) {
		var file = File.open(fileName, false)
		if (!file)
			throw new Error("Could not read file '" + fileName + "'")

		offset = prepareForWrite(offset, file, false)
		offset /= pageSize

		try {
			var size = file.size() / pageSize

			var remaining = size
			var startOffset = offset
			while (remaining > 0) {
				var count = Math.min(remaining, bufferPages)

				var result = callReadUserSignaturePages(offset, count)

				file.seek((offset - startOffset) * pageSize)
				var data = file.read(count * pageSize)

				var comp = Utils.compareBuffers(result, data)
				if (comp !== undefined)
					throw new Error("Failed verification, First error at offset " +
							Utils.hex(offset * pageSize + comp, 8))

				var percent = 100 * (1 - ((remaining - count) / size))
				print("Verified " + (count * pageSize) + " bytes at address " +
				      Utils.hex(offset * pageSize, 8) +
				      " (" + percent.toFixed(2) + "%)")

				offset += count
				remaining -= count
			}
		}
		finally {
			file.close()
		}
	}

	/*! \internal */
	function commandLineCommandWriteVerifyUserSignaturePages(args, shouldWrite) {
		var addr, length, filename

		if (args.length < 1)
			return "Invalid number of arguments (expected at least 1)."
		if (args.length > 2)
			return "Invalid number of arguments (expected at most 2)."

		// filename (required)
		if (args[0].length === 0)
			return "Invalid file name parameter (empty)"
		filename = args[0]

		// address (optional)
		if (args.length >= 2) {
			if (args[1].length > 0) {
				addr = Utils.parseInteger(args[1])
				if (isNaN(addr))
					return "Invalid address parameter (not a number)."
			}
		}

		if (typeof addr === "undefined")
			addr = 0

		try {
			if (shouldWrite)
				writeUserSignaturePages(addr, filename)
			else
				verifyUserSignaturePages(addr, filename)
		} catch (err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (command === "getgpnvm") {
			return commandLineCommandGetGPNVM(args)
		} else if (command === "setgpnvm") {
			return commandLineCommandSetGPNVM(args)
		} else if (command === "getwpmr") {
			return commandLineCommandGetWPMR(args)
		} else if (command === "setwpmr") {
			return commandLineCommandSetWPMR(args)
		} else if (command === "getusr") {
			return commandLineCommandGetUSR(args)
		} else if (command === "setusr") {
			return commandLineCommandSetUSR(args)
		} else if (command === "eraseup") {
			return commandLineCommandEraseUserSignaturePages(args)
		} else if (command === "readup") {
			return commandLineCommandReadUserSignaturePages(args)
		} else if (command === "writeup") {
			return commandLineCommandWriteVerifyUserSignaturePages(args, true)
		} else if (command === "verifyup") {
			return commandLineCommandWriteVerifyUserSignaturePages(args, false)
		} else {
			return defaultCommandLineCommand(command, args)
		}
	}
}
