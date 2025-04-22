            processor 6502
            include "vcs.h"
            include "macro.h"

            seg.u Data
            org $80

BGColor     ds.b 1

            seg Code
            org $f000

Start       CLEAN_START

            
NextFrame   VERTICAL_SYNC   ; 3+1 lines of VSYNC

            ldx #36         ; 36 lines of VBLANK (plus 1 from above)
LVBlank     sta WSYNC
            dex
            bne LVBlank

            lda #0          ; disable VBLANK
            sta VBLANK      ; renable output

            ldx #192        ; 192 visible scanlines
            lda BGColor     ; load the starting background color
            clc             ; clear the carry flag
ScanLoop    sta COLUBK      ; set the background color
            sta WSYNC       ; wait for next line
            adc #1          ; increment background color
            dex
            bne ScanLoop

            lda #2          ; enable VBLANK again
            sta VBLANK

            ldx #30         ; 30 lines of overscan
LVOver      sta WSYNC
            dex
            bne LVOver

            dec BGColor     ; decrement starting BG color

            jmp NextFrame   ; do another frame

            seg Vectors
            org $fffa

            dc.w Start      ; NMI vector
            dc.w Start      ; reset vector
            dc.w Start      ; IRQ vector
