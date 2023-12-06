#INCLUDE "protheus.ch

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCalcEstag�Autor  � Adilson Silva      � Data � 13/04/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Calculo das Ferias para Estagiarios.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fCalcEstag()

 Local aDelVerbas := {}
 Local nPos, nX
 
 // Lista das verbas que devem ser excluidas nas ferias de estagiarios
 Aadd(aDelVerbas,aCodFol[077,1])		// 1/3 Ferias
 Aadd(aDelVerbas,aCodFol[065,1])		// INSS Ferias
 Aadd(aDelVerbas,aCodFol[013,1])		// Salario Contribuicao Ate Limite
 Aadd(aDelVerbas,aCodFol[168,1])		// Inss Deducao da Base do IRRF

 If SRA->RA_CATFUNC $ "E-G"
    If c__Roteiro == "FER"
       For nX := 1 To Len( aPd )
           If ( nPos := Ascan(aDelVerbas,{|x| x==aPd[nX,1]}) ) > 0
              fDelPd( aPd[nX,1] )
           EndIf
       Next nX
    EndIf
 EndIf

Return( "" )
