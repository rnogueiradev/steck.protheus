#Include "Protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFCIA01  �Autor  �Microsiga           � Data �  28/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para atualiza��o da Tabela CFD conforme defini��o da���
���          � area fiscal da Steck                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STFCIA05()

	Local aSays		:= {}
	Local aButtons	:= {}

	Private cCadastro 	:= OemToAnsi("Atualiza��o da Tabela CFD para gera��o da FCI")
	Private cPerg 		:= "STFCIA05"
	Private aHeader 	:= {}
	Private aCols		:= {}
	Private cTabela		:= ""
	Private oGetDados1
	Private nOpcao 		:= 0

	// Funcao para criacao de perguntas da rotina.


	AAdd(aSays,"Este programa tem como objetivo atualizar a tabela CFD, com base nas transmiss�o das industrias.")
	AAdd(aSays,"Ficha de Conteudo de Importa��o com base nos parametros")
	AAdd(aSays,"selecionados.")

	AAdd(aButtons,{ 1,.T.,{|| IIF(fConfMark(),FechaBatch(),nOpcao := 0) } } )
	AAdd(aButtons,{ 2,.T.,{|| FechaBatch() } } )

	FormBatch(cCadastro,aSays,aButtons)

	If nOpcao == 1
		If ApMsgYesNo("Atualiza a Tabela FCI industria >>> distribuidora (S/N)?")
			Processa({||STFCA05A(),"Processando... "})
		EndIf
	EndIf

Return

Static Function fConfMark()

	Local _lRet := .T.

	nOpcao := 1

Return(_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFCIA01  �Autor  �Microsiga           � Data �  28/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para atualiza��o da Tabela CFD conforme defini��o da���
���          � area fiscal da Steck                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function STFCA05A()


	Local _cQry := " "
	Local _cAlia1 	:= "QRYCON"

	_cQry :=  " SELECT TMP.*,TB1.B1_ORIGEM AS B1_ORIGEM         "
	_cQry  +=  " FROM UDBP12.CFD010 TMP,UDBP12.SB1010 TB1      "
	_cQry  +=  " WHERE TMP.D_E_L_E_T_ <> '*'    AND            "
	_cQry  +=  "       TB1.B1_COD = TMP.CFD_COD AND            "
	_cQry  +=  "       TB1.D_E_L_E_T_ <> '*'    AND            "

	_cQry  +=  "   NOT EXISTS(                                 "

	_cQry  +=  "   SELECT CFD.CFD_FCICOD                       "
	_cQry  +=  "   FROM UDBD11."+RetSqlName("CFD")+" CFD       "
	_cQry  +=  "   WHERE CFD.D_E_L_E_T_ <> '*' AND             "
	_cQry  +=  "         CFD.CFD_FCICOD=TMP.CFD_FCICOD  AND     "
	_cQry  +=  "         CFD.CFD_PERCAL=TMP.CFD_PERCAL  AND     "
	_cQry  +=  "         CFD.CFD_PERVEN=TMP.CFD_PERVEN  AND     "
    _cQry  +=  "         CFD.CFD_COD=TMP.CFD_COD                "
	_cQry  +=  " )  "

	If !Empty(Select(_cAlia1))
		DbSelectArea(_cAlia1)
		(_cAlia1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),_cAlia1,.F.,.T.)

	//TCQUERY _cQry ALIAS _cAlia1 NEW

	(_cAlia1)->(dbGoTop())

	While !(_cAlia1)->(Eof())

		    DbSelectArea("CFD")
			DbSetOrder(1)
			If !DbSeek(xFilial("CFD")+(_cAlia1)->CFD_PERCAL+(_cAlia1)->CFD_PERVEN+(_cAlia1)->CFD_COD)
			RecLock("CFD",.T.)
			CFD->CFD_FILIAL := xFilial("CFD")
			CFD->CFD_PERCAL :=(_cAlia1)->CFD_PERCAL
			CFD->CFD_PERVEN := (_cAlia1)->CFD_PERVEN
			CFD->CFD_COD	:= (_cAlia1)->CFD_COD
			CFD->CFD_VSAIIE	:= (_cAlia1)->CFD_VSAIIE
			CFD->CFD_VPARIM	:= (_cAlia1)->CFD_VPARIM
			CFD->CFD_CONIMP	:= (_cAlia1)->CFD_CONIMP
			CFD->CFD_FILOP	:= (_cAlia1)->CFD_FILOP
			CFD->CFD_ORIGEM	:= (_cAlia1)->B1_ORIGEM
			CFD->CFD_FCICOD := (_cAlia1)->CFD_FCICOD
			CFD->(MsUnLock())
            ELSE
               

			RecLock("CFD",.f.)
			CFD->CFD_FCICOD := (_cAlia1)->CFD_FCICOD
			CFD->(MsUnLock())

			Endif

		(_cAlia1)->(DbSkip())


	Enddo


	// Fecha todas as �reas de trabalho
	(_cAlia1)->(DBCloseAll())

	MsgInfo("Processamento realizado com sucesso...","Aten��o")

return
