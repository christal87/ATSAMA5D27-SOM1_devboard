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

.pragma library

var SECURITY_OFF                = 0
var SECURITY                    = 0x1 << SECURITY_OFF

var BMS_OFF                     = 1
var BMS                         = 0x1 << BMS_OFF

var EFL_OFF                     = 2
var EFL_MASK                    = 0x7 << EFL_OFF

var SBS_OFF                     = 5
var SBS_MASK                    = 0xf << SBS_OFF
var SBS_SAMBA_MONITOR           = 0x0 << SBS_OFF
var SBS_STANDARD_BOOT           = 0x3 << SBS_OFF
var SBS_SECURE_SAMBA_MONITOR    = 0x9 << SBS_OFF
var SBS_SECURE_BOOT             = 0xa << SBS_OFF
var SBS_SECURE_BOOT_NO_MONITOR  = 0xc << SBS_OFF

function toText(value)
{
    var text = []

    switch (value & SBS_MASK) {
    case SBS_SAMBA_MONITOR:
	text.push("SAMBA_MONITOR")
	break
    case SBS_STANDARD_BOOT:
	text.push("STANDARD_BOOT")
	break
    case SBS_SECURE_SAMBA_MONITOR:
	text.push("SECURE_SAMBA_MONITOR")
	break
    case SBS_SECURE_BOOT:
	text.push("SECURE_BOOT")
	break
    case SBS_SECURE_BOOT_NO_MONITOR:
	text.push("SECURE_BOOT_NO_MONITOR")
	break
    case SBS_MASK:
	text.push("SBS_MASK")
	break
    default:
	text.push("SBS_RESERVED")
	break
    }

    if ((value & EFL_MASK) !== 0)
	text.push("EFL")

    if (value & BMS)
	text.push("BMS")

    if (value & SECURITY)
	text.push("SECURITY")

    return text.join(",")
}

function fromText(text)
{
    var entries = text.split(',')

    var value = 0
    for (var i = 0; i < entries.length; i++) {
	var str = entries[i].toUpperCase()

	if (str === "SECURITY") {
	    value |= SECURITY
	} else if (str === "BMS") {
	    value |= BMS
	} else if (str === "EFL" || str === "EFL_MASK") {
	    value |= EFL_MASK
	} else if (str === "SBS_MASK") {
	    value |= SBS_MASK
	} else if (str === "SAMBA_MONITOR") {
	    value = (value & ~SBS_MASK) | SBS_SAMBA_MONITOR
	} else if (str === "STANDARD_BOOT") {
	    value = (value & ~SBS_MASK) | SBS_STANDARD_BOOT
	} else if (str === "SECURE_SAMBA_MONITOR") {
	    value = (value & ~SBS_MASK) | SBS_SECURE_SAMBA_MONITOR
	} else if (str === "SECURE_BOOT") {
	    value = (value & ~SBS_MASK) | SBS_SECURE_BOOT
	} else if (str === "SECURE_BOOT_NO_MONITOR") {
	    value = (value & ~SBS_MASK) | SBS_SECURE_BOOT_NO_MONITOR
	}
    }

    return value
}
