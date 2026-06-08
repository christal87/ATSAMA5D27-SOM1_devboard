# sam-ba v3.7 boot assistant tool cheat sheet (via serial)

#### Board serial connection test by reading the device's unique ID
```
./sam-ba -p serial:ttyUSB0 -b sama5d27-som1 -a readuniqueid
```

#### This is the default state of boot config registers and fuses before changes

Read fuse:  
```
./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c readcfg:fuse
Opening serial port 'ttyUSB0'
Connection opened.
Executing command 'readcfg:fuse'
FUSE=0x00000000 / QSPI0_IOSET1,QSPI1_IOSET1,SPI0_IOSET1,SPI1_IOSET1,NFC_IOSET1,SDMMC0,SDMMC1,UART1_IOSET1,JTAG_IOSET1
Connection closed.
```

Read BUREG[0:3]:  
```
./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c readcfg:bureg0
Opening serial port 'ttyUSB0'
Connection opened.
Executing command 'readcfg:bureg0'
BUREG0=0x00000000 / QSPI0_IOSET1,QSPI1_IOSET1,SPI0_IOSET1,SPI1_IOSET1,NFC_IOSET1,SDMMC0,SDMMC1,UART1_IOSET1,JTAG_IOSET1
Connection closed.

./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c readcfg:bureg1
Opening serial port 'ttyUSB0'
Connection opened.
Executing command 'readcfg:bureg1'
BUREG1=0x00000000 / QSPI0_IOSET1,QSPI1_IOSET1,SPI0_IOSET1,SPI1_IOSET1,NFC_IOSET1,SDMMC0,SDMMC1,UART1_IOSET1,JTAG_IOSET1
Connection closed.

./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c readcfg:bureg2
Opening serial port 'ttyUSB0'
Connection opened.
Executing command 'readcfg:bureg2'
BUREG2=0x00000000 / QSPI0_IOSET1,QSPI1_IOSET1,SPI0_IOSET1,SPI1_IOSET1,NFC_IOSET1,SDMMC0,SDMMC1,UART1_IOSET1,JTAG_IOSET1
Connection closed.

./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c readcfg:bureg3
Opening serial port 'ttyUSB0'
Connection opened.
Executing command 'readcfg:bureg3'
BUREG3=0x00000000 / QSPI0_IOSET1,QSPI1_IOSET1,SPI0_IOSET1,SPI1_IOSET1,NFC_IOSET1,SDMMC0,SDMMC1,UART1_IOSET1,JTAG_IOSET1
Connection closed.
```

Read BSCR:  
```
draken@christal-oldlaptop2:~/Downloads/sam-ba_3.5$ ./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c readcfg:bscr
Opening serial port 'ttyUSB0'
Connection opened.
Executing command 'readcfg:bscr'
BSCR=0x00000000 / BUREG0
Connection closed.
```

#### Set SDMMC0 boot
Set up BUREG0 to boot from SDMMC0 with various IOSETs, then activate it by making it valid in the BSCR  

```
./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c writecfg:bureg0:SDMMC0,SDMMC1_DISABLED,NFC_IOSET1,QSPI0_DISABLED,QSPI1_IOSET2,SPI0_IOSET1,SPI1_DISABLED,JTAG_IOSET3,QSPI_XIP_MODE,EXT_MEM_BOOT
./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c writecfg:bscr:bureg0,valid
./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a bootconfig -c readcfg:bscr
```

#### SDMMC read test into file

Read 1024 bytes at offset 0 to a file from SDMMC0, IOSET1, 1st boot partition, 4-line I/O, at 3.3V level  
```
./sam-ba -p serial:ttyUSB0 -b sama5d27-som1 -t 5 -a sdmmc:0:1:1:4:4 -c read:firmware.bin:0x0:1024
```

#### NAND modification steps
**Notice: Only set fuses when they are to be permanent (in production)! Until then configs are held until RTC is powered down.**
1. Leave factory default DISABLE_BSCR (bit 22) as 0
2. Set BUREG_VALID if not already 1
3. Leave factory default BUREG_INDEX which has to be 0
4. Set up the correct BUREG_x according to the previously read index value
5. Set EXT_MEM_BOOT_ENABLE to 1 for using NAND, etc. flash
    - https://microchip.my.site.com/s/article/How-to-configure-the-PMECC
    - https://www.linux4sam.org/bin/view/Linux4SAM/PmeccConfigure
    - https://github.com/ARM-software/u-boot/blob/master/doc/README.nand
6. Set the correct PMECC header to configure the BCH algorithm for the NAND flash interface ECC controller
```
     example header: 0xc0098da5 - 0b1100 0 000000010 01 100 011011010 010 1
     key bits[31:28] - 1100 - decimal 12 or 0x0c must be written here to validate the content of the whole word
     bit[27] - not used, leave set to 0
     eccOffset bits[26:18] - 000000010 - 2: 2 byte offset of the first ECC byte in the spare zone
     sectorSize bits[17:16] - 01 - 1: For 1024 bytes per sector
     eccBitReq bits[15:13] - 100 - 4: 24-bit ECC
     spareSize bits[12:4] - 011011010 - 218 bytes
     nbSectorPerPage bits[3:1] - 010 - 2 sectors per page
     usePmecc bits[0] - 1 - use PMECC
```

#### NAND PMECC header according to the data sheet of a Micron MT29F32G08ABAAAWP-ITZ:A
Flash parameters:  
```
page (main) area size: 8192bytes
page OOB (spare) area size: 448bytes
block size: 1024K (56K OOB total per block)
plane size: 2 planes (2048blocks * 2) 
device size: 2 planes or 4096 blocks
erase block (sector) size: 1024k
minimum advised ECC: 8-bit BCH
```

Derived header: 0xc0e14387 - 0b 1100 0 000111000 01 010 000111000 011 1 (according to doc/nandflash.html)  
```
key bits[31:28] - 1100 - decimal 12 or 0x0c must be written here to validate the content of the whole word
bit[27] - not used, leave set to 0
eccOffset bits[26:18] - 000111000 - 56: datasheet: First spare area location: Byte 8192, 56 byte offset of the first ECC byte in the spare zone (app dependent) | Linux4sam: oob (spareSize) size - (PMECC encode data size * sector number per page): 56 - ( 14 x 8 ) = -56
sectorSize bits[17:16] - 01 - 1: For 1024 bytes per sector (determined by the user, sometimes called erase block size?)
eccBitReq bits[15:13] - 010 - 2: 8-bit ECC
spareSize bits[12:4] - 000111000 - 56 bytes (datasheet 114 bytes total / 8 sector = 56, spare area for ECC and wear levelling, minimum value: N = Number of ECC bytes x Sectors Per Page: 14 x 8 = 112)
nbSectorPerPage bits[3:1] - 011 - 8 sectors per page (depends on sectorSize and page size of the NAND, nbSectorPerPage * sectorSize = page size: 8 * 1024 = 8192)
usePmecc bits[0] - 1 - use PMECC
```

#### NAND flash read/write test (IOSET1, 8-bit bus, previously calculated PM ECC header)
First check if it's empty already then test by downloading a 1kByte dummy "hello world" binary to the target. Read back the previously written binary and verify using hexdump.  
```
./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a nandflash:1:8:0xc0e14387 -c read:firmware.bin::1024
./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a nandflash:1:8:0xc0e14387 -c write:firmware.bin
./sam-ba -t 5 -p serial:ttyUSB0 -b sama5d27-som1 -a nandflash:1:8:0xc0e14387 -c read:firmware_written.bin::1024
hexdump firmware_written.bin
```
