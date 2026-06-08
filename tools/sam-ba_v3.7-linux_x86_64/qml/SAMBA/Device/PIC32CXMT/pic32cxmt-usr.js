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

var EEFC_USR_RDENUSB_OFF        = 0
var EEFC_USR_RDENUSB_MASK       = 0xff << EEFC_USR_RDENUSB_OFF
var EEFC_USR_RDENUSB0           = 0x01 << EEFC_USR_RDENUSB_OFF
var EEFC_USR_RDENUSB1           = 0x02 << EEFC_USR_RDENUSB_OFF
var EEFC_USR_RDENUSB2           = 0x04 << EEFC_USR_RDENUSB_OFF
var EEFC_USR_RDENUSB3           = 0x08 << EEFC_USR_RDENUSB_OFF
var EEFC_USR_RDENUSB4           = 0x10 << EEFC_USR_RDENUSB_OFF
var EEFC_USR_RDENUSB5           = 0x20 << EEFC_USR_RDENUSB_OFF
var EEFC_USR_RDENUSB6           = 0x40 << EEFC_USR_RDENUSB_OFF
var EEFC_USR_RDENUSB7           = 0x80 << EEFC_USR_RDENUSB_OFF

var EEFC_USR_WRENUSB_OFF        = 8
var EEFC_USR_WRENUSB_MASK       = 0xff << EEFC_USR_WRENUSB_OFF
var EEFC_USR_WRENUSB0           = 0x01 << EEFC_USR_WRENUSB_OFF
var EEFC_USR_WRENUSB1           = 0x02 << EEFC_USR_WRENUSB_OFF
var EEFC_USR_WRENUSB2           = 0x04 << EEFC_USR_WRENUSB_OFF
var EEFC_USR_WRENUSB3           = 0x08 << EEFC_USR_WRENUSB_OFF
var EEFC_USR_WRENUSB4           = 0x10 << EEFC_USR_WRENUSB_OFF
var EEFC_USR_WRENUSB5           = 0x20 << EEFC_USR_WRENUSB_OFF
var EEFC_USR_WRENUSB6           = 0x40 << EEFC_USR_WRENUSB_OFF
var EEFC_USR_WRENUSB7           = 0x80 << EEFC_USR_WRENUSB_OFF

var EEFC_USR_PRIVUSB_OFF        = 16
var EEFC_USR_PRIVUSB_MASK       = 0xff << EEFC_USR_PRIVUSB_OFF
var EEFC_USR_PRIVUSB0           = 0x01 << EEFC_USR_PRIVUSB_OFF
var EEFC_USR_PRIVUSB1           = 0x02 << EEFC_USR_PRIVUSB_OFF
var EEFC_USR_PRIVUSB2           = 0x04 << EEFC_USR_PRIVUSB_OFF
var EEFC_USR_PRIVUSB3           = 0x08 << EEFC_USR_PRIVUSB_OFF
var EEFC_USR_PRIVUSB4           = 0x10 << EEFC_USR_PRIVUSB_OFF
var EEFC_USR_PRIVUSB5           = 0x20 << EEFC_USR_PRIVUSB_OFF
var EEFC_USR_PRIVUSB6           = 0x40 << EEFC_USR_PRIVUSB_OFF
var EEFC_USR_PRIVUSB7           = 0x80 << EEFC_USR_PRIVUSB_OFF

var EEFC_USR_LOCKUSRB_OFF       = 24
var EEFC_USR_LOCKUSRB_MASK      = 0xff << EEFC_USR_LOCKUSRB_OFF
var EEFC_USR_LOCKUSRB0          = 0x01 << EEFC_USR_LOCKUSRB_OFF
var EEFC_USR_LOCKUSRB1          = 0x02 << EEFC_USR_LOCKUSRB_OFF
var EEFC_USR_LOCKUSRB2          = 0x04 << EEFC_USR_LOCKUSRB_OFF
var EEFC_USR_LOCKUSRB3          = 0x08 << EEFC_USR_LOCKUSRB_OFF
var EEFC_USR_LOCKUSRB4          = 0x10 << EEFC_USR_LOCKUSRB_OFF
var EEFC_USR_LOCKUSRB5          = 0x20 << EEFC_USR_LOCKUSRB_OFF
var EEFC_USR_LOCKUSRB6          = 0x40 << EEFC_USR_LOCKUSRB_OFF
var EEFC_USR_LOCKUSRB7          = 0x80 << EEFC_USR_LOCKUSRB_OFF

function toText(value)
{
    var text = []

    if (value & EEFC_USR_LOCKUSRB_MASK) {
	for (var block = 0; block < 8; block++) {
	    if (value & (1 << (EEFC_USR_LOCKUSRB_OFF + block)))
		text.push("LOCKUSRB" + block)
	}
    }

    if (value & EEFC_USR_PRIVUSB_MASK) {
	for (var block = 0; block < 8; block++) {
	    if (value & (1 << (EEFC_USR_PRIVUSB_OFF + block)))
		text.push("PRIVUSB" + block)
	}
    }

    if (value & EEFC_USR_WRENUSB_MASK) {
	for (var block = 0; block < 8; block++) {
	    if (value & (1 << (EEFC_USR_WRENUSB_OFF + block)))
		text.push("WRENUSB" + block)
	}
    }

    if (value & EEFC_USR_RDENUSB_MASK) {
	for (var block = 0; block < 8; block++) {
	    if (value & (1 << (EEFC_USR_RDENUSB_OFF + block)))
		text.push("RDENUSB" + block)
	}
    }

    return text.join(",")
}

function fromText(text)
{
    var entries = text.split(',')
    var rdenusb_regexp = /^RDENUSB([0-7])$/i
    var wrenusb_regexp = /^WRENUSB([0-7])$/i
    var privusb_regexp = /^PRIVUSB([0-7])$/i
    var lockusrb_regexp = /^LOCKUSRB([0-7])$/i

    var value = 0
    var found
    var block
    for (var i = 0; i < entries.length; i++) {
	var str = entries[i].toUpperCase()

	if (str === "RDENUSB_MASK")
	    value |= EEFC_USR_RDENUSB_MASK

	if ((found = str.match(rdenusb_regexp)) !== null) {
	    block = parseInt(found[1], 10)
	    value |= 1 << (EEFC_USR_RDENUSB_OFF + block)
	}

	if (str === "WRENUSB_MASK")
	    value |= EEFC_USR_WRENUSB_MASK

	if ((found = str.match(wrenusb_regexp)) !== null) {
	    block = parseInt(found[1], 10)
	    value |= 1 << (EEFC_USR_WRENUSB_OFF + block)
	}

	if (str === "PRIVUSB_MASK")
	    value |= EEFC_USR_PRIVUSB_MASK

	if ((found = str.match(privusb_regexp)) !== null) {
	    block = parseInt(found[1], 10)
	    value |= 1 << (EEFC_USR_PRIVUSB_OFF + block)
	}

	if (str === "LOCKUSRB_MASK")
	    value |= EEFC_USR_LOCKUSRB_MASK

	if ((found = str.match(lockusrb_regexp)) !== null) {
	    block = parseInt(found[1], 10)
	    value |= 1 << (EEFC_USR_LOCKUSRB_OFF + block)
	}
    }

    return value
}
