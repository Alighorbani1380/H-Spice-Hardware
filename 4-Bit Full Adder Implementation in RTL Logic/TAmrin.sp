***RTL invertor***
.INCLUDE MODEL.TXT
***AND && OR && NOT SUBCKT***
.OPTION POST NOMOD ACCURATE PROBE PROBE METHOD=GEAR


*****V*****
.GLOBAL VDD
VDD VDD 0 5
*VINA INA 0 PULSE (0 5 10P 1N 1N 100N 200N)
*VINB INB 0 PULSE (0 5 10P 1N 1N 200N 400N)
*VINC INC 0 PULSE (0 5 10P 1N 1N 400N 800N)



*XAND INA INB OUT_AND AND
*XOR INA INB OUT_OR OR
*XXOR INA INB OUT_XOR XOR
*XHA INA INB OUT_COUT OUT_SUM HA
*XFA INA INB INC OUT_FA_COUT OUT_FA_SUM FA
*XNOT INA OUT_NOT NOT
*RL OUT_NOT 1 1K
*CL OUT_NOT 0 1P
***********************Tamrin FullAdder 4 Bit**************************
VINA0 INA0 0 PULSE (0 5 10P 1N 1N 10N 20N)
VINA1 INA1 0 PULSE (0 5 10P 1N 1N 20N 40N)
VINA2 INA2 0 PULSE (0 5 10P 1N 1N 40N 80N)
VINA3 INA3 0 PULSE (0 5 10P 1N 1N 80N 160N)
VINB0 INB0 0 PULSE (0 5 10P 1N 1N 160N 320N)
VINB1 INB1 0 PULSE (0 5 10P 1N 1N 320N 640N)
VINB2 INB2 0 PULSE (0 5 10P 1N 1N 640N 1280N)
VINB3 INB3 0 PULSE (0 5 10P 1N 1N 1280N 2560N)
VINC INC 0 PULSE (0 5 10P 1N 1N 1500N 3000N)

XXOR0 INB0 INC OUT_XOR0 XOR
XXOR1 INB1 INC OUT_XOR1 XOR
XXOR2 INB2 INC OUT_XOR2 XOR
XXOR3 INB3 INC OUT_XOR3 XOR
XFA0 INA0 OUT_XOR0 INC OUT_FA0_COUT S0 FA
XFA1 INA1 OUT_XOR1 OUT_FA0_COUT OUT_FA1_COUT S1 FA
XFA2 INA2 OUT_XOR2 OUT_FA1_COUT OUT_FA2_COUT S2 FA
XFA3 INA3 OUT_XOR3 OUT_FA2_COUT OUT_FA3_COUT S3 FA


****ANALYZE*****
.TRAN 10P 3000N 
.PRINT TRAN  V(INA2)V(INA3)V(INA0)V(INA1) V(INB0) V(INB1)V(INB2)V(INB3)  V(INC) V(OUT_FA3_COUT) V(S0) V(S1) V(S2) V(S3)
*.PRINT TRAN V(OUT_FA_COUT) V(OUT_FA_SUM) V(OUT_NOT)

**********NOT*****************
.SUBCKT NOT IN OUT

RC VDD OUT 10K
Q1 OUT BASE 0 NPN
RB IN BASE 10K
.ENDS NOT
********

**********XOR*****************
.SUBCKT XOR A B OUT

XBNOT B G1 NOT
XAND1 A G1 G2 AND

XANOT A G3 NOT
XAND2 B G3 G4 AND

XOR G2 G4 OUT OR

.ENDS XOR
********

***********AND*********************
.SUBCKT AND INA INB OUT_AND

RC VDD OUT 10K
Q1 OUT BASE1 EQ1 NPN
Q2 EQ1 BASE2 0 NPN
RB1 INA BASE1 10K
RB2 INB BASE2 10K
XNOT OUT OUT_AND NOT
.ENDS AND
********

***********OR********************
.SUBCKT OR INA INB OUT_OR

RC VDD OUT 10K
Q1 OUT BASE1 0 NPN
Q2 OUT BASE2 0 NPN
RB1 INA BASE1 10K
RB2 INB BASE2 10K
XNOT OUT OUT_OR NOT
.ENDS OR
********

**************HALF ADDER**************
.SUBCKT HA A B COUT SUM

XXOR A B SUM XOR
XAND A B COUT AND
.ENDS HA
********

**************FULL ADDER**************
.SUBCKT FA A B C COUT SUM

XHF1 A B COUT1 SUM1 HA
XHF2 SUM1 C COUT2 SUM HA

XOR COUT1 COUT2 COUT OR

.ENDS FA
********


.END