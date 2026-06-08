/*
 * Copyright (c) 2022, Microchip.
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
import SAMBA.Device.SAM9X7 3.7

/*!
	\qmltype SAM9X75-DDR3-EB
	\inqmlmodule SAMBA.Device.SAM9X7
	\brief Contains a specialization of the SAM9X7 QML type for the
			SAM9X75-DDR3 Engineering Board.
*/
SAM9X7 {
    name: "sam9x75-ddr3-eb"

	aliases: []

	description: "SAM9X75 DDR3 Engineering Board"

	config {
		serial {
			instance: 0 /* DBGU */
			ioset: 1
		}

		// SDMMC0, I/O Set 1, User Partition, Automatic bus width, 3.3V
		sdmmc {
			instance: 0
			ioset: 1
			partition: 0
			busWidth: 0
			voltages: 4 /* 3.3V */
		}

		// FlexCom->SPI5, I/O Set 1, NPCS0, 50MHz
		serialflash {
			instance:5
			ioset: 1
			chipSelect: 0
			freq: 50
		}

		// QPSI0, I/O Set 1, 50MHz
		qspiflash {
			instance: 0
			ioset: 1
			freq: 50
		}

		// SMC, I/O Set 1, 8-bit bus width
		nandflash {
			ioset: 1
			busWidth: 8
		}
	}
}
