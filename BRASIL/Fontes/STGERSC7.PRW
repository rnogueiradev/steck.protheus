#INCLUDE "Totvs.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STGERSC7	ºAutor  ³Renato Nogueira     º Data ³  25/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para gerar pedido de compra a partir da	    º±±
±±º          ³nota fiscal de saída				    				           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ 		                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STGERSC7()

	Local _aArea 			:= GetArea()
	Local _aRet 			:= {}
	Local _aParamBox 		:= {}
	Local aCab        	:= {}
	Local aItens         := {}
	Local cNumPc 			:= ""
	Local nX				:= 0
	Local _cQuery 		:= ""
	Local nItem		:= 1
	Private _nRecno		:= 0
	Private nErrQry
	Private cQuery 			:= ""
	Private cAlias 			:= "QRYTEMP"

	//Tentei usar execauto mas sem chance, não funciona, desisti! kkkkk

	If !(cFilAnt=="01")
		MsgAlert("Atenção, essa rotina só pode ser utilizada na filial 01")
		Return
	EndIf

	AADD(_aParamBox,{1,"NF+SERIE"		,Space(12),""  ,"U_STVLDNF()","","",0,.F.}) //50

	If ParamBox(_aParamBox,"Filtro de notas        ",@_aRet,,,.T.,,500)

		If MsgYesNo("Deseja gerar o pedido da nota: "+SubStr(_aRet[1],1,9))

			Begin Transaction

				//cNumPc :=GetSXENum("SC7","C7_NUM")
				cNumPc := GETSX8NUM("SC7","C7_NUM","03SC7030")//Chamado 007286 - Everson Santana - Coloquei o terceiro parametro para pegar a numeração da mesma origem.
				cQuery := " SELECT D2_COD, D2_UM, B1_LOCPAD, B1_DESC, F2_COND, F2_VALMERC, D2_VALICM, D2_PICM, D2_DESCZFC,D2_DESCON, D2_DESCZFP, D2_BASEICM, D2_PRUNIT, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_LOCAL, D2_IPI, D2_CONTA, D2_DESCZFR, "
				cQuery += " (SELECT A2_COD FROM SA2"+IIf(cEmpAnt=="01","010","030")+" "
				cQuery += " A2 WHERE A2.D_E_L_E_T_=' ' AND A2_CGC=CNPJ) FORNECEDOR, "
				cQuery += " (SELECT A2_LOJA FROM SA2"+IIf(cEmpAnt=="01","010","030")+" "
				cQuery += " A2 WHERE A2.D_E_L_E_T_=' ' AND A2_CGC=CNPJ) LOJA, F2_LOJA FILENT "
				cQuery += " FROM SF2"+IIf(cEmpAnt=="01","030","010")+" F2 "
				cQuery += " LEFT JOIN SPED050 SP50 ON DOC_CHV=F2_CHVNFE "
				cQuery += " LEFT JOIN SPED001 SP01 ON SP50.ID_ENT=SP01.ID_ENT "
				cQuery += " LEFT JOIN SD2"+IIf(cEmpAnt=="01","030","010")+" D2 "
				cQuery += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA "
				cQuery += " LEFT JOIN SB1"+IIf(cEmpAnt=="01","030","010")+" B1 "
				cQuery += " ON B1_COD=D2_COD "
				cQuery += " WHERE F2.D_E_L_E_T_=' ' AND SP50.D_E_L_E_T_=' ' AND SP01.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '  "
				cQuery += " AND F2.R_E_C_N_O_="+CVALTOCHAR(_nRecno)+" "

				If !Empty(Select(cAlias))
					DbSelectArea(cAlias)
					(cAlias)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

				dbSelectArea(cAlias)
				(cAlias)->(dbGoTop())

				While (cAlias)->(!Eof())

					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbGoTop())
					SB1->(DbSeek(xFilial("SB1")+(cAlias)->D2_COD))

					cC7Item := StrZero(nItem,TamSX3("C7_ITEM")[1])

					SC7->(RecLock("SC7",.T.))
						SC7->C7_FILIAL	:= xFilial("SC7")
						SC7->C7_TIPO		:= 1
						SC7->C7_FILENT	:= (cAlias)->FILENT
						SC7->C7_ITEM		:= cC7Item
						SC7->C7_PRODUTO	:= (cAlias)->D2_COD
						SC7->C7_UM			:= (cAlias)->D2_UM
						SC7->C7_QUANT		:= (cAlias)->D2_QUANT
						SC7->C7_PRECO		:= RetPrvUnit()
						SC7->C7_TOTAL		:= RetPrvUnit()*(cAlias)->D2_QUANT
						SC7->C7_MOTIVO	:= IIf(cEmpAnt=="01","MAO","SAO")
						SC7->C7_DATPRF	:= DDATABASE
						SC7->C7_LOCAL		:= SB1->B1_LOCPAD
						SC7->C7_FORNECE	:= (cAlias)->FORNECEDOR
						SC7->C7_LOJA		:= (cAlias)->LOJA
						SC7->C7_CONTA		:= (cAlias)->D2_CONTA
						SC7->C7_COND		:= (cAlias)->F2_COND
						SC7->C7_EMISSAO	:= DDATABASE
						SC7->C7_NUM		:= cNumPc
						SC7->C7_DESCRI	:= (cAlias)->B1_DESC
						SC7->C7_FLUXO		:= "S"
						SC7->C7_APROV		:= "000003"
						SC7->C7_CONAPRO	:= "L"
						SC7->C7_USER		:= __cUserId
						SC7->C7_PICM		:= (cAlias)->D2_PICM
						SC7->C7_BASEICM	:= (cAlias)->D2_BASEICM
						SC7->C7_TXMOEDA	:= 1
						SC7->C7_MOEDA		:= 1
						SC7->C7_VLDESC	:= (cAlias)->(D2_DESCZFR-D2_DESCZFP-D2_DESCZFC)
					SC7->(MsUnLock())

					nItem   += 1

					(cAlias)->(DbSkip())

				EndDo

				_cQuery := " UPDATE "
				_cQuery += " SF2"+IIf(cEmpAnt=="01","030","010")+" F2 "
				_cQuery += " SET F2.F2_XPEDGER='S' "
				_cQuery += " WHERE F2.D_E_L_E_T_=' ' AND F2.R_E_C_N_O_="+CVALTOCHAR(_nRecno) "

				nErrQry := TCSqlExec( _cQuery )

				If nErrQry <> 0
					DisarmTransaction()
					MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
				EndIf

				MsgAlert("Pedido inserido com sucesso: "+cNumPc)
				SC7->(ConfirmSX8())

			End Transaction

		EndIf

	EndIf

	RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STVLDNF	ºAutor  ³Renato Nogueira     º Data ³  25/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verificar se a nota existe na outra empresa				    º±±
