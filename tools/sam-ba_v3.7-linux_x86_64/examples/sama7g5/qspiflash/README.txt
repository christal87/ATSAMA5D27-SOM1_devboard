# SAMA7G5 QSPIFlash Example

Sample scripts to flash a linux environment on QSPIFlash of the
"SAMA7G5 Engineering Board".

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Plug a USB cable between your PC and the "USB Device" connector of the board
- Close the "DISABLE_BOOT" jumper
- Power-on or reset the board
- Open the "DISABLE_BOOT" jumper
- Run the qml script using the sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x qspiflash-usb.qml
    On Linux:
        ../../../sam-ba -x qspiflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Plug your J-Link adapter to the JTAG header
- Power-on the board
- Run the qml script using the sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x qspiflash-jlink.qml
    On Linux:
        ../../../sam-ba -x qspiflash-jlink.qml

## Command Line

Aternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the qspiflash-usb.qml script:

        sam-ba -p serial -b sama7g5-eb -a qspiflash -c erase
        sam-ba -p serial -b sama7g5-eb -a qspiflash -c writeboot:at91bootstrap.bin
        sam-ba -p serial -b sama7g5-eb -a qspiflash -c write:u-boot-env.bin:0x4000
        sam-ba -p serial -b sama7g5-eb -a qspiflash -c write:u-boot.bin:0x8000
        sam-ba -p serial -b sama7g5-eb -a qspiflash -c write:sama7g5_eb.dtb:0x60000
        sam-ba -p serial -b sama7g5-eb -a qspiflash -c write:zImage:0x6c000

The following commands are equivalent to the qspiflash-jlink.qml script:

        sam-ba -p j-link -b sama7g5-eb -a qspiflash -c erase
        sam-ba -p j-link -b sama7g5-eb -a qspiflash -c writeboot:at91bootstrap.bin
        sam-ba -p j-link -b sama7g5-eb -a qspiflash -c write:u-boot-env.bin:0x4000
        sam-ba -p j-link -b sama7g5-eb -a qspiflash -c write:u-boot.bin:0x8000
        sam-ba -p j-link -b sama7g5-eb -a qspiflash -c write:sama7g5_eb.dtb:0x60000
        sam-ba -p j-link -b sama7g5-eb -a qspiflash -c write:zImage:0x6c000
