            processor 6502
            include "vcs.h"
            include "macro.h"

            seg.u Data
            org $80

Counter     ds.b 1

            seg Code
            org $f000

Start       CLEAN_START         ; Initialize TIA/RAM/stack

NextFrame   VERTICAL_SYNC       ; 1 + 3 lines of VSYNC

            ldx #36             ; 36 more lines of VBLANK
LVBlank     sta WSYNC
            dex
            bne LVBlank

            stx VBLANK          ; disable VBLANK

            lda #$82            ; set playfield color
            sta COLUPF

            ldx #192            ; generate 192 visible scanlines
            ;lda #0             ; changes every scanline
            lda Counter         ; uncomment to scroll!

ScanLoop    sta WSYNC           ; wait for next scanline
            sta PF0             ; update playfield bitmap registers
            sta PF1
            sta PF2
            stx COLUBK          ; set the background color
            adc #1
            dex
            bne ScanLoop        ; do another scanline

            lda #2              ; re-enable VBLANK for bottom (and top of next frame)
            sta VBLANK

            ldx #30             ; 30 lines of overscan
LVOver      sta WSYNC
            dex
            bne LVOver

            inc Counter         ; prepare for next frame
            jmp NextFrame

            seg Vectors
            org $fffa

            dc.w Start          ; NMI vector (unused)
            dc.w Start          ; reset vector
            dc.w Start          ; IRQ vector (unused)
