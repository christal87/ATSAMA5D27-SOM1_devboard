import SAMBA 3.7
import SAMBA.Connection.JLink 3.7
import SAMBA.Device.PIC32CXMT 3.7

JLinkConnection {
	swd: true

	device: PIC32CXMT {
	}

	onConnectionOpened: {
		// initialize internal flash applet
		initializeApplet("internalflash")

		// erase all memory
		applet.erase(0, applet.memorySize)

		// write files
		applet.write(0x00000, "program.bin")

		// Set GPNVM[8:5] to 0011b
		applet.setGPNVM(GPNVM.SBS_STANDARD_BOOT, GPNVM.SBS_MASK)
	}
}