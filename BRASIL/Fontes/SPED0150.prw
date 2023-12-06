#Include "Rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SPED0150  �Autor  �Cristiano Pereira   � Data �  04/19/17   ���                                
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na gera��o do sped fiscal (participantes) ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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