
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STFIN090() �Autor  � Cristiano Pereira� Data �  28/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para atualiza��o das contas x produto                 ��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static _lMostra := .F.
User Function STFIN090()

	Local cArqImp

//��������������������������������������������������������������������������Ŀ
//� Busca o arquivo para leitura.											 �
//����������������������������������������������������������������������������

	If !_lMostra .Or. Empty(MV_PAR04)
		cArqImp := cGetFile("Arquivo .RET |*.RET","Selecione o Arquivo de retorno",0,"",.f.,  GETF_NETWORKDRIVE)
		//If (nHandle := FT_FUse(cArqImp))== -1
		//	MsgInfo("Erro ao tentar abrir arquivo.","Aten��o")
		//	Return
		//EndIf
		cArqImp :=  StrTran(cArqImp,"\cnab\entrada\",'')

		If FunName()=="FINA430"
			MV_PAR03:= cArqImp
		ELSE
			MV_PAR04:= cArqImp
		Endif
		_lMostra:= .t.
	Endif
return .t.
