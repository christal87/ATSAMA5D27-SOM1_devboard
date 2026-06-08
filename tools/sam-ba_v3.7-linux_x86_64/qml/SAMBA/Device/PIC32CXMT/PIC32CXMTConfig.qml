import QtQuick 2.3
import SAMBA.Applet 3.7

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
		\brief Configuration for the 'internalflash' applet

		See \l{SAMBA.Applet::}{InternalFlashConfig} for a list of configurable properties.
	*/
	property alias internalflash: internalflash
	InternalFlashConfig {
		id: internalflash
	}
}
