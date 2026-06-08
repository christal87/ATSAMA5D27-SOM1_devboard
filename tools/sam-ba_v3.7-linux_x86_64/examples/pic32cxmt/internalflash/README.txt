# PIC32CXMT Internal Flash Example

Sample script to flash a program on the internal flash of PIC32CXMT-based
boards.

## Setup

- Adapt the qml script file for your application (name of the file to flash)

## Flashing using UART RS-232

- Connect the host running sam-ba tool to the FLEXCOM0 USART ioset1 pins on
  the target device then power it on.
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x internalflash-uart.qml
    On Linux:
        ../../../sam-ba -x internalflash-uart.qml

## Flashing using SEGGER J-Link adapter

- Connect J-Link to the JTAG/SWD connector then power the target device on.
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x internalflash-jlink.qml
    On Linux:
        ../../../sam-ba -x internalflash-jlink.qml

## Command Line

Atlernatively, it is possible to use command-line commands instead of the QML script.

The following command is equivalent to the internalflash-uart.qml script:

        sam-ba -p serial -d pic32cxmt -a internalflash -c erase -c write:program.bin -c setgpnvm:STANDARD_BOOT:SBS_MASK

The following command uses the JTAG connection to reset the bootmode to the SAM-BA monitor:

        sam-ba -p j-link::swd -d pic32cxmt -a internalflash -c setgpnvm:SAMBA_MONITOR:SBS_MASK

