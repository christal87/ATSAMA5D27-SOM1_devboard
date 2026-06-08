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
import SAMBA.Applet 3.7
import SAMBA.Device.SAM9X7 3.7

/*!
	\qmltype SAM9X7Config
	\inqmlmodule SAMBA.Device.SAM9X7
	\brief Contains configuration values for a SAM9X7 Series.

	By default, no configuration values are set.

    \section1 Serial Console Configuration

    The following serial console configurations are supported:

    \table
    \header \li Instance \li Peripheral \li I/O Set \li TX Pin
    \row    \li 0        \li DBGU       \li 1       \li PA27A
    \row    \li 1        \li FLEXCOM0   \li 1       \li PA30A
    \row    \li 2        \li FLEXCOM1   \li 1       \li PA28A
    \row    \li 3        \li FLEXCOM2   \li 1       \li PA13A
    \row    \li 4        \li FLEXCOM3   \li 1       \li PC22B
    \row    \li 5        \li FLEXCOM4   \li 1       \li PA10A
    \row    \li 6        \li FLEXCOM5   \li 1       \li PA16B
    \row    \li 7        \li FLEXCOM6   \li 1       \li PA24A
    \row    \li 8        \li FLEXCOM7   \li 1       \li PC0C
    \row    \li 9        \li FLEXCOM8   \li 1       \li PB4B
    \row    \li 10       \li FLEXCOM9   \li 1       \li PC8C
    \row    \li 11       \li FLEXCOM10  \li 1       \li PC16C
    \row    \li 12       \li FLEXCOM11  \li 1       \li PB15C
    \row    \li 13       \li FLEXCOM12  \li 1       \li PB17C
    \endtable

    \section1 SD/MMC Configuration

    The following SD/MMC configurations are supported:

    \table
    \header \li Instance \li Peripheral \li I/O Set \li Bus Width
    \row    \li 0        \li SDMMC0     \li 1       \li 1-bit, 4-bit
    \row    \li 1        \li SDMMC1     \li 1       \li 1-bit, 4-bit
    \endtable

    The SD/MMC applet on SAM9X60 does not support voltage switching, so the
    \a voltage configuration property is ignored.

    \section2 Pin List for SD/MMC Instance 0 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PA2A  \li Clock
    \row    \li PA1A  \li Command
    \row    \li PA0A  \li Data 0 (bus width: 1-bit, 4-bit)
    \row    \li PA3A  \li Data 1 (bus width: 4-bit)
    \row    \li PA4A  \li Data 2 (bus width: 4-bit)
    \row    \li PA5A  \li Data 4 (bus width: 4-bit)
    \endtable

    \section2 Pin List for SD/MMC Instance 1 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PA11B \li Clock
    \row    \li PA10B \li Command
    \row    \li PA9B  \li Data 0 (bus width: 1-bit, 4-bit)
    \row    \li PA6B  \li Data 1 (bus width: 4-bit)
    \row    \li PA7B  \li Data 2 (bus width: 4-bit)
    \row    \li PA8B  \li Data 3 (bus width: 4-bit)
    \endtable

    \section1 QSPI Flash Configuration

    The following QSPI Flash configurations are supported:

    \table
    \header \li Instance \li Peripheral \li I/O Set
    \row    \li 0        \li QSPI0      \li 1
    \endtable

    \section2 Pin List for QSPI Serial Flash Instance 0 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PB19A \li SCK
    \row    \li PB20A \li CS
    \row    \li PB21A \li IO0
    \row    \li PB22A \li IO1
    \row    \li PB23A \li IO2
    \row    \li PB24A \li IO3
    \endtable

    \section1 NAND Flash Configuration

    The following NAND Flash configurations are supported:

    \table
    \header \li I/O Set \li Bus Width
    \row    \li 1       \li 8-bit, 16-bit
    \endtable

    \section2 Pin List for NAND Flash (I/O Set 1)

    \table
    \header \li Pin   \li Use           \li Bus Width
    \row    \li PD0A  \li NANDOE        \li 8-bit, 16-bit
    \row    \li PD1A  \li NANDWE        \li 8-bit, 16-bit
    \row    \li PD2A  \li NANDALE       \li 8-bit, 16-bit
    \row    \li PD3A  \li NANDCLE       \li 8-bit, 16-bit
    \row    \li PD4A  \li NCS3          \li 8-bit, 16-bit
    \row    \li PD14A  \li NWAIT        \li 8-bit, 16-bit
    \row    \li PD6A  \li NANDDAT0      \li 8-bit, 16-bit
    \row    \li PD7A  \li NANDDAT1      \li 8-bit, 16-bit
    \row    \li PD8A  \li NANDDAT2      \li 8-bit, 16-bit
    \row    \li PD9A  \li NANDDAT3      \li 8-bit, 16-bit
    \row    \li PD10A \li NANDDAT4      \li 8-bit, 16-bit
    \row    \li PD11A \li NANDDAT5      \li 8-bit, 16-bit
    \row    \li PD12A \li NANDDAT6      \li 8-bit, 16-bit
    \row    \li PD13A \li NANDDAT7      \li 8-bit, 16-bit

    \endtable

    \section1 SPI Serial Flash Configuration

    The following SPI Serial Flash configurations are supported:

    \table
    \header \li Instance \li Peripheral \li I/O Set \li Chip Selects
    \row    \li 0        \li FLEXCOM0   \li 1       \li 0, 1
    \row    \li 1        \li FLEXCOM1   \li 1       \li 0, 1
    \row    \li 2        \li FLEXCOM2   \li 1       \li 0, 1
    \row    \li 3        \li FLEXCOM3   \li 1       \li 0, 1
    \row    \li 4        \li FLEXCOM4   \li 1       \li 0, 1, 2, 3, 4, 5
    \row    \li 5        \li FLEXCOM5   \li 1       \li 0, 1, 2, 3, 4
    \endtable

    \section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PA30A  \li MOSI
    \row    \li PA31A  \li MISO
    \row    \li PA8A  \li SPCK
    \row    \li PA7A  \li NPCS0
    \row    \li PA6A  \li NPCS1
    \endtable

    \section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PA28A  \li MOSI
    \row    \li PA29A  \li MISO
    \row    \li PC29C \li SPCK
    \row    \li PC28C \li NPCS0
    \row    \li PC27C \li NPCS1
    \endtable

    \section2 Pin List for SPI Serial Flash Instance 2 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PA13A  \li MOSI
    \row    \li PA14A  \li MISO
    \row    \li PB2B  \li SPCK
    \row    \li PB1B  \li NPCS0
    \row    \li PB0B  \li NPCS1
    \endtable

    \section2 Pin List for SPI Serial Flash Instance 3 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PC22B \li MOSI
    \row    \li PC23B \li MISO
    \row    \li PC26B \li SPCK
    \row    \li PC25B \li NPCS0
    \row    \li PC24B \li NPCS1
    \endtable

    \section2 Pin List for SPI Serial Flash Instance 4 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PA10A \li MOSI
    \row    \li PA9A \li MISO
    \row    \li PA11A \li SPCK
    \row    \li PA12A \li NPCS0
    \row    \li PA13B  \li NPCS1
    \row	\li PA30C  \li NPCS2
    \row    \li PA14C  \li NPCS3
    \row    \li PA32B  \li NPCS4
    \row    \li PB3B    \li NPCS5
    \endtable

    \section2 Pin List for SPI Serial Flash Instance 5 (I/O Set 1)

    \table
    \header \li Pin   \li Use
    \row    \li PA16B \li MOSI
    \row    \li PA15B \li MISO
    \row    \li PA17B \li SPCK
    \row    \li PA14B  \li NPCS0
    \row    \li PA12C  \li NPCS1
    \row    \li PA30B \li NPCS2
    \row    \li PA25B \li NPCS3
    \row    \li PA24B \li NPCS4
    \endtable
*/
Item {
	/*!
		\brief Configuration for applet serial console output

		See \l{SAMBA.Applet::}{SerialConfig} for a list of configurable properties.
		*/
	property alias serial: serial
	SerialConfig {
		id: serial
	}

	/*!
		\brief Configuration for SD/MMC applet

		See \l{SAMBA.Applet::}{SDMMCConfig} for a list of configurable properties.
		*/
	property alias sdmmc: sdmmc
	SDMMCConfig {
		id: sdmmc
	}

	/*!
		\brief Configuration for SPI Serial Flash applet

		See \l{SAMBA.Applet::}{SerialFlashConfig} for a list of configurable properties.
        */
	property alias serialflash: serialflash
	SerialFlashConfig {
		id: serialflash
	}

	/*!
		\brief Configuration for NAND Flash applet

		See \l{SAMBA.Applet::}{NANDFlashConfig} for a list of configurable properties.
        */
	property alias nandflash: nandflash
	NANDFlashConfig {
		id: nandflash
	}

	/*!
		\brief Configuration for QSPI Flash applet

		See \l{SAMBA.Applet::}{QSPIFlashConfig} for a list of configurable properties.
        */
	property alias qspiflash: qspiflash
	QSPIFlashConfig {
		id: qspiflash
	}

    /*!
        \brief Configuration for Set GPIO applet
    */
    property alias setgpio: setgpio
    SetGPIOConfig {
        id: setgpio
    }
}
