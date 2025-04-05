            processor 6502
            include "vcs.h"
            include "macro.h"

            seg.u Data
            org $80

BGColor     ds.b 1      ; starting BG color for frame

            seg Code
            org $f000

Start       CLEAN_START ; zero out RAM and TIA registers

NextFrame   lda #2      ; enable VBLANK
            sta VBLANK
            sta VSYNC   ; enable VSYNC

            sta WSYNC   ; hold for 3 scanlines
            sta WSYNC
            sta WSYNC

            lda #0      ; disable VSYNC
            sta VSYNC

            ldx #37     ; 37 lines of VBLANK
LVBlank     sta WSYNC   ; to allow beam time
            dex         ; to return to upper
            bne LVBlank ; left

            stx VBLANK  ; disable VBLANK

            ldx #192    ; 192 visible scanlines
            lda BGColor ; get starting BG color
ScanLoop    sta COLUBK  ; set background color
            sta WSYNC   ; wait for next scanline
            adc #1      ; next BG color
            dex
            bne ScanLoop ; do next scanline

            lda #2
            sta VBLANK  ; re-enable VBLANK

            ldx #30     ; 30 line of overscan
LVOver      sta WSYNC
            dex
            bne LVOver

            inc BGColor ; bump next frame starting BG color

            jmp NextFrame ; do another frame

            seg Vectors
            org $fffa

            dc.w Start  ; NMI vector
            dc.w Start  ; Reset vector
            dc.w Start  ; IRQ vector
