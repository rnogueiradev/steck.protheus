#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | WSTELEGRAM         | Autor | GIOVANI.ZAGO            | Data | 21/02/2018 |
|=====================================================================================|
|Descrição | WSTELEGRAM                                                               |
|          | 										                                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-----------------------------* 

/*
528494411:AAES4ODOLP7X41JLIbYflKVBoO36vcaKRKI
https://api.telegram.org/bot528494411:AAES4ODOLP7X41JLIbYflKVBoO36vcaKRKI/deletewebhook
https://api.telegram.org/bot528494411:AAES4ODOLP7X41JLIbYflKVBoO36vcaKRKI/setwebhook?url=https://stkconsulta.steck.com.br:8443/teste.php
*/
WSSERVICE xWSTELEGRAM DESCRIPTION "Serviço Telegram Protheus"

	WSDATA pedido		AS STRING
	WSDATA cRet		    AS STRING
	WSDATA cChatid		AS STRING
	WSDATA cMessageid	AS STRING
	WSDATA cOpcao		AS STRING
	WSDATA cTitle		AS STRING

	WSMETHOD RetTelegram DESCRIPTION "Método que retorna telegram"

ENDWSSERVICE

WSMETHOD RetTelegram WSRECEIVE pedido,cChatid,cMessageid,cOpcao,cTitle WSSEND cRet WSSERVICE xWSTELEGRAM
	Private cPerg 			:= 'RetTelegram'
	Private cQuery     		:= ' '
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private _cret			:= ' '
	Private _cDat     		:= Month2Str( date())
	Private _cDat1    		:= Month2Str(MonthSum(date(),1))
	Private _cDat2    		:= Month2Str(MonthSum(date(),2))
	Private _cDat3    		:= Month2Str(MonthSum(date(),3))
	Private _cDat4    		:= Month2Str(MonthSum(date(),4))
	Private _cDat5    		:= Month2Str(MonthSum(date(),5))
	Private _cDat6    		:= Month2Str(MonthSum(date(),6))
	Private _cDat7    		:= Month2Str(MonthSum(date(),7))
	Private _cDat8    		:= Month2Str(MonthSum(date(),8))
	Private _nToVal			:= 0
	Private _UserChat		:= GetMv('ST_TELUSER',,'461780234/447858864')
	Private _nToTFat		:= 0
	Private	_nDiaFat		:= 0


	conout(pedido)
	conout(cChatid)
	conout(cMessageid)
	conout(cOpcao)
	conout(cTitle)
	conout("Inicio consulta"+DTOC(date())+' - '+ TIME())


	DbSelectArea("Z1B")
	Z1B->(RecLock("Z1B",.T.))

	Z1B->Z1B_FILIAL		:= 'WS'
	Z1B->Z1B_DATA		:= date()
	Z1B->Z1B_HORA		:= TIME()
	Z1B->Z1B_USUARI		:= ' '
	Z1B->Z1B_NOME		:= Upper(Alltrim(pedido))
	Z1B->Z1B_ROTINA		:= 'WS TELEGRAM'
	Z1B->Z1B_NOMERO		:= 'WS TELEGRAM - '+ Upper(Alltrim(cOpcao))
	Z1B->Z1B_OBS		:= Alltrim(cChatid)
	Z1B->Z1B_MENU		:= ' '

	Z1B->(MsUnlock())
	Z1B->(DbCommit())


	IF SELECT (cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	ENDIF


	If Alltrim(cChatid) $ _UserChat


		If cOpcao = 'faturamento'

			ctQuery()
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			If  Select(cAliasLif) > 0

				_nToTFat:=(cAliasLif)->TOTAL
				_nDiaFat:=(cAliasLif)->DIA

				ctQuery1()
				dbSelectArea(cAliasLif)
				(cAliasLif)->(dbgotop())
				If  Select(cAliasLif) > 0

					_nToTFat+=(cAliasLif)->TOTAL
					_nDiaFat+=(cAliasLif)->DIA

					dvQuery()
					dbSelectArea(cAliasLif)
					(cAliasLif)->(dbgotop())
					If  Select(cAliasLif) > 0

						_nToTFat:= _nToTFat-(cAliasLif)->TOTAL
						_nDiaFat:=_nDiaFat-(cAliasLif)->DIA

						dvQuery1()
						dbSelectArea(cAliasLif)
						(cAliasLif)->(dbgotop())
						If  Select(cAliasLif) > 0

							_nToTFat:= _nToTFat-(cAliasLif)->TOTAL
							_nDiaFat:=_nDiaFat-(cAliasLif)->DIA

							_cret:= 'Faturamento Brasil '+substr(dtos(date()),5,2)+'/'+substr(dtos(date()),1,4)+CR+' R$ '+ TransForm((_nToTFat )	,"@E 99,999,999.99") +CR+CR
							_cret+= 'Faturamento '+ DTOC(date())+CR+' R$ '+ TransForm((_nDiaFat )	,"@E 9,999,999.99")

							/***********************************************************************************************
							If Upper(Alltrim(pedido)) $ Upper(Alltrim('klecios/giovani/daniel/rogerio/iago/MARIA TATIANA'))

								arQuery()
								dbSelectArea(cAliasLif)
								(cAliasLif)->(dbgotop())
								If  Select(cAliasLif) > 0

									_nToTFat:= (cAliasLif)->TOTAL
									_nDiaFat:= (cAliasLif)->DIA
									If	Upper(Alltrim(pedido)) $ Upper(Alltrim('MARIA TATIANA'))
										_cret:= ' '
									EndIf
									_cret+= CR+CR+CR+'Faturamento - Argentina '+substr(dtos(date()),5,2)+'/'+substr(dtos(date()),1,4)+CR+' AR$ '+ TransForm((_nToTFat )	,"@E 99,999,999.99") +CR+CR
									_cret+= 'Faturamento '+ DTOC(date())+CR+' AR$ '+ TransForm((_nDiaFat )	,"@E 99,999,999.99")

								EndIf
							EndIf
							***********************************************************************************************/

							/***********************************************************************************************
							If Upper(Alltrim(pedido)) $ Upper(Alltrim('klecios/giovani/daniel/vinicius/iago'))

								colQuery()
								dbSelectArea(cAliasLif)
								(cAliasLif)->(dbgotop())
								If  Select(cAliasLif) > 0

									_nToTFat:= (cAliasLif)->TOTAL
									_nDiaFat:= (cAliasLif)->DIA
									If	Upper(Alltrim(pedido)) $ Upper(Alltrim('vinicius'))
										_cret:= ' '
									EndIf
									_cret+= CR+CR+CR+'Faturamento - Colômbia '+substr(dtos(date()),5,2)+'/'+substr(dtos(date()),1,4)+CR+' COP$ '+ TransForm((_nToTFat )	,"@E 999,999,999.99") +CR+CR
									_cret+= 'Faturamento '+ DTOC(date())+CR+' COP$ '+ TransForm((_nDiaFat )	,"@E 999,999,999,999.99")

								EndIf
							EndIf
							***********************************************************************************************/

						EndIf

					EndIf

				EndIf

			EndIf

		//ElseIf cOpcao = 'captacao' desativado até revisão
		ELSEIF cOpcao = 'captacao'

			/////StQuery()
			////dbSelectArea(cAliasLif)
			/***********************************************************************************************************************
			<<< ALTERAÇÃO >>>
			ação.........: Chama a query de dentro do relatório RSTFATDB.PRW
			Desenvolvedor: Marcelo Klopfer Leme
			Data.........: 20/07/2022
			Chamado......: 20220713013842 - Reativar captação no Telegram
			xAlias = Alias 
			xMV01 = Data 
			xMV02 = Data 
			xMV03 = Numérico
			xMV04 = Numérico
			xMV05 = Numérico
			xFunName = Nome da função
			***********************************************************************************************************************/
			U_QRY_RSTFATDB(FirstDate(Date()),LastDate(Date()),2,1,1, "WSTELEGRAM",cAliasLif)

			(cAliasLif)->(dbgotop())
			If  Select(cAliasLif) > 0

				_cret+= 'Captação'+CR+CR
				_cret+= 'Total mês: '+CR+CR
				_cret+= 'R$ '+ TransForm((cAliasLif)->TOTAL,"@E 99,999,999.99") +CR+CR
				//_cret+= 'Rejeitado total
				//_cret+= 'R$ '+ TransForm((cAliasLif)->REJEITADO,"@E 99,999,999.99") +CR+CR

				(cAliasLif)->(DbCloseArea())

				U_QRY_RSTFATDB(Date(),Date(),2,1,1, "WSTELEGRAM",cAliasLif)

				(cAliasLif)->(dbgotop())
				If  Select(cAliasLif) > 0

				_cret+= 'Total dia: '+CR+CR
				_cret+= 'R$ '+ TransForm((cAliasLif)->TOTAL,"@E 99,999,999.99") +CR+CR
				//_cret+= 'Rejeitado mes
				//_cret+= 'R$ '+ TransForm((cAliasLif)->REJEITADO,"@E 99,999,999.99") +CR+CR

				(cAliasLif)->(DbCloseArea())

				EndIf

				/*********************************************************************************************************************************
				_nToVal:= (cAliasLif)->TOTAL-(cAliasLif)->REJEITADOS-(cAliasLif)->ANALISE-(cAliasLif)->TOTAL5-(cAliasLif)->TOTAL1-(cAliasLif)->TOTAL2-(cAliasLif)->TOTAL3 -(cAliasLif)->X999+(cAliasLif)->X9994+(cAliasLif)->X9991+(cAliasLif)->X9992+(cAliasLif)->X9993//-(cAliasLif)->MES
				//
				01 De: disponível  para : carteira faturavel
				02 Incluir ( X999 ) são unicom ainda sem referencia para a fabrica produzir, então este valor deverá ser abatido da carteira faturável , porem nos mostrar quanto tem no X999.
				03 TOTAL =  passará a ser a soma da carteira faturável  + rejeitado + analise – X999.
				04 Programados para próximos 3 meses, manter a informação mês a mês e não deverá mais ser somado ao total.
				//
				//	_cret:= 'Em Manutenção, realizando alterações solicitadas pelo vanderlei.: '+CR
				_cret+= 'Captação:'+CR+CR
				_cret+= 'Cart. Faturável:' + replicate('_',16- len('Cart  Faturável'))
				_cret+= 'R$ '+ TransForm((_nToVal),"@E 99,999,999.99") +CR+CR

				_cret+= 'Unicon(999):' + replicate('_',16- len('Unicon   999'))
				_cret+= 'R$ '+ TransForm(((cAliasLif)->X999-(cAliasLif)->X9991-(cAliasLif)->X9992-(cAliasLif)->X9993-(cAliasLif)->X9994)	,"@E 9,999,999.99") +CR+CR


				//_cret+= 'Rejeitados:'+CR
				//_cret+= 'R$ '+ replicate(' ',len(cvaltochar((cAliasLif)->REJEITADOS))-18 )	+ TransForm(((cAliasLif)->REJEITADOS)	,"@E 99,999,999.99") +CR

				_cret+= 'Anali. Financ.:'+ replicate('_',16- len('Anal  Financ '))
				_cret+= 'R$ '+ TransForm(( (cAliasLif)->ANALISE  +(cAliasLif)->REJEITADOS)		,"@E 9,999,999.99") +CR+CR



				_cret+= 'Total:' + replicate('_',16- len('Total'))
				_cret+= 'R$ '+ TransForm((_nToVal+(cAliasLif)->ANALISE+(cAliasLif)->REJEITADOS+(cAliasLif)->X999-(cAliasLif)->X9991-(cAliasLif)->X9992-(cAliasLif)->X9993-(cAliasLif)->X9994),"@E 99,999,999.99") +CR+CR

				_cret+= 'Blq.Comercial:'+ replicate('_',16- len('Blq    Comercial '))
				_cret+= 'R$ '+ TransForm(( (cAliasLif)->BLQ_COMER)		,"@E 999,999.99") +CR+CR


				_cret+= 'Prox.1ºMes:'+ replicate('_',16- len('Prox 1  Mes'))
				_cret+= 'R$ '+ TransForm(((cAliasLif)->TOTAL1)		,"@E 9,999,999.99") +CR+CR

				_cret+= 'Prox.2ºMes:' + replicate('_',16- len('Prox 1  Mes'))
				_cret+= 'R$ '+ TransForm(((cAliasLif)->TOTAL2)		,"@E 9,999,999.99") +CR+CR

				_cret+= 'Prox.3ºMes:' + replicate('_',16- len('Prox 1  Mes'))
				_cret+= 'R$ '+ TransForm(((cAliasLif)->TOTAL3)		,"@E 9,999,999.99") +CR+CR
				**********************************************************************************************************************************************/


			EndIf

			conout("Fim consulta"+DTOC(date())+' - '+ TIME())

			::cRet	:= _cret
			Return(.t.)

			XtQuery()
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			If  Select(cAliasLif) > 0

				_cret+= 'Faltas:' + replicate('_',16- len('Faltas'))
				_cret+= 'R$ '+    TransForm(((cAliasLif)->FALTA-(cAliasLif)->F999)		,"@E 99,999,999.99") +CR+CR

				_cret+= 'Faltas(999):' + replicate('_',16- len('Faltas(999)'))
				_cret+= 'R$ '+    TransForm(((cAliasLif)->F999)		,"@E 9,999,999.99") +CR+CR


			EndIf


			RtQuery()
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			If  Select(cAliasLif) > 0

				_cret+= 'Fab.Prox.Mês:' + replicate('_',16 - len('Fab.Prox.Mês:'))
				_cret+= 'R$ '+    TransForm(((cAliasLif)->FALTA)		,"@E 99,999,999.99") +CR+CR

			EndIf

			ZtQuery()
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			If  Select(cAliasLif) > 0

				_cret+= 'Capt.Diaria:'+ replicate('_',16- len('Capt Diaria'))
				_cret+= 'R$ '+ TransForm(((cAliasLif)->DIA)		,"@E 9,999,999.99") +CR+CR
			EndIf

			/***********************************************************************************************
			If Upper(Alltrim(pedido)) $ Upper(Alltrim('klecios/giovani/daniel/iago/MARIA TATIANA'))

				axQuery()
				dbSelectArea(cAliasLif)
				(cAliasLif)->(dbgotop())
				If  Select(cAliasLif) > 0

					_nToTFat:= (cAliasLif)->TOTAL
					_nDiaFat:= (cAliasLif)->DIA
					If	Upper(Alltrim(pedido)) $ Upper(Alltrim('MARIA TATIANA'))
						_cret:= ' '
					EndIf


					_cret+= CR+CR+CR+'Captação - Argentina '+substr(dtos(date()),5,2)+'/'+substr(dtos(date()),1,4)+CR+' US$ '+ TransForm((_nToTFat )	,"@E 99,999,999.99") +CR+CR
					_cret+= 'Captação '+ DTOC(date())+CR+' US$ '+ TransForm((_nDiaFat )	,"@E 99,999,999.99")

				EndIf
			EndIf
			***********************************************************************************************/

			/***********************************************************************************************
			If Upper(Alltrim(pedido)) $ Upper(Alltrim('klecios/giovani/daniel/vinicius/iago'))

				axColQuery()
				dbSelectArea(cAliasLif)
				(cAliasLif)->(dbgotop())
				If  Select(cAliasLif) > 0

					_nToTFat:= (cAliasLif)->TOTAL
					_nDiaFat:= (cAliasLif)->DIA
					If	Upper(Alltrim(pedido)) $ Upper(Alltrim('vinicius'))
						_cret:= ' '
					EndIf


					_cret+= CR+CR+CR+'Captação - Colômbia '+substr(dtos(date()),5,2)+'/'+substr(dtos(date()),1,4)+CR+' COP$ '+ TransForm((_nToTFat )	,"@E 999,999,999.99") +CR+CR
					_cret+= 'Captação '+ DTOC(date())+CR+' COP$ '+ TransForm((_nDiaFat )	,"@E 999,999,999,999.99")

				EndIf
			EndIf
			***********************************************************************************************/

		ElseIf cOpcao = 'orcamento'

			::cRet	:= "Em manutenção"
			Return(.t.)

			If Upper(Alltrim(pedido)) $ Upper(Alltrim('klecios/giovani/tereza'))

				orcaQuery()
				dbSelectArea(cAliasLif)
				(cAliasLif)->(dbgotop())
				If  Select(cAliasLif) > 0

					_nToTFat:= (cAliasLif)->TOTAL
					_nDiaFat:= (cAliasLif)->DIA
					_nToTPv := (cAliasLif)->TOTAL_PV
					_nDiaPv := (cAliasLif)->DIA_PV
					_nToTQtd:= (cAliasLif)->TOTAL_QTD
					_nDiaQtd:= (cAliasLif)->DIA_QTD

					_cret+= CR+CR+CR+'Orçamento - Brasil '+substr(dtos(date()),5,2)+'/'+substr(dtos(date()),1,4)+CR+' R$ '+ TransForm((_nToTFat )	,"@E 99,999,999.99")
					_cret+= CR+'Orçamento: '+ DTOC(date())+CR+' R$ '+ TransForm((_nDiaFat )	,"@E 99,999,999.99")
					_cret+= CR+CR+'Virou Pv: '+substr(dtos(date()),5,2)+'/'+substr(dtos(date()),1,4)+CR+' R$ '+ TransForm((_nToTPv )	,"@E 99,999,999.99")
					_cret+= CR+'Virou Pv: '+ DTOC(date())+CR+' R$ '+ TransForm((_nDiaPv )	,"@E 99,999,999.99")
					_cret+= CR+CR+'Qtd.Orçamento: '+substr(dtos(date()),5,2)+'/'+substr(dtos(date()),1,4)+CR+' '+ TransForm((_nToTQtd )	,"@E 99,999,999")
					_cret+= CR+'Qtd.Orçamento: '+ DTOC(date())+CR+''+ TransForm((_nDiaQtd )	,"@E 99,999,999")





				EndIf
			EndIf

		ElseIf cOpcao = 'produto'

			_cret:="Em Teste.....!!!"

		ElseIf cOpcao = 'cliente'

			_cret:="Em Teste.....!!!"
		EndIf
		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
	Else
		_cret:= 'Solicite Liberação ao TI.'
		conout(_cret+' - '+cChatid)


	EndIf
	//Conout("TELEGRAM via webservice : ")


	::cRet	:= _cret

Return .T.

Static Function OrcaQuery()


	cQuery:= " SELECT
	cQuery+= " SUM(UA_ZVALLIQ) AS TOTAL,
	cQuery+= " NVL(sum(case when UA_EMISSAO = '"+ dtos(date()) +"'  then UA_ZVALLIQ else 0 end ),0) as DIA,
	cQuery+= " NVL(sum(case when UA_NUMSC5 <> ' '  then UA_ZVALLIQ else 0 end ),0) as TOTAL_PV,
	cQuery+= " NVL(sum(case when UA_EMISSAO = '"+ dtos(date()) +"' AND UA_NUMSC5 <> ' '   then UA_ZVALLIQ else 0 end ),0) as DIA_PV,
	cQuery+= " COUNT(*) AS TOTAL_QTD,
	cQuery+= " NVL(sum(case when UA_EMISSAO = '"+ dtos(date()) +"'  then 1 else 0 end ),0) as DIA_QTD
	cQuery+= " FROM SUA110 SUA
	cQuery+= " WHERE SUA.D_E_L_E_T_ = ' '  AND UA_FILIAL ='01'
	cQuery+= " AND SUBSTR(UA_EMISSAO,1,6)  = '"+substr(dtos(date()),1,6)+"'




	//conout("ar "+cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()




Static Function arQuery()

	cQuery:= " 	SELECT
	cQuery+= " SUM(SD2.D2_TOTAL) AS TOTAL,
	cQuery+= " NVL(sum(case when D2_EMISSAO = '"+ dtos(date()) +"'  then d2_total else 0 end ),0) as DIA
	cQuery+= " FROM SD2070 SD2
	cQuery+= " INNER JOIN(SELECT * FROM SF4070)SF4
	cQuery+= " ON SF4.D_E_L_E_T_ = ' '
	cQuery+= " AND F4_CODIGO = D2_TES
	cQuery+= " AND F4_DUPLIC = 'S'
	cQuery+= " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery+= " AND D2_SERIE <> 'R'
	cQuery+= " AND D2_ESPECIE = 'NF'
	cQuery+= " AND SUBSTR(D2_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'  and d2_filial ='01' "

	//conout("ar "+cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function COLQuery()

	cQuery:= " SELECT
	cQuery+= "  SUM(SD2.D2_TOTAL) AS TOTAL,
	cQuery+= "  NVL(sum(case when D2_EMISSAO = '"+ dtos(date()) +"'  then d2_total else 0 end ),0) as DIA
	cQuery+= "  FROM SD2080 SD2
	cQuery+= "  INNER JOIN(SELECT * FROM SF4080)SF4
	cQuery+= "  ON SF4.D_E_L_E_T_ = ' '
	cQuery+= "  AND F4_CODIGO = D2_TES
	cQuery+= "  AND F4_DUPLIC = 'S'
	cQuery+= "  WHERE SD2.D_E_L_E_T_ = ' '
	cQuery+= "  AND D2_ESPECIE = 'NF'
	cQuery+= "  AND SUBSTR(D2_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'  and d2_filial ='01'

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


Static Function axQuery()

	cQuery:= " SELECT
	cQuery+= "  SUM(C6_VALOR) as TOTAL,
	cQuery+= " NVL(sum(case when C5_EMISSAO = '"+ dtos(date()) +"'  then C6_VALOR else 0 end ),0) as DIA

	cQuery+= " FROM SC6070 SC6


	cQuery+= " INNER JOIN(SELECT * FROM SC5070) SC5
	cQuery+= " ON SC5.D_E_L_E_T_ = ' '
	cQuery+= " AND SUBSTR(C5_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'

	cQuery+= " AND C5_NUM = C6_NUM

	cQuery+= " INNER JOIN(SELECT * FROM SF4070)SF4
	cQuery+= " ON SF4.D_E_L_E_T_ = ' '
	cQuery+= " AND F4_CODIGO = C6_TES
	cQuery+= " AND F4_DUPLIC = 'S'

	cQuery+= " WHERE SC6.D_E_L_E_T_ = ' '

	//conout("aX "+cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()



Static Function axColQuery()

	cQuery:= " SELECT
	cQuery+= "  SUM(C6_VALOR) as TOTAL,
	cQuery+= " NVL(sum(case when C5_EMISSAO = '"+ dtos(date()) +"'  then C6_VALOR else 0 end ),0) as DIA

	cQuery+= " FROM SC6080 SC6


	cQuery+= " INNER JOIN(SELECT * FROM SC5080) SC5
	cQuery+= " ON SC5.D_E_L_E_T_ = ' '
	cQuery+= " AND SUBSTR(C5_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'

	cQuery+= " AND C5_NUM = C6_NUM

	cQuery+= " INNER JOIN(SELECT * FROM SF4080)SF4
	cQuery+= " ON SF4.D_E_L_E_T_ = ' '
	cQuery+= " AND F4_CODIGO = C6_TES
	cQuery+= " AND F4_DUPLIC = 'S'

	cQuery+= " WHERE SC6.D_E_L_E_T_ = ' '

	//conout("aX "+cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()



Static Function ctQuery()

	cQuery:= " SELECT NVL(SUM( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM),0) AS TOTAL,
	cQuery+= " NVL(sum(case when D2_EMISSAO = '"+ dtos(date()) +"'  then( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) else 0 end ),0) as DIA
	cQuery+= " FROM SD2110 SD2
	cQuery+= " INNER JOIN(SELECT * FROM SA1110)SA1
	cQuery+= " ON SA1.D_E_L_E_T_ = ' ' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA1.A1_GRPVEN <> 'ST'
	cQuery+= " AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'
	cQuery+= " INNER JOIN(SELECT * FROM SB1110)SB1
	cQuery+= " ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = D2_COD
	cQuery+= " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery+= " AND SD2.D2_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5405','5403','5501','5551','5922','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6404','6501','6502','6551','6922','7101','7102')
	cQuery+= " AND SUBSTR(D2_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'
	//cQuery+= " AND SUBSTR(D2_EMISSAO,1,6) = '202201'

	//conout("fat "+cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function ctQuery1()

	cQuery:= " SELECT NVL(SUM( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM),0) AS TOTAL,
	cQuery+= " NVL(sum(case when D2_EMISSAO = '"+ dtos(date()) +"'  then( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) else 0 end ),0) as DIA
	cQuery+= " FROM UDBP12.SD2030 SD2
	cQuery+= " INNER JOIN(SELECT * FROM UDBP12.SA1030)SA1
	cQuery+= " ON SA1.D_E_L_E_T_ = ' ' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA1.A1_GRPVEN <> 'ST'
	cQuery+= " AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST    <> 'EX'
	cQuery+= " INNER JOIN(SELECT * FROM UDBP12.SF2030)SF2
	cQuery+= " ON SF2.D_E_L_E_T_ = ' ' AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_FILIAL = D2_FILIAL
	cQuery+= " INNER JOIN(SELECT * FROM SB1110)SB1
	cQuery+= " ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = D2_COD
	cQuery+= " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery+= " AND SD2.D2_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5405','5403','5501','5551','5922','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6404','6501','6502','6551','6922','7101','7102')
	cQuery+= " AND SUBSTR(D2_EMISSAO,1,6) = '"+substr(dtos(date()),1,6)+"'
	//cQuery+= " AND SUBSTR(D2_EMISSAO,1,6) = '202201'
	cQuery+= " and d2_filial ='01'

	//conout("fat "+cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function DVQuery()

	cQuery:= " SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) as	TOTAL ,
	cQuery+= " NVL(sum(case when D1_EMISSAO = '"+ dtos(date()) +"'  then (D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) else 0 end ),0) DIA
	cQuery+= " FROM  SD1110  SD1
	cQuery+= " INNER JOIN(SELECT * FROM SA1110)SA1
	cQuery+= " ON SA1.D_E_L_E_T_ = ' '
	cQuery+= " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery+= " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery+= " AND SA1.A1_FILIAL = '  '
	cQuery+= " AND SA1.A1_GRPVEN <> 'ST'
	cQuery+= " AND SA1.A1_GRPVEN <> 'SC'
	cQuery+= " AND SA1.A1_EST    <> 'EX'
	cQuery+= " INNER JOIN(SELECT * FROM SB1110)SB1
	cQuery+= " ON SB1.D_E_L_E_T_ = ' '
	cQuery+= " AND SB1.B1_COD = D1_COD
	cQuery+= " WHERE SD1.D_E_L_E_T_ = ' '
	cQuery+= " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211')
	cQuery+= " AND SD1.D1_TIPO = 'D'
	cQuery+= " AND SUBSTR(SD1.D1_DTDIGIT,1,6) = '"+substr(dtos(date()),1,6)+"'
	//cQuery+= " AND SUBSTR(SD1.D1_DTDIGIT,1,6) = '202201'


	//conout("DEV "+cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function DVQuery1()

	cQuery:= " SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) as	TOTAL ,
	cQuery+= " NVL(sum(case when D1_EMISSAO = '"+ dtos(date()) +"'  then (D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM) else 0 end ),0) DIA
	cQuery+= " FROM  UDBP12.SD1030  SD1
	cQuery+= " INNER JOIN(SELECT * FROM UDBP12.SA1030)SA1
	cQuery+= " ON SA1.D_E_L_E_T_ = ' '
	cQuery+= " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery+= " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery+= " AND SA1.A1_FILIAL = '  '
	cQuery+= " AND SA1.A1_GRPVEN <> 'ST'
	cQuery+= " AND SA1.A1_GRPVEN <> 'SC'
	cQuery+= " AND SA1.A1_EST    <> 'EX'
	cQuery+= " INNER JOIN(SELECT * FROM SB1110)SB1
	cQuery+= " ON SB1.D_E_L_E_T_ = ' '
	cQuery+= " AND SB1.B1_COD = D1_COD
	cQuery+= " WHERE SD1.D_E_L_E_T_ = ' '
	cQuery+= " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211')
	cQuery+= " AND SD1.D1_TIPO = 'D'
	cQuery+= " AND SUBSTR(SD1.D1_DTDIGIT,1,6) = '"+substr(dtos(date()),1,6)+"'
	//cQuery+= " AND SUBSTR(SD1.D1_DTDIGIT,1,6) = '202201'
	//conout("DEV "+cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function StQuery()

	Local cQuery     := ' '
	cQuery := " SELECT

	cQuery += "    SUM(round( (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)    ,2)         )
	cQuery += ' "TOTAL",

	cQuery += "    SUM(round(CASE WHEN  (SC5.C5_XATE = '30'   AND  C5_XMATE = ' ' OR    SC5.C5_XATE = '31'   AND C5_XMATE = ' ') OR  (SC5.C5_XATE = '30'   AND C5_XMATE = '11' OR    SC5.C5_XATE = '31'   AND C5_XMATE = '11')
	cQuery += "  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "MES",

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE  <> '"+_cDat+"'   And SC5.C5_XMATE  <> ' ' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	//cQuery += ' "TOTAL4",

	cQuery += ' NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(TC9.QUANT),2)),0) "REJEITADOS",
	//	cQuery += "   SUM(round(CASE WHEN  SB1.B1_GRUPO <> '999' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(TC9.QUANT)  else 0 end ,2)         )
	//	cQuery += '"REJEITADOS",
	cQuery += ' NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(BC9.QUANT),2)),0) "ANALISE",
	//cQuery += " 	 NVL(SUM(      round(   (    SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*CASE WHEN   SC5.C5_ZBLOQ   <> '1' THEN (BC9.QUANT) ELSE 0 END    ,2)   ),0)
	//cQuery += ' "ANALISE",


	cQuery += " NVL(SUM(      round(    CASE WHEN   SC5.C5_ZBLOQ   = '1' THEN (    SC6.C6_ZVALLIQ/SC6.C6_QTDVEN) ELSE 0 END    ,2)   ),0)
	cQuery += ' "BLQ_COMER",
	/*
	cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"'   THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL1",

	cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"'   THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL2",

	cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"'   THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL3"

	//cQuery += "  ,SUM(round(CASE WHEN  SC5.C5_XMATE||SC5.C5_XAANO in ('"+_cDat4+ substr(dtos(date()),1,4)+"','"+_cDat5+substr(dtos(date()),1,4)+" ','"+_cDat6+substr(dtos(date()),1,4)+" ','"+_cDat7+substr(dtos(date()),1,4)+" ' )
	cQuery += "  ,SUM(round(CASE WHEN  SC5.C5_XAANO >=  '2020'"// substr(dtos(MonthSum(date(),4)),1,4)+"'

	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL5"
	*/

							//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"'
							If _cDat = '12'
								cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat1+"'
							Else
								cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"'
							EndIf
							cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += ' "TOTAL1",

							//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"'
							If _cDat = '11'
								cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE))=   '" + substr(dtos(date() +360),1,4)+_cDat2+"'
							ElseIf _cDat = '12'
								cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat2+"'
							Else
								cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"'
							EndIf
							cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += ' "TOTAL2",

							//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"'
							If _cDat = '10'
								cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
							ElseIf _cDat = '11'
								cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
							ElseIf _cDat = '12'
								cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
							Else
								cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"'
							EndIf
							cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += ' "TOTAL3",


							If _cDat = '09'
								cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"01'
							ElseIf _cDat = '10'
								cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"02'
							ElseIf _cDat = '11'
								cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"03'
							ElseIf _cDat = '12'
								cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"04'
							Else
								cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '" + substr(dtos(date()),1,4)+_cDat4+"'
							EndIf
							cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += ' "TOTAL5"



							cQuery += "  , SUM(round(CASE WHEN  SB1.B1_GRUPO = '999' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += ' "X999"


							cQuery += " , SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"' AND SB1.B1_GRUPO = '999'  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += ' "X9991",

							cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' AND SB1.B1_GRUPO = '999'  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += ' "X9992",

							cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' AND SB1.B1_GRUPO = '999'  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += ' "X9993",

							//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE > '"+_cDat3+"' and SC5.C5_XMATE <= '12'  AND SB1.B1_GRUPO = '999'  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
							cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE > '"+_cDat3+"' and SC5.C5_XMATE <= '12'  AND SB1.B1_GRUPO = '999'  THEN  0 else 0 end ,2)         )
							cQuery += ' "X9994"



							cQuery += " FROM SC5110 SC5
							cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
							cQuery += " ON SC6.D_E_L_E_T_   = ' '
							cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
							cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
							cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
							//cQuery += " AND SC6.C6_BLQ <> 'R'
							cQuery += ' LEFT JOIN(SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM, SUM(SC9.C9_QTDLIB) "QUANT",SC9.C9_BLCRED
							cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
							cQuery += " WHERE   SC9.D_E_L_E_T_ = ' '
							cQuery += " GROUP BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED)TC9
							cQuery += " ON  TC9.C9_PEDIDO = SC6.C6_NUM
							cQuery += " AND  TC9.C9_ITEM   = SC6.C6_ITEM
							cQuery += " AND TC9.C9_FILIAL = SC6.C6_FILIAL
							cQuery += " AND TC9.C9_BLCRED = '09'

							cQuery += ' LEFT JOIN(SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM, SUM(SC9.C9_QTDLIB) "QUANT",SC9.C9_BLCRED
							cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
							cQuery += " WHERE   SC9.D_E_L_E_T_ = ' '
							cQuery += " GROUP BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED)BC9
							cQuery += " ON  BC9.C9_PEDIDO = SC6.C6_NUM
							cQuery += " AND  BC9.C9_ITEM   = SC6.C6_ITEM
							cQuery += " AND BC9.C9_FILIAL = SC6.C6_FILIAL
							cQuery += " AND (BC9.C9_BLCRED = '04' or BC9.C9_BLCRED = '01')
							cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
							cQuery += " ON SB1.D_E_L_E_T_   = ' '
							cQuery += " AND SB1.B1_COD    = SC6.C6_PRODUTO
							cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
							cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" )SBM "
							cQuery += " ON SBM.D_E_L_E_T_   = ' '
							cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
							cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
							cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
							cQuery += " ON SA1.D_E_L_E_T_   = ' '
							cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
							cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
							cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
							cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
							cQuery += " ON SA3.D_E_L_E_T_   = ' '
							cQuery += " AND SA3.A3_COD = SC5.C5_VEND2
							cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
							cQuery += " LEFT JOIN (SELECT *FROM "+RetSqlName("PC1")+" )PC1 "
							cQuery += " ON C6_NUM = PC1.PC1_PEDREP
							cQuery += " AND PC1.D_E_L_E_T_ = ' '
							cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
							cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
							cQuery += " AND SF4.D_E_L_E_T_ = ' '
							cQuery += " AND SC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+")

							cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '
							cQuery += " AND SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
							cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
							cQuery += " AND SC5.C5_TIPO = 'N'
							cQuery += " AND SA1.A1_GRPVEN <> 'ST'
							cQuery += " AND SA1.A1_GRPVEN <> 'SC'
							cQuery += " AND SA1.A1_EST    <> 'EX'
							cQuery += " AND SBM.BM_XAGRUP <> ' '
							cQuery += " AND PC1.PC1_PEDREP IS NULL



							//conout("cap "+cQuery)


							If Select(cAliasLif) > 0
								(cAliasLif)->(dbCloseArea())
							EndIf

							dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)


							Return()

