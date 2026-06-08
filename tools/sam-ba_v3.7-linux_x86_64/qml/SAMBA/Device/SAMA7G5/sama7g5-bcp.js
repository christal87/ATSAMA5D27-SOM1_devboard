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

.pragma library

var DISABLE_MONITOR	= 0
var CHECK_IMAGE		= 1
var CONSOLE_IOSET	= 2

var MAX_BOOTABLE_INTERF	= 7
var BOOT_CFG_PKT_SIZE	= 17

var IOSET_OFF		= 0
var IOSET_MASK		= 0xf << IOSET_OFF

var INST_ID_OFF		= 4
var INST_ID_MASK	= 0xf << INST_ID_OFF

var TYPE_OFF		= 8
var TYPE_MASK		= 0xf << TYPE_OFF
var TYPE_DISABLED	= 0x0 << TYPE_OFF
var TYPE_QSPI		= 0x1 << TYPE_OFF
var TYPE_SPI		= 0x2 << TYPE_OFF
var TYPE_SDMMC		= 0x3 << TYPE_OFF
var TYPE_NFC		= 0x4 << TYPE_OFF

var CD_PIN_OFF		= 0
var CD_PIN_MASK		= 0x1f << CD_PIN_OFF

var CD_PID_OFF		= 5
var CD_PID_MASK		= 0x3 << CD_PID_OFF

var CD_ENABLED		= 1 << 7

var CD_MAGIC_OFF	= 8
var CD_MAGIC_MASK	= 0xff << CD_MAGIC_OFF
var CD_MAGIC_PASSWORD	= 0x96 << CD_MAGIC_OFF

var romcodeConsoles     = [
	[ 0, 1], [ 0, 2], [ 0, 3], [ 0, 4],
	[ 1, 1], [ 1, 2], [ 1, 3], [ 1, 4],
	[ 2, 1], [ 2, 2], [ 2, 3], [ 2, 4], [ 2, 5],
	[ 3, 1], [ 3, 2], [ 3, 3], [ 3, 4], [ 3, 5],
	[ 4, 1], [ 4, 2], [ 4, 3], [ 4, 4], [ 4, 5],
	[ 5, 1], [ 5, 2], [ 5, 3], [ 5, 4], [ 5, 5],
	[ 6, 1], [ 6, 2], [ 6, 3], [ 6, 4], [ 6, 5],
	[ 7, 1], [ 7, 2], [ 7, 3], [ 7, 4], [ 7, 5],
	[ 8, 1], [ 8, 2], [ 8, 3], [ 8, 4], [ 8, 5],
	[ 9, 1], [ 9, 2], [ 9, 3], [ 9, 4], [ 9, 5],
	[10, 1], [10, 2], [10, 3], [10, 4], [10, 5],
	[11, 1], [11, 2], [11, 3], [11, 4], [11, 5],
]

