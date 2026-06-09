# ATSAMA5D27-SOM1_devboard

A custom SAMA5D27 development board I made a while ago for personal experimentation. It's exposing the parallel NAND flash interface to get some hands-on experience using that as a traditional embedded boot device.  

#### TODO:
- [x] PMIC power sequencing works, voltage regulation feedbacks valid, ripple low
- [x] board unique ID readable
- [x] serial console works
- [x] RTC backup supercap works
- [x] default SDMMC0 boots
- [x] USB host VBUS present
- [x] USB High Speed host works
- [x] NAND r/w test OK
- [ ] Configure NAND IOSET and boot config
- [ ] Implement NAND support in the at91bootstrap 2nd level bootloader and U-Boot
- [ ] Compile a kernel and make a rootfs that boots from NAND (buildroot/linux4sam custom board and kernel configs)
- [ ] test (Q)SPI interfaces
- [ ] use (Q)SPI to store the bootloader as NVM
- [ ] test other interfaces (JTAG, UARTs, USB device, ethernet, I^2C, SPI, PIOBU, HSIC)
- [ ] bonus: design and add an eMMC breakout board
