;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
ARY1	.set	0x0200
ARY1S	.set	0x0210
ARY2	.set	0x0220
ARY2S	.set	0x0230

		clr.w	R4
		clr.w	R5
		clr.w	R6


RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

SORT1	mov.w	#ARY1, R4
		mov.w	#ARY1S, R6
		call	#ArraySetup1
		call	#COPY
		call	#SORT

Sort2	mov.w	#ARY2, R4
		mov.w	#ARY2S, R6
		call	#ArraySetup2
		call	#COPY
		call	#SORT

Mainloop	jmp	Mainloop

ArraySetup1	mov.b	#10, 0(R4)
			mov.b	#17, 1(R4)
			mov.b	#75, 2(R4)
			mov.b	#-67, 3(R4)
			mov.b	#23, 4(R4)
			mov.b	#36, 5(R4)
			mov.b	#-07, 6(R4)
			mov.b	#44, 7(R4)
			mov.b	#8, 8(R4)
			mov.b	#-74, 9(R4)
			mov.b	#18, 10(R4)

			ret

ArraySetup2	mov.b	#10, 0(R4)
			mov.b	#54, 1(R4)
			mov.b	#-04, 2(R4)
			mov.b	#-23, 3(R4)
			mov.b	#-19, 4(R4)
			mov.b	#-72, 5(R4)
			mov.b	#-07, 6(R4)
			mov.b	#36, 7(R4)
			mov.b	#62, 8(R4)
			mov.b	#00, 9(R4)
			mov.b	#39, 10(R4)

			ret

COPY		push	R4
			push 	R5
			push	R6
			mov.b	#11, R5

CopyLoop	mov.b	@R4+, 0(R6)
			inc.w	R6
			dec.w	R5
			jnz		CopyLoop

			pop		R6
			pop		R5
			pop		R4

			ret

SORT		push	R4
			push 	R5
			push 	R6
			mov.b	@R4, R5			;This is the number of elements
			dec.w	0(R4)
			dec.w	R5				; elements need to be reduced by 1 before continuing
InnerLoop	cmp.b	1(R6), 2(R6)	; check if array element 2 in R6 is lower than array element 1 in R4
			jge		SKIP			; skip if lower
			mov.b	1(R6), 12(R4)	;else, move array element 1 into empty spot in original array
			mov.b	2(R6), 1(R6)	;move array element 2 into array element 1 of sorted
			mov.b	12(R4), 2(R6)	;move array element 1 stored in original array into array element 2 of sorted

SKIP		inc.w	R6				;increment R6
			dec.w	R5				;decrease counter by 1
			jnz		InnerLoop		;repeat

OuterLoop	dec.w	0(R4)
			mov.b	@R4, R5
			pop		R6
			push	R6
			tst.w	R5
			jnz		InnerLoop

			mov.b	#10, 0(R4)
			pop		R6
			pop		R5
			pop		R4

			ret

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