Static Function RtQuery()

	Local cQuery     := ' '

	cQuery := "  SELECT NVL(SUM(round((PC6.C6_ZVALLIQ/PC6.C6_QTDVEN)*TA1.PA1_QUANT,2)),0) as FALTA
	cQuery += " FROM "+RetSqlName("SC6")+" PC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PA1")+" )TA1 "
	cQuery += " ON TA1.D_E_L_E_T_ = ' '
	cQuery += " AND TA1.PA1_DOC = PC6.C6_NUM||PC6.C6_ITEM
	cQuery += " AND TA1.PA1_FILIAL= '01'
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SC9")+")SC9
	cQuery += "  ON SC9.D_E_L_E_T_ = ' '
	cQuery += "  AND C9_FILIAL = C6_FILIAL
	cQuery += "  AND C9_PEDIDO = C6_NUM
	cQuery += " AND C9_BLCRED = ' '
	cQuery += " AND C9_ITEM = C6_ITEM
	cQuery += " INNER JOIN SC5110 SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM   AND SC5.D_E_L_E_T_ = ' ' AND C5_XMATE = ' ' "
	cQuery += " LEFT JOIN SA1110 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SF4110 SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SB1110 SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SBM110 SBM ON BM_FILIAL = '"+xFilial("SBM")+"' AND B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ' ' "

	cQuery += " LEFT JOIN PC1110 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' "

	cQuery += " WHERE PC6.D_E_L_E_T_   = ' '
	cQuery += " AND PC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+")
	cQuery += " AND PC6.C6_ZENTRE2 >= '"+ Substr(dtos(date()+29),1,6)+'01' +"'"
	cQuery += " AND PC6.C6_FILIAL ='01'
	cQuery += " AND PC6.C6_BLQ <> 'R'
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " AND PC1.PC1_PEDREP IS NULL

	//conout("fal "+cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)


