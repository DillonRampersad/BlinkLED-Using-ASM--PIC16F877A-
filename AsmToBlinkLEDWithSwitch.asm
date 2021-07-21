LIST p=16f877	;Define Microcontroller
INCLUDE <P16F877.INC>

REGA	EQU	0x20	;Label 3 registers to be used for the delay
REGB 	EQU	0x21	
REGC	EQU	0x22
	
	ORG	0x00	;Directs the PIC on where to load program on reset
	goto	main
main
	ORG	0x20	;Start main program from this address to avoid conflict with interrupt vectors etc.
	BANKSEL	TRISD	;Select bank 1, where the TRISD register is
	movelw	B'01000000'	;Define every pin on PORTD as output except pin 6(RD6)
	movwf	TRISD	;Move value into TRISD register to configure it

;-------STARTING MAIN PROGRAM------------
checkSwitch
	BANKSEL	PORTD	;Select bank 0, where PORTD is
	btfsc	PORTD, 6	;Check status of switch, if high or low
	goto	startBlink	;If High, execute startBlink
	bcf	PORTD, 6	;clear PORTD
	goto	stopBlink	;If Low, execute stopBlink

startBlink
	BANKSEL	PORTD	;Select bank 0 again just incase
	movlw	B'10000000'	;Make RD7 High
	movwf	PORTD	;Move value into register to turn on LED
	call	oneSecondDelay	;Keep LED lit for 1 second
	movlw	B'00000000'	;Make RD7 Low
	movwf	PORTD	;Move value into register to turn of LED
	call 	oneSecondDelay	;Keep LED off for 1 second
	goto	checkSwitch	;Check status of switch

stopBlink
	goto	checkSwitch	;Check ststus of switch

;---------ROUTINES---------------------
oneSecondDelay
	movlw	0x05
	movwf	REGA
loopOne
	movlw	D'255'
	movwf	REGB
loopTwo
	movlw	D'255'
	movwf	REGC
loopThree
	decfsz	REGC,F
	goto	loopThree
	decfsz	REGB,f
	goto	loopTwo
	decfsz	REGA,F
	goto	loopOne
	return

	END