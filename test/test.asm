.include "atari2600.inc"

        .segment "BSS"

BGColor:
        .res 1

        .segment "STARTUP"

.proc   Start

	      sei
	      cld
	      ldx #$ff
	      txs

	      lda #$00
        ldx #0

Zero:	  sta $00,X
	      inx
	      bne Zero

NextFrame:
        lda #2        ; Enable VBLANK
        sta VBLANK

        lda #2        ; Set VSYNC
        sta VSYNC

        sta WSYNC     ; Hold for three scanlines
        sta WSYNC
        sta WSYNC

        lda #0
        sta VSYNC

        ldx #37        ; 37 lines of VBLANK
LVBlank:
        sta WSYNC
        dex
        bne LVBlank

        lda #0
        sta VBLANK    ; Re-enable output

        ldx #192      ; 192 visible scanlines
        lda BGColor
ScanLoop:
        adc #1
        sta COLUBK
        sta WSYNC
        dex
        bne ScanLoop

        lda #2
        sta VBLANK

        ldx #30
LVOver:
        sta WSYNC
        dex
        bne LVOver

        dec BGColor

        jmp NextFrame


.endproc

    .segment "VECTORS"

	  .word	Start
	  .word Start
	  .word	Start

