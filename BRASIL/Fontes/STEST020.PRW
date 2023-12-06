#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "APVT100.CH"

/*====================================================================================\
|Programa  | STEST020        | Autor | RENATO.OLIVEIRA           | Data | 21/12/2018  |
|=====================================================================================|
|Descrição | Rotina para controlar as arrumações do estoque                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|Chamado 008250																		  |
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST020()

	Local _lRet 		:= .T.
	Local _cQuery1 		:= ""
	Local _cAlias1		:= GetNextAlias()
	Local _cQuery2 		:= ""
	Local _cAlias2		:= GetNextAlias()
	Local _cQuery3 		:= ""
	Local _cAlias3		:= GetNextAlias()
	Local _cQuery4		:= ""
	Private cLocaliz 	:= Space(17)
	Private cProduto 	:= Space(50)
	Private _aProdsBF	:= {}
	Private _aProdsBip	:= {}
	Private _cStatus	:= ""

	DbSelectArea("SBE")
	SBE->(DbSetOrder(9))

	DbSelectArea("CB1")
	CB1->(DbSetOrder(2))
	If !CB1->(DbSeek(xFilial("CB1")+__cUserId))
		VTALERT("Operador não cadastrado, verifique!")
		Return
	EndIf

	DbSelectArea("Z43")
	Z43->(DbSetOrder(1))
	Z43->(DbSeek(xFilial("Z43")+CB1->CB1_CODOPE))

	If Z43->(Eof())
		MsgAlert("Nenhuma localizacao foi encontrada para o seu usuario, verifique!")
		Return
	EndIf

	While Z43->(!Eof()) .And. Z43->(Z43_FILIAL+Z43_OPER)==xFilial("Z43")+CB1->CB1_CODOPE

		VTCLEAR()

		_cQuery3 := " SELECT COUNT(*) TOTAL, SUM(CASE WHEN Z43_DATA<>' ' THEN 1 ELSE 0 END) CONFERIDO
		_cQuery3 += " FROM "+RetSqlName("Z43")+" Z43
		_cQuery3 += " WHERE Z43.D_E_L_E_T_=' ' AND Z43_OPER='"+CB1->CB1_CODOPE+"'

		If !Empty(Select(_cAlias3))
			DbSelectArea(_cAlias3)
			(_cAlias3)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

		dbSelectArea(_cAlias3)
		(_cAlias3)->(dbGoTop())

		If (_cAlias3)->(!Eof())
			If (_cAlias3)->TOTAL==(_cAlias3)->CONFERIDO
				VtAlert("Atencao, todas as suas localizacoes foram conferidas e o processo sera reiniciado!")

				_cQuery4 := " UPDATE "+RetSqlName("Z43")+" Z43 SET Z43.Z43_DATA=' ', Z43.Z43_HORA=' '
				_cQuery4 += " WHERE Z43.D_E_L_E_T_=' ' AND Z43_OPER='"+CB1->CB1_CODOPE+"'

				TcSqlExec(_cQuery4)

			EndIf
		EndIf

		If !Empty(Z43->Z43_DATA)
			Z43->(DbSkip())
			Loop
		EndIf
		
		_lRet 		:= .T.
		cLocaliz 	:= Space(17)

		While _lRet

			@ 0,0 VTSAY "Local "+Z43->Z43_LOCAL
			@ 1,0 VTGET cLocaliz PICTURE "@!" VALID VLDLOC(cLocaliz)

			VTREAD

			If VTLASTKEY()==27
				If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
					Return
				Endif
			EndIf

			If Empty(cLocaliz) .Or. !VLDLOC(cLocaliz)
				Loop
			EndIf

			_lRet := .F.

		EndDo

		_aProdsBF 	:= {}
		_aProdsBip	:= {}
		_cStatus 	:= ""

		VTCLEAR()
		_lRet := .T.

		_cQuery1 := " SELECT DISTINCT BF_PRODUTO
		_cQuery1 += " FROM "+RetSqlName("SBF")+" BF
		_cQuery1 += " WHERE BF.D_E_L_E_T_=' ' AND BF_FILIAL='"+xFilial("SBF")+"'
		_cQuery1 += " AND BF_LOCAL='"+SBE->BE_LOCAL+"' AND BF_LOCALIZ='"+SBE->BE_LOCALIZ+"'
		_cQuery1 += " ORDER BY BF_PRODUTO

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		While (_cAlias1)->(!Eof())
			AADD(_aProdsBF,(_cAlias1)->BF_PRODUTO)
			(_cAlias1)->(DbSkip())
		EndDo

		While _lRet

			@ 0,0 VTSAY "Localizacao"
			@ 1,0 VTSAY SBE->BE_LOCALIZ

			@ 3,0 VTSAY "Bipe o produto"
			@ 4,0 VTGET cProduto PICTURE "@!" VALID EXISTCAD(cProduto,"2")

			VTREAD

			If VTLASTKEY()==27
				If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
					Return
				Endif
			EndIf

			If Empty(cProduto) .Or. !EXISTCAD(cProduto,"2")
				Loop
			EndIf

			AADD(_aProdsBip,cProduto)
			cProduto := Space(50)

			If !CBYesNo("Continuar bipando?")
				_lRet := .F.
			EndIf

		EndDo

		If VtYesNo("Confirma arrumacao dos produtos na localizacao "+AllTrim(SBE->BE_LOCALIZ)+"?")
			GRAVADADOS(_aProdsBip)
			VTALERT("Gravacao efetuada com sucesso, obrigado!")
		Else
			VTALERT("Gravacao cancelada!")
		EndIf

		Z43->(DbSkip())
	EndDo

Return()

/*/{Protheus.doc} GravaDados
@name GravaDados
@type Static Function
@desc gravar registro na tabela
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GravaDados(_aProdsBip)

	Local _nX 		:= 0
	Local _nY 		:= 0
	Local _nConf 	:= 0

	DbSelectArea("Z21")
	Z21->(DbSetOrder(1))
	
	For _nY:=1 To Len(_aProdsBip)
		For _nX:=1 To Len(_aProdsBF)
			If AllTrim(_aProdsBF[_nX])==AllTrim(_aProdsBip[_nY])
				_nConf++
			EndIf
		Next
	Next
	
	If !(Len(_aProdsBip)==Len(_aProdsBF))
		If Len(_aProdsBip)>Len(_aProdsBF)
			_cStatus := "6"
		Else
			_cStatus := "4"
		EndIf
	Else
		If _nConf==Len(_aProdsBF)
			_cStatus := "1"
		Else
			_cStatus := "4"
		EndIf
	EndIf

	For _nX:=1 To Len(_aProdsBip)
		
		/*
		If !Z21->(DbSeek(xFilial("Z21")+PADR(cLocaliz,15)+PADR(_aProdsBip[_nX],15)+DTOS(Date())))
			Z21->(RecLock("Z21",.T.))
		EndIf
		*/
		Z21->(RecLock("Z21",.T.))
		Z21->Z21_FILIAL := xFilial("Z21")
		Z21->Z21_STATUS := _cStatus
		Z21->Z21_LOCAL  := SBE->BE_LOCALIZ
		Z21->Z21_PROD	:= _aProdsBip[_nX]
		Z21->Z21_OPER	:= CB1->CB1_CODOPE
		Z21->Z21_NOMOPE	:= CB1->CB1_NOME
		Z21->Z21_DTEXEC	:= Date()
		Z21->Z21_HREXEC := Time()
		Z21->(MsUnLock())

	Next

	If Z43->(!Eof())
		Z43->(RecLock("Z43",.F.))
		Z43->Z43_DATA := Date()
		Z43->Z43_HORA := Time()
		Z43->(MsUnLock())
	EndIf

