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
import SAMBA 3.7
import SAMBA.Applet 3.7
import SAMBA.Device.SAMA7G5 3.7

/*! \internal */
BootConfigOTPCApplet {
	bcpPacketWords: 17
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
				"",
				"        <boot_config_text> := [ <global_settings> ] | <global_settings> \",\" <boot_config_text> |",
				"                              [ <boot_sequence> ] | <boot_sequence> \",\" <boot_config_text>",
				"",
				"        <global_settings> := [ <global_setting> ] | <global_setting> \",\" <global_settings>",
				"",
				"        <global_setting> := \"MONITOR_DISABLED\" | \"CHECK_IMAGE\" | <console_ioset>",
				"",
				"        <console_ioset> := \"CONSOLE_DISABLED\" | <usart0_entry> | <usart1_entry> | ... | <usart11_entry>",
				"",
				"        <usart0_entry> := \"FLEXCOM0_USART_IOSET1\" | \"FLEXCOM0_USART_IOSET2\" | \"FLEXCOM0_USART_IOSET2\" | \"FLEXCOM0_USART_IOSET4\"",
				"",
				"        <usart1_entry> := \"FLEXCOM1_USART_IOSET1\" | \"FLEXCOM1_USART_IOSET2\" | \"FLEXCOM1_USART_IOSET2\" | \"FLEXCOM1_USART_IOSET4\"",
				"",
				"        <usart2_entry> := \"FLEXCOM2_USART_IOSET1\" | \"FLEXCOM2_USART_IOSET2\" | \"FLEXCOM2_USART_IOSET2\" | \"FLEXCOM2_USART_IOSET4\" | \"FLEXCOM2_USART_IOSET5\"",
				"",
				"        <usart3_entry> := \"FLEXCOM3_USART_IOSET1\" | \"FLEXCOM3_USART_IOSET2\" | \"FLEXCOM3_USART_IOSET2\" | \"FLEXCOM3_USART_IOSET4\" | \"FLEXCOM3_USART_IOSET5\"",
				"",
				"        <usart4_entry> := \"FLEXCOM4_USART_IOSET1\" | \"FLEXCOM4_USART_IOSET2\" | \"FLEXCOM4_USART_IOSET2\" | \"FLEXCOM4_USART_IOSET4\" | \"FLEXCOM4_USART_IOSET5\"",
				"",
				"        <usart5_entry> := \"FLEXCOM5_USART_IOSET1\" | \"FLEXCOM5_USART_IOSET2\" | \"FLEXCOM5_USART_IOSET2\" | \"FLEXCOM5_USART_IOSET4\" | \"FLEXCOM5_USART_IOSET5\"",
				"",
				"        <usart6_entry> := \"FLEXCOM6_USART_IOSET1\" | \"FLEXCOM6_USART_IOSET2\" | \"FLEXCOM6_USART_IOSET2\" | \"FLEXCOM6_USART_IOSET4\" | \"FLEXCOM6_USART_IOSET5\"",
				"",
				"        <usart7_entry> := \"FLEXCOM7_USART_IOSET1\" | \"FLEXCOM7_USART_IOSET2\" | \"FLEXCOM7_USART_IOSET2\" | \"FLEXCOM7_USART_IOSET4\" | \"FLEXCOM7_USART_IOSET5\"",
				"",
				"        <usart8_entry> := \"FLEXCOM8_USART_IOSET1\" | \"FLEXCOM8_USART_IOSET2\" | \"FLEXCOM8_USART_IOSET2\" | \"FLEXCOM8_USART_IOSET4\" | \"FLEXCOM8_USART_IOSET5\"",
				"",
				"        <usart9_entry> := \"FLEXCOM9_USART_IOSET1\" | \"FLEXCOM9_USART_IOSET2\" | \"FLEXCOM9_USART_IOSET2\" | \"FLEXCOM9_USART_IOSET4\" | \"FLEXCOM9_USART_IOSET5\"",
				"",
				"        <usart10_entry> := \"FLEXCOM10_USART_IOSET1\" | \"FLEXCOM10_USART_IOSET2\" | \"FLEXCOM10_USART_IOSET2\" | \"FLEXCOM10_USART_IOSET4\" | \"FLEXCOM10_USART_IOSET5\"",
				"",
				"        <usart11_entry> := \"FLEXCOM11_USART_IOSET1\" | \"FLEXCOM11_USART_IOSET2\" | \"FLEXCOM11_USART_IOSET2\" | \"FLEXCOM11_USART_IOSET4\" | \"FLEXCOM11_USART_IOSET5\"",
				"",
				"        <boot_sequence> := [ <boot_entry> ] | <boot_entry> \",\" <boot_sequence>",
				"",
				"        <boot_entry> := <qspi_entry> | <sdmmc_entry> | <nfc_entry>",
				"",
				"        <qspi_entry> := \"QSPI0_IOSET1\" | \"QSPI0_IOSET1_AT25\" | \"QSPI1_IOSET1\" | \"QSPI1_IOSET1_AT25\"",
				"",
                "        <sdmmc_entry> := \"SDMMC0_IOSET1\" | \"SDMMC0_IOSET1_NO_CARD_DETECT\" | \"SDMMC1_IOSET1\" | \"SDMMC1_IOSET1_NO_CARD_DETECT\" | \"SDMMC2_IOSET1\" | \"SDMMC2_IOSET1_NO_CARD_DETECT\"",
				"",
				"        <nfc_entry> := \"NFC_IOSET1\" | \"NFC_IOSET2\"",
				"",
				"",
				"    writecfg:(uhcp-otp|uhcp-emul):<user_hw_config_text>",
				"",
				"        <user_hw_config_text> := [ <user_hw_setting> ] | <user_hw_setting> \",\" <user_hw_config_text>",
				"",
				"        <user_hw_setting> := \"JTAGDIS\" | \"SECDBG\" | \"URDDIS\" | \"UPGDIS\" | \"URFDIS\" |",
				"                             \"UHCINVDIS\" | \"UHCLKDIS\" | \"UHCPGDIS\" |",
				"                             \"BCINVDIS\" | \"BCLKDIS\" | \"BCPGDIS\" |",
				"                             \"SBCINVDIS\" | \"SBCLKDIS\" | \"SBCPGDIS\" |",
				"                             \"CINVDIS\" | \"CLKDIS\" | \"CPGDIS\" |",
				"                             \"SCINVDIS\" | \"SCLKDIS\" | \"SCPGDIS\"",
				"",
				"",
				"    writecfg:(sbcp-otp|sbcp-emul):",
				"",
				"",
				"    writecfg:bscr:<bscr_value>",
				"",
				"        <bscr_value> := \"EMULATION_DISABLED\" | \"EMULATION_ENABLED\"",
				"",
				"",
				"Examples:",
				"    writecfg:bscr:EMULATION_ENABLED                           enable OTP emulation mode",
				"    writecfg:bscr:EMULATION_DISABLED                          disable OTP emulation mode",
				"    writecfg:bcp-emul:FLEXCOM0_USART_IOSET1                   empty boot config (console on FLEXCOM0) stored in OTP emulation mode",
				"    writecfg:bcp-otp:FLEXCOM0_USART_IOSET1,SDMMC1_IOSET1      boot config with console on FLEXCOM0, boot from SDMMC1 stored in OTP matrix",
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
