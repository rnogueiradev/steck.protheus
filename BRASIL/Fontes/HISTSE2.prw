#include "protheus.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "Colors.CH"
#INCLUDE "FONT.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � HISTSE2  �Autor  � Ricardo Posman     � Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Manutencao do campo Historico Titulos a Pagar (SE2)         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � STECK                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function HISTSE2() 

PRIVATE aRotina := { { OemToAnsi("Pesquisar"),"AxPesqui"  	,0,1},;		//"Pesquisar"  
					 { OemToAnsi("Visualizar"),"AxVisual"	,0,2},; 	//"Visualizar"
					 { OemToAnsi("Historico"),"U_GRVSE2()" 	,0,3} }	    //"Historico"

PRIVATE cCadastro := OemToAnsi("Gravacao Historico Titulos a Pagar") //"Gravacao Historico Titulos a Pagar"

Private cString := "SE2"


dbSelectArea("SE2")
dbSetOrder(1)

mBrowse( 6, 1,22,75,"SE2",,,,,,)


Return .T.  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GRVSE2   � Autor � Ricardo Posman     � Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Tela para digitacao do campo historico                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � STECK                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function GRVSE2()   

Private _cObs    :=SE2->E2_HIST

@ 199,274 	To 450,792 Dialog DlgVolume Title OemToAnsi("Historico")
@ 12,10 	To 100,240
@ 25,18 	Say OemToAnsi("Observacao") Size 25,8 
@ 25,052  	Get _cObs     Size 185,10
@ 105,202 	Button OemToAnsi("_Ok") Size 36,16 Action _Altera2()
@ 105,150 	Button OemToAnsi("_Sair") Size 36,16 Action Close(DlgVolume)

ACTIVATE MSDIALOG DlgVolume Centered

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Altera2  � Autor � Ricardo Posman     � Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Grava novo historico no campo SE1_HIST                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � STECK                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function _Altera2()   


		RECLOCK("SE2",.F.)
		SE2->E2_HIST  :=	_cObs    
 		MSUNLOCK("SE2")

Close(DlgVolume)

Return()