Return()

/*/{Protheus.doc} EXISTCAD
@name EXISTCAD
@type Static Function
@desc verificar registro digitado
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function EXISTCAD(cCodigo,cTipo)

	Local _lRet := .T.
	Local _nX

	Do Case
		Case cTipo=="1"
		DbSelectArea("SBE")
		SBE->(DbSetOrder(1))
		If !SBE->(DbSeek(xFilial("SBE")+cCodigo))
			_lRet := .F.
			VTALERT("Endereco nao encontrado, verifique!")
		Else
			cLocaliz := SBE->BE_LOCALIZ
		EndIf
		Case cTipo=="2"

		cID 	:= cCodigo
		aBarras := {}

		If At("=",cID) > 0 .or. At("|",cID) > 0

			If At("=",cID) > 0
				aBarras := StrTokArr( cId, '=' )
			ElseIf At("|",cID) > 0
				aBarras := StrTokArr( cId, '|' )
			EndIf
			If Len(aBarras) < 3
				ApMsgAlert("Codigo de barras Steck Invalido","Atencao")
				Return(.F.)
			EndIf

			cProduto 	:= Padr(aBarras[1],Len(SB1->B1_COD))
			cLote		:= Padr(aBarras[2],Len(SD3->D3_LOTECTL))
			nQtde		:= Val(aBarras[3])/1

			cCodigo := cProduto

		EndIf

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek(xFilial("SB1")+cCodigo))
			_lRet := .F.
			VTALERT("Produto nao encontrado, verifique!")
		EndIf

		_lAchou := .F.

		For _nX:=1 To Len(_aProdsBip)
			If AllTrim(_aProdsBip[_nX])==AllTrim(SB1->B1_COD)
				_lAchou := .T.
				Exit
			EndIf
		Next

		If _lAchou
			VTALERT("Produto ja bipado, verifique!")
			_lRet := .F.
		EndIf

	EndCase

Return(_lRet)

/*/{Protheus.doc} VLDLOC
@name VLDLOC
@type Static Function
@desc validar local digitado
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLOC(cLocaliz)

	Local _lRet := .F.
	Local _cLocDig := ""
	
	If AllTrim(cLocaliz)==AllTrim(Z43->Z43_LOCAL)
		_lRet := .T.
		_cLocDig := AllTrim(cLocaliz)
	ElseIf AllTrim(SubStr(cLocaliz,3,Len(cLocaliz)))==AllTrim(Z43->Z43_LOCAL)
		_lRet := .T.
		_cLocDig := AllTrim(SubStr(cLocaliz,3,Len(cLocaliz)))
	Else
		_lRet := .F.
		VtAlert("Local incorreto, verifique!")
	EndIf
	
	If _lRet
		If !SBE->(DbSeek(xFilial("SBE")+_cLocDig))
			_lRet := .F.
			VtAlert("Endereco nao encontrado, verifique!")
		EndIf
	EndIf

Return(_lRet)