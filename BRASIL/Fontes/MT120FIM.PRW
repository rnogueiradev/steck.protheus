#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120FIM	ºAutor  ³Renato Nogueira     º Data ³  04/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada após a inclusão do pedido de compra		  º±±
±±º          ³	    							 	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ nOpca,cNumPC                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120FIM(_nOpc,_nNumPc)

	Local _aArea		:= GetArea()
	Local _cQuery		:= ""
	Local _cAlias 		:= "QRYTEMP"
	Local _cEmail   	:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= 'Pedido '+PARAMIXB[2]+' filial '+cFilAnt+' empresa '+cEmpAnt+' inserido com CC do TI'
	Local cMsg	    	:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local nOpt			:= Paramixb[1]
	Local cNumSol		:= Paramixb[2]
	Local cRot 			:= ' '
	Local aEma 			:= {}
	Local nOpcA     	:= PARAMIXB[3]
	Local _cMal         := ' '
	Local _lAlterou		:= .F.
	Local _cWork  		:=  GetMV("ST_MAILPED",.F.," ")
	Local aRet 			:= {}
	Local aParamBox 	:= {}
	Local lContinua		:= .F.
	Local _nY			:= 0
	Local _cQuery2  	:= ""
	Local _cAlias2  	:= GetNextAlias()

	Local SC7Recno := SC7->(Recno())

	If PARAMIXB[1]==3 .And. PARAMIXB[3]==1 //Inclusão e confirmada operação

	/*	_cQuery	 := " SELECT COUNT(*) CONTADOR  "
		_cQuery  += " FROM " +RetSqlName("SC7")+ " C7 "
		_cQuery  += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+cFilAnt+"' AND C7_NUM='"+PARAMIXB[2]+"' "
		_cQuery  += " AND C7_CC='112104' AND C7_RESIDUO=' ' "

		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())

		If (_cAlias)->CONTADOR>=1
			 U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
				
		EndIf
*/
		//Portal - Adicionar descrição do produto no pedido
		_cQuery2 := " MERGE INTO "+RetSqlName("SC7")+" XC7
		_cQuery2 += " USING (
		_cQuery2 += " SELECT C7_PRODUTO, C7_XDESEXD, B1_XDESEXD, C7.R_E_C_N_O_ RECSC7
		_cQuery2 += " FROM "+RetSqlName("SC7")+" C7
		_cQuery2 += " LEFT JOIN "+RetSqlName("SB1")+" B1
		_cQuery2 += " ON B1_COD=C7_PRODUTO
		_cQuery2 += " WHERE C7.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '  
		_cQuery2 += " AND C7_FILIAL='"+cFilAnt+"' AND C7_NUM='"+PARAMIXB[2]+"'
		_cQuery2 += " ) XXX
		_cQuery2 += " ON (XC7.R_E_C_N_O_=XXX.RECSC7)
		_cQuery2 += " WHEN MATCHED THEN UPDATE SET
		_cQuery2 += " XC7.C7_XDESEXD=utl_raw.cast_to_varchar2(dbms_lob.substr(XXX.B1_XDESEXD,2000,1))

		TCSqlExec( _cQuery2 )

	EndIf

	//Adicionar adicional para fora do estado
	If PARAMIXB[3]==1 .And. (PARAMIXB[1]==3 .Or. PARAMIXB[1]==4)
		U_STATUSZ7(SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_FORNECE,SC7->C7_LOJA)
	EndIf

	If nOpcA = 1
		do case
			case nOpt == 3
			cRot 		:= 'Inclusão de Pedido de Compra('+cNumSol+')'
			case nOpt == 4
			cRot 		:= 'Alteração de Pedido de Compra('+cNumSol+')'
			case nOpt == 5
			cRot 		:= 'Exclusão de Pedido de Compra('+cNumSol+')'
		endcase

		If !(Empty(Alltrim(cRot)))

			Dbselectarea("SC7")
			SC7->(Dbsetorder(1))
			Dbselectarea("SA2")
			SA2->(Dbsetorder(1))
			SA2->(dbseek(xfilial("SA2")+SC7->C7_FORNECE))
			If SC7->(dbseek(xfilial("SC7")+cNumSol))			
				_cPed := _cWork
				aadd(aEma,{"Pedido",cNumSol})
				aadd(aEma,{"Dt.Entrega",dtoc(SC7->C7_DATPRF)})
				aadd(aEma,{"Usuario",cUserName})
				aadd(aEma,{"Data",dtoc(dDataBase)})
				aadd(aEma,{"Hora",substr(time(),1,5)})
				aadd(aEma,{"Fornecedor",cValtochar(SC7->C7_FORNECE)}) //- JEFF
				aadd(aEma,{"Razao Social",cValToChar(SA2->A2_NOME)}) // - JEFF	
				aadd(aEma,{"Obs",cValToChar(SC7->C7_OBS)}) // - JEFF			
				aadd(aEma,{"Produto","Quantidade"})
				While SC7->(!EOF()) .And. cNumSol = SC7->C7_NUM .And. SC7->C7_FILIAL = xfilial("SC7")
					_cMal:= SC7->C7_XEMAIL 
					aadd(aEma,{ Alltrim(SC7->C7_PRODUTO)+" - "+ Alltrim(SC7->C7_DESCRI),cvaltochar(SC7->C7_QUANT) })
					SC7->(dBSkip())
				EndDo
				If !(Empty(Alltrim(_cMal)))
					U_PCEMAIL(cRot,aEma,_cMal)
				EndIf
				If !(Empty(AllTrim(_cPed)))
					U_PCEMAIL(cRot,aEma,_cPed)
				EndIf   
			EndIf
		EndIf

	EndIf

	If TYPE("_aItensInc")=="A" .And. PARAMIXB[1]==4 .And. PARAMIXB[3]==1

		AADD(aParamBox,{1,"Motivo da alteração" 	,space(4),"","NAOVAZIO()","SC7MOT"	,"",0,.T.})

		For _nY:=1 To Len(_aItensInc)
			SC7->(Dbsetorder(1))
			If SC7->(DbSeek(xFilial("SC7")+_aItensInc[_nY][1]+_aItensInc[_nY][2]))
				SC7->(RecLock("SC7",.F.))
				SC7->C7_XLOG	:= SC7->C7_XLOG+_aItensInc[_nY][3]
				SC7->(MsUnLock())

				lContinua	:= .F.

				While !lContinua 

					If ParamBox(aParamBox,"Item "+SC7->C7_ITEM+" Produto "+SC7->C7_PRODUTO,@aRet)

						SC7->(RecLock("SC7",.F.))
						SC7->C7_XMOTREJ	:= aRet[1]
						SC7->(MsUnLock())

						aRet[1]	:= space(4)
						lContinua	:= .T.

					EndIf

				EndDo

			EndIf
		Next

		_aItensInc	:= {}

	EndIf

	SC7->(DbGoTo(SC7Recno))
	RestArea(_aArea)

Return()
