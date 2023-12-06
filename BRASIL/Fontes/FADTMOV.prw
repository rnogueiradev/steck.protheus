#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FADTMOV �Autor  �Cristiano Pereira  � Data �  11/23/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualizar a data de fechamento financeiro                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FADTMOV()
    
	Local lRet := .T.
	Local dData := ParamIxb[1] //Data informada pela fun��o DtMovFin
	Private _dData := Ctod(Space(8))


	OpenSxs(,,,,cEmpAnt,"CT0SX6","SX6",,.F.)

	DbSetOrder(1)
	If DbSeek(xFilial("SX6")+"MV_DATAFIN")
		_dData	:= STOD(CT0SX6->X6_CONTEUD)
	Endif

    If dData <=	_dData .And. FunNAme()=="FINA210"
        MsgInfo("Data informada bloqueada para reprocessamento, reprcessar o saldo do m�s em aberto... ","Aten��o")
		lRet := .F.
	EndIF

return lRet

