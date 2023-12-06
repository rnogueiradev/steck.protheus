#include "Protheus.ch"
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | STGRPESVLO       | Autor | GIOVANI.ZAGO             | Data | 18/05/2013  |
|=====================================================================================|
|Descrição | Volume, peso liquido , peso bruto                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGRPESVLO                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------*
User Function STGRPESVLO(_cFil,_cDoc,_cSerie)
	*---------------------------------------------*
	Local _xAlias 	  := GetArea()
	Local _F2Alias 	  := SF2->(GetArea())
	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAliasLif   := "TE"+cHora+ cMinutos+cSegundos
	Local cQuery      := ' '
	Local cOrdSep     := ' '
	Local nQtdEmb     := 0
	Local nTotPeso    := 0
	Local nTotLiqu    := 0
	Local nTotCub	  := 0
	Local cPedSd2     := ' '
	Local _lGrpsVol   := GetMv("ST_GRPVOL",,.F.)
	Local _nPallet	  := 0
	Local _cCep       := ' '
	Local _cMun       := ' '
	Local _nD2Item	  := 0
	Local _cAssunto	  := 'NF COM DESCONTO'
	Local _cCopia	  := "everson.santana@steck.com.br ; Julio.Oliveira@steck.com.br; marcelo.avelino@steck.com.br"
	Local _cEmail	  := 'vanessa.silva@steck.com.br ; carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br"
	Local cMsg		  := ' '
	Local cAttach     := ' '
	Local _nTotDe     := 0
	Local nPsPall     := 0
	Local nReg        := 0
	Local _aNfVenda   := {}


	DbSelectArea( "SF2" )
	SF2->(DbSetOrder(1))  // F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA
	If 	SF2->(DbSeek( xFilial("SF2") + _cDoc + _cSerie))
		If SF2->F2_DESCONT <> 0 .And. SF2->F2_EST <> 'EX'
			cMsg := " "
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>NF: </b>'+_cDoc+'<br><b>DESCONTO: </b>'+ Transform(SF2->F2_DESCONT ,"@E 999,999,999.99")  +'<br>'
			cMsg += '</body></html>'


			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)


		EndIf


		If  SF2->F2_EST $ 'RO/AM/RR/AC/AP' .And. SF2->F2_FILIAL=="02" //Ticket 20190919000011
			cMsg := " "
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>NF: </b>'+_cDoc +'<br>'
			cMsg += '</body></html>'
			_cAssunto	  := 'NF COM PIN'
			_cEmail:='aricleia.silva@steck.com.br;edilaine.damaceno@steck.com.br;maria.santos@steck.com.br; marcelo.avelino@steck.com.br;juliete.vieira@steck.com.br'
			_cCopia:= ' '//'giovani.zago@steck.com.br'
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)


		EndIf



	EndIf
	cQuery := " SELECT   DISTINCT SD2.D2_ORDSEP
	cQuery += " FROM "+RetSqlName("SD2")+" SD2   "
	cQuery += " WHERE SD2.D2_ORDSEP <> ' '
	cQuery += " AND SD2.D2_DOC      =  '"+_cDoc+"'"
	cQuery += " AND SD2.D2_SERIE    =  '"+_cSerie+"'"
	cQuery += " AND SD2.D_E_L_E_T_  =  ' '
	cQuery += " AND SD2.D2_FILIAL   =  '"+_cFil+"'"

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If  Select(cAliasLif) > 0
		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())

		While (cAliasLif)->(!Eof())

			cOrdSep:=(cAliasLif)->D2_ORDSEP
			CB9->(DbSetorder(4))
			CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
			CB6->(DbSeek(xFilial('CB6')+cOrdSep))
			While CB6->(! Eof() .and. CB6_FILIAL+CB6_XORDSE == xFilial('CB6')+cOrdSep)

				nQtdEmb	++
				nTotPeso +=	CB6->CB6_XPESO
				nTotCub  += Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_VOLUME") //Renato Nogueira - Chamado 000213

				CB6->(DbSkip())
			EndDo
			(cAliasLif)->(DbSkip())
		End

	EndIf
	If    nQtdEmb > 0   .And. nTotPeso > 0
		DbSelectArea( "SF2" )
		SF2->(DbSetOrder(1))  // F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA
		If 	SF2->(DbSeek( xFilial("SF2") + _cDoc + _cSerie))
			cTime       := Time()
			cHora       := SUBSTR(cTime, 1, 2)
			cMinutos    := SUBSTR(cTime, 4, 2)
			cSegundos   := SUBSTR(cTime, 7, 2)
			cAliasLif   := "TE"+cHora+ cMinutos+cSegundos

			cQuery := ' SELECT    SD2.D2_QUANT * SB1.B1_PESO "PESO"  '
			cQuery += ' , SD2.D2_PEDIDO "PEDIDO"    '//GIOVANI ZAGO AJUSTE PARA EXPORTAÇÃO CONSIDERAR PALLETS 12/08/14
			cQuery += " FROM "+RetSqlName("SD2")+" SD2   "
			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1   "
			cQuery += " ON SB1.B1_COD = D2_COD
			cQuery += " AND SB1.D_E_L_E_T_  =  ' '
			cQuery += " WHERE SD2.D2_ORDSEP <> ' '
			cQuery += " AND SD2.D2_DOC      =  '"+_cDoc+"'"
			cQuery += " AND SD2.D2_SERIE    =  '"+_cSerie+"'"
			cQuery += " AND SD2.D_E_L_E_T_  =  ' '
			cQuery += " AND SD2.D2_FILIAL   =  '"+_cFil+"'"

			cQuery := ChangeQuery(cQuery)

			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

			If  Select(cAliasLif) > 0
				dbSelectArea(cAliasLif)
				(cAliasLif)->(dbgotop())
				While (cAliasLif)->(!Eof())
					nTotLiqu+=	(cAliasLif)->PESO
					cPedSd2 := 	(cAliasLif)->PEDIDO
					(cAliasLif)->(DbSkip())
				End

			EndIf
			//GIOVANI ZAGO AJUSTE PARA EXPORTAÇÃO CONSIDERAR PALLETS 12/08/14
			If SF2->F2_EST = 'EX' .And. !Empty(Alltrim(cPedSd2))   .And. _lGrpsVol
				dbSelectArea('EE7')
				EE7->(DbOrderNickName("PEDFAT"))
				//If 	EE7->(DbSeek(xFilial('EE7')+Alltrim(cPedSd2))) .And. !Empty(Alltrim(EE7->EE7_XDVOL)) .And. EE7->EE7_XQVOL <> 0
				If 	EE7->(DbSeek(xFilial('EE7')+Alltrim(cPedSd2))) .And. Alltrim(EE7->EE7_XDVOL) = 'PALLETS' .And. EE7->EE7_XQVOL <> 0 //Giovani Zago 19/04/17 ajuste de pallets e caixas
					
					// --------- Valdemir Rabelo 14/04/2021 - Ticket: 20210412005829
					nPsPall := 0
				    nReg := getEEC(Alltrim(cPedSd2))
					if nReg > 0
						EEC->( dbGoto(nReg) )
						IF EX9->( FieldPos("EX9_XPSPAL") ) > 0
							nPsPall := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9_XPSPAL")
						ELSE 
							MsgInfo("Campo (EX9_XPSPAL) peso do pallet não foi criado. Por favor, comunique o depto. TI","Atenção!")
							Return
						Endif
					Endif  				    
					//-------------
					nQtdEmb  := EE7->EE7_XQVOL
					//_nPallet := nQtdEmb * 10
					_nPallet := nQtdEmb * nPsPall           // Adicionado ticket: 20210412005829 - Valdemir
				EndIf
			EndIf
			//GIOVANI ZAGO AJUSTE PARA GRAVAR CEP E MUNICIPIO kleber cd  28/08/14
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+cPedSd2))
				If !Empty(Alltrim(SC5->C5_ZCEPE))

					_cMun:= Alltrim(SC5->C5_ZMUNE)
					_cCep:= Alltrim(SC5->C5_ZCEPE)
				Else
					DbSelectArea("SA1")
					SA1->(dbSetOrder(1))
					If	SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
						_cMun:= Alltrim(SA1->A1_MUN)
						_cCep:= Alltrim(SA1->A1_CEP)

					EndIf
				EndIf
			EndIf

			SF2->(RecLock("SF2",.F.))
			SF2->F2_XCEP   	 := _cCep
			SF2->F2_XCIDADE	 := _cMun
			SF2->F2_VOLUME1  := nQtdEmb
			SF2->F2_PLIQUI   := Iif(nTotLiqu=0, nTotPeso,nTotLiqu)
			SF2->F2_PBRUTO   := nTotPeso + _nPallet
			SF2->F2_XCUBAGE	 := nTotCub   ////Renato Nogueira - Chamado 000213
			SF2->F2_XCOOR	 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1  ,"A3_SUPER"))//GIOVANI ZAGO 13/08/2018 GRAVAR O COORDENADOR NA HORA DO FATURAMENTO
			SF2->(MsUnlock())
			SF2->(DbCommit())



			//Giovani zago frete embarcador 26/01/15
			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))
			If  SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))

				While SD2->(!EOF()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
					_nD2Item++
					SD2->(DbSkip())
				End
			EndIf
			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))
			SD2->(DbGoTop())
			If  SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))

				While SD2->(!EOF()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
					SD2->(RecLock("SD2",.F.))

					SD2->D2_PESO    := round((SF2->F2_PBRUTO/_nD2Item),6)

					SD2->(MsUnlock())
					SD2->(DbCommit())
					SD2->(DbSkip())
				End

			EndIf
		EndIf
	EndIf

	If Empty(ALltrim(SF2->F2_XCEP))
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If  SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
				If !Empty(Alltrim(SC5->C5_ZCEPE))

					_cMun:= Alltrim(SC5->C5_ZMUNE)
					_cCep:= Alltrim(SC5->C5_ZCEPE)
				Else
					DbSelectArea("SA1")
					SA1->(dbSetOrder(1))
					If	SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
						_cMun:= Alltrim(SA1->A1_MUN)
						_cCep:= Alltrim(SA1->A1_CEP)

					EndIf
				EndIf
			EndIf

			SF2->(RecLock("SF2",.F.))
			SF2->F2_XCEP   	 := _cCep
			SF2->F2_XCIDADE	 := _cMun
			SF2->(MsUnlock())
			SF2->(DbCommit())
		EndIf
	EndIf


	//giovani zago 23/08/18 chamado 007669 ajuste para nf de remessa sair com o peso certo	
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	If  SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
		If Alltrim(SD2->D2_CF) $ GetMv("ST_CFNFE",,"5923/6923/6924/5924")

			DbSelectArea( "SF2" )
			SF2->(DbSetOrder(1))
			If 	SF2->(DbSeek( xFilial("SF2") + tira1(SD2->D2_DOC) + SD2->D2_SERIE))
				Aadd(_aNfVenda,{SF2->F2_VOLUME1  ,SF2->F2_PLIQUI   ,SF2->F2_PBRUTO })
				Aadd(_aNfVenda,{SF2->F2_VOLUME1  ,SF2->F2_PLIQUI   ,SF2->F2_PBRUTO })
			EndIf
			If Len(_aNfVenda)>0
				DbSelectArea( "SF2" )
				SF2->(DbSetOrder(1))
				If 	SF2->(DbSeek( xFilial("SF2") + SD2->D2_DOC + SD2->D2_SERIE))
					SF2->(RecLock("SF2",.F.))
					SF2->F2_VOLUME1  := _aNfVenda[1,1]
					SF2->F2_PLIQUI	 := _aNfVenda[1,2]
					SF2->F2_PBRUTO	 := _aNfVenda[1,3]
					SF2->(MsUnlock())
					SF2->(DbCommit())
				EndIf
			EndIf
		EndIf
	EndIf



	If GetMv("ST_GRPVO2",,.T.) .And. SF2->F2_EST = 'SP'

		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If	SA1->(DbSeek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA ))



			If SF2->F2_PBRUTO >= 1000 .And. SF2->F2_TRANSP = '000163'
				_cEmail	:= "francisco.smania@steck.com.br;wellington.gamas@steck.com.br;kleber.braga@steck.com.br  "
				_cAssunto := "[STECK] - NF "+AllTrim(SF2->F2_DOC)+" - TNT - SP"

				cMsg := " "
				cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
				cMsg += '<b>NF: </b>'			+AllTrim(SF2->F2_DOC)+'<br>
				cMsg += '<b>PESO BRUTO:</b>'	+ Transform(SF2->F2_PBRUTO ,"@E 999,999,999.99")  +'<br>'
				cMsg += '<b>UF: </b>'			+SF2->F2_EST+'<br>
				cMsg += '<b>FRETE CIF: </b>'	+SF2->F2_TPFRETE+'<br>
				cMsg += '<b>VOLUME: </b>'		+cValToChar(SF2->F2_VOLUME1)+'<br>
				cMsg += '<b>VALOR NF: </b>'		+ Transform(SF2->F2_VALBRUT ,"@E 999,999,999.99")  +'<br>'
				cMsg += '<b>RAZÃO SOCIAL: </b>'	+SA1->A1_NOME+'<br>
				cMsg += '<b>CNPJ: </b>'			+SA1->A1_CGC+'<br>
				cMsg += '<b>EMISSÃO: </b>'		+Dtoc(SF2->F2_EMISSAO)+'<br>
				cMsg += '<b>CEP: </b>'			+SF2->F2_XCEP+'<br>
				cMsg += '<b>MUNICIPIO: </b>'	+SF2->F2_XCIDADE+'<br>

				cMsg += '</body></html>'


				U_STMAILTES(_cEmail, '', _cAssunto, cMsg)
			EndIf

		EndIf

	EndIf




	RestArea(_F2Alias)
	RestArea(_xAlias)
	Return ()


	/*====================================================================================\
	|Programa  | STGRPNF          | Autor | GIOVANI.ZAGO             | Data | 18/05/2013  |
	|=====================================================================================|
	|Descrição | Volume, peso liquido , peso bruto                                        |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STGRPNF                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*---------------------------------------------*
User Function STGRPNF(_cFil,_cDoc,_cSerie)
	*---------------------------------------------*
	Local _xAlias 	  := GetArea()
	Local _cCep       := ' '
	Local _cMun       := ' '

	If Empty(ALltrim(SF2->F2_XCEP))
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If  SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
				If !Empty(Alltrim(SC5->C5_ZCEPE))

					_cMun:= Alltrim(SC5->C5_ZMUNE)
					_cCep:= Alltrim(SC5->C5_ZCEPE)
				Else
					DbSelectArea("SA1")
					SA1->(dbSetOrder(1))
					If	SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
						_cMun:= Alltrim(SA1->A1_MUN)
						_cCep:= Alltrim(SA1->A1_CEP)

					EndIf
				EndIf
			EndIf

			SF2->(RecLock("SF2",.F.))
			SF2->F2_XCEP   	 := _cCep
			SF2->F2_XCIDADE	 := _cMun
			SF2->(MsUnlock())
			SF2->(DbCommit())
		EndIf
	EndIf
	RestArea(_xAlias)
Return ()

User Function SF2CEP()
	Local _cCep       := ' '
	Local _cMun       := ' '

	dbSelectArea("SF2")
	SF2->(dbSetOrder(1) )
	SF2->(dbgotop() )
	While !SF2->(Eof())


		If Empty(ALltrim(SF2->F2_XCEP))
			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))
			If  SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
					If !Empty(Alltrim(SC5->C5_ZCEPE))

						_cMun:= Alltrim(SC5->C5_ZMUNE)
						_cCep:= Alltrim(SC5->C5_ZCEPE)
					Else
						DbSelectArea("SA1")
						SA1->(dbSetOrder(1))
						If	SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
							_cMun:= Alltrim(SA1->A1_MUN)
							_cCep:= Alltrim(SA1->A1_CEP)

						EndIf
					EndIf
				EndIf

				SF2->(RecLock("SF2",.F.))
				SF2->F2_XCEP   	 := _cCep
				SF2->F2_XCIDADE	 := _cMun
				SF2->(MsUnlock())
				SF2->(DbCommit())
			EndIf
		EndIf
		SF2->(DbSkip())
	Enddo


Return ()





User Function STVPPN(_cFil,_cDoc,_cSerie)

	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAliasLif   := "STVPPN"+cHora+ cMinutos+cSegundos
	Local cQuery      := ' '
	Local _nTotDe     := 0



	DbSelectArea( "PPN" )
	PPN->(DbSetOrder(1))
	If 	PPN->(DbSeek( xFilial("PPN") + SF2->F2_CLIENTE  + SF2->F2_LOJA)) .And. cEmpAnt = '01' .And. cFilAnt = '02'
		If PPN->PPN_DE <= dDataBase .And. PPN->PPN_ATE >= dDataBase
			If PPN->PPN_DESC <> 0


				cQuery := " SELECT  SD2.R_E_C_N_O_
				cQuery += ' "REC"
				cQuery += " , SD2.D2_VALBRUT
				cQuery += ' "VALOR"
				cQuery += " FROM SD2010 SD2 WHERE  SD2.D_E_L_E_T_ = ' '
				cQuery += " AND SD2.D2_DOC      =  '"+_cDoc+"'"
				cQuery += " AND SD2.D2_SERIE    =  '"+_cSerie+"'"
				cQuery += " AND SD2.D_E_L_E_T_  =  ' '
				cQuery += " AND SD2.D2_FILIAL   =  '"+_cFil+"'"
				cQuery := ChangeQuery(cQuery)

				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
				cQuery := ' '
				If  Select(cAliasLif) > 0
					dbSelectArea(cAliasLif)
					(cAliasLif)->(dbgotop())

					While (cAliasLif)->(!Eof())

						DbSelectArea("SD2")
						SD2->(DbGoTo((cAliasLif)->REC ))
						If (cAliasLif)->REC    = SD2->(RECNO())
							SD2->(RecLock("SD2",.F.))
							SD2->D2_XDESCLI := round( ((cAliasLif)->VALOR / 100 * PPN->PPN_DESC),2)
							SD2->(MsUnlock())
							SD2->(DbCommit())

							_nTotDe+=SD2->D2_XDESCLI
						EndIf

						(cAliasLif)->(DbSkip())
					End

				EndIf

				SF2->(RecLock("SF2",.F.))
				SF2->F2_XDESCLI   	 := _nTotDe
				SF2->(MsUnlock())
				SF2->(DbCommit())

			EndIf
		EndIf
	EndIf

Return()

/*/{Protheus.doc} getEEC
description
Rotina que irá procurar pedido relacionado
@type function
@version  
@author Valdemir Jose
@since 14/04/2021
@param pPedido, param_type, param_description
@return return_type, return_description
/*/
Static Function getEEC(pPedido)
	Local nRET     := 0
	Local aAreaEEC := GetArea() 
	Local cQry     := ""

	dbSelectArea("SC5")
	dbSetOrder(1)
	if !dbSeek(XFilial("SC5")+pPedido)
	   MsgInfo("Pedido: "+pPedido+" não encontrado")
	   Return 0
	Endif 

	cQry += "SELECT R_E_C_N_O_ REG " + CRLF 
	cQry += "FROM " + RETSQLNAME("EEC") + " EEC " + CRLF 
	cQry += "WHERE EEC.D_E_L_E_T_ = ' ' " + CRLF 
	cQry += " AND EEC.EEC_FILIAL='"+XFILIAL('EEC')+"'      " + CRLF
	cQry += " AND EEC.EEC_PEDREF='"+SC5->C5_PEDEXP+"' " + CRLF
	cQry += "ORDER BY EEC_FILIAL, EEC_PEDREF " + CRLF

	IF SELECT('TEEC') > 0
	   TEEC->( dbCloseArea() )
	ENDIF 

	tcQuery cQry New Alias 'TEEC'

	if TEEC->( !Eof() )
	   nRET := TEEC->REG
	endif 

	IF SELECT('TEEC') > 0
	   TEEC->( dbCloseArea() )
	ENDIF 

	RestArea( aAreaEEC )

Return nRET
