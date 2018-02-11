;******************************************************************************
;******************************************************************************
; 
; FILE: rifft_128_data.asm
; 
; DESCRIPTION: Input test data for the IFFT
; 
;******************************************************************************
;  $TI Release: C28x VCU Library Version v1.10 $
;  $Release Date: September 26, 2011 $
;******************************************************************************
;  This software is licensed for use with Texas Instruments C28x
;  family DSCs.  This license was provided to you prior to installing
;  the software.  You may review this license by consulting a copy of
;  the agreement in the doc directory of this library.
; ------------------------------------------------------------------------
;          Copyright (C) 2010-2011 Texas Instruments, Incorporated.
;                          All Rights Reserved.
;******************************************************************************
        ;.cdecls   C,LIST,"fft.h"
;############################################################################
;
;/*! \page RIFFT_128_DATA (Input test data to the IFFT)
;
; The input test data is the FFT of a two tone function. We run the ifft to 
; recover the original signal
;*/
;############################################################################

        .sect .econst
         .global _RIFFT16_128p_in_data,_RIFFT16_128p_out_data

; FFT input data   
_RIFFT16_128p_in_data: 
		.word   0, 0,  -8134, 1084,  -8140, -42,  -8057, -1023
        .word   -7863, -2079,  -7579, -2955,  -7230, -3796,  -6650, -4732
        .word   -6182, -5455,  -5320, -6205,  -4559, -6690,  -3574, -7420
        .word   -2621, -7682,  -1791, -7929,  -730, -8132,  127, -8184
        .word   1132, -8104,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0
        .word   0, 0,  0, 0,  0, 0,  0, 0


; FFT output data, two-tone
_RIFFT16_128p_out_data:
        .word   -309, -255,  -179, -85,  19, 124,  222, 305
        .word   368, 405,  415, 399,  361, 306,  242, 175
        .word   112, 59,  21, -1,  -7, 0,  18, 42
        .word   66, 88,  102, 108,  105, 93,  76, 54
        .word   32, 14,  1, -5,  -4, 3,  14, 29
        .word   43, 54,  61, 63,  59, 50,  38, 24
        .word   11, 0,  -7, -9,  -6, 1,  10, 21
        .word   31, 39,  43, 42,  38, 31,  20, 10
        .word   0, -7,  -10, -11,  -7, 0,  8, 17
        .word   24, 29,  31, 30,  25, 18,  10, 1
        .word   -5, -10,  -11, -10,  -5, 1,  8, 15
        .word   20, 23,  23, 20,  15, 8,  1, -7
        .word   -11, -14,  -13, -10,  -5, 2,  9, 15
        .word   19, 21,  19, 15,  9, 1,  -6, -12
        .word   -17, -19,  -18, -14,  -9, -2,  4, 9
        .word   13, 14,  12, 8,  2, -4,  -10, -15
        .word   -18, -18,  -16, -11,  -6, 0,  6, 10
        .word   11, 10,  7, 2,  -5, -11,  -17, -21
        .word   -23, -22,  -18, -13,  -7, -1,  4, 8
        .word   8, 6,  2, -4,  -11, -17,  -22, -24
        .word   -25, -23,  -18, -12,  -6, 0,  5, 6
        .word   6, 2,  -3, -10,  -17, -24,  -28, -30
        .word   -29, -25,  -19, -12,  -5, 1,  4, 5
        .word   2, -4,  -11, -20,  -28, -35,  -38, -39
        .word   -36, -31,  -23, -14,  -6, 0,  3, 3
        .word   -1, -9,  -19, -29,  -38, -45,  -48, -47
        .word   -43, -34,  -25, -14,  -5, 0,  2, -2
        .word   -10, -21,  -34, -48,  -59, -66,  -68, -64
        .word   -55, -42,  -28, -14,  -3, 3,  2, -6
        .word   -21, -41,  -62, -83,  -100, -110,  -111, -103
        .word   -87, -66,  -41, -20,  -4, 1,  -8, -31
        .word   -69, -118,  -174, -231,  -282, -321,  -341, -338
