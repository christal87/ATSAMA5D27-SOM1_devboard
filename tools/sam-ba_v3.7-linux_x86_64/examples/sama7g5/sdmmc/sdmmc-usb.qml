import SAMBA 3.7
import SAMBA.Connection.Serial 3.7
import SAMBA.Device.SAMA7G5 3.7

SerialConnection {
	device: SAMA7G5-EK {
	}

	onConnectionOpened: {
		// initialize SDMMC applet
		initializeApplet("sdmmc")

		// write files
		applet.write(0x00000, "sdcard.img")
	}
}