Return()
Static Function XtQuery()

	Local cQuery     := ' '

	cQuery := "  SELECT NVL(SUM(round((PC6.C6_ZVALLIQ/PC6.C6_QTDVEN)*TA1.PA1_QUANT,2)),0) as FALTA ,
	cQuery += " SUM(round(CASE WHEN  SB1.B1_GRUPO = '999' THEN  (PC6.C6_ZVALLIQ/PC6.C6_QTDVEN)*TA1.PA1_QUANT  else 0 end ,2)         )
	cQuery += ' "F999"

	cQuery += " FROM "+RetSqlName("SC6")+" PC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PA1")+" )TA1 "
	cQuery += " ON TA1.D_E_L_E_T_ = ' '
	cQuery += " AND TA1.PA1_DOC = PC6.C6_NUM||PC6.C6_ITEM
	cQuery += " AND TA1.PA1_FILIAL= '01'
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SC9")+")SC9
	cQuery += "  ON SC9.D_E_L_E_T_ = ' '
	cQuery += "  AND C9_FILIAL = C6_FILIAL
	cQuery += "  AND C9_PEDIDO = C6_NUM
	cQuery += " AND C9_BLCRED = ' '
	cQuery += " AND C9_ITEM = C6_ITEM
	cQuery += " INNER JOIN SC5110 SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM   AND SC5.D_E_L_E_T_ = ' ' AND C5_XMATE = ' ' "
	cQuery += " LEFT JOIN SA1110 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SF4110 SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SB1110 SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SBM110 SBM ON BM_FILIAL = '"+xFilial("SBM")+"' AND B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ' ' "

	cQuery += " LEFT JOIN PC1110 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' "

	cQuery += " WHERE PC6.D_E_L_E_T_   = ' '
	cQuery += " AND PC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+")

	cQuery += " AND PC6.C6_FILIAL ='01'
	cQuery += " AND PC6.C6_BLQ <> 'R'
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " AND PC1.PC1_PEDREP IS NULL

	//conout("fal "+cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)


