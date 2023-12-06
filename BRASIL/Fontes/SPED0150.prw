#Include "Rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSPED0150  บAutor  ณCristiano Pereira   บ Data ณ  04/19/17   บฑฑ                                
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada na gera็ใo do sped fiscal (participantes) บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

User Function SPED0150()

Local aReg0150  := PARAMIXB[1]
Local _nPosName := Iif(  IsInCallStack('FISA008'),1,2)

If _nPosName == 2
    aReg0150[12] :=  AllTrim(LTRIM(RTRIM(aReg0150[12])))
    aReg0150[12] :=  STRTRAN(aReg0150[12],'	','')
    aReg0150[11] :=  AllTrim(LTRIM(RTRIM(aReg0150[11])))
    aReg0150[11] :=  STRTRAN(aReg0150[11],'	','') 
    aReg0150[03] := AllTrim(LTRIM(RTRIM(aReg0150[03])))
    aReg0150[03] :=  STRTRAN(aReg0150[03],'	','') 
ElseIf _nPosName == 1

    aReg0150[12] :=  AllTrim(LTRIM(RTRIM(aReg0150[12])))
    aReg0150[12] :=  STRTRAN(aReg0150[12],'	','')
    aReg0150[11] :=  AllTrim(LTRIM(RTRIM(aReg0150[11])))
    aReg0150[11] :=  STRTRAN(aReg0150[11],'	','') 
    aReg0150[03] := AllTrim(LTRIM(RTRIM(aReg0150[03])))
    aReg0150[03] :=  STRTRAN(aReg0150[03],'	','') 
    
Endif 

return(aReg0150)