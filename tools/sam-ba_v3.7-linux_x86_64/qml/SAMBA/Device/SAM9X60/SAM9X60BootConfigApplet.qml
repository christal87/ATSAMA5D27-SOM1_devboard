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
import SAMBA.Device.SAM9X60 3.7

/*! \internal */
BootConfigOTPCApplet {
	bcpPacketWords: 19
	uhcpPacketWords: 2
	sbcpPacketWords: 8

	/*! \internal */
	function bscrFromText(text) {
		return BSCR.fromText(text)
	}

	/*! \internal */
	function bscrToText(value) {
		return BSCR.toText(value)
	}

	/*! \internal */
	function bcpFromText(text) {
		return BCP.fromText(text)
	}

	/*! \internal */
	function bcpToText(value) {
		return BCP.toText(value)
	}

	/*! \internal */
	function uhcpFromText(text) {
		return UHCP.fromText(text)
	}

	/*! \internal */
	function uhcpToText(value) {
		return UHCP.toText(value)
	}

	/*! \internal */
	function sbcpFromText(text) {
		return SBCP.fromText(text)
	}

	/*! \internal */
	function sbcpToText(value) {
		return SBCP.toText(value)
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "readcfg") {
			return [" * readcfg - read boot configuration",
				"Syntax:",
				"    readcfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul|sbcp-emul|sbcp-otp|bscr)",
				"Examples:",
				"    readcfg:bcp-otp   read the boot config packet from OTP matrix",
				"    readcfg:bcp-emul  read the boot config packet from OTP emulation mode",
				"    readcfg:uhcp-otp  read the user hardware config packet from OTP matrix",
				"    readcfg:uhcp-emul read the user hardware config packet from OTP emulation mode",
				"    readcfg:sbcp-otp  read the secure boot config packet from OTP matrix",
				"    readcfg:sbcp-emul read the secure boot config packet from OTP emulation mode",
				"    readcfg:bscr      read the boot sequence register (BSCR)"]
		}
		else if (command === "writecfg") {
			return [" * writecfg - write boot configuration",
				"Syntax:",
				"    writecfg:(bcp-otp|bcp-emul):<boot_config_text>",
				"    writecfg:(uhcp-otp|uhcp-emul):<user_hw_config_text>",
				"    writecfg:(sbcp-otp|sbcp-emul):",
				"    writecfg:bscr:<bscr_value>",
				"",
				"    <bscr_value> := \"EMULATION_DISABLED\" | \"EMULATION_ENABLED\"",
				"",
				"    <boot_config_text> := <global_settings> | [ <global_settings> \",\" ] [ <boot_sequence> ]",
				"",
				"    <global_settings> := <global_setting> | <global_setting> \",\" <global_settings>",
				"",
				"    <global_setting> := \"MONITOR_DISABLED\" | <console_ioset>",
				"",
				"    <console_ioset> := \"DBGU\" | \"FLEXCOM0_USART_IOSET1\" | ... | \"FLEXCOM12_USART_IOSET1\"",
				"",
				"    <boot_sequence> := <boot_entry> | <boot_entry> \",\" <boot_sequence>",
				"",
				"    <boot_entry> := <spi_entry> | <qspi_entry> | <sdmmc_entry> | <nfc_entry>",
				"",
				"    <spi_entry> := <spi0_entry> | <spi1_entry> | <spi2_entry> | <spi3_entry> | <spi4_entry> | <spi5_entry>",
				"",
				"    <spi0_entry> := \"FLEXCOM0_SPI_IOSET1\" | \"FLEXCOM0_SPI_IOSET2\"",
				"",
				"    <spi1_entry> := \"FLEXCOM1_SPI_IOSET1\" | \"FLEXCOM1_SPI_IOSET2\"",
				"",
				"    <spi2_entry> := \"FLEXCOM2_SPI_IOSET1\" | \"FLEXCOM2_SPI_IOSET2\"",
				"",
				"    <spi3_entry> := \"FLEXCOM3_SPI_IOSET1\" | \"FLEXCOM3_SPI_IOSET2\"",
				"",
				"    <spi4_entry> := \"FLEXCOM4_SPI_IOSET1\" | \"FLEXCOM4_SPI_IOSET2\" | \"FLEXCOM4_SPI_IOSET3\" | \"FLEXCOM4_SPI_IOSET4\" | \"FLEXCOM4_SPI_IOSET5\" | \"FLEXCOM4_SPI_IOSET6\"",
				"",
				"    <spi5_entry> := \"FLEXCOM5_SPI_IOSET1\" | \"FLEXCOM5_SPI_IOSET2\" | \"FLEXCOM5_SPI_IOSET3\" | \"FLEXCOM5_SPI_IOSET4\" | \"FLEXCOM5_SPI_IOSET5\"",
				"",
				"    <qspi_entry> := \"QSPI0_IOSET1\" | \"QSPI0_IOSET1_XIP\"",
				"",
				"    <sdmmc_entry> := <sdmmc_controller> [ '_' <card_detect_pin> ]",
				"",
				"    <sdmmc_controller> := \"SDMMC0_IOSET1\", \"SDMMC1_IOSET1\"",
				"",
				"    <card_detect_pin> := \"P\" <pio_instance> <pin_number>",
				"",
				"    <pio_instance> := \"A\" | \"B\" | \"C\" | \"D\"",
				"",
				"    <pin_number> := \"0\" | \"1\" | \"2\" | \"3\" | \"4\" | \"5\" | ... | \"29\" | \"30\" | \"31\"",
				"",
				"    <nfc_entry> := \"NFC_IOSET1\" | \"NFC_IOSET2\"",
				"",
				"    <user_hw_config_text> := \"\" | <user_hw_setting> | <user_hw_setting> \",\" <user_hw_config_text>",
				"",
				"    <user_hw_setting> := \"JTAGDIS\" | \"URDDIS\" | \"UPGDIS\" | \"URFDIS\" |",
				"                         \"UHCINVDIS\" | \"UHCLKDIS\" | \"UHCPGDIS\" |",
				"                         \"BCINVDIS\" | \"BCLKDIS\" | \"BCPGDIS\" |",
				"                         \"SBCINVDIS\" | \"SBCLKDIS\" | \"SBCPGDIS\" |",
				"                         \"CINVDIS\" | \"CLKDIS\" | \"CPGDIS\"",
				"",
				"Examples:",
				"    writecfg:bscr:EMULATION_ENABLED                           enable OTP emulation mode",
				"    writecfg:bscr:EMULATION_DISABLED                          disable OTP emulation mode",
				"    writecfg:bcp-emul:DBGU                                    empty boot config (console on DBGU) stored in OTP emulation mode",
				"    writecfg:bcp-otp:FLEXCOM0_USART_IOSET1,SDMMC1_IOSET1_PA10 boot config with console on FLEXCOM0, boot from SDMMC1 (PA10 as card-detect pin) stored in OTP matrix",
				"    writecfg:sbcp-emul:                                       empty secure boot config stored in OTP emulation mode",
				"    writecfg:sbcp-otp:                                        empty secure boot config stored in OTP matrix"]
		}
		else if (command === "invalidatecfg") {
			return ["* invalidatecfg - invalidate the boot config packet",
				"Syntax:",
				"    invalidatecfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul|sbcp-otp|sbcp-emul)",
				"Examples:",
				"    invalidatecfg:bcp-otp   invalidate the boot config packet in OTP matrix",
				"    invalidatecfg:bcp-emul  invalidate the boot config packet in OTP emulation mode",
				"    invalidatecfg:uhcp-otp  invalidate the user hardware config packet in OTP matrix",
				"    invalidatecfg:uhcp-emul invalidate the user hardware config packet in OTP emulation mode",
				"    invalidatecfg:sbcp-otp  invalidate the secure boot config packet in OTP matrix",
				"    invalidatecfg:sbcp-emul invalidate the secure boot config packet in OTP emulation mode"]
		}
		else if (command === "lockcfg") {
			return ["* lockcfg - lock the boot config packet",
				"Syntax:",
				"    lockcfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul|sbcp-top|sbcp-emul)",
				"Examples:",
				"    lockcfg:bcp-otp   lock the boot config packet in OTP matrix",
				"    lockcfg:bcp-emul  lock the boot config packet in OTP emulation mode",
				"    lockcfg:uhcp-otp  lock the user hardware config packet in OTP matrix",
				"    lockcfg:uhcp-emul lock the user hardware config packet in OTP emulation mode",
				"    lockcfg:sbcp-otp  lock the secure boot config packet in OTP matrix",
				"    lockcfg:sbcp-emul lock the secure boot config packet in OTP emulation mode"]
		}
		else if (command === "refreshcfg") {
			return ["* refreshcfg - refresh the OTP matrix or emulation mode",
				"Syntax:",
				"    refreshcfg:(otp|emul)",
				"Examples:",
				"    refreshcfg:otp   disable the OTP emulation mode, if needed, then refresh the OTPC",
				"    refreshcfg:emul  enable the OTP emulation mode, if needed, then refresh the OTPC"]
		}
		else if (command === "resetemul") {
			return ["* resetemul - reset the OTPC SRAM used in emulation mode",
				"Syntax:",
				"    resetemul",
				"Example:",
				"    resetemul  reset the internal SRAM used by the OTPC in emulation mode"]
		}
	}
}