Return()

Static Function ztQuery()

	Local cQuery     := ' '

	cQuery := "  SELECT NVL(
	cQuery += " SUM(CASE WHEN C6_BLQ = 'R' AND C6_ZVALLIQ > 0 THEN C6_ZVALLIQ/C6_QTDVEN*C6_QTDENT WHEN C6_ZVALLIQ > 0 THEN C6_ZVALLIQ WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END),0)
	cQuery += " as DIA
	cQuery += " FROM "+RetSqlName("SC6")+" PC6 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_NUM = PC6.C6_NUM AND SC5.C5_EMISSAO  = '"+ dtos(date()) +"'"
	cQuery += " AND SC5.C5_FILIAL= '01'

	cQuery += " LEFT JOIN SA1110 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SF4110 SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SB1110 SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN SBM110 SBM ON BM_FILIAL = '"+xFilial("SBM")+"' AND B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ' ' "

	cQuery += " LEFT JOIN PC1110 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' "


	cQuery += " WHERE PC6.D_E_L_E_T_   = ' '
	//cQuery += " AND PC6.C6_QTDVEN - PC6.C6_QTDENT > 0
	cQuery += " AND PC6.C6_FILIAL ='01'
	cQuery += "   AND
	cQuery += " C5_TIPO = 'N' AND "
	cQuery += " A1_GRPVEN NOT IN ('ST','SC') AND "
	cQuery += " A1_EST <> 'EX' AND "
	cQuery += " F4_DUPLIC = 'S' AND "
	cQuery += " BM_XAGRUP <> ' ' AND "

	cQuery += " PC1_PEDREP IS NULL

	//conout("dia "+cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)


Return()
