#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA103MNU �Autor  �Microsiga           � Data �  03/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para adicionar itens no menu do MATA103	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA103MNU()

	aAdd(aRotina,{"FATEC"		 	, "U_STFSRE10"   , 0 , 3, 0, .F.})
	AAdd(aRotina,{"Alt.Chave NF-e"	, "U_STCHVD01", 0 , 4, 0, Nil})
	AAdd(aRotina,{"Altera��es"		, "U_STALTSF1", 0 , 5, 0, Nil})
	AAdd(aRotina,{"Cons. multiplos PC" , "U_STCOM230", 0 , 9, 0, Nil})
	
	SetKey( K_CTRL_T , { || U_STCOM190() } )
	SetKey( K_CTRL_U , { || U_STCOM191() } )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STALTSD1 �Autor  �Microsiga           � Data �  03/01/10    ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera��es na SD1											    	 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STALTSF1()

	Local _aArea		:= GetArea()
	Local _aRet 			:= {}
	Local _aParamBox 		:= {}

	If !Empty(SF1->F1_STATUS)
		MsgAlert("Aten��o, essa nota n�o pode ser alterada pois j� foi classificada!")
		Return
	EndIf

	AADD(_aParamBox,{1,"Cond. Pagto",Space(3) ,"","EXISTCPO('SE4')","SE4","",0,.F.})
	AADD(_aParamBox,{1,"Natureza"   ,Space(10),"","EXISTCPO('SED')","SED","",0,.F.})
	
	If ParamBox(_aParamBox,"Altera��es",@_aRet,,,.T.,,500)
		SF1->(RecLock("SF1",.F.))
		SF1->F1_COND		:= _aRet[1]
		SF1->F1_ZNATURE	:= _aRet[2]
		SF1->(MsUnLock())
		MsgInfo("Altera��es efetuadas com sucesso!")
	EndIf

	RestArea(_aArea)

// Ponto de chamada Conex�oNF-e sempre como �ltima instru��o.
    U_GTPE010()

Return()
