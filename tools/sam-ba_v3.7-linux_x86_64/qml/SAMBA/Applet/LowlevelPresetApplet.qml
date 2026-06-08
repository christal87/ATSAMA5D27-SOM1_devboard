/*
 * Copyright (c) 2018, Microchip.
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
LowlevelApplet {
	readonly property int xtalf_passwd: 0x5a5 << 20

	/*! \internal */
	function buildInitArgs() {
		var config = device.config.lowlevel

		if (typeof config.preset === "undefined")
			config.preset = 0

		if (typeof config.xtalf === "undefined")
			config.xtalf = 0

		if (config.xtalf !== 0)
			config.xtalf |= xtalf_passwd

		var args = defaultInitArgs()
		Array.prototype.push.apply(args, [config.preset, config.xtalf, 0, 0])
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args) {
		if (args.length > 2)
			return "Invalid number of arguments."

		var config = device.config.lowlevel


		if (args.length >= 2) {
			if (args[1].length > 0) {
				config.xtalf = Utils.parseInteger(args[1])
				if (isNaN(config.xtalf))
					return "Invalid xtalf (not a number)."
			}
		}

		if (args.length >= 1) {
			if (args[0].length > 0) {
				config.preset = Utils.parseInteger(args[0])
				if (isNaN(config.preset))
					return "Invalid preset (not a number)."
			}
		}

		return true
	}

	/* \internal */
	function commandLineHelp() {
		return ["Syntax: lowlevel:[<preset>]:[<xtalf>]",
			"Parameters:",
			"    preset  System clock configuration",
			"    xtalf   Frequency (in kHz) of the Main Crystal Osciallator",
			"Examples: ",
			"    lowlevel           use default board settings if defined, preset 0 otherwise",
			"    lowlevel:0         use preset 0 for system clock configuration",
			"    lowlevel::24000    skip the main crystal detection and force its frequency at 24MHz"]
	}
}
