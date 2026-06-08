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

var EEFC_WPMR_WPEN      = 1 << 0
var EEFC_WPMR_GPNVMWP   = 1 << 1
var EEFC_WPMR_LOCKWP    = 1 << 2
var EEFC_WPMR_ERASEWP   = 1 << 3
var EEFC_WPMR_USRWP     = 1 << 4
var EEFC_WPMR_ERASEWL   = 1 << 7

function toText(value)
{
    var text = []

    if (value & EEFC_WPMR_ERASEWL)
	text.push("ERASEWL")
    if (value & EEFC_WPMR_USRWP)
	text.push("USRWP")
    if (value & EEFC_WPMR_ERASEWP)
	text.push("ERASEWP")
    if (value & EEFC_WPMR_LOCKWP)
	text.push("LOCKWP")
    if (value & EEFC_WPMR_GPNVMWP)
	text.push("GPNVMWP")
    if (value & EEFC_WPMR_WPEN)
	text.push("WPEN")

    return text.join(",")
}

function fromText(text)
{
    var entries = text.split(',')

    var value = 0
    for (var i = 0; i < entries.length; i++) {
	var str = entries[i].toUpperCase()

	if (str === "WPEN") {
	    value |= EEFC_WPMR_WPEN
	} else if (str === "GPNVMWP") {
	    value |= EEFC_WPMR_GPNVMWP
	} else if (str === "LOCKWP") {
	    value |= EEFC_WPMR_LOCKWP
	} else if (str === "ERASEWP") {
	    value |= EEFC_WPMR_ERASEWP
	} else if (str === "USRWP") {
	    value |= EEFC_WPMR_USRWP
	} else if (str === "ERASEWL") {
	    value |= EEFC_WPMR_ERASEWL
	}
    }

    return value
}
