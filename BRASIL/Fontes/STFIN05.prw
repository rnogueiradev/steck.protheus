#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFIN05  �Autor  �Cristiano Pereira  � Data �  11/23/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualizar a data de fechamento financeiro                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFIN05()

Local oDlg1
Local _nOpc  := 0
Private _dData := Ctod(Space(8))


OpenSxs(,,,,cEmpAnt,"CT0SX6","SX6",,.F.)

DbSetOrder(1)
If DbSeek(xFilial("CT0SX6")+"MV_DATAFIN")
	
	  _dData	:= STOD(CT0SX6->X6_CONTEUD) 
	
Endif

DEFINE MSDIALOG oDlg1 TITLE "Fechamento financeiro" FROM 0,0 TO 260,450 PIXEL
@ 10, 10 SAY "Data do Fechamento" PIXEL
@ 10, 70 MSGET _dData  OF oDlg1 PIXEL

@ 113, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( _nOpc:=1,oDlg1:End()   )
@ 113, 130 BUTTON "Sair" SIZE 40,10 PIXEL ACTION (  oDlg1:End()   )

ACTIVATE DIALOG oDlg1 CENTERED

If _nOpc == 1
	_fGrava1()
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

Static Function _fGrava1()

OpenSxs(,,,,cEmpAnt,"CT0SX6","SX6",,.F.)
DbSetOrder(1)
If DbSeek(xFilial("SX6")+"MV_DATAFIN")
	/* Removido\Ajustado - N�o executa mais RecLock na X6. Cria��o/altera��o de dados deve ser feita apenas pelo m�dulo Configurador ou pela rotina de atualiza��o de vers�o.
	If Reclock("CT0SX6",.F.)
		CT0SX6->X6_CONTEUD:= Dtos(_dData)
		MsUnlock()
	Endif*/
	
Endif


return

