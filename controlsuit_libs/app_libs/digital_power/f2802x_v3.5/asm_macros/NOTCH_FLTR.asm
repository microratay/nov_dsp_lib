;----------------------------------------------------------------------------------
;	FILE:			NOTCH_FLTR.asm
;
;	Description:	Notch Filter
;
;	Version: 		3.0
;
;   Target:  		F2802x / F2803x 
;
;----------------------------------------------------------------------------------
;  Copyright Texas Instruments � 2010
;----------------------------------------------------------------------------------
;  Revision History:
;----------------------------------------------------------------------------------
;  Date	     | Description
;----------------------------------------------------------------------------------
;   | Release 3.0  (MB)
;----------------------------------------------------------------------------------
;=============================
NOTCH_FLTR_INIT	.macro n
;=============================
; allocate memory space for data & terminal pointers
_NOTCH_FLTR_Ref:n:	.usect 	"NOTCH_FLTR_Section",2,1,1		; reference input terminal
_NOTCH_FLTR_Fdbk:n:	.usect 	"NOTCH_FLTR_Section",2,1,1		; feedback input terminal
_NOTCH_FLTR_Out:n:	.usect 	"NOTCH_FLTR_Section",2,1,1		; output terminal
_NOTCH_FLTR_Coef:n:	.usect 	"NOTCH_FLTR_Section",2,1,1		; coefficients & saturation limits (14 words)
_NOTCH_FLTR_DBUFF:n:	.usect  "NOTCH_FLTR_Section",10,1,1		; internal Data BUFF

; publish terminal pointers for access from the C environment
		.def 	_NOTCH_FLTR_Ref:n:
		.def 	_NOTCH_FLTR_Fdbk:n:
		.def 	_NOTCH_FLTR_Out:n:
		.def 	_NOTCH_FLTR_Coef:n:
		.def 	_NOTCH_FLTR_DBUFF:n:

; set terminal pointers to ZeroNet
		MOVL	XAR2, #ZeroNet
		MOVW	DP, #_NOTCH_FLTR_Ref:n:
		MOVL	@_NOTCH_FLTR_Ref:n:, XAR2
		MOVW	DP, #_NOTCH_FLTR_Fdbk:n:
		MOVL	@_NOTCH_FLTR_Fdbk:n:, XAR2
		MOVW	DP, #_NOTCH_FLTR_Out:n:
		MOVL	@_NOTCH_FLTR_Out:n:, XAR2

; zero data buffer
		MOVW	DP, #_NOTCH_FLTR_DBUFF:n:
		MOVL 	XAR2,#_NOTCH_FLTR_DBUFF:n:
		RPT		#9 	; 10 times
	||	MOV 	*XAR2++, #0
	
		.endm

;----------------------------------------------------------------------------------
;=============================
NOTCH_FLTR	.macro n
;=============================

	; set up address pointers
	MOVW	DP, #_NOTCH_FLTR_Vars:n:
	MOVL 	XAR4, @_NOTCH_FLTR_Ref:n:	
	MOVW	DP,#_NOTCH_FLTR_Coeff:n:
	MOVL    XAR5, @_NOTCH_FLTR_Coeff:n:	

	; XAR4 has the vars
	; XAR5 has the coeff

; compute notch filter equation
; In(n-2)*B2 +In(n-1)*B1+In(n)*B0+Out(n-2)*A2+Out(n-1)*A1
	MOV		AR0,#8
	MOVL	XT, *+XAR4[AR0]					; XT  = In(n-2)
	IMPYL	P,XT,*XAR5						; P   = In(n-2)Q24*B2{Q24}
	QMPYL	ACC, XT, *XAR5++				; ACC = In(n-2)Q24*B2{Q24} = I16Q48 (upper half)
	LSL64   ACC:P,#(32-24)					; ACC -> I8Q24
	MOVL	@XAR6,ACC						; XAR6 = ACC = In(n-2)*B2

    MOV     AR0,#6                          ;
	MOVDL	XT,*+XAR4[AR0]					; XT  = In(n-1),   In(n-2) = In(n-1)
	IMPYL	P, XT, *XAR5					; P   = In(n-1)Q24*B1{Q24}  = I16Q48,(lower half)
	QMPYL	ACC,XT,*XAR5++					; ACC = In(n-1)Q24*B1{Q24}  = I16Q48,(upper half)
	LSL64   ACC:P,#(32-24)					; ACC -> I8Q24
	ADDL    @XAR6,ACC						; XAR6 = XAR6+ACC = In(n-2)*B2+In(n-1)*B1

	MOVDL	XT,*+XAR4[4]					; XT  = In(n),   In(n-1) = In(n)
	IMPYL	P, XT, *XAR5					; P   = In(n)Q24*B0{Q24}  = I16Q48,(lower half)
	QMPYL	ACC,XT,*XAR5++					; ACC = In(n)Q24*B0{Q24}  = I16Q48,(upper half)
	LSL64   ACC:P,#(32-24)					; ACC -> I8Q24
	ADDL    @XAR6,ACC						; XAR6 = XAR6+ACC = In(n-2)*B2+In(n-1)*B1+In(n)*B0

	MOVL	XT,*+XAR4[2] 					; XT  = Out(n-2)
	IMPYL	P, XT, *XAR5					; P   = Out(n-2)Q24*A2{Q24}  = I16Q48,(lower half)
	QMPYL	ACC,XT,*XAR5++					; ACC = Out(n-2)Q24*A2{Q24}  = I16Q48,(upper half)
	LSL64   ACC:P,#(32-24)					; ACC -> I8Q24
	ADDL    @XAR6,ACC						; XAR6 = XAR6+ACC = In(n-2)*B2+In(n-1)*B1+In(n)*B0+Out(n-2)*A2

	MOVDL	XT,*+XAR4[0] 					; XT  = Out(n-1), Out(n-2)=Out(n-1)
	IMPYL	P, XT, *XAR5					; P   = Out(n-1)Q24*A1{Q24}  = I16Q48,(lower half)
	QMPYL	ACC,XT,*XAR5++					; ACC = Out(n-1)Q24*A1{Q24}  = I16Q48,(upper half)
	LSL64   ACC:P,#(32-24)					; ACC -> I8Q24
	ADDL    ACC,@XAR6						; ACC = XAR6+ACC = In(n-2)*B2+In(n-1)*B1+In(n)*B0+Out(n-2)*A2+Out(n-1)*A1
	MOVL	*XAR4, ACC						; In(n-1) = In(n) = ACC

