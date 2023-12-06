/*
Função          : EECPEM42()
Parâmetros      : Nenhum
Retorno         : .T. / .F.
Objetivo        : Alteração do Array aRotina. Inclusão da rotina de containers customizada.
Autor           : Julio de Paula Paz
Data/Hora       : 02/09/2010 - 10:00
Obs.            :
*/
User Function EECPEM42()
	Local lRet  := .T.
	Local cParam := If(Type("ParamIxb")="A",ParamIxb[1],ParamIxb)
	Local nI

	Begin Sequence
		Do Case
			Case cParam == "EMBARQUE"
			For nI := 1 To Len(aRotina)

				If ValType(aRotina[nI,2]) = "C"
					If Upper(aRotina[nI,2]) == "EECAE104" .Or. Upper(aRotina[nI,2]) == "AE110ESTUF"
						//aRotina[nI] := {"Containers-Steck","U_ECEstufMerc",0,4}
						Aadd(aRotina,{"Containers-Steck","U_ECEstufMerc",0,4})
						Aadd(aRotina,{"Invoice-Steck","U_rstfatag",0,4}) //giovani zago 28/03/16 chamado arisla comex
						Aadd(aRotina,{"Carrega SD","U_STCAREE9",0,4})
					EndIf
				EndIf
			Next
		EndCase
	End Sequence


Return lRet

User Function STCAREE9()

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}

	AADD(_aParamBox,{1,"Nr. S.D."	,Space(20)  ,"@!","","","",20,.F.}) //50
	AADD(_aParamBox,{1,"Averb. S.D.",DDATABASE,"99/99/9999","","","",50,.F.})
	AADD(_aParamBox,{1,"R.E."	,Space(12),"@!","","","",12,.F.}) //50
	AADD(_aParamBox,{1,"Data R.E.",DDATABASE,"99/99/9999","","","",50,.F.})
	AADD(_aParamBox,{1,"Data da DDE",DDATABASE,"99/99/9999","","","",50,.F.})

	If ParamBox(_aParamBox,"Alterações de SD",@_aRet,,,.T.,,500)

		cQuery := " UPDATE "+RetSqlName("EE9")+" "
		cQuery += " SET EE9_NRSD='"+_aRet[1]+"',"
		cQuery += " EE9_DTAVRB='"+DTOS(_aRet[2])+"', "
		cQuery += " EE9_RE='"+_aRet[3]+"', "
		cQuery += " EE9_DTRE='"+DTOS(_aRet[4])+"', "
		cQuery += " EE9_DTDDE='"+DTOS(_aRet[5])+"' "
		cQuery += " WHERE D_E_L_E_T_=' ' AND EE9_FILIAL='"+EEC->EEC_FILIAL+"' AND EE9_PEDIDO='"+EEC->EEC_PEDREF+"' "
		cQuery += " AND EE9_PREEMB='"+EEC->EEC_PREEMB+"' "

		nErrQry := TCSqlExec( cQuery )

		If nErrQry <> 0
			MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
		EndIf

	EndIf

Return()