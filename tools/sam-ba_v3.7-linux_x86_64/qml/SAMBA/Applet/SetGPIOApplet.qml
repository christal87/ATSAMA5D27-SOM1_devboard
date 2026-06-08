/*
 * Copyright (c) 2015-2018, Atmel Corporation.
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
	name: "setgpio"
	description: "set GPIO configuration "
	commands: [
		AppletCommand { name:"initialize"; code:0 }
	]

	/*! \internal */
	function buildInitArgs() {
		var config = device.config.setgpio

		if (typeof config.group === "undefined" ||
			typeof config.mask === "undefined" ||
			typeof config.type === "undefined" ||
			typeof config.attribute === "undefined")
			throw new Error("Incomplete GPIO configuration")

		var args = defaultInitArgs()
		var config = [ 0, config.group, config.mask, config.type, config.attribute ]
		Array.prototype.push.apply(args, config)
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args) {
		if (args.length > 4)
			return "Invalid number of arguments."

		var config = device.config.setgpio

        if (args.length >= 4 && args[3].length > 0) {
			config.attribute = Utils.parseInteger(args[3]);
            if (isNaN(config.attribute))
				return "Invalid attribute (not a number)."
		}

		if (args.length >= 3 && args[2].length > 0) {
			config.type = Utils.parseInteger(args[2]);
			if (isNaN(config.type))
				return "Invalid type (not a number)."
		}

		if (args.length >= 2 && args[1].length > 0) {
			config.mask = Utils.parseInteger(args[1]);
			if (isNaN(config.mask))
				return "Invalid mask (not a number)."
		}

		if (args.length >= 1 && args[0].length > 0) {
			config.group = Utils.parseInteger(args[0]);
			if (isNaN(config.group))
				return "Invalid group (not a number)."
		}

		return true
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: setgpio:<group>:<mask>:<type>:<attribute>",
			"Parameters:",
			"	 group	   The IO group containing the pins to configure",
			"	 mask	   Bitmask of pin(s) to configure",
			"	 type 	   Pin type",
			"	 attribute Pin config attribute"]
	}

	/*! \internal */
	function commandLineCommands() {
		return [ ]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		return "Unknown command."
	}
}