; write result to output terminal (Q24)
	MOV     AR0,#10
    MOVL    *+XAR4[AR0],ACC



; set up address pointers
		MOVW	DP, #_NOTCH_FLTR_Ref:n:
		MOVL 	XAR0, @_NOTCH_FLTR_Ref:n:		; net pointer to Ref (XAR0)
		MOVW	DP,#_NOTCH_FLTR_Fdbk:n:
		MOVL    XAR1, @_NOTCH_FLTR_Fdbk:n:		; net pointer to Fdbk (XAR1)
		MOVW	DP,#_NOTCH_FLTR_DBUFF:n:
		MOVL	XAR4, #_NOTCH_FLTR_DBUFF:n:		; pointer to the DBUFF array (used internally by the module)
		
; calculate error (Ref - Fdbk)
		MOVL	ACC, *XAR0						; ACC = Ref	(Q24) = Q(24)
		SUBL	ACC, *XAR1				    	; ACC = Ref(Q24) - Fdbk(Q24)= error(Q24)
		LSL     ACC, #6							; Logical left shift by 6,  Q{24}<<6 -> Q{30}
;store error in DBUFF 
		MOVL	*+XAR4[4], ACC					; e(n) = ACC = error Q{30}		
		
		MOVW	DP,#_NOTCH_FLTR_Out:n:
		MOVL    XAR2, @_NOTCH_FLTR_Out:n:		; net pointer to Out (XAR2)
		MOVW	DP,#_NOTCH_FLTR_Coef:n:
		MOVL    XAR3, @_NOTCH_FLTR_Coef:n:		; net pointer to Coef (XAR3)
		ZAPA		
; compute 2P2Z filter
		MOV		AR0,#8
		MOVL	XT, *+XAR4[AR0]					; XT  = e(n-2)
		QMPYL	P, XT, *XAR3++					; P   = e(n-2)Q30*B2{Q26} = I8Q24
		MOVDL	XT, *+XAR4[6]					; XT  = e(n-1), e(n-2) = e(n-1)
		QMPYAL	P, XT, *XAR3++ 					; P   = e(n-1)Q30*B1{Q26} = Q24, ACC=e(n-2)*B2
		MOVDL	XT, *+XAR4[4]	 				; XT  = e(n), e(n-1) = e(n) 
		QMPYAL	P, XT, *XAR3++ 					; P   = e(n)Q30*B0{Q26}= Q24, ACC = e(n-2)*B2 + e(n-1)*B1 
		MOVL	XT,*+XAR4[2]					; XT  = u(n-2)
		QMPYAL	P, XT, *XAR3++					; P   = u(n-2)*A2, ACC = e(n-2)*B2 + e(n-1)*B1 + e(n)*B0
		MOVDL	XT,*+XAR4[0] 					; XT  = u(n-1), u(n-2) = u(n-1)
		QMPYAL	P, XT, *XAR3++ 					; P   = u(n-1)*A1, ACC = e(n-2)*B2 + e(n-1)*B1 + e(n)*B0 + u(n-2)*A2
		ADDL	ACC, @P							; ACC = e(n-2)*B2 + e(n-1)*B1 + e(n)*B0 + u(n-2)*A2 + u(n-1)*A1 

; scale u(n):Q24, saturate (max>u(n)>min0), and save history
		
		MINL	ACC, *XAR3++ 					; saturate to < max (Q24)
		MAXL	ACC, *XAR3++                    ; saturate to the internal min >internal min (-1.0, Q24)
		MOVL    @XAR1, ACC						; save this value temporaily in XAR1

; Convert the internal u(n) to Q30 format and store in the data buffer
		LSL     ACC, #6							; Logical left shift by 6, Q{24}<<6 -> Q{30}
		MOVL	*XAR4, ACC						; u(n-1) = u(n) = ACC

		MOVL    ACC,@XAR1						; load the temporaily saved value in Q24 from XAR1 to ACC
		MAXL	ACC, *XAR3 						; saturate to > output min (Q24)

; write controller result to output terminal (Q24)
		MOVL	*XAR2, ACC						; output control effort to terminal net

		.endm
			
; end of file

