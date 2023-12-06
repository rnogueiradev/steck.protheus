#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAssManaus�Autor  � Adilson Silva      � Data � 16/04/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Calculo da Contribuicao Assistencial - Especifico p/ Manaus���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fAssManaus()

 Local cMesCalc  := StrZero(Month( dDataBase ),2)
 Local lCalc     := .T.
 Local nValFolha := 0
 
 //If cMesCalc <> "03" .And. SRA->RA_ASSISAM == "S" .And. cMesCalc $ M_MESASSAM
 If cMesCalc <> "03" .And. SRA->RA_ASSIST == "1" .And. cMesCalc $ M_MESASSAM

    If SRA->RA_SITFOLH == "D"
       lCalc := .F.
    ElseIf SRA->RA_SITFOLH == "A"
       Aeval(aPd,{|x| SomaInc(x,1,@nValFolha,,,,,,,aCodFol)})
       If nValFolha <= 0
          lCalc := .F.
       EndIf
    EndIf

    If lCalc
       fGeraVerba("432",M_ASSISTAM,,,,,,,,,.T.)
    EndIf
 EndIf

Return( "" )
