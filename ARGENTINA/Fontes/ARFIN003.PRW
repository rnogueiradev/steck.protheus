#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ARFIN003   �Autor  �Cristiano Pereira  � Data �  11/23/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualizar a data de fechamento do estoque                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ARFIN003()

Local oDlg1
Local _nOpc  := 0
Private _dData := Ctod(Space(8))


DbSelectArea("SX6")
DbSetOrder(1)
If DbSeek(xFilial("SX6")+"MV_DATAFIN")
	
	  _dData	:= STOD(SX6->X6_CONTSPA) 
	
Endif

DEFINE MSDIALOG oDlg1 TITLE "Fechamento financeiro" FROM 0,0 TO 260,450 PIXEL
@ 10, 10 SAY "Data do Fechamento" PIXEL
@ 10, 70 MSGET _dData  OF oDlg1 PIXEL

@ 113, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( _nOpc:=1,oDlg1:End()   )
@ 113, 130 BUTTON "Sair" SIZE 40,10 PIXEL ACTION (  oDlg1:End()   )

ACTIVATE DIALOG oDlg1 CENTERED

If _nOpc == 1
	_fGrava()
Endif

return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fGrava  �Autor  �Cristiano Pereira    � Data �  11/23/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gravacao do par�metro na tabela SX6                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _fGrava()

DbSelectArea("SX6")
DbSetOrder(1)
If DbSeek(xFilial("SX6")+"MV_DATAFIN")
	
	If Reclock("SX6",.F.)
		SX6->X6_CONTSPA := Dtos(_dData)
		MsUnlock()
	Endif
	
Endif


return