/*!
	\qmlmethod string BCP::toText(Uint32Array value)
	Converts a boot config packet \a value to text for user display.
*/
function toText(value) {
	if (value.length !== BOOT_CFG_PKT_SIZE)
		throw new Error("Invalid Boot Config Packet")

	var text = []

	if (value[DISABLE_MONITOR] !== 0)
		text.push("MONITOR_DISABLED")

	if (value[CHECK_IMAGE] !== 0)
		text.push("CHECK_IMAGE")

	if (value[CONSOLE_IOSET] < romcodeConsoles.length) {
		var entry = romcodeConsoles[value[CONSOLE_IOSET]]
		var inst_id = entry[0]
		var ioset = entry[1]
		text.push("FLEXCOM" + inst_id + "_USART_IOSET" + ioset)
	} else {
		text.push("CONSOLE_DISABLED")
	}

	for (var i = 0; i < MAX_BOOTABLE_INTERF; i++) {
		var details = value[2 * i + 3]
		var mem_cfg = value[2 * i + 4]
		var ioset = ((details & IOSET_MASK) >> IOSET_OFF) + 1
		var inst_id = (details & INST_ID_MASK) >> INST_ID_OFF
		var boot_entry

		switch (details & TYPE_MASK) {
		default:
		case TYPE_DISABLED:
			continue
		case TYPE_QSPI:
			boot_entry = "QSPI" + inst_id + "_IOSET" + ioset
			if (mem_cfg !== 0)
				boot_entry += "_AT25"
			break
		case TYPE_SPI:
			boot_entry = "FLEXCOM" + inst_id + "_SPI_IOSET" + ioset
			break
		case TYPE_SDMMC:
			var cfg_mask = CD_MAGIC_MASK | CD_ENABLED
			var cfg_value = CD_MAGIC_PASSWORD | CD_ENABLED
			boot_entry = "SDMMC" + inst_id + "_IOSET" + ioset
			if ((mem_cfg & cfg_mask) !== cfg_value)
				boot_entry += "_NO_CARD_DETECT"
			break
		case TYPE_NFC:
			boot_entry = "NFC_IOSET" + ioset
			break
		}

		text.push(boot_entry)
	}

	return text.join(",")
}

/*!
	\qmlmethod Uint32Array BCP::fromText(string text)
	Converts a string to a boot config packet \a value.
*/
function fromText(text) {
	var entries = text.split(',')
	var console_regexp = /^FLEXCOM(\d{1,2})_USART_IOSET(\d)$/i
	var qspi_regexp = /^QSPI(\d)_IOSET(\d)(.*)$/i
	var spi_regexp = /^FLEXCOM(\d)_SPI_IOSET(\d)$/i
	var sdmmc_regexp = /^SDMMC(\d)_IOSET(\d)(.*)$/i
	var nfc_regexp = /^NFC_IOSET(\d)$/i

	var inst_id
	var ioset
	var found
	var boot_entry = 0
	var bcp = new Uint32Array(BOOT_CFG_PKT_SIZE)
	for (var i = 0; i < entries.length; i++) {
		if (entries[i].toUpperCase() === "MONITOR_DISABLED") {
			bcp[DISABLE_MONITOR] = 1
		} else if (entries[i].toUpperCase() === "CHECK_IMAGE") {
			bcp[CHECK_IMAGE] = 1
		} else if (entries[i].toUpperCase() === "CONSOLE_DISABLED") {
			bcp[CONSOLE_IOSET] = -1
		} else if ((found = entries[i].match(console_regexp)) !== null) {
			inst_id = 0
			for (var j = 0; j < romcodeConsoles.length; j++) {
				if (romcodeConsoles[j][0] == found[1] &&
				    romcodeConsoles[j][1] == found[2]) {
					inst_id = j
					break
				}
			}
			bcp[CONSOLE_IOSET] = inst_id
		} else if ((found = entries[i].match(qspi_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
			bcp[2 * boot_entry + 3] = TYPE_QSPI |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
			if (found[3].toUpperCase() === "_AT25")
				bcp[2 * boot_entry + 4] = 1
			boot_entry++
		} else if ((found = entries[i].match(spi_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
			bcp[2 * boot_entry + 3] = TYPE_SPI |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
			boot_entry++
		} else if ((found = entries[i].match(sdmmc_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
			bcp[2 * boot_entry + 3] = TYPE_SDMMC |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
			if (found[3].toUpperCase() !== "_NO_CARD_DETECT")
				bcp[2 * boot_entry + 4] = CD_MAGIC_PASSWORD | CD_ENABLED
			boot_entry++
		} else if ((found = entries[i].match(nfc_regexp)) !== null) {
			ioset = parseInt(found[1], 10) - 1
			bcp[2 * boot_entry + 3] = TYPE_NFC | ((ioset << IOSET_OFF) & IOSET_MASK)
			boot_entry++
		}
	}
	return bcp
}
