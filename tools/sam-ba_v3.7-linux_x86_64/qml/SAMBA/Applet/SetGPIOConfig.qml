/*
 * Copyright (c) 2019, Microchip Technology.
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

/*!
    \qmltype SetGPIOConfig
    \inqmlmodule SAMBA.Applet
    \brief Contains configuration values for the SetGPIO applet.
*/
Item {
    /*! The IO group (PIO contrroller) containing the pins you want to use */
    property var group

    /*! Bitmask indicating which pin(s) to configue */
    property var mask

    /*! Pin type */
    property var type

    /*! Pin config attribute */
    property var attribute
}
