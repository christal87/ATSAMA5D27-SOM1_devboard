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
import SAMBA.Device.SAMA7G5 3.7

/*!
	\qmltype SAMA7G5EK
	\inqmlmodule SAMBA.Device.SAMA7G5
	\brief Contains a specialization of the SAMA7G5 QML type for the
	       SAMA7G5 Evaluation Kit.
*/
SAMA7G5 {
	name: "sama7g5-ek"

	aliases: []

	description: "SAMA7G5 Evaluation Kit"

	config {
		serial {
			instance: 3 /* FLEXCOM3 USART */
			ioset: 5
		}

		// SDMMC0, I/O Set 1, User Partition, Automatic bus width, 3.3V
		sdmmc {
			instance: 0
			ioset: 1
			partition: 0
			busWidth: 0
			voltages: 4 /* 3.3V */
		}

		// QPSI0, I/O Set 1, 50MHz
		qspiflash {
			instance: 0
			ioset: 1
			freq: 50
		}
	}
}
