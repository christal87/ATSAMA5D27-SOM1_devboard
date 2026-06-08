/*
 * Copyright (c) 2019, Microchip.
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
import SAMBA.Device.SAMA7G5 3.7

/*!
	\qmltype SAMA7G5Config
	\inqmlmodule SAMBA.Device.SAMA7G5
	\brief Contains configuration values for a SAMA7G5 device.

	By default, no configuration values are set.

	\section1 Serial Console Configuration

	The following serial console configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li TX Pin \li RX
	\row    \li 0        \li FLEXCOM0       \li 1       \li PA0B	\li PA1A
	\row    \li 0        \li FLEXCOM0       \li 2       \li PD3B	\li PD4B
	\row    \li 0        \li FLEXCOM0       \li 3       \li PD10F	\li PD11F
	\row    \li 0        \li FLEXCOM0       \li 4       \li PE3B	\li PE4B

	\row    \li 1        \li FLEXCOM1       \li 1       \li PA5B	\li PA6B
	\row    \li 1        \li FLEXCOM1       \li 2       \li PD12B	\li PD13B
	\row    \li 1        \li FLEXCOM1       \li 3       \li PA2F	\li PA3F
	\row    \li 1        \li FLEXCOM1       \li 4       \li PC9F	\li PC10F

	\row    \li 2        \li FLEXCOM2       \li 1       \li PA7B	\li PA8B
	\row    \li 2        \li FLEXCOM2       \li 2       \li PD17B	\li PD18B
	\row    \li 2        \li FLEXCOM2       \li 3       \li PA4F	\li PA5F
	\row    \li 2        \li FLEXCOM2       \li 4       \li PC11F	\li PC12F
	\row    \li 2        \li FLEXCOM2       \li 5       \li PD14F   \li PD15F

	\row    \li 3       \li FLEXCOM3       \li 1       \li PA15B	\li PA16B
	\row    \li 3       \li FLEXCOM3       \li 2       \li PC0B	\li PC1B
	\row    \li 3       \li FLEXCOM3       \li 3       \li PA6F	\li PA7F
	\row    \li 3       \li FLEXCOM3       \li 4       \li PC13F	\li PC14F
	\row    \li 3       \li FLEXCOM3       \li 5       \li PD16F	\li PD17F

	\row    \li 4       \li FLEXCOM4       \li 1       \li PA20B	\li PA21B
	\row    \li 4       \li FLEXCOM4       \li 2       \li PC2B	\li PC3B
	\row    \li 4       \li FLEXCOM4       \li 3       \li PA8F	\li PA9F
	\row    \li 4       \li FLEXCOM4       \li 4       \li PC15F	\li PC16F
	\row    \li 4       \li FLEXCOM4       \li 5       \li PD18F	\li PD19F

	\row    \li 5       \li FLEXCOM5       \li 1       \li PA28B	\li PA29B
	\row    \li 5       \li FLEXCOM5       \li 2       \li PD25B	\li PD26B
	\row    \li 5       \li FLEXCOM5       \li 3       \li PA10F	\li PA11F
	\row    \li 5       \li FLEXCOM5       \li 4       \li PC17F	\li PC18F
	\row    \li 5       \li FLEXCOM5       \li 5       \li PD20F	\li PD21F

	\row    \li 6       \li FLEXCOM6       \li 1       \li PB2B	\li PB1B
	\row    \li 6       \li FLEXCOM6       \li 2       \li PD30B	\li PD31B
	\row    \li 6       \li FLEXCOM6       \li 3       \li PA12F	\li PA13F
	\row    \li 6       \li FLEXCOM6       \li 4       \li PC19F	\li PC20F
	\row    \li 6       \li FLEXCOM6       \li 5       \li PC21F	\li PC22F

	\row    \li 7       \li FLEXCOM7       \li 1       \li PB23F	\li PB24F
	\row    \li 7       \li FLEXCOM7       \li 2       \li PC7B	\li PC8B
	\row    \li 7       \li FLEXCOM7       \li 3       \li PA25F	\li PA26F
	\row    \li 7       \li FLEXCOM7       \li 4       \li PB28F	\li PB29F
	\row    \li 7       \li FLEXCOM7       \li 5       \li PC23F	\li PC24F

	\row    \li 8       \li FLEXCOM8       \li 1       \li PB8B	\li PB9B
	\row    \li 8       \li FLEXCOM8       \li 2       \li PC14B	\li PC13B
	\row    \li 8       \li FLEXCOM8       \li 3       \li PA27F	\li PA28F
	\row    \li 8       \li FLEXCOM8       \li 4       \li PB30F	\li PB31F
	\row    \li 8       \li FLEXCOM8       \li 5       \li PD2F	\li PD3F

	\row    \li 9       \li FLEXCOM9       \li 1       \li PB13B	\li PB14B
	\row    \li 9       \li FLEXCOM9       \li 2       \li PC18B	\li PC19B
	\row    \li 9       \li FLEXCOM9       \li 3       \li PA29F	\li PA30F
	\row    \li 9       \li FLEXCOM9       \li 4       \li PC0F	\li PC1F
	\row    \li 9       \li FLEXCOM9       \li 5       \li PD4F	\li PD5F

	\row    \li 10       \li FLEXCOM10       \li 1       \li PB18B	\li PB19B
	\row    \li 10       \li FLEXCOM10       \li 2       \li PC30B	\li PC31B
	\row    \li 10       \li FLEXCOM10       \li 3       \li PA31F	\li PB0F
	\row    \li 10       \li FLEXCOM10       \li 4       \li PC2F	\li PC3F
	\row    \li 10       \li FLEXCOM10       \li 5       \li PC6F	\li PC7F

	\row    \li 11       \li FLEXCOM11       \li 1       \li PB3B	\li PB4B
	\row    \li 11       \li FLEXCOM11       \li 2       \li PD0B	\li PD1B
	\row    \li 11       \li FLEXCOM11       \li 3       \li PB1F	\li PB2F
	\row    \li 11       \li FLEXCOM11       \li 4       \li PC4F	\li PC5F
	\row    \li 11       \li FLEXCOM11       \li 5       \li PD8F	\li PD9F
	\endtable

	\section1 SD/MMC Configuration

	The following SD/MMC configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Bus Width \li Voltage
	\row    \li 0        \li SDMMC0     \li 1       \li 1-bit, 8-bit \li 1.8/3.3V
	\row    \li 1        \li SDMMC1     \li 1       \li 1-bit, 4-bit \li 1.8/3.3V
	\row    \li 2        \li SDMMC2     \li 1       \li 1-bit, 4-bit \li 1.8/3.3V
	\endtable

	\section2 Pin List for SD/MMC Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA0A  \li Clock
	\row    \li PA1A  \li Command
	\row    \li PA3A  \li Data 0 (bus width: 1-bit, 4-bit, 8-bit)
	\row    \li PA4A  \li Data 1 (bus width: 4-bit, 8-bit)
	\row    \li PA5A  \li Data 2 (bus width: 4-bit, 8-bit)
	\row    \li PA6A  \li Data 3 (bus width: 4-bit, 8-bit)
	\row    \li PA7A  \li Data 4 (bus width: 8-bit)
	\row    \li PA8A  \li Data 5 (bus width: 8-bit)
	\row    \li PA9A  \li Data 6 (bus width: 8-bit)
	\row    \li PA10A \li Data 7 (bus width: 8-bit)
	\row    \li PA13A \li VDDSel
	\endtable

	\section2 Pin List for SD/MMC Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PB30A \li Clock
	\row    \li PB29A \li Command
	\row    \li PB31A \li Data 0 (bus width: 1-bit, 4-bit)
	\row    \li PC0A  \li Data 1 (bus width: 4-bit)
	\row    \li PC1A  \li Data 2 (bus width: 4-bit)
	\row    \li PC2A  \li Data 3 (bus width: 4-bit)
	\row    \li PC5A  \li VDDSel
	\endtable

	\section2 Pin List for SD/MMC Instance 2 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PD4A  \li Clock
	\row    \li PD3A  \li Command
	\row    \li PD5A  \li Data 0 (bus width: 1-bit, 4-bit)
	\row    \li PD6A  \li Data 1 (bus width: 4-bit)
	\row    \li PD7A  \li Data 2 (bus width: 4-bit)
	\row    \li PD8A  \li Data 3 (bus width: 4-bit)
	\row    \li PD11A \li VDDSel
	\endtable

	\section1 SPI Serial Flash Configuration

	The following SPI Serial Flash configurations are supported:

	\table
	\header \li Instance \li Peripheral  \li I/O Set \li Chip Selects
	\row    \li 0        \li FLEXCOM0    \li 1       \li 0, 1, 2, 3
	\row    \li 0        \li FLEXCOM0    \li 2       \li 0, 1, 2, 3
	\row    \li 0        \li FLEXCOM0    \li 3       \li 0, 1, 2, 3
	\row    \li 0        \li FLEXCOM0    \li 4       \li 0, 1
	\row    \li 11       \li FLEXCOM11   \li 2       \li 0, 1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA0   \li MOSI
	\row    \li PA1   \li MISO
	\row    \li PA2   \li SPCK
	\row    \li PA3   \li NPCS0
	\row    \li PA4   \li NPCS1
	\row    \li PA24  \li NPCS2
	\row    \li PA25  \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PD3   \li MOSI
	\row    \li PD4   \li MISO
	\row    \li PD5   \li SPCK
	\row    \li PD6   \li NPCS0
	\row    \li PD7   \li NPCS1
	\row    \li PB29  \li NPCS2
	\row    \li PB30  \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 3)

	\table
	\header \li Pin   \li Use
	\row    \li PD10  \li MOSI
	\row    \li PD11  \li MISO
	\row    \li PD5   \li SPCK
	\row    \li PD6   \li NPCS0
	\row    \li PD7   \li NPCS1
	\row    \li PC23  \li NPCS2
	\row    \li PC24  \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 4)

	\table
	\header \li Pin   \li Use
	\row    \li PE3   \li MOSI
	\row    \li PE4   \li MISO
	\row    \li PE5   \li SPCK
	\row    \li PE6   \li NPCS0
	\row    \li PE7   \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 11 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PB3   \li MOSI
	\row    \li PB4   \li MISO
	\row    \li PB5   \li SPCK
	\row    \li PB6   \li NPCS0
	\row    \li PB7   \li NPCS1
	\endtable

	\section1 QSPI Flash Configuration

	The following QSPI Flash configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set
	\row    \li 0        \li QSPI0      \li 1
	\row    \li 1        \li QSPI1      \li 1
	\endtable

	\section2 Pin List for QSPI Serial Flash Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA14A \li SCK
	\row    \li PA13A \li CS
	\row    \li PB12A \li IO0
	\row    \li PB11A \li IO1
	\row    \li PB10A \li IO2
	\row    \li PB9A  \li IO3
	\endtable

	\section2 Pin List for QSPI Serial Flash Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PB27A \li SCK
	\row    \li PB26A \li CS
	\row    \li PB25A \li IO0
	\row    \li PB24A \li IO1
	\row    \li PB23A \li IO2
	\row    \li PB22A \li IO3
	\endtable

	\section1 NAND Flash Configuration

	The following NAND Flash configurations are supported:

	\section2 Pin List for NAND Flash (I/O Set 1)

	\table
	\header \li Pin    \li Use     \li Bus Width
	\row    \li PB11D  \li NANDOE  \li 8-bit
	\row    \li PB10D  \li NANDWE  \li 8-bit
	\row    \li PB12D  \li NANDALE \li 8-bit
	\row    \li PB13D  \li NANDCLE \li 8-bit
	\row    \li PB9D   \li NCS3    \li 8-bit
	\row    \li PB7D   \li NWAIT   \li 8-bit
	\row    \li PB22D  \li NANDRDY \li 8-bit
	\row    \li PB14D  \li D0      \li 8-bit
	\row    \li PB15D  \li D1      \li 8-bit
	\row    \li PB16D  \li D2      \li 8-bit
	\row    \li PB17D  \li D3      \li 8-bit
	\row    \li PB18D  \li D4      \li 8-bit
	\row    \li PB19D  \li D5      \li 8-bit
	\row    \li PB20D  \li D6      \li 8-bit
	\row    \li PB21D  \li D7      \li 8-bit
	\endtable

	\section2 Pin List for NAND Flash (I/O Set 2)

	\table
	\header \li Pin    \li Use     \li Bus Width
	\row    \li PD6D   \li NANDOE  \li 8-bit
	\row    \li PD5D   \li NANDWE  \li 8-bit
	\row    \li PD7D   \li NANDALE \li 8-bit
	\row    \li PD8D   \li NANDCLE \li 8-bit
	\row    \li PD4D   \li NCS3    \li 8-bit
	\row    \li PB7D   \li NWAIT   \li 8-bit
	\row    \li PD3D   \li NANDRDY \li 8-bit
	\row    \li PD9D   \li D0      \li 8-bit
	\row    \li PD10D  \li D1      \li 8-bit
	\row    \li PD11D  \li D2      \li 8-bit
	\row    \li PC21D  \li D3      \li 8-bit
	\row    \li PC22D  \li D4      \li 8-bit
	\row    \li PC23D  \li D5      \li 8-bit
	\row    \li PC24Dv \li D6      \li 8-bit
	\row    \li PD2D   \li D7      \li 8-bit
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
		\brief Configuraiton for Low Level applet

		see \l{SAMBA.Applet::}{LowlevelPresetConfig} for a list if configurable properties.
	*/
	property alias lowlevel: lowlevel
	LowlevelPresetConfig {
		id: lowlevel
	}

	/*!
		\brief Configuration for external RAM applet

		See \l{SAMBA.Applet::}{ExtRamConfig} for a list of configurable properties.
        */
	property alias extram: extram
	ExtRamConfig {
		id: extram
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
