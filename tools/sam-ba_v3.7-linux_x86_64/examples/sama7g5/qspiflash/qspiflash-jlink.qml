import SAMBA 3.7
import SAMBA.Connection.JLink 3.7
import SAMBA.Device.SAMA7G5 3.7

JLinkConnection {
	device: SAMA7G5-EK {
	}

	onConnectionOpened: {
		// initialize QSPI flash applet
		initializeApplet("qspiflash")

		// erase all memory
		applet.erase(0, applet.memorySize)

		// write files
		applet.write(0x00000, "at91bootstrap.bin", true)
		applet.write(0x04000, "u-boot-env.bin")
		applet.write(0x08000, "u-boot.bin")
		applet.write(0x60000, "sama7g5_ek.dtb")
		applet.write(0x6c000, "zImage")
	}
}