±±º          ³									    				           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ 		                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDNF()

	Local _lRet	:= .T.

	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"

	cQuery	 := " SELECT R_E_C_N_O_ REGISTRO "

	If cEmpAnt=="01"
		cQuery  += " FROM SF2030 F2 "
	ElseIf cEmpAnt=="03"
		cQuery  += " FROM SF2010 F2 "
	EndIf

	cQuery  += " WHERE F2.D_E_L_E_T_=' ' AND F2_LOJA='01' AND F2_DOC='"+SubStr(mv_par01,1,9)+"' "
	cQuery  += " AND F2_SERIE='"+SubStr(mv_par01,10,3)+"' AND F2_XPEDGER=' ' "

	If cEmpAnt=="01"
		cQuery  += " AND F2_CLIENTE='033467'  "
	ElseIf cEmpAnt=="03"
		cQuery  += " AND F2_CLIENTE='035444'  "
	EndIf

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	If Empty((cAlias)->REGISTRO)
		_lRet	:= .F.
		MsgAlert("Atenção, nota não encontrada ou pedido já foi feito para essa nota")
	Else
		_nRecno	:= (cAlias)->REGISTRO
	EndIf

Return(_lRet)

Static Function RetPrvUnit()

Local nRetorno 		:= 0
Local nDesconto		:= (cAlias)->D2_DESCON
Local lMvNFLeiZF	:= SuperGetMV("MV_NFLEIZF",,.F.)

	If !(lMvNFLeiZF)
		If (cAlias)->D2_QUANT < 1
			if (cAlias)->D2_PRUNIT == (cAlias)->D2_PRCVEN
				nRetorno := ( ( ( (cAlias)->D2_PRUNIT * (cAlias)->D2_QUANT ) + nDesconto + (cAlias)->D2_DESCZFR ) / (cAlias)->D2_QUANT )
			elseif (cAlias)->D2_PRUNIT < (cAlias)->D2_PRCVEN
				nRetorno := ( ( ( (cAlias)->D2_PRCVEN * (cAlias)->D2_QUANT ) + (cAlias)->D2_DESCZFR ) / (cAlias)->D2_QUANT )
			else
				nRetorno := ( ( ( (cAlias)->D2_PRUNIT * (cAlias)->D2_QUANT ) + (cAlias)->D2_DESCZFR ) / (cAlias)->D2_QUANT )
			endif
		Else
			nRetorno := ( ( (cAlias)->D2_TOTAL + nDesconto + (cAlias)->D2_DESCZFR ) / (cAlias)->D2_QUANT )
		Endif
	Else
		If (cAlias)->D2_QUANT < 1
			if (cAlias)->D2_PRUNIT == (cAlias)->D2_PRCVEN
				nRetorno := ( ( ( (cAlias)->D2_PRUNIT * (cAlias)->D2_QUANT ) + nDesconto + (cAlias)->D2_DESCZFR - ((cAlias)->D2_DESCZFP + (cAlias)->D2_DESCZFC)  ) / (cAlias)->D2_QUANT )
			elseif (cAlias)->D2_PRUNIT < (cAlias)->D2_PRCVEN
				nRetorno := ( ( ( (cAlias)->D2_PRCVEN * (cAlias)->D2_QUANT ) + (cAlias)->D2_DESCZFR - ((cAlias)->D2_DESCZFP + (cAlias)->D2_DESCZFC) ) / (cAlias)->D2_QUANT )
			else
				nRetorno := ( ( ( (cAlias)->D2_PRUNIT * (cAlias)->D2_QUANT ) + (cAlias)->D2_DESCZFR - ((cAlias)->D2_DESCZFP + (cAlias)->D2_DESCZFC)  ) / (cAlias)->D2_QUANT )
			endif
		Else
			nRetorno := ( ( (cAlias)->D2_TOTAL + nDesconto + (cAlias)->D2_DESCZFR - ((cAlias)->D2_DESCZFP + (cAlias)->D2_DESCZFC)  ) / (cAlias)->D2_QUANT )
		Endif
	Endif

Return( NoRound( nRetorno, 8 ) )