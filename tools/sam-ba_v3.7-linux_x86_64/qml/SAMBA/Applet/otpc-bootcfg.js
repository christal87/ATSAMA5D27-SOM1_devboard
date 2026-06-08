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

/* Boot Config OTPC indexes */

/*! \qmlproperty int BootCfgOTPC::BSCR
    \brief Boot configuration index for BSCR. */
var BSCR = 0

/*! \qmlproperty int BootCfgOTPC::BCP_EMUL
    \brief Boot configuration index for Boot Configuration Packet in emulation SRAM. */
var BCP_EMUL = 1

/*! \qmlproperty int BootCfgOTPC::BCP_OTP
    \brief Boot configuration index for Boot Configuration Packet in OTP. */
var BCP_OTP = 2

/*! \qmlproperty int BootCfgOTPC::UHCP_EMUL
    \brief Boot configuration index for User Hardware Configuration Packet in emulation SRAM. */
var UHCP_EMUL = 3

/*! \qmlproperty int BootCfgOTPC::UHCP_OTP
    \brief Boot configuration index for User Hardware Configuration Packet in OTP. */
var UHCP_OTP = 4

/*! \qmlproperty int BootCfgOTPC::SBCP_EMUL
    \brief Boot configuration index for Secure Boot Configuration Packet in emulation SRAM. */
var SBCP_EMUL = 5

/*! \qmlproperty int BootCfgOTPC::SBCP_OTP
    \brief Boot configuration index for Secure Boot Configuration Packet in OTP. */
var SBCP_OTP = 6

/*! \qmlproperty int BootCfgOTPC::REFRESH_OTP
    \brief Reresh packets in OTP. */
var REFRESH_OTP = 0

/*! \qmlproperty int BootCfgOTPC::REFRESH_EMUL
    \brief Refresh packets in emulation mode SRAM. */
var REFRESH_EMUL = 1
