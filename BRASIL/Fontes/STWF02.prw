#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
#DEFINE Cr chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STWF02	ºAutor  ³Giovani Zago     º Data ³  16/05/19      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³WF 														  º±±
±±º          ³   													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function XSTWF27()
	U_STWF27("000006")
Return()

User Function STWF27(_cCod)
	Private _aPH5:= {}
	Default _cCod := ' '

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")        // Valdemir Rabelo 19/01/2022 - Chamado: 20220119001499

	dbSelectArea("PH4")
	PH4->(dbgotop())
	PH4->(dbsetorder(1))
	While 	PH4->(!Eof())
		_aPH5:= {}
		_lSP:= .T.
		If PH4->PH4_WF = 'S'
			If ( !(Empty(Alltrim(_cCod))) .And. PH4->PH4_NUM = _cCod) .Or. Empty(Alltrim(_cCod))

				dbSelectArea("PH6")
				PH6->(dbgotop())
				PH6->(dbsetorder(1))
				If PH6->(DbSeek(xFilial("PH6")+PH4->PH4_NUM+ Substr(DTOS(DATE()),1,4)))

					dbSelectArea("PH5")
					PH5->(dbgotop())
					PH5->(dbsetorder(1))
					If PH5->(DbSeek(xFilial("PH5")+PH4->PH4_NUM))
						While 	PH5->(!Eof()) .And. PH4->PH4_NUM = PH5->PH5_NUM

							Aadd(_aPH5,{ PH5->PH5_CLIENT,PH5->PH5_NUM  })

							DbSelectArea("SA1")
							SA1->(dbSetOrder(1))
							If 	SA1->(DbSeek(xFilial("SA1")+ PH5->PH5_CLIENT  ))
								While SA1->(!Eof()) .And. SA1->(A1_FILIAL+A1_COD) = xFilial("SA1")+PH5->PH5_CLIENT
									If SA1->A1_EST <> 'SP'
										_lSP:= .F.
									EndIf
									SA1->(DbSkip())
								End

							EndIf

							PH5->(dbskip())
						End

					EndIf
				EndIf
				If Len(_aPH5) > 0
					SSTWF27(_aPH5 ,PH6->PH6_META,PH4->PH4_DESC,PH4->PH4_MAILWF,_lSP)
				EndIf
			EndIf
		EndIf
		PH4->(dbskip())

	End

Return()

Static Function SSTWF27(_aPH5, _nMeta,_cCliNom,_cPh4Mail )

	Local cAliasSuper	:= 'STWF27'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''
	Local aTotal            :={0,0,0,0,0,0,0,0,0,0,0}
	Local i				:= 0
	Private cPerg 			:= "RFAT12"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private c1AliasLif   	:= "x"+cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private _cNome          := " "
	Public  _cXCodVen361    := ' '
	Public n
	Public aCols		:={}
	Default _aPH5:= {}

	strelquer('010')
	xVALUSST('010')

	If Alltrim(_aPH5[1,1]) $ '029188/010298/012661'
		strelquer('030')
		xVALUSST('030')

	EndIf

	aSort(Acols,,,{|x,y| x[1]<y[1]})

	aadd(_aMsg,{"GRUPO",'Quantidade('+tira1(Substr(DTOS(DATE()),1,4))+')','Valor NET('+tira1(Substr(DTOS(DATE()),1,4))+')','Quantidade('+ Substr(DTOS(DATE()),1,4) +')	 ','Valor NET('+  Substr(DTOS(DATE()),1,4) +')',"Variação Anual","Valor Mercadoria","St","Ipi", "ST/IPI", "Icms/Difal"})

	For i:=1 To Len(Acols)

		_n05:= aCols[i][05]- sDEVRST(substr(aCols[i][01],1,3),Substr(dtos(date()),1,4))
		aadd(_aMsg,{aCols[i][01],;
			aCols[i][02] ,;
			aCols[i][03] ,;
			aCols[i][04] ,;
			_n05 ,;
			aCols[i][06] ,;
			aCols[i][07] ,;
			aCols[i][08] ,;
			aCols[i][09] ,;
			aCols[i][10] ,;
			aCols[i][11] ;
			}  )

		aTotal[01]	:=	aCols[i][2] +	aTotal[01]
		aTotal[02]	:=	aCols[i][3] +	aTotal[02]
		aTotal[03]	:=	aCols[i][4] +	aTotal[03]
		aTotal[04]	:=	_n05	 	+	aTotal[04]
		aTotal[05]	:= 	aCols[i][6] +	aTotal[05]

		aTotal[07]	:= 	aCols[i][7] +	aTotal[07]
		aTotal[08]	:= 	aCols[i][8] +	aTotal[08]
		aTotal[09]	:= 	aCols[i][9] +	aTotal[09]
		aTotal[10]	:= 	aCols[i][10] +	aTotal[10]
		aTotal[11]	:= 	aCols[i][11] +	aTotal[11]

	next i

	aadd(_aMsg,{'TOTAIS',;
		aTotal[01] ,;
		aTotal[02] ,;
		aTotal[03] ,;
		aTotal[04] ,;
		((aTotal[04]*100)/	aTotal[02] ) - 100 ,;
		aTotal[07] ,;
		aTotal[08] ,;
		aTotal[09] ,;
		aTotal[10] ,;
		aTotal[11] ;
		}  )

	If Len(_aMsg) > 1
		_nCap:= STCAP()
		aadd(_aMsg,{'META - '+Substr(DTOS(DATE()),1,4),;
			0 ,;
			0 ,;
			0 ,;
			_nMeta ,;
			0 ,;
			Iif(_lSP, Round(_nMeta/0.7275,2),0) ,;
			0 ,;
			0 ,;
			0 ,;
			0 ,;
			}  )
		aadd(_aMsg,{'FALTA PARA A META',;
			0 ,;
			0 ,;
			0 ,;
			_nMeta-aTotal[04] ,;
			0 ,;
			Iif(_lSP, Round((_nMeta-aTotal[04])/0.7275,2),0) ,;
			0 ,;
			0 ,;
			0 ,;
			0 ,;
			}  )
		aadd(_aMsg,{'CARTEIRA A FATURAR',;
			0 ,;
			0 ,;
			0 ,;
			_nCap ,;
			0 ,;
			Iif(_lSP, Round(_nCap/0.7275,2) ,0),;
			0 ,;
			0 ,;
			0 ,;
			0 ,;
			}  )

		STWFR27(_aMsg,_cPh4Mail,''  ,'',_cCliNom)
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR27(_aMsg,_cEmail,_cCopia,_CodNF,_cCliNom)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Steck - NSM - '+ Alltrim(Upper(_cCliNom))
	Local cFuncSent		:= "STWFR27"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +  Iif(_nLin>=Len(_aMsg)-2,' ',  Transform(_aMsg[_nLin,2],"@E 999,999,999")) + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +  Iif(_nLin>=Len(_aMsg)-2,' ',  Transform(_aMsg[_nLin,3],"@E 999,999,999.99")) + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +  Iif(_nLin>=Len(_aMsg)-2,' ',  Transform(_aMsg[_nLin,4],"@E 999,999,999")) + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +   Transform(_aMsg[_nLin,5],"@E 999,999,999.99") + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +  Iif(_nLin>=Len(_aMsg)-2,' ',  Transform(_aMsg[_nLin,6],"@E 999,999,999.99")+'%') + '  </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +   Transform(_aMsg[_nLin,7],"@E 999,999,999.99") + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +  Iif(_nLin>=Len(_aMsg)-2,' ',  Transform(_aMsg[_nLin,8],"@E 999,999,999.99")) + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +  Iif(_nLin>=Len(_aMsg)-2,' ',  Transform(_aMsg[_nLin,9],"@E 999,999,999.99")) + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +  Iif(_nLin>=Len(_aMsg)-2,' ',  Transform(_aMsg[_nLin,10],"@E 999,999,999.99")) + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' +  Iif(_nLin>=Len(_aMsg)-2,' ',  Transform(_aMsg[_nLin,11],"@E 999,999,999.99")) + ' </Font></TD>'
			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,';marcelo.oliveira@steck.com.br ')

	EndIf
	RestArea(aArea)
Return()

Static Function strelquer(_cEmp)

	Local cQuery     := ' '
	Local o    	     := 0
	Default _cEmp	:= '010'

	cQuery := " SELECT
	cQuery += ' SUBSTR(SD2.D2_EMISSAO,1,6) "MES",
	cQuery += ' SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM) "VALOR",
	cQuery += ' SUM(SD2.D2_TOTAL) "BRUTO",
	cQuery += ' SUM(SD2.D2_ICMSRET) "ST",
	cQuery += ' SUM(SD2.D2_VALIPI) "IPI",
	cQuery += ' SUM(SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET) "STIPI",
	cQuery += ' SUM(D2_DIFAL+D2_ICMSCOM) "DIFAL",
	cQuery += ' SB1.B1_GRUPO  "GRUPO",
	cQuery += ' SBM.BM_DESC   "DESCG" ,
	cQuery += ' SUM(SD2.D2_QUANT)  "QTD"

	cQuery += " FROM SD2"+_cEmp+" SD2 "

	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "
	cQuery += " ON SB1.D_E_L_E_T_   = ' '
	cQuery += " AND SB1.B1_COD    = SD2.D2_COD
	cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"

	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" ) SBM "
	cQuery += " ON SBM.D_E_L_E_T_   = ' '
	cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
	cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"

	cQuery += " INNER JOIN(SELECT * FROM SA1"+_cEmp+" ) SA1 "
	cQuery += " ON SA1.D_E_L_E_T_   = ' '
	cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"

	cQuery += " INNER JOIN (SELECT * FROM SF4"+_cEmp+" ) SF4 "
	cQuery += " ON SD2.D2_TES = SF4.F4_CODIGO
	cQuery += " AND SF4.D_E_L_E_T_ = ' '

	cQuery += " WHERE  SD2.D_E_L_E_T_   = ' '
	cQuery += " AND ( SUBSTR(SD2.D2_EMISSAO,1,6) between  '"+tira1(Substr(dtos(date()),1,4))+'01'+"'  and '"+tira1(Substr(dtos(date()),1,4))+'12'+"' or SUBSTR(SD2.D2_EMISSAO,1,6) between  '"+Substr(dtos(date()),1,4)+'01'+"'  and '"+Substr(dtos(date()),1,4)+'12'+"')

	If Len(_aPH5) = 1
		cQuery += " AND SD2.D2_CLIENTE = '"+_aPH5[1,1] +"'
	Else
		cQuery += " AND ( "
		For o:=1 To Len(_aPH5)
			If o=1
				cQuery += "  SD2.D2_CLIENTE = '"+_aPH5[o,1] +"'
			Else
				cQuery += " OR SD2.D2_CLIENTE = '"+_aPH5[o,1] +"'
			EndIf
		Next o
		cQuery += " )"
	EndIf

	cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_EST    <> 'EX'

	cQuery += " GROUP BY SUBSTR(D2_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC
	cQuery += " ORDER BY SUBSTR(D2_EMISSAO,1,6),SB1.B1_GRUPO,SBM.BM_DESC

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return ()

	*-----------------------------*
Static Function   xVALUSST(_cEmp)
	*-----------------------------*
	Local _lRet   		:= .F.
	Local _nOld   		:= 1
	Local _nPosOper     := 0
	Local _nPosProd     := 0
	Local _nPosTES      := 0
	Local _nPosClas     := 0
	Local _nPosPrc    	:= 0
	Local _nPosDESC     := 0
	Local _nPosDEXC     := 0
	Local _nICMPAD	    :=_nICMPAD2 :=0
	Local _nDescPad		:=0
	Local _nPis 		:=0
	Local _nCofis		:=0
	Local _nIcms    	:= SA1->A1_CONTRIB
	Local _cEst			:= SA1->A1_EST
	Local _nOpcao 		:= 3
	Local _xAlias 		:= GetArea()
	Local aFields 		:= {}
	Local aCpoEnch		:= {}
	Local aTam  		:= {}
	Local aNoEnch		:= {"C5_NUM","C5_CLIENTE"}
	Local oDlg
	Local _cCodAut  	:= GetMv("ST_CODFIS",,'000000')
	Local _nAsc         := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipos das Opcoes						  ³
	//³ _nOpcao == 1 -> Incluir					  ³
	//³ _nOpcao == 2 -> Visualizar                ³
	//³ _nOpcao == 3 -> Alterar                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local bCampoSC5		:= { |nCPO| Field(nCPO) }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arrays de controle dos campos que deverao ser alterados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aCposAlt 		:= {}
	Local _NgIO := 0
	//Local _nValAcre     := Posicione("SE4",1,xFilial("SE4")+'01',"E4_XACRESC")

	Public aHeader 		:= {}

	nUsado:=0

	//				  1-Campo    , 2-Tipo, 3-Tam	, 4-Dec	, 5-Titulo		, 6-Validacao  											, 7-ComboBox
	aTam := TamSX3("C6_PRODUTO")
	aadd(aFields, {'C6_PRODUTO', 'C', aTam[1], 0, 'Grupo'                                              , " ", ''})
	aTam := TamSX3( 'C6_QTDVEN' )
	aadd(aFields, {'C6_QTDVEN' , 'N', aTam[1], 0, 'Quantidade(' +tira1(Substr(dtos(date()),1,4))+ ')	 ', " ", ''})
	aTam := TamSX3( 'C6_PRCVEN' )
	aadd(aFields, {'C6_PRCVEN' , 'N', aTam[1], 0, 'Valor(' +tira1(Substr(dtos(date()),1,4))+ ')	 '     , " ", ''})
	aTam := TamSX3( 'C6_QTDVEN' )
	aadd(aFields, {'C6_QTDVEN' , 'N', aTam[1], 0, 'Quantidade(' +Substr(dtos(date()),1,4)+ ')	 '       , " ", ''})
	aTam := TamSX3( 'C6_PRCVEN' )
	aadd(aFields, {'C6_PRCVEN' , 'N', aTam[1], 0, 'Valor(' +Substr(dtos(date()),1,4)+ ')	 '            , " ", ''})
	aTam := TamSX3( 'C6_QTDVEN' )
	aadd(aFields, {'C6_QTDVEN' , 'N', aTam[1], 0, 'Diferença'                                          , " ", ''})

	aTam := TamSX3( 'C6_PRCVEN' )
	aadd(aFields, {'C6_PRCVEN' , 'N', aTam[1], 0, '07'                                                 , " ", ''})
	aTam := TamSX3( 'C6_PRCVEN' )
	aadd(aFields, {'C6_PRCVEN' , 'N', aTam[1], 0, '08'                                                 , " ", ''})
	aTam := TamSX3( 'C6_PRCVEN' )
	aadd(aFields, {'C6_PRCVEN' , 'N', aTam[1], 0, '09'                                                 , " ", ''})
	aTam := TamSX3( 'C6_PRCVEN' )
	aadd(aFields, {'C6_PRCVEN' , 'N', aTam[1], 0, '10'                                                 , " ", ''})
	aTam := TamSX3( 'C6_PRCVEN' )
	aadd(aFields, {'C6_PRCVEN' , 'N', aTam[1], 0, '11'                                                 , " ", ''})

	aHeader := {}	// Monta Cabecalho do aHeader. A ordem dos elementos devem obedecer a sequencia da estrutura dos campos logo acima. aFields[0,6]
	// 	01-Titulo			   			        , 02-Campo		, 03-Picture, 04-Tamanho	, 05-Decimal, 06-Valid		, 07-Usado	, 08-Tipo		, 09-F3		, 10-Contexto	, 11-ComboBox	, 12-Relacao	, 13-When		  , 14-Visual	, 15-Valid Usuario
	aAdd( aHeader, {	aFields[01,5]+Space(20)	, aFields[01,1]	, '@!'		, aFields[01,3]	, 0			, aFields[01,6]	, ''		, aFields[01,2]	, ''		, 'R'			, aFields[01,7]	, ''			, ''   			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[02,5]+Space(20)	, aFields[02,1]	, '@E 999,999,999.99'		, aFields[02,3]	, 0			, aFields[02,6]	, ''		, aFields[02,2]	, ''		, 'R'			, aFields[02,7]	, ''			, ''  			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[03,5]+Space(20)	, aFields[03,1]	, '@E 999,999,999.99'		, aFields[03,3]	, 0			, aFields[03,6]	, ''		, aFields[03,2]	, ''		, 'R'			, aFields[03,7]	, ''			, '' 			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[04,5]+Space(20)	, aFields[04,1]	, '@E 999,999,999.99'		, aFields[04,3]	, 0			, aFields[04,6]	, ''		, aFields[04,2]	, ''		, 'R'			, aFields[04,7]	, ''			, '', ''		, ''				} )
	aAdd( aHeader, {	aFields[05,5]+Space(20)	, aFields[05,1]	, '@E 999,999,999.99'		, aFields[05,3]	, 0			, aFields[05,6]	, ''		, aFields[05,2]	, ''		, 'R'			, aFields[05,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[06,5]+Space(20)	, aFields[06,1]	, '@E 999,999,999.99'		, aFields[06,3]	, 0			, aFields[06,6]	, ''		, aFields[06,2]	, ''		, 'R'			, aFields[06,7]	, ''			, ''			  , ''		, ''				} )

	aAdd( aHeader, {	aFields[07,5]+Space(20)	, aFields[07,1]	, '@E 999,999,999.99'		, aFields[07,3]	, 0			, aFields[07,6]	, ''		, aFields[07,2]	, ''		, 'R'			, aFields[07,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[08,5]+Space(20)	, aFields[08,1]	, '@E 999,999,999.99'		, aFields[08,3]	, 0			, aFields[08,6]	, ''		, aFields[08,2]	, ''		, 'R'			, aFields[08,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[09,5]+Space(20)	, aFields[09,1]	, '@E 999,999,999.99'		, aFields[09,3]	, 0			, aFields[09,6]	, ''		, aFields[09,2]	, ''		, 'R'			, aFields[09,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[10,5]+Space(20)	, aFields[10,1]	, '@E 999,999,999.99'		, aFields[10,3]	, 0			, aFields[10,6]	, ''		, aFields[10,2]	, ''		, 'R'			, aFields[10,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[11,5]+Space(20)	, aFields[11,1]	, '@E 999,999,999.99'		, aFields[11,3]	, 0			, aFields[11,6]	, ''		, aFields[11,2]	, ''		, 'R'			, aFields[11,7]	, ''			, ''			  , ''		, ''				} )

	nUsado:=len(aHeader)

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			If len(aCols) > 0
				_nAsc:=aScan(aCols, {|x| SUBSTR(x[1],1,4) == (cAliasLif)->GRUPO })
			EndIf
			If _nAsc = 0

				AADD(aCols,Array(nUsado+1))
				_nAsc:=	len(aCols)
				aCols[_nAsc,2]:= 0
				aCols[_nAsc,3]:= 0
				aCols[_nAsc,4]:= 0
				aCols[_nAsc,5]:= 0
				aCols[_nAsc,6]:= 0

				aCols[_nAsc,7]:= 0
				aCols[_nAsc,8]:= 0
				aCols[_nAsc,9]:= 0
				aCols[_nAsc,10]:= 0
				aCols[_nAsc,11]:= 0

				If tira1(Substr(dtos(date()),1,4)) = SUBSTR((cAliasLif)->MES,1,4)
					aCols[_nAsc,1]:= (cAliasLif)->GRUPO+'  '+(cAliasLif)->DESCG
					aCols[_nAsc,2]+= (cAliasLif)->QTD
					aCols[_nAsc,3]+= (cAliasLif)->VALOR - DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))

				Else
					aCols[_nAsc,1]:= (cAliasLif)->GRUPO+'  '+(cAliasLif)->DESCG
					aCols[_nAsc,4]+= (cAliasLif)->QTD
					aCols[_nAsc,5]+= (cAliasLif)->VALOR - DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,7]:= (cAliasLif)->BRUTO - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,8]:= (cAliasLif)->ST
					aCols[_nAsc,9]:= (cAliasLif)->IPI
					aCols[_nAsc,10]:= (cAliasLif)->STIPI - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,11]:= (cAliasLif)->DIFAL

				EndIf
				aCols[Len(aCols),nUsado+1]:=.F.

				_nAsc:=0
			Else

				If  Substr(dtos(date()),1,4)  = SUBSTR((cAliasLif)->MES,1,4)
					aCols[_nAsc,4]+= (cAliasLif)->QTD
					aCols[_nAsc,5]+= (cAliasLif)->VALOR - DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,6]:= IiF  (	aCols[_nAsc,5] = 0 .or.  aCols[_nAsc,3] = 0,0, ((	aCols[_nAsc,5]*100)/	aCols[_nAsc,3] ) - 100 )

					aCols[_nAsc,7]+= (cAliasLif)->BRUTO - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,8]+= (cAliasLif)->ST
					aCols[_nAsc,9]+= (cAliasLif)->IPI
					aCols[_nAsc,10]+= (cAliasLif)->STIPI - xDEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,11]+= (cAliasLif)->DIFAL

				Else
					aCols[_nAsc,2]+= (cAliasLif)->QTD
					aCols[_nAsc,3]+= (cAliasLif)->VALOR - DEVRST((cAliasLif)->GRUPO,SUBSTR((cAliasLif)->MES,1,6))
					aCols[_nAsc,6]:= IiF  (	aCols[_nAsc,5] = 0 .or.  aCols[_nAsc,3] = 0,0, ((	aCols[_nAsc,5]*100)/	aCols[_nAsc,3] ) - 100 )

				EndIf
			EndIf

			_NgIO+= (cAliasLif)->VALOR
			(cAliasLif)->(dbskip())

		End

	EndIf

Return  ()

Static Function sDEVRST(_cGru,_cDat,_cEmp)

	Local cQuery     := ' '
	Local _nRe       := 0
	Local o          := 0
	Default _cEmp	 :='010'

	cQuery := " SELECT  NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += ' "TOTAL"
	cQuery += " FROM  SD1"+_cEmp+"  SD1
	cQuery += " INNER JOIN(SELECT * FROM   SA1"+_cEmp+" ) SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_TIPO = 'D'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += " AND SA1.A1_FILIAL = '  '

	cQuery += " INNER JOIN(SELECT * FROM SF2"+_cEmp+" ) SF2
	cQuery += " ON SF2.D_E_L_E_T_ = ' '
	cQuery += " AND SF2.F2_DOC = D1_NFORI
	cQuery += " AND SF2.F2_SERIE = D1_SERIORI
	cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
	cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')

	cQuery += " AND  SD1.D1_GRUPO =  '" + _cGru + "'
	cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,4) = '" + _cDat + "'

	If Len(_aPH5) = 1
		cQuery += " AND SA1.A1_COD = '"+_aPH5[1,1] +"'
	Else
		cQuery += " AND ( "
		For o:=1 To Len(_aPH5)
			If o=1
				cQuery += "  SA1.A1_COD = '"+_aPH5[o,1] +"'
			Else
				cQuery += " OR SA1.A1_COD = '"+_aPH5[o,1] +"'
			EndIf
		Next o
		cQuery += " )"
	EndIf

	cQuery := ChangeQuery(cQuery)

	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c1AliasLif)
	If Select(c1AliasLif) > 0
		_nRe:= (c1AliasLif)->TOTAL
	EndIf

	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf

Return  (_nRe)


Static Function DEVRST(_cGru,_cDat,_cEmp)

	Local cQuery     := ' '
	Local _nRe       := 0
	Local o			:= 0
	Default _cEmp	 :='010'

	cQuery := " SELECT  NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += ' "TOTAL"
	cQuery += " FROM  SD1"+_cEmp+"  SD1
	cQuery += " INNER JOIN(SELECT * FROM   SA1"+_cEmp+" )SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_TIPO = 'D'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += " AND SA1.A1_FILIAL = '  '

	cQuery += " INNER JOIN(SELECT * FROM SF2"+_cEmp+" )SF2
	cQuery += " ON SF2.D_E_L_E_T_ = ' '
	cQuery += " AND SF2.F2_DOC = D1_NFORI
	cQuery += " AND SF2.F2_SERIE = D1_SERIORI
	cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
	cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')

	cQuery += " AND  SD1.D1_GRUPO =  '" + _cGru + "'
	cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) = '" + _cDat + "'

	If Len(_aPH5) = 1
		cQuery += " AND SA1.A1_COD = '"+_aPH5[1,1] +"'
	Else
		cQuery += " AND ( "
		For o:=1 To Len(_aPH5)
			If o=1
				cQuery += "  SA1.A1_COD = '"+_aPH5[o,1] +"'
			Else
				cQuery += " OR SA1.A1_COD = '"+_aPH5[o,1] +"'
			EndIf
		Next o
		cQuery += " )"
	EndIf

	cQuery := ChangeQuery(cQuery)

	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c1AliasLif)
	If Select(c1AliasLif) > 0
		_nRe:= (c1AliasLif)->TOTAL
	EndIf

	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf

	_nRe:=0
Return  (_nRe)

Static Function xDEVRST(_cGru,_cDat,_cEmp)

	Local cQuery     := ' '
	Local _nRe       := 0
	Local o          := 0
	Default _cEmp	 :='010'

	cQuery := " SELECT  NVL(SUM(D1_TOTAL),0)
	cQuery += ' "TOTAL"
	cQuery += " FROM  SD1"+_cEmp+"  SD1
	cQuery += " INNER JOIN(SELECT * FROM   SA1"+_cEmp+" ) SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_TIPO = 'D'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += " AND SA1.A1_FILIAL = '  '

	cQuery += " INNER JOIN(SELECT * FROM SF2"+_cEmp+" ) SF2
	cQuery += " ON SF2.D_E_L_E_T_ = ' '
	cQuery += " AND SF2.F2_DOC = D1_NFORI
	cQuery += " AND SF2.F2_SERIE = D1_SERIORI
	cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
	cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')

	cQuery += " AND  SD1.D1_GRUPO =  '" + _cGru + "'
	cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) = '" + _cDat + "'

	If Len(_aPH5) = 1
		cQuery += " AND SA1.A1_COD = '"+_aPH5[1,1] +"'
	Else
		cQuery += " AND ( "
		For o:=1 To Len(_aPH5)
			If o=1
				cQuery += "  SA1.A1_COD = '"+_aPH5[o,1] +"'
			Else
				cQuery += " OR SA1.A1_COD = '"+_aPH5[o,1] +"'
			EndIf
		Next o
		cQuery += " )"
	EndIf

	cQuery := ChangeQuery(cQuery)

	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c1AliasLif)
	If Select(c1AliasLif) > 0
		_nRe:= (c1AliasLif)->TOTAL
	EndIf

	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf

Return  (_nRe)


Static Function STCAP(_cEmp)

	Local cQuery     := ' '
	Local _nRe       := 0
	Local o          := 0
	Default _cEmp	 :='010'

	cQuery := " SELECT

	cQuery += " SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) AS NET

	cQuery += " FROM SC6"+_cEmp+" SC6

	cQuery += " INNER JOIN (SELECT *  FROM SC5"+_cEmp+")SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_NUM = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL

	cQuery += " INNER JOIN(SELECT * FROM SA1"+_cEmp+")SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND A1_COD = C5_CLIENTE
	cQuery += " AND A1_LOJA = C5_LOJACLI
	cQuery += " AND A1_FILIAL = ' '
	cQuery += " LEFT JOIN (SELECT *  FROM  PC1"+_cEmp+" )PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' '
	cQuery += " INNER JOIN (SELECT * FROM SF4"+_cEmp+" ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S'
	cQuery += " WHERE  SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_FILIAL = '"+xFilial('SC6')+"' "        // Valdemir Rabelo 19/01/2022
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_EST <> 'EX'
	cQuery += " AND PC1.PC1_PEDREP IS NULL
	cQuery += " AND C6_QTDVEN > C6_QTDENT
	cQuery += " AND C6_BLQ <> 'R'

	If Len(_aPH5) = 1
		cQuery += " AND SA1.A1_COD = '"+_aPH5[1,1] +"'
	Else
		cQuery += " AND ( "
		For o:=1 To Len(_aPH5)
			If o=1
				cQuery += "  SA1.A1_COD = '"+_aPH5[o,1] +"'
			Else
				cQuery += " OR SA1.A1_COD = '"+_aPH5[o,1] +"'
			EndIf
		Next o
		cQuery += " )"
	EndIf

	cQuery := ChangeQuery(cQuery)

	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c1AliasLif)
	If Select(c1AliasLif) > 0
		_nRe:= (c1AliasLif)->NET
	EndIf

	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf

Return  (_nRe)

User Function STWF28( )

	Local cAliasSuper	:= 'STWF28'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")                // Valdemir Rabelo 19/01/2022 - Chamado: 20220119001499

	cQuery	:= " SELECT
	cQuery	+= " B1_COD, B1_DESC, B2_QATU, B2_DMOV, D3_USUARIO
	cQuery	+= " FROM "+RetSqlName("SB2") + " SB2 "
	cQuery	+= " INNER JOIN(SELECT * FROM "+RetSqlName("SB1") + ") SB1
	cQuery	+= " ON SB1.D_E_L_E_T_ = ' '
	cQuery	+= " AND B1_COD = B2_COD
	cQuery	+= " LEFT JOIN(SELECT * FROM "+RetSqlName("SD3") + ") SD3
	cQuery	+= " ON SD3.D_E_L_E_T_ = ' '
	cQuery	+= " AND D3_FILIAL = B2_FILIAL
	cQuery	+= " AND D3_LOCAL = B2_LOCAL
	cQuery	+= " AND D3_COD = B2_COD
	cQuery	+= " AND D3_QUANT = B2_QATU
	cQuery	+= " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery	+= " AND B2_FILIAL ='"+xFilial('SB2')+"' "       // Valdemir Rabelo 19/01/2022
	cQuery	+= " AND B2_LOCAL = '50'
	cQuery	+= " AND B2_QATU <> 0 "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Cod","Desc","Qtd","Data","Usuario"})

		While (cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->B1_COD,;
				(cAliasSuper)->B1_DESC ,;
				Transform( (cAliasSuper)->B2_QATU ,"@E 999,999,999"), ;
				Dtoc(Stod((cAliasSuper)->B2_DMOV)),;
				(cAliasSuper)->D3_USUARIO;
				}  )

			(cAliasSuper)->(dbskip())

		End

		If Len(_aMsg) > 1
			STWFR28(_aMsg,'',''  ,'')
		EndIf

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR28(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Armazem 50'
	Local cFuncSent		:= "STWFR28"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   kleber.braga@steck.com.br  "
	default _cCopia  	:= ' '

	_cEmail  	:= "   kleber.braga@steck.com.br "

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()

User Function STWF29( )

	Local cAliasSuper	:= 'STWF29'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")  
	RpcSetEnv("11","01",,,"FAT")               // Valdemir Rabelo - Chamado: 20220119001499

	cQuery	:= " SELECT
	cQuery	+= " B1_COD, B1_DESC, B2_QATU, B2_DMOV, MAX(D3_USUARIO) D3_USUARIO, MAX(D1_DOC) D1_DOC
	cQuery  += " ,MAX(D1_XFATEC) D1_XFATEC, MAX(PC1_ATENDE) PC1_ATENDE
	cQuery	+= " FROM  "+RETSQLNAME("SB2")+" SB2 "
	cQuery	+= " INNER JOIN(SELECT * FROM  "+RETSQLNAME("SB1") + ") SB1 "  // Valdemir Rabelo - Chamado: 20220119001499
	cQuery	+= " ON SB1.D_E_L_E_T_ = ' '
	cQuery	+= " AND B1_COD = B2_COD
	cQuery	+= " LEFT JOIN(SELECT * FROM "+RETSQLNAME("SD3") + ") SD3 "   // Valdemir Rabelo - Chamado: 20220119001499
	cQuery	+= " ON SD3.D_E_L_E_T_ = ' '
	cQuery	+= " AND D3_FILIAL = B2_FILIAL
	cQuery	+= " AND D3_LOCAL = B2_LOCAL
	cQuery	+= " AND D3_COD = B2_COD
	//cQuery	+= " AND D3_QUANT = B2_QATU
	//cQuery  += " AND D3_EMISSAO=B2_DMOV

	cQuery	+= " LEFT JOIN(SELECT * FROM "+RETSQLNAME("SD1") + ") SD1 "     // Valdemir Rabelo - Chamado: 20220119001499
	cQuery	+= " ON SD1.D_E_L_E_T_ = ' '
	cQuery	+= " AND D1_COD = B2_COD
	cQuery	+= " AND D1_NUMSEQ = D3_IDENT
	cQuery	+= " AND D1_XFATEC <> ' '
	cQuery	+= " AND D1_FILIAL = D3_FILIAL

	cQuery	+= " LEFT JOIN(SELECT * FROM "+RETSQLNAME("PC1") + ") PC1 "    // Valdemir Rabelo - Chamado: 20220119001499
	cQuery	+= " ON PC1.D_E_L_E_T_ = ' '
	cQuery	+= " AND PC1_NUMERO = D1_XFATEC

	cQuery	+= " WHERE SB2.D_E_L_E_T_ = ' '
	// Adicionado xFilial Valdemir Rabelo - Chamado: 20220119001499
	cQuery	+= " AND B2_FILIAL ='"+xFilial('SB2')+"' "
	cQuery	+= " AND B2_LOCAL = '60'
	cQuery	+= " AND B2_QATU <> 0 "

	cQuery += " GROUP BY B1_COD, B1_DESC, B2_QATU, B2_DMOV

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Cod","Desc","Qtd","Data","Usuario(D3)","NF","FATEC","ATENDENTE"})

		While (cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->B1_COD,;
				(cAliasSuper)->B1_DESC ,;
				Transform( (cAliasSuper)->B2_QATU ,"@E 999,999,999"), ;
				Dtoc(Stod((cAliasSuper)->B2_DMOV)),;
				(cAliasSuper)->D3_USUARIO,;
				(cAliasSuper)->D1_DOC,;
				(cAliasSuper)->D1_XFATEC,;
				(cAliasSuper)->PC1_ATENDE;
				}  )

			(cAliasSuper)->(dbskip())

		End

		If Len(_aMsg) > 1
			STWFR29(_aMsg,'',''  ,'')
		EndIf

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR29(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Armazem 60'
	Local cFuncSent		:= "STWFR29"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   kleber.braga@steck.com.br"
	default _cCopia  	:= ' '

	_cEmail  	:= "   kleber.braga@steck.com.br"

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()

User Function STWF30( )

	Local cAliasSuper	:= 'STWF30'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")                       // Valdemir Rabelo 19/01/2022 - chamado: 20220119001499 / 20220118001422

	cQuery	:= " SELECT  BE_LOCAL,BE_LOCALIZ, BE_DTINV, SBE010.* FROM " + RETSQLNAME("SBE") +" SBE010 WHERE BE_FILIAL = '"+xFilial('SBE')+"' AND BE_DTINV = to_char(sysdate - 1,'YYYYMMDD') AND D_E_L_E_T_ = ' '

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Local","Endereço","Dt Blq Inventario"})

		While (cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->BE_LOCAL,;
				(cAliasSuper)->BE_LOCALIZ ,;
				Dtoc(Stod((cAliasSuper)->BE_DTINV)),;
				}  )

			(cAliasSuper)->(dbskip())

		End

		If Len(_aMsg) > 1
			STWFR30(_aMsg,'',''  ,'')
		EndIf

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR30(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Endereços com bloqueio de Inventario.'
	Local cFuncSent		:= "STWFR30"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= ' '
	default _cCopia  	:= ' '

	_cEmail  	:= GetMv('ST_ENDBLQ',,'maurilio.francisquet@steck.com.br')

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		//	If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
		U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		//	EndIf

	EndIf
	RestArea(aArea)

Return()

User Function STWF32( )

	Local cAliasSuper	:= 'STWF32'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"COM")
	RpcSetEnv("11","01",,,"COM")                    // VALDEMIR RABELO 19/01/2022 - CHAMADO: 20220119001499

	cQuery = "SELECT * FROM (	"
	cQuery += " SELECT 'STECK SP' EMPRESA, C7_FILIAL, C7_NUM, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT-C7_QUJE C7_QTDF, C7_DATPRF, A2_NREDUZ, A2_EMAIL, Y1_NOME, Y1_EMAIL	"
	cQuery += " FROM "+RETSQLNAME("SC7")+ " SC7 "
	cQuery += "	LEFT JOIN(SELECT * FROM "+RETSQLNAME("SA2") +") SA2	"
	cQuery += "	ON SA2.D_E_L_E_T_ = ' '	"
	cQuery += "	AND A2_COD = C7_FORNECE	"
	cQuery += "	AND A2_LOJA = C7_LOJA	"
	cQuery += "	AND A2_EST <> 'EX'	"
	cQuery += "	LEFT JOIN(SELECT * FROM "+RETSQLNAME("SY1") +") SY1	"
	cQuery += "	ON SY1.D_E_L_E_T_ = ' '	"
	cQuery += "	AND Y1_USER = C7_USER	"
	cQuery += "	WHERE SC7.D_E_L_E_T_ = ' '	"
	cQuery += "	AND C7_QUANT > C7_QUJE 	"
	cQuery += "	AND C7_RESIDUO=' ' 	"
	cQuery += "	AND C7_CONAPRO<>'B'	"
	cQuery += "	AND C7_CONTRA=' '	"
	cQuery += "	AND C7_FILIAL<>'01'	"
	cQuery += " AND  C7_DATPRF = '" + DtoS(dDataBase + 2) + "' "
	cQuery += " UNION "
	cQuery += " SELECT 'STECK AM' EMPRESA, C7_FILIAL, C7_NUM, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT-C7_QUJE C7_QTDF, C7_DATPRF, A2_NREDUZ, A2_EMAIL, Y1_NOME, Y1_EMAIL	"
	cQuery += " FROM UDBP12.SC7030 SC7 "                          // Valdemir rabelo 19/01/2022
	cQuery += "	LEFT JOIN(SELECT * FROM UDBP12.SA2030) SA2	"     // Valdemir Rabelo 19/01/2022s
	cQuery += "	ON SA2.D_E_L_E_T_ = ' '	"
	cQuery += "	AND A2_COD = C7_FORNECE	"
	cQuery += "	AND A2_LOJA = C7_LOJA	"
	cQuery += "	AND A2_EST <> 'EX'	"
	cQuery += "	LEFT JOIN(SELECT * FROM UDBP12.SY1030) SY1	"	  // Valdemir Rabelo 19/01/2022
	cQuery += "	ON SY1.D_E_L_E_T_ = ' '	"
	cQuery += "	AND Y1_USER = C7_USER	"
	cQuery += "	WHERE SC7.D_E_L_E_T_ = ' '	"
	cQuery += "	AND C7_QUANT > C7_QUJE 	"
	cQuery += "	AND C7_RESIDUO=' ' 	"
	cQuery += "	AND C7_CONAPRO<>'B'	"
	cQuery += "	AND C7_CONTRA=' '	"
	cQuery += "	AND C7_FILIAL='01'	"
	cQuery += " AND  C7_DATPRF = '" + DtoS(dDataBase + 2) + "' ) QRYTMP "
	cQuery += " ORDER BY QRYTMP.C7_NUM, QRYTMP.C7_ITEM "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		aadd(_aMsg,{"Pedido","Item","Produto","Descrição","Quantidade","Data Entrega","Fornecedor","e-mail","Comprador","e-mail"})

		While (cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->C7_NUM,;
				(cAliasSuper)->C7_ITEM ,;
				(cAliasSuper)->C7_PRODUTO ,;
				(cAliasSuper)->C7_DESCRI ,;
				(cAliasSuper)->C7_QTDF ,;
				Dtoc(Stod((cAliasSuper)->C7_DATPRF)),;
				(cAliasSuper)->A2_NREDUZ ,;
				(cAliasSuper)->A2_EMAIL ,;
				(cAliasSuper)->Y1_NOME ,;
				(cAliasSuper)->Y1_EMAIL ,;
				(cAliasSuper)->EMPRESA ,;
				(cAliasSuper)->C7_FILIAL ,;
				}  )

			(cAliasSuper)->(dbskip())

		End

		If Len(_aMsg) > 1
			STWFR32(_aMsg,'',''  ,'')
		EndIf

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR32(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Pedidos para Entrega.'
	Local cFuncSent		:= "STWFR32"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= ' '
	default _cCopia  	:= ' '

	//_cEmail  	:= GetMv('ST_ENDBLQ',,'maurilio.francisquet@steck.com.br')

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		For _nLin := 1 to Len(_aMsg)

			If _nLin > 1
				//Definicao do cabecalho do email                                             ?
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title>' + _cAssunto + " - "+ALLTRIM(_aMsg[_nLin,11])+"/"+ALLTRIM(_aMsg[_nLin,12])+'</title>'
				cMsg += '</head>'
				cMsg += '<br>'
				cMsg += '<body>'
				cMsg += '<p style="text-align:center;font-family:verdana;">Prezado ' + _aMsg[_nLin,7] + ', por favor confirmar a entrega para o dia ' + _aMsg[_nLin,6] + ' conforme pedido numero ' + _aMsg[_nLin,1] + '. </p>'
				cMsg += '<br>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+ALLTRIM(_aMsg[_nLin,11])+"/"+ALLTRIM(_aMsg[_nLin,12])+ '</FONT> </Caption>'
				//Definicao do texto/detalhe do email                                         ?
				cMsg += '<tr BgColor=#848484>'
				cMsg += '<TD><B><Font Color=#FFFFFF Size="2" Face="Arial">Pedido</Font></B></TD>'
				cMsg += '<TD><B><Font Color=#FFFFFF Size="2" Face="Arial">Item</Font></B></TD>'
				cMsg += '<TD><B><Font Color=#FFFFFF Size="2" Face="Arial">Produto</Font></B></TD>'
				cMsg += '<TD><B><Font Color=#FFFFFF Size="2" Face="Arial">Descrição</Font></B></TD>'
				cMsg += '<TD><B><Font Color=#FFFFFF Size="2" Face="Arial">Quantidade</Font></B></TD>'
				cMsg += '<TD><B><Font Color=#FFFFFF Size="2" Face="Arial">Data Entrega</Font></B></TD>'
				cMsg += '</tr>'

				IF _aMsg[_nLin,1] == _aMsg[_nLin+1,1]

					If (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#FFFFFF>'
					Else
						cMsg += '<TR BgColor=#B0E2FF>'
					EndIf

					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + Str(_aMsg[_nLin,5]) + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
					cMsg += '</tr>'

					While _aMsg[_nLin,1] == _aMsg[_nLin+1,1]

						If (_nLin/2) == Int( _nLin/2 )
							cMsg += '<TR BgColor=#B0E2FF>'
						Else
							cMsg += '<TR BgColor=#FFFFFF>'
						EndIf

						cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin+1,1] + ' </Font></TD>'
						cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin+1,2] + ' </Font></TD>'
						cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin+1,3] + ' </Font></TD>'
						cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin+1,4] + ' </Font></TD>'
						cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + Str(_aMsg[_nLin+1,5]) + ' </Font></TD>'
						cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin+1,6] + ' </Font></TD>'
						cMsg += '</tr>'

						IF _nLin <= Len(_aMsg)-1
							_nLin++
						EndIF

					Enddo

				Else

					If (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#FFFFFF>'
					Else
						cMsg += '<TR BgColor=#B0E2FF>'
					EndIf

					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + Str(_aMsg[_nLin,5]) + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
					cMsg += '</tr>'

				EndIF

				//Definicao do rodape do email

				cMsg += '</Table>'
				cMsg += '<P>'
				cMsg += '<Table align="center">'
				cMsg += '<tr>'
				cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
				cMsg += '</tr>'
				cMsg += '</Table>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '</body>'
				cMsg += '</html>'

				_cEmail  	:= alltrim(_aMsg[_nLin,10])+';'+alltrim(_aMsg[_nLin,8])
				_cCopia  	:= ""//alltrim(_aMsg[_nLin,10])

				U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')

			EndIF

		Next

	EndIf

	RestArea(aArea)

Return()

User Function STWF33( )

	Local cAliasSuper	:= 'STWF33'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ''
	Local _cCop			:= ''
return() //giovani desabilitado 08/09/2020 novo calculo de custo passado por planilha pela controladoria
	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")              
	RpcSetEnv("11","01",,,"FAT")                      // Valdemir Rabelo 19/01/2022 - Chamado: 20220119001499

	cQuery := " SELECT DISTINCT D2_COD FROM "+RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_FILIAL = '"+xFilial('SD2')+"' AND D2_EMISSAO >= '"+ Dtos(date() -180)+"' ORDER BY D2_COD

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		aadd(_aMsg,{"Produto","Descrição","Custo Antigo","Custo atual","Variação"})

		While (cAliasSuper)->(!Eof())

			_nProCus:= 0
			DbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+(cAliasSuper)->D2_COD ))
				_nProCus:= u_STCUSTO((cAliasSuper)->D2_COD,.F.)
				If SB1->B1_XPCSTK <> _nProCus
					aadd(_aMsg,{(cAliasSuper)->D2_COD,;
						Alltrim(SB1->B1_DESC),;
						Transform(SB1->B1_XPCSTK ,"@E 999,999,999.99")	 ,;
						Transform(_nProCus,"@E 999,999,999.99")	  ,;
						Iif(SB1->B1_XPCSTK <> 0 .And. _nProCus <> 0 , Transform(_nProCus*100/SB1->B1_XPCSTK-100,"@E 999,999,999.99"),'0')+' %' ;
						})

					RecLock("SB1",.F.)
					SB1->B1_XPCSTK := _nProCus
					SB1->(MsUnLock())
					SB1->(DbCommit())
				EndIf
			EndIf

			If Len(_aMsg) > 1000
				STWFR33(_aMsg,'',''  ,'')
				_aMsg:= {}
				aadd(_aMsg,{"Produto","Descrição","Custo Antigo","Custo atual","Variação"})
			EndIf

			(cAliasSuper)->(dbskip())

		End

		If Len(_aMsg) > 1
			STWFR33(_aMsg,'',''  ,'')
		EndIf

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR33(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Atualização de Custo.'
	Local cFuncSent		:= "STWFR33"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= ' '
	default _cCopia  	:= ' '

	_cEmail  	:= 'reinaldo.franca@steck.com.br;jadson.silva@steck.com.br;mateus.ferreira@steck.com.br'

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)

Return()

User Function STWF34( )

	Local cAliasSuper	:= 'STWF34'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")			// Valdemir Rabelo 19/01/2022 - Chamado: 20220119001499

	cQuery := " SELECT
	cQuery += " ZZV_CLIENT||'-'||ZZV_LOJA AS COD,
	cQuery += " ZZV_NOMECL,
	cQuery += " ZZV_DTEMIS,
	cQuery += " ZZV_DTREV,
	cQuery += " NVL(SA3.A3_EMAIL,' ') AS VEND1,
	cQuery += " NVL(TA3.A3_EMAIL,' ') AS SUPER
	cQuery += " FROM "+RetSqlName('ZZV') + " ZZV
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName('SA3')+") SA3
	cQuery += " ON SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SA3.A3_COD = ZZV_VEND1
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName('SA3')+") TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' '
	cQuery += " AND TA3.A3_COD = ZZV_SUPER
	cQuery += " WHERE ZZV.D_E_L_E_T_ = ' '
	cQuery += " AND ZZV_DTREV >= '"+ Dtos(date() -5)+"'
	cQuery += " AND ZZV_DTREV <>  ' '

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		aadd(_aMsg,{"Codigo","Nome","Emissão","Revisão"})

		While (cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->COD,;
				Alltrim((cAliasSuper)->ZZV_NOMECL),;
				dtoc(stod((cAliasSuper)->ZZV_DTEMIS))	 ,;
				dtoc(stod((cAliasSuper)->ZZV_DTREV))	 ;
				})

			STWFR34(_aMsg, alltrim((cAliasSuper)->VEND1)+';'+alltrim((cAliasSuper)->SUPER) ,' ' ,'')
			_aMsg:= {}

			(cAliasSuper)->(dbskip())

		End

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR34(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Revisão de Pré-Cadastro'
	Local cFuncSent		:= "STWFR34"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= ' '
	default _cCopia  	:= ' '

	_cCopia  	:= '  suely.guinati@steck.com.br;carla.lodetti@steck.com.br ;janaina.paixao@steck.com.br ;filipe.nascimento@steck.com.br;marcelo.oliveira@steck.com.br '

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)

Return()

User Function STWF35(_cPedNum,_nTipo,_cValor )

	Local cAliasSuper	:= 'STWF35'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= 'francisco.smania@steck.com.br;wellington.gamas@steck.com.br;jefferson.puglia@steck.com.br;leandro.nobre@steck.com.br'
	Local _cCop			:= ''
	Local _lRet 		:= .T.

	If Substr(_cValor,1,1) $ 'N#n'

		cQuery := " SELECT  COUNT(*),C9.C9_FILIAL, C9.C9_NFISCAL,C9.C9_PEDIDO,C9.C9_ORDSEP,C9.C9_CLIENTE,C9.C9_LOJA,
		cQuery += " (SELECT COUNT(*) FROM "+RetSqlName("CB9")+" CB9 WHERE CB9_ORDSEP = C9.C9_ORDSEP AND CB9_FILIAL = C9.C9_FILIAL AND CB9_VOLUME <> ' ' AND D_E_L_E_T_ = ' ') VOL
		cQuery += " FROM "+RetSqlName("SC9")+" C9
		cQuery += " WHERE C9.C9_PEDIDO = '"+_cPedNum+"' AND C9.D_E_L_E_T_ = ' '
		cQuery += " GROUP BY C9.C9_FILIAL,C9.C9_NFISCAL,C9.C9_PEDIDO,C9.C9_ORDSEP,C9.C9_CLIENTE,C9.C9_LOJA

		If Select(cAliasSuper) > 0
			(cAliasSuper)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

		dbSelectArea(cAliasSuper)
		(cAliasSuper)->(dbgotop())

		If  Select(cAliasSuper) > 0

			aadd(_aMsg,{"Nota Fiscal","Pedido","Ordem de Separação","Cliente"})

			While (cAliasSuper)->(!Eof())

				aadd(_aMsg,{(cAliasSuper)->C9_NFISCAL,;
					Alltrim((cAliasSuper)->C9_PEDIDO),;
					Alltrim((cAliasSuper)->C9_ORDSEP)	 ,;
					Posicione("SA1",1,xFilial("SA1")+(cAliasSuper)->C9_CLIENTE+(cAliasSuper)->C9_LOJA,"A1_NOME") } )

				STWFR35(_aMsg,_cmail ,' ' ,'')
				_aMsg:= {}
				(cAliasSuper)->(dbskip())

			End
		EndIf

		If Select(cAliasSuper) > 0
			(cAliasSuper)->(dbCloseArea())
		EndIf

		Do Case
		Case _nTipo==1
			If !U_STFAT340("4","T",.T.)
				_lRet := .F.
			EndIf
		Case _nTipo==2
			If !U_STFAT340("1","T",.T.)
				_lRet := .F.
			EndIf
		EndCase

	EndIf

Return(_lRet)

	*------------------------------------------------------------------*
Static Function STWFR35(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Retrabalho finalizado'
	Local cFuncSent		:= "STWFR35"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= ' '
	default _cCopia  	:= ' '

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)

Return()



	/*/{Protheus.doc} User Function STESTJOB
	(long_description)
	JOB para coletar registros que não foram informado data do desenho superior 3 dias
	@author user
	VALDEMIR RABELO (SIGAMAT)
	@since 10/12/2019
	@example
	(examples)
	U_JOBUNDES()
	/*/
User Function JOBUNDES()
	Local _cEmpresa := '11'      // Valdemir Rabelo 19/01/2022
	Local _cFilial  := '01'		 // Valdemir Rabelo 19/01/2022

	ConOut( "*******************************************************************" )
	ConOut( "*    INICIO LEITURA - PROCURA DE REGISTROS SEM ROTEIROS VIA JOB   *" )
	ConOut( "*******************************************************************" )

	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(_cEmpresa,_cFilial,,,,GetEnvServer(),{ "PP8","SA1","SB1","SG2" } )
	SetModulo("SIGAFAT","FAT")

	// Efetua chamada da rotina...
	JOBUDESE()

	RpcClearEnv()

	ConOut( "*******************************************************************" )
	ConOut( "*    TERMINO LEITURA JOB (STESTJOB)                               *" )
	ConOut( "*******************************************************************" )

Return .T.

	/*/{Protheus.doc} User Function STESTJOB
	(long_description)
	Rotina quqe prepara os registros e envio do WF
	@author user
	VALDEMIR RABELO (SIGAMAT)
	@since 10/12/2019
	@example
	(examples)
	/*/
Static Function JOBUDESE()
	Local cQry    := MntQry()
	Local aWFDes  := {}
	Local aRegis  := {}
	Local _cEmail := SuperGetMV("ST_EMLUDES",.F.,"filipe.nascimento@steck.com.br")
	Local aAreaPP8:= GetArea()

	if Select("TPP8") > 0
		TPP8->( dbCloseArea() )
	Endif

	TcQuery cQry New Alias "TPP8"
	TcSetField("TPP8","PP8_DAPCLI", "D")

	While !Eof()
		if ((TPP8->PP8_DAPCLI+3) <= DDATABASE)
			// Preparando Envio WF
			Aadd( aRegis, { "Atendimento: "     , TPP8->PP8_CODIGO }  )
			Aadd( aRegis, { "Item: "            , TPP8->PP8_ITEM }  )
			Aadd( aRegis, { "Data Liberação: "  , dtoc(TPP8->PP8_DAPCLI) } )
			aAdd(aWFDes, aRegis)
			aRegis := {}
		Endif
		dbSkip()
	EndDo

	if Select("TPP8") > 0
		TPP8->( dbCloseArea() )
	Endif

	RestArea( aAreaPP8 )

	if Len(aWFDes) > 0
		U_EnviaWF1(aWFDes, _cEmail, "AVISO ( DATA ENTREGA DESENHO NÃO INFORMADO SUPERIOR 3 DIAS )" + CRLF  )
	Endif

Return

	/*/{Protheus.doc} User Function STESTJOB
	(long_description)
	Rotina para montar query comn os registros que serão enviado via WF
	@author user
	VALDEMIR RABELO (SIGAMAT)
	@since 10/12/2019
	@example
	(examples)
	/*/
Static Function MntQry()
	Local cRET := ""

	cRET += "SELECT * " + CRLF
	cRET += "FROM " + RETSQLNAME('PP8') + " PP8 " + CRLF
	cRET += "WHERE PP8.D_E_L_E_T_ = ' ' " + CRLF
	cRET += " AND PP8.PP8_DTPRES =  ' ' " + CRLF
	cRET += " AND PP8.PP8_DAPCLI <> ' ' " + CRLF
	cRET += " AND PP8.PP8_STATUS='E'    " + CRLF
	cRET += "ORDER BY PP8_DAPCLI        " + CRLF

Return cRET

User Function STWF36()

	Local cAliasSuper	:= 'STWF36'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= 'simone.mara@steck.com.br; jefferson.puglia@steck.com.br; guilherme.fernandez@steck.com.br; kleber.braga@steck.com.br; francisco.smania@steck.com.br; wellington.gamas@steck.com.br; leandro.nobre@steck.com.br;cleonice.cosmo@steck.com.br,; marcelo.galera@steck.com.br; maurilio.francisquetti@steck.com.br'

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")    // Valdemir Rabelo 10/02/2022 - Chamado: 20220114001103

	cQuery := " SELECT * FROM (
	cQuery += " SELECT
	cQuery += " C5_NUM,
	cQuery += " CB7_ORDSEP,
	cQuery += " COUNT(CB6_VOLUME) AS VOLUME,
	cQuery += " nvl(SUM(CB6_XPESO),0) as CB6_XPESO,
	cQuery += " ' ' AS REGIAO,
	cQuery += " CB6_XOPERA ||' - '|| CB1_NOME AS EMBALADOR,
	cQuery += " SUBSTR(CB7_XDFEM,7,2)||'/'||SUBSTR(CB7_XDFEM,5,2)||'/'||SUBSTR(CB7_XDFEM,1,4)          AS CB7_XDFEM,
	cQuery += " CB7_XHFEM,
	cQuery += " C5_XNOME,
	cQuery += " CB7_NOTA,
	cQuery += " C5_XBLQROM ,
	cQuery += " C5_XREAN14

	cQuery += " FROM " + RetSqlName("SC5") + " SC5

	cQuery += " INNER JOIN(SELECT * FROM " + RetSqlName("CB7") + ")CB7
	cQuery += " ON CB7.D_E_L_E_T_ = ' '
	cQuery += " AND CB7_FILIAL = C5_FILIAL
	cQuery += " AND CB7_PEDIDO = C5_NUM

	cQuery += "  LEFT JOIN(SELECT * FROM " + RetSqlName("CB6")+") CB6
	cQuery += " ON CB6.D_E_L_E_T_ = ' '
	cQuery += " AND CB6_FILIAL = C5_FILIAL
	cQuery += " AND CB6_XORDSE = CB7_ORDSEP

	cQuery += "  LEFT JOIN(SELECT * FROM " + RetSqlName("CB1")+") CB1
	cQuery += " ON CB1.D_E_L_E_T_ = ' '
	cQuery += " AND CB1_FILIAL = C5_FILIAL
	cQuery += " AND CB1_CODOPE = CB6_XOPERA

	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = '02'
	cQuery += " AND (C5_XBLQROM = '1' OR  C5_XREAN14 = '1')
	cQuery += " AND NOT EXISTS (SELECT * FROM " + RetSqlName("PD2")+" PD2 WHERE PD2.D_E_L_E_T_ = ' '
	cQuery += " AND PD2.PD2_NFS    = CB7.CB7_NOTA
	cQuery += " AND PD2.PD2_SERIES = CB7.CB7_SERIE
	cQuery += " AND PD2.PD2_FILIAL = '"+xFilial("PD2")+"')

	cQuery += " GROUP BY C5_NUM, CB7_ORDSEP,CB6_XOPERA ||' - '|| CB1_NOME,CB7_XDFEM ,
	cQuery += " CB7_XHFEM,
	cQuery += " C5_XNOME,
	cQuery += " CB7_NOTA,C5_XBLQROM , C5_XREAN14
	cQuery += " )
	cQuery += " ORDER BY C5_XNOME, CB7_ORDSEP

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		aadd(_aMsg,{"Pedido","Ordem de Separação","Volume","Peso","Região","Embalador","Data Fim","Hora Fim","Cliente","Nota","Blq.Romaneio","EAN14"})

		While (cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->C5_NUM,;
				(cAliasSuper)->CB7_ORDSEP,;
				(cAliasSuper)->VOLUME,;
				(cAliasSuper)->CB6_XPESO,;
				(cAliasSuper)->REGIAO,;
				(cAliasSuper)->EMBALADOR,;
				(cAliasSuper)->CB7_XDFEM,;
				(cAliasSuper)->CB7_XHFEM,;
				(cAliasSuper)->C5_XNOME,;
				(cAliasSuper)->CB7_NOTA,;
				IIf((cAliasSuper)->C5_XBLQROM=="1","Sim","Não"),;
				IIf((cAliasSuper)->C5_XREAN14=="1","Sim","Não");
				} )

			(cAliasSuper)->(dbskip())

		End
	EndIf

	If Len(_aMsg) > 1
		STWFR36(_aMsg,_cmail ,' ' ,'')
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR36(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Blq.Romaneio/EAN14'
	Local cFuncSent		:= "STWFR36"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= ' '
	default _cCopia  	:= ' '

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,12] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + Transform(_aMsg[_nLin,3],"@E 999,999,999.99") + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + Transform(_aMsg[_nLin,4],"@E 999,999,999.99") + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,12] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)

Return()

//Ticket 20191127000022 - Cassio Kenj - SigaMat
User Function STWF37()

	Local cAliasSuper	:= 'STWF37'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")                      // Valdemir Rabelo 19/01/2022 - Chamado: 20220119001499

	cQuery += "	SELECT SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, TMP2.A1_NOME, SC5.C5_VEND1, SC5.C5_VEND2, "
	cQuery += " TMP2.E1_NUM,TMP2.E1_PARCELA,TMP2.E1_VENCREA,TMP2.E1_VALOR " //20200406001465
	cQuery += " FROM " + RetSqlName("SC5") + " SC5 	 "
	cQuery += "	INNER JOIN (	 "
	cQuery += "	SELECT SC9.C9_PEDIDO, SC9.C9_CLIENTE, SC9.C9_LOJA, TMP1.A1_NOME, "
	cQuery += " TMP1.E1_NUM,TMP1.E1_PARCELA,TMP1.E1_VENCREA,TMP1.E1_VALOR " //20200406001465
	cQuery += " FROM " + RetSqlName("SC9") + " SC9 	 "
	cQuery += "	INNER JOIN (SELECT SA1.A1_COD,SA1.A1_NOME,
	cQuery += " SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_VENCREA,SE1.E1_VALOR "
	cQuery += " FROM " + RetSqlName("SA1") + " SA1 	 "
	cQuery += "	INNER JOIN " + RetSqlName("SE1") + " SE1 	 "
	cQuery += "	ON SA1.A1_COD = SE1.E1_CLIENTE	 "
	cQuery += "	AND SA1.A1_LOJA = SE1.E1_LOJA 	 "
	cQuery += "	AND SE1.E1_FILIAL = '"+xFilial('SE1')+"'	 "
	cQuery += "	AND SA1.A1_XBLQFIN='1'	 "
	cQuery += "	AND SE1.E1_SITUACA='F'	 "
	cQuery += "	AND SE1.E1_SALDO>0	 "
	cQuery += "	WHERE SE1.D_E_L_E_T_=' ' AND SA1.D_E_L_E_T_=' '	 "
	cQuery += "	GROUP BY SA1.A1_COD,SA1.A1_NOME,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_VENCREA,SE1.E1_VALOR) TMP1	 "
	cQuery += "	ON SC9.C9_CLIENTE=TMP1.A1_COD	 "
	cQuery += "	AND SC9.D_E_L_E_T_ = ' ' 	 "
	cQuery += "	AND SC9.C9_BLCRED = ' ' 	 "
	cQuery += "	AND SC9.C9_BLEST = ' ' 	 "
	cQuery += "	AND SC9.C9_BLTMS = ' ' 	 "
	cQuery += "	WHERE SC9.D_E_L_E_T_=' '	 "
	cQuery += "	GROUP BY SC9.C9_PEDIDO, SC9.C9_CLIENTE, SC9.C9_LOJA, TMP1.A1_NOME,TMP1.E1_NUM,TMP1.E1_PARCELA,TMP1.E1_VENCREA,TMP1.E1_VALOR	 "
	cQuery += "	) TMP2	 "
	cQuery += "	ON SC5.C5_NUM=TMP2.C9_PEDIDO	 "
	cQuery += "	WHERE SC5.D_E_L_E_T_=' '	 "
	cQuery += " and C5_ZFATBLQ = ' ' " //Ticket 20200303000814
	cQuery += " and C5_NOTA  = ' ' " //Ticket 20200303000814
	cQuery += "	ORDER BY SC5.C5_VEND1 "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		aadd(_aMsg,{"Pedido","Cliente","Loja","Nome","Titulo","Parcela","Vencimento","Valor"})

		While (cAliasSuper)->(!Eof()) .and. !Empty((cAliasSuper)->C5_VEND1)

			cVendedor := (cAliasSuper)->C5_VEND1

			While (cAliasSuper)->(!Eof()) .and. cVendedor == (cAliasSuper)->C5_VEND1

				DbSelectArea("SA3")
				SA3->(dbSetOrder(1))
				SA3->(DBGoTop())

				IF !Empty((cAliasSuper)->C5_VEND1) .and. SA3->(Dbseek(xFilial("SA3")+(cAliasSuper)->C5_VEND1))

					cMailVend := SA3->A3_EMAIL

					IF !Empty(SA3->A3_SUPER) .and. SA3->(Dbseek(xFilial("SA3")+SA3->A3_SUPER))

						cMailSup := SA3->A3_EMAIL

					EndIF

					IF !Empty(SA3->A3_GEREN) .and. SA3->(Dbseek(xFilial("SA3")+SA3->A3_GEREN))

						cMailGer := SA3->A3_EMAIL

					EndIF

					aadd(_aMsg,{(cAliasSuper)->C5_NUM,;
						(cAliasSuper)->C5_CLIENTE,;
						(cAliasSuper)->C5_LOJACLI,;
						(cAliasSuper)->A1_NOME,;
						(cAliasSuper)->E1_NUM,;
						(cAliasSuper)->E1_PARCELA,;
						Dtoc(stod((cAliasSuper)->E1_VENCREA)),;
						Transform((cAliasSuper)->E1_VALOR,"@E 999,999,999.99")	})

					_cEmail := ALLTRIM(cMailVend)+"; " + ALLTRIM(cMailSup)+"; " + ALLTRIM(cMailGer)

				EndIF

				(cAliasSuper)->(dbskip())

			EndDo

			If Len(_aMsg) > 1000
				STWFR99(_aMsg,_cEmail,''  ,'')
				_aMsg:= {}
				aadd(_aMsg,{"Pedido","Cliente","Loja","Nome","Titulo","Parcela","Vencimento","Valor"})
			EndIf

			If Len(_aMsg) > 1
				STWFR37(_aMsg,_cEmail,''  ,'')
			EndIf

			//	(cAliasSuper)->(dbskip())
			_aMsg   := {}
			_cEmail := ""
			aadd(_aMsg,{"Pedido","Cliente","Loja","Nome","Titulo","Parcela","Vencimento","Valor"})

		EndDo

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR37(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Faturamento bloqueado verifique com o financeiro' //verificar com davi o texto do email
	Local cFuncSent		:= "STWFR37"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	Local _cEmail  	    := _cEmail
	Local _cCopia     	:= Alltrim(GetMV("ST_MAILFIN")) //email do davi ect

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			//_cEmail := "everson.santana@steck.com.br"
			//_cCopia := ""
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)

Return()

//Ticket 20200131000266 - Everson Santana - 23/03/2020
User Function STWF38()

	Local cAliasSuper	:= 'STWF38'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")     // Valdemir Rabelo 19/01/2022

	cQuery += "	SELECT to_char(sysdate + 14,'YYYYMMDD'),RA_MAT,RA_NOME,RA_DEPTO,QB_DESCRIC,RA_VCTEXP2,RA_SALARIO,RA_XUSRSUP "
	cQuery += "	FROM "+RetSqlName("SRA")+" RA "
	cQuery += " LEFT JOIN "+RetSqlName("SQB")+" QB "
	cQuery += "     ON QB.QB_DEPTO = RA.RA_DEPTO "
	cQuery += "     AND QB.D_E_L_E_T_ = ' ' "
	cQuery += "	WHERE RA_VCTEXP2 = to_char(sysdate + 14,'YYYYMMDD')	 "
	cQuery += "	AND RA.D_E_L_E_T_ = ' ' "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		While (cAliasSuper)->(!Eof())

			aAdd(_aMsg, {"Matricula:   ", (cAliasSuper)->RA_MAT} 				)
			aAdd(_aMsg, {"Nome:        ", (cAliasSuper)->RA_NOME}   			)
			aAdd(_aMsg, {"Depto:       ", (cAliasSuper)->RA_DEPTO}   			)
			aAdd(_aMsg, {"Descrição:   ", (cAliasSuper)->QB_DESCRIC}   			)
			aAdd(_aMsg, {"Dt Vencimento:", Dtoc(Stod((cAliasSuper)->RA_VCTEXP2))}   	)

			If Empty((cAliasSuper)->RA_XUSRSUP)
				aAdd(_aMsg, {"Atenção","Superior não está cadastrado na SRA, Campo USR PRO SUP!!!"}   	)
			EndIf

			If Len(_aMsg) > 1
				_cEmail :=  UsrRetMail((cAliasSuper)->RA_XUSRSUP)
				STWFR38(_aMsg,_cEmail,''  ,'')
			EndIf

			_aMsg := {}

			(cAliasSuper)->(dbskip())

		End

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR38(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Aviso de vencimento da experiência'
	Local cFuncSent		:= "STWFR38"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin			:= 0
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	Local _cEmail  	    := _cEmail
	Local _cCopia     	:= Alltrim(GetMV("ST_MAILRH"))

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)

			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')

	EndIf
	RestArea(aArea)

Return()

User Function STWF39()

	Local cAliasSuper	:= 'STWF39'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ' '
	Local _cFil 		:= '01'
	Local _cEmp  		:= '11'

	RpcSetType( 3 )
	//RpcSetEnv(_cEmp,_cEmp,,,"FAT")
	RpcSetEnv(_cEmp,_cEmp,,,"FAT")              // Valdemir Rabelo 19/01/2022

	cQuery := " SELECT
	//SUA.R_E_C_N_O_,ZZY.R_E_C_N_O_ ,ZZI.R_E_C_N_O_   ,SUA.*,ZZY.*
	cQuery += " NVL(SUA.R_E_C_N_O_,0) AS SUAREC,NVL(ZZY.R_E_C_N_O_,0) AS ZZYREC,NVL(ZZI.R_E_C_N_O_ ,0) AS ZZIREC, UA_NUM AS ORCAMENTO,
	cQuery += " SA1.A1_COD||' - '||SA1.A1_NOME AS CLIENTE,
	cQuery += " SA3.A3_COD||' - '||SA3.A3_NOME AS VEND1,
	cQuery += " TA3.A3_COD||' - '||TA3.A3_NOME AS COORD,
	//cQuery += " TRIM(TA3.A3_EMAIL)||' ; '|| TRIM(CASE WHEN SUBSTR(SA3.A3_COD,1,1) = 'R' THEN   CASE WHEN SUBSTR(ZA3.A3_COD,1,1) = 'R' THEN  ' ' ELSE ZA3.A3_EMAIL END   ELSE SA3.A3_EMAIL END)  AS EMAILCOOR,
	cQuery += " TRIM(TA3.A3_EMAIL)||' ; '||TRIM( ZA3.A3_EMAIL)||' ; '|| TRIM(SA3.A3_EMAIL)   AS EMAILCOOR,
	cQuery += " SUA.UA_ZVALLIQ AS VALOR,
	cQuery += " SUBSTR(UA_EMISSAO,7,2)||'/'||SUBSTR(UA_EMISSAO,5,2)||'/'||SUBSTR(UA_EMISSAO,1,4) AS EMISSAO
	cQuery += " FROM "+RetSqlName("SUA")+" SUA
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+")SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND A1_COD = UA_CLIENTE
	cQuery += " AND A1_LOJA = UA_LOJA
	cQuery += " AND SUBSTR(A1_GRPVEN,1,1) IN ('D','R')
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("ZZY")+")ZZY
	cQuery += " ON ZZY.D_E_L_E_T_ = ' '
	cQuery += " AND ZZY.ZZY_NUM = UA_NUM AND ZZY.ZZY_DTINCL < '" + DtoS(dDataBase - 13) + "'
	cQuery += " AND ZZY_FILIAL = UA_FILIAL
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("ZZI")+")ZZI
	cQuery += " ON ZZI.D_E_L_E_T_ = ' '
	cQuery += " AND ZZI_NUM = UA_NUM
	cQuery += " AND ZZI_TIPO ='ORÇAMENTO'
	cQuery += " AND ZZI_FILANT = UA_FILIAL
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("SA3")+") SA3
	cQuery += " ON SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SA3.A3_COD = UA_VEND
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("SA3")+") ZA3
	cQuery += " ON ZA3.D_E_L_E_T_ = ' '
	cQuery += " AND ZA3.A3_COD = UA_VEND2
	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("SA3")+") TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' '
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " WHERE SUA.D_E_L_E_T_ = ' '
	cQuery += " AND UA_EMISSAO < '" + DtoS(dDataBase - 13) + "'
	cQuery += " AND UA_NUMSC5 = ' '
	cQuery += " AND UA_XBLOQ <> '3'
	cQuery += " AND UA_ZVALLIQ < 3000
	cQuery += " AND (ZZY.R_E_C_N_O_  IS NULL OR ZZY.R_E_C_N_O_ = (SELECT MAX(TZY.R_E_C_N_O_) AS REC FROM "+RetSqlName("ZZY")+" TZY
	cQuery += " WHERE TZY.D_E_L_E_T_ = ' ' AND TZY.ZZY_NUM = UA_NUM  )  )
	cQuery += " ORDER BY SA3.A3_COD, SUA.UA_ZVALLIQ DESC

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0
		_cCoord:= ' '

		While (cAliasSuper)->(!Eof())
			If _cCoord <> Alltrim((cAliasSuper)->VEND1)+' - '+Alltrim((cAliasSuper)->COORD)
				If Len(_aMsg) > 1
					STWFR39(_aMsg,_cmail ,_cECoor ,_cCoord)
					_aMsg:={}
				EndIf
				aadd(_aMsg,{"Cliente","Orçamento","Valor","Emissão"})
			EndIf

			aadd(_aMsg,{(cAliasSuper)->CLIENTE,;
				(cAliasSuper)->ORCAMENTO,;
				(cAliasSuper)->VALOR,;
				(cAliasSuper)->EMISSAO;
				} )

			_cCoord:= Alltrim((cAliasSuper)->VEND1)+' - '+Alltrim((cAliasSuper)->COORD)
			_cECoor:= (cAliasSuper)->EMAILCOOR

			DbSelectArea("SUA")
			SUA->(DbGoTo((cAliasSuper)->SUAREC ))
			If (cAliasSuper)->SUAREC    = SUA->(RECNO())
				SUA->(RecLock("SUA",.F.))
				SUA->UA_XCODMCA:= '000008'
				SUA->UA_XCODCAN:= '000008'
				SUA->UA_XBLOQ:= '3'
				SUA->UA_XDESBLQ:= 'X'
				SUA->UA_ZOBS:= DTOC(DATE())+' - AUTOMATICO '+ Alltrim(SUA->UA_ZOBS)
				SUA->(MsUnlock())
				SUA->( DbCommit() )
			EndIf
			If (cAliasSuper)->ZZIREC  <> 0
				DbSelectArea("ZZI")
				ZZI->(DbGoTo((cAliasSuper)->ZZIREC ))
				If (cAliasSuper)->ZZIREC    = ZZI->(RECNO())
					ZZI->(RecLock("ZZI",.F.))
					ZZI->ZZI_FILIAL:= '69'
					ZZI->(DbDelete())
					ZZI->(MsUnlock())
					ZZI->( DbCommit() )
				EndIf
			EndIf

			(cAliasSuper)->(dbskip())

		End
	EndIf

	If Len(_aMsg) > 1
		STWFR39(_aMsg,_cmail ,_cECoor ,_cCoord)
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR39(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Orçamentos Baixados: '+Alltrim(_CodNF)
	Local cFuncSent		:= "STWFR39"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= ' '
	default _cCopia  	:= ' '

	_cEmail		:= 'marcelo.oliveira@steck.com.br'
	//_cCopia:= ' '
	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + Transform(_aMsg[_nLin,3],"@E 999,999,999.99") + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')

	EndIf
	RestArea(aArea)

Return()

User Function STWF40()

	Local _cQuery     	:= ' '
	Local _cFil 		:= '01'    // 02 - Valdemir Rabelo 19/01/2022
	Local _cEmp  		:= '11'    // 01 - Valdemir Rabelo 19/01/2022

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cEmp,,,"FIN")

	_cQuery := " UPDATE " + RetSqlName("SE2") + " SET  E2_XBLQ = ' ',E2_USRINC = ' ',E2_XAPROV = ' '
	_cQuery += " WHERE E2_PREFIXO IN( 'EIC','EEC')
	_cQuery += " AND E2_XBLQ <> ' ' AND D_E_L_E_T_ = ' '

	TCSqlExec(_cQuery)

	//>> Ticket 20210720013212 - Everson Santana - 20.07.2021
	_cQuery     	:= ' '
	_cFil 		:= '01'
	_cEmp  		:= '03'

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cEmp,,,"FIN")

	_cQuery := " UPDATE SE2030 SET  E2_XBLQ = ' ',E2_USRINC = ' ',E2_XAPROV = ' '
	_cQuery += " WHERE E2_PREFIXO IN( 'EIC','EEC')
	_cQuery += " AND E2_XBLQ <> ' ' AND D_E_L_E_T_ = ' '

	TCSqlExec(_cQuery)
	//<< Ticket 20210720013212
Return
//>> Ticket 20200612002939 - Everson Santana - 18.06.2020
User Function STWF41()

	Local cAliasSuper	:= 'STWF41'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cEmail		:= ''
	Local _CodNF		:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")                // Valdemir Rabelo 19/01/2022

	cQuery += "	SELECT F2_FILIAL,F2_XOBSROM,F2_XCODROM,SF2.* FROM "+RetSqlName("SF2")+" SF2 "
	cQuery += "	WHERE F2_XOBSROM <> ' ' "
	cQuery += "  AND F2_XCODROM = ' ' "
	cQuery += "  AND F2_FILIAL = '"+xFilial('SF2')+"' "
	//>>Ticket 20200731004933
	cQuery += " AND (SELECT COUNT(*) FROM "+RetSqlName("PD2")+" PD2 WHERE  "
	cQuery += " PD2.PD2_FILIAL = SF2.F2_FILIAL "
	cQuery += " AND PD2.PD2_NFS = SF2.F2_DOC "
	cQuery += " AND PD2.PD2_SERIES = SF2.F2_SERIE "
	cQuery += " AND PD2.PD2_CLIENT = SF2.F2_CLIENTE "
	cQuery += " AND PD2.PD2_LOJCLI = SF2.F2_LOJA "
	cQuery += " AND PD2.D_E_L_E_T_ = ' '    "
	cQuery += " ) = 0 "
	//cQuery += "  AND F2_EMISSAO  > = to_char(sysdate - 90 ,'YYYYMMDD')  "
	//<<Ticket 20200731004933
	//cQuery += "  AND F2_DOC = '000391076' "
	cQuery += "  AND D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY F2_EMISSAO "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		While (cAliasSuper)->(!Eof())

			If Alltrim((cAliasSuper)->F2_VEND1) == Alltrim((cAliasSuper)->F2_VEND2)

				_cEmail	:= 	Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND1,"A3_EMAIL"))+";"+;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND1,"A3_SUPER")),"A3_EMAIL"))+";"+;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND1,"A3_GEREN")),"A3_EMAIL"))
			Else

				_cEmail	:= 	Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND1,"A3_EMAIL"))+";"+;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND2,"A3_EMAIL"))+";"+;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND1,"A3_SUPER")),"A3_EMAIL"))+";"+;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND2,"A3_SUPER")),"A3_EMAIL"))+";"+;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND1,"A3_GEREN")),"A3_EMAIL"))+";"+;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasSuper)->F2_VEND2,"A3_GEREN")),"A3_EMAIL"))

			EndIf

			_CodNF :=  Alltrim((cAliasSuper)->F2_DOC)
			aAdd(_aMsg, {"Observação:   	"	, Alltrim((cAliasSuper)->F2_XOBSROM)} 				)
			aAdd(_aMsg, {"Cod. Cliente:	 	"	, (cAliasSuper)->F2_CLIENTE}   			)
			aAdd(_aMsg, {"Cliente:      	"	,Posicione("SA1",1,xFilial("SA1")+(cAliasSuper)->(F2_CLIENTE+F2_LOJA),"A1_NOME")}   			)
			aAdd(_aMsg, {"Pedido:   		"	, Posicione("SD2",3,(cAliasSuper)->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO")} 	)
			aAdd(_aMsg, {"Transportadora:	"	, (cAliasSuper)->F2_TRANSP+" - "+Posicione("SA4",1,xFilial("SA4")+(cAliasSuper)->F2_TRANSP,"A4_NOME")}   	)
			aAdd(_aMsg, {"Tp. Entrega:		"	, IIf(Posicione("SC5",1,(cAliasSuper)->F2_FILIAL+Posicione("SD2",3,(cAliasSuper)->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO"),"C5_XTIPO")=="1","Retira","Entrega")}   	)
			aAdd(_aMsg, {"Dt Emissão:		"	, Dtoc(Stod((cAliasSuper)->F2_EMISSAO))}   	)
			aAdd(_aMsg, {"Ordem Compra: 	"	, Posicione("SC5",1,xFilial("SC5")+Posicione("SD2",3,(cAliasSuper)->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO"),"C5_XORDEM")} 	)
			aAdd(_aMsg, {"Qtd Volume: 		"	, Transform( (cAliasSuper)->F2_VOLUME1,"@E 9999")} 	)
			aAdd(_aMsg, {"Peso Bruto: 		"	, Transform((cAliasSuper)->F2_PBRUTO,"@E 999,999,999.999")} 	)
			If Len(_aMsg) > 1
				STWFR41(_aMsg,_cEmail,''  ,_CodNF)
			EndIf

			_CodNF := ''
			_aMsg := {}

			(cAliasSuper)->(dbskip())

		End

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR41(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= "Pendência para embarque no CD - NF "+AllTrim(_CodNF)+" "
	Local cFuncSent		:= "STWFR41"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin			:= 0
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	Local _cEmail  	    := _cEmail
	Local _cCopia     	:= ""

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		_cCopia := GetMv("ST_MAIL001",,"francisco.smania@steck.com.br")

		// Ticket: 20210330005139
		If SA1->A1_COD $ "092887x014519x028358x023789x038134x053211"
			_cCopia := Alltrim(_cCopia)
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)

			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf


			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

			//cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			//cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		//_cEmail := "everson.santana@steck.com.br"
		//_cCopia := ""
		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf
	EndIf
	RestArea(aArea)

Return()
//<< 20200612002939 - Everson Santana - 18.06.2020
//>> 20200616003035 - Everson Santana - 18.06.2020
User Function STWF42()

	Local cAliasSuper	:= 'STWF42'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cEmail		:= ''
	Local _xNomAprov	:= ''
	Local _xAprov		:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")                // Valdemir Rabelo 19/01/2022

	aadd(_aMsg,{ "Numero", "Nome" ,"Valor","Emissao", "Vencto Real","Incluido Por"  })

	cQuery += "	SELECT E2_XBLQ,SE2.* FROM " + RetSqlName("SE2") + " SE2"
	cQuery += "	WHERE E2_XBLQ = '1' "
	cQuery += "  AND E2_XAPROV <> ' ' "
	cQuery += "  AND E2_PREFIXO NOT IN( 'EIC','EEC') "
	cQuery += "  AND D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY E2_XAPROV "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		While (cAliasSuper)->(!Eof())

			_xAprov := (cAliasSuper)->E2_XAPROV

			While (cAliasSuper)->(!Eof()) .and. _xAprov == (cAliasSuper)->E2_XAPROV

				Aadd( _aMsg ,{(cAliasSuper)->E2_PREFIXO+(cAliasSuper)->E2_NUM+" - "+(cAliasSuper)->E2_PARCELA,;
					(cAliasSuper)->E2_NOMFOR,;
					transform(((cAliasSuper)->E2_VALOR)	,"@E 999,999,999.99") ,;
					Dtoc(stod((cAliasSuper)->E2_EMISSAO)),;
					Dtoc(stod((cAliasSuper)->E2_VENCREA)),;
					UsrRetName( (cAliasSuper)->E2_USRINC) } )

				_cEmail := UsrRetMail((cAliasSuper)->E2_XAPROV)
				_xNomAprov := UsrRetName((cAliasSuper)->E2_XAPROV)

				(cAliasSuper)->( dbskip() )

			End

			If Len(_aMsg) > 1
				STWFR42(_aMsg,_cEmail,''  ,_xNomAprov)
			EndIf

			_xNomAprov 	:= ''
			_cEmail		:= ''
			_aMsg := {}
			aadd(_aMsg,{ "Numero", "Nome" ,"Valor","Emissao", "Vencto Real","Incluido Por"  })

		End

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR42(_aMsg,_cEmail,_cCopia,_xNomAprov)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= "Solicitação de Aprovação Contas a Pagar - Resumo"
	Local cFuncSent		:= "STWFR42"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin			:= 0
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	Local _cEmail  	    := _cEmail
	Local _cCopia     	:= ""

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)


			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'

		cMsg += '<tr><td colspan="10" align="center"><font color="black" size="3">Aprovador: '+Alltrim(_xNomAprov)+'</td></tr>'
		cMsg += '<tr></tr>'
		cMsg += '<tr></tr>'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf
	EndIf
	RestArea(aArea)

Return()
//<< 20200616003035 - Everson Santana - 18.06.2020

//>> Everson Santana - 22.09.2020
User Function STWF43()

	Local cAliasSuper	:= 'STWF43'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cEmail		:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")                 // Valdemir Rabelo 19/01/2022

	_cEmail := "everson.santana@steck.com.br"

	aadd(_aMsg,{ "Filial", "Pedido" ,"Item","Quant SC6", "Quant SD2" })

	cQuery += "SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_QTDVEN, SUM(D2_QUANT) D2_QUANT "
	cQuery += " FROM "+RetSqlName('SC5010')+" C5 "
	cQuery += "  LEFT JOIN " + RetSqlName("SC6")+" C6 "
	cQuery += "  ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM "
	cQuery += "  LEFT JOIN " + RetSqlName("SD2")+" D2 "
	cQuery += " ON D2_FILIAL=C6_FILIAL AND D2_PEDIDO=C6_NUM AND D2_ITEMPV=C6_ITEM AND D2.D_E_L_E_T_=' ' "
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C5_EMISSAO>='20200101' "
	cQuery += " AND C6_FILIAL='02' AND C6_QTDENT>0 "
	cQuery += " HAVING SUM(D2_QUANT)>C6_QTDVEN "
	cQuery += " GROUP BY C6_FILIAL, C6_NUM, C6_ITEM, C6_QTDVEN "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		While (cAliasSuper)->(!Eof())

			Aadd( _aMsg ,{(cAliasSuper)->C6_FILIAL,;
				(cAliasSuper)->C6_NUM,;
				(cAliasSuper)->C6_ITEM,;
				transform(((cAliasSuper)->C6_QTDVEN)	,"@E 999,999,999.99") ,;
				transform(((cAliasSuper)->D2_QUANT)	,"@E 999,999,999.99")  } )

			(cAliasSuper)->( dbskip() )

		End

		If Len(_aMsg) > 1
			STWFR43(_aMsg,_cEmail,'')
		EndIf

		_cEmail		:= ''
		_aMsg := {}
		aadd(_aMsg,{ "Filial", "Pedido" ,"Item","Quant SC6", "Quant SD2" })

	End

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR43(_aMsg,_cEmail,_cCopia)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= "Atenção - Nota fiscal Duplicada"
	Local cFuncSent		:= "STWFR43"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin			:= 0
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	Local _cEmail  	    := _cEmail
	Local _cCopia     	:= ""

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)


			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				
			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				
			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'

		//cMsg += '<tr><td colspan="10" align="center"><font color="black" size="3">Aprovador: '+Alltrim(_xNomAprov)+'</td></tr>'
		cMsg += '<tr></tr>'
		cMsg += '<tr></tr>'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf
	EndIf
	RestArea(aArea)

Return()
//<< Everson Santana - 22.09.2020

/*/{Protheus.doc} STWF44
(long_description) Ticket 20201109010226 - WF para inconsistência entre as tabelas SD3 e CBA
Incluir no Schedule todos os dias as 07:00 horas - Enviar mesmo sem divergência.
@type  Static Function
@author user Eduardo Pereira - Sigamat
@since 01/12/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function STWF44()

	Local cAliasSuper	:= 'STWF44'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cEmail		:= ''
	Local _cCopia		:= ''

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")                     // Valdemir Rabelo 20/01/2022

	_cEmail := "kleber.braga@steck.com.br"
	_cCopia := "maurilio.francisquet@steck.com.br;marcelo.galera@steck.com.br"

	aAdd(_aMsg,{ "Filial", "Produto", "Endereço", "Data", "Tipo Movimento SD3", "Quant SD3", "Quant CBA" })

	cQuery += " SELECT D3_FILIAL, D3_COD, CBA_PROD, D3_QUANT, CBA_XQTDAJ, D3_LOCALIZ, CBA_LOCALI, D3_EMISSAO, CBA_DATA, D3_DOC, D3_TM "
	cQuery += " FROM " + RetSQLName("SD3") + " SD3 "
	cQuery += " INNER JOIN " + RetSQLName("CBA") + " CBA "
	cQuery += " ON D3_FILIAL = CBA_FILIAL AND CBA_DATA = D3_EMISSAO AND CBA_PROD = D3_COD AND CBA_LOCALI = D3_LOCALIZ AND CBA.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SD3.D_E_L_E_T_ = ' ' "
	cQuery += " AND SD3.D3_FILIAL='"+xFilial('SD3')+"' "                 // Vldemir Rabelo 20/01/2022
	cQuery += " AND  SD3.D3_TM =  CASE WHEN CBA.CBA_XQTDAJ < 0  THEN '999' ELSE '499' END " //Jackson - chamado: 20220805015198
	cQuery += " 	AND D3_DOC = 'INVENT' "
	cQuery += " 	AND D3_EMISSAO >= '"+DTOS(Date()-30)+"' "
	cQuery += " 	AND D3_QUANT <> ABS(CBA_XQTDAJ)
	cQuery += " ORDER BY D3_FILIAL, D3_COD, D3_EMISSAO, D3_TM "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->( dbCloseArea() )
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->( dbgotop() )

	If Select(cAliasSuper) > 0
		While (cAliasSuper)->( !Eof() )
			aAdd( _aMsg ,{	(cAliasSuper)->D3_FILIAL												,;	// 1. Filial
							(cAliasSuper)->D3_COD													,;	// 2. Produto
							(cAliasSuper)->D3_LOCALIZ												,;	// 3. Localização
							DtoC(StoD((cAliasSuper)->D3_EMISSAO))									,;	// 4. Data de Emissao
							(cAliasSuper)->D3_TM													,;	// 5. Tipo de Movimento
							Alltrim(Transform(((cAliasSuper)->D3_QUANT)	,"@E 999,999,999.99"))		,;	// 6. Quantidade SD3
							Alltrim(Transform(((cAliasSuper)->CBA_XQTDAJ)	,"@E 999,999,999.99"))  })	// 7. Quantidade Ajustar CBA
			(cAliasSuper)->( dbskip() )
		End
		//If Len(_aMsg) > 1
			STWFR44(_aMsg,_cEmail,_cCopia)
		//EndIf
		_cEmail	:= ''
		_cCopia	:= ''
		_aMsg 	:= {}
		aAdd(_aMsg,{ "Filial", "Produto", "Endereço", "Data", "Tipo Movimento SD3", "Quant SD3", "Quant CBA" })
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->( dbCloseArea() )
	EndIf

Return

/*/{Protheus.doc} STWFR44
(long_description) Ticket 20201109010226 - WF para inconsistência entre as tabelas SD3 e CBA - Montagem do corpo do e-mail
@type  Static Function
@author user Eduardo Pereira - Sigamat
@since 01/12/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function STWFR44(_aMsg,_cEmail,_cCopia)

	Local aArea 		:= GetArea()
	Local _cAssunto		:= "Atenção - Inconsistência entre as tabelas SD3 e CBA"
	Local cFuncSent		:= "STWFR44"
	Local cMsg     		:= ""
	Local _nLin			:= 0

	If ( Type("l410Auto") == "U" .Or. !l410Auto )
		// Definicao do cabecalho do email
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</FONT> </Caption>'
		// Definicao do texto/detalhe do email
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
			Else
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
			EndIf
		Next
		// Definicao do rodape do email
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr></tr>'
		cMsg += '<tr></tr>'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'
	If Dow(Date()) <> 1 .And. Dow(Date()) <> 7 // Domingo ---- Sabado
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf
	EndIf

	RestArea(aArea)

Return

/*/Protheus.doc STWF45
@(long_description) Ticket 20210120001051 - Melhorias- Contratos Parceria
Incluir no Schedule todos os dias as 07:00 horas - WF para Alerta de do termino de contrato, com base na vigência, sendo campo aberto para inclusão de data, conforme cláusulas contratuais (podendo variar por contrato).
@type Function STWF45
@author Eduardo Pereira - Sigamat
@since 05/02/2021
@version 12.1.25
/*/

User Function STWF45()

Local cQrySC3	:= ""
Local _aMsg 	:= {}
Local aDifData	:= {}
Local aQtde75	:= {}
Local _cEmail	:= ""
Local _cCopia	:= ""
Local nI		
Local cAssunto	:= ""

RpcSetType( 3 )
//RpcSetEnv("01","01",,,"COM")
RpcSetEnv("11","01",,,"COM")                     // Valdemir Rabelo 20/01/2022

_cEmail := "fernando.torres@steck.com.br;simone.paula@steck.com.br;ronaldo.fortunato@steck.com.br;julianny.bernardo@steck.com.br;cristiane.carvalho@steck.com.br;katia.oliveira@steck.com.br;ewerton.souza@steck.com.br;roberto.coelho@steck.com.br"
_cCopia := ""

aAdd(_aMsg,{ "Filial", "Nro Contrato", "Item", "Produto", "Data Final da Entrega", "Motivo" })

If Select("STWF45") > 0
    STWF45->( dbCloseArea() )
EndIf
cQrySC3 := " SELECT "
cQrySC3 += "    * "
cQrySC3 += " FROM " + RetSQLName("SC3")
cQrySC3 += " WHERE D_E_L_E_T_ = ' ' "
cQrySC3 += "    AND C3_ENCER = ' ' "
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQrySC3),"STWF45")

If Select("STWF45") > 0
	While STWF45->( !Eof() )
		nDif60 := StoD(STWF45->C3_DATPRF) - 60
		nQtde75	 := (STWF45->C3_QUJE / STWF45->C3_QUANT) * 100
		If dDataBase = nDif60	// 60 dias
			aAdd( _aMsg ,{	STWF45->C3_FILIAL					,;	// 1. Filial
							STWF45->C3_NUM						,;	// 2. Numero do Contrato
							STWF45->C3_ITEM						,;	// 3. Item
							STWF45->C3_PRODUTO					,;	// 4. Produto
							DtoC(StoD(STWF45->C3_DATPRF))		,;	// 5. Data Final de Entrega
							"D"									})	// 6. Dias da vigência
		EndIf
		If nQtde75 > 75 .Or. nQtde75 = 75
			aAdd( _aMsg ,{	STWF45->C3_FILIAL					,;	// 1. Filial
							STWF45->C3_NUM						,;	// 2. Numero do Contrato
							STWF45->C3_ITEM						,;	// 3. Item
							STWF45->C3_PRODUTO					,;	// 4. Produto
							DtoC(StoD(STWF45->C3_DATPRF))		,;	// 5. Data Final de Entrega
							"P"									})	// 6. Percentual
		EndIf
		STWF45->( dbSkip() )
	End
	If Len(_aMsg) > 1
		For nI := 1 to Len(_aMsg)
			If _aMsg[nI,6] == "D"
				aAdd(aDifData, {_aMsg[nI,1], _aMsg[nI,2], _aMsg[nI,3], _aMsg[nI,4], _aMsg[nI,5]} )
			ElseIf _aMsg[nI,6] == "P"
				aAdd(aQtde75, {_aMsg[nI,1], _aMsg[nI,2], _aMsg[nI,3], _aMsg[nI,4], _aMsg[nI,5]} )
			Else
				If nI = 1
					aAdd(aDifData,{ "Filial", "Nro Contrato", "Item", "Produto", "Data Final da Entrega", "Motivo" })
					aAdd(aQtde75,{ "Filial", "Nro Contrato", "Item", "Produto", "Data Final da Entrega", "Motivo" })
				EndIf
			EndIf
		Next
		If Len(aDifData) > 1
			cAssunto := "Atenção - Alerta de termino de contrato em 60 dias, com base na vigência"
			STWFR45(aDifData,_cEmail,_cCopia,cAssunto)
			_cEmail	 := ""
			_cCopia	 := ""
			_aMsg 	 := {}
			aDifData := {}
			aAdd(_aMsg,{ "Filial", "Nro Contrato", "Item", "Produto", "Data Final da Entrega", "Motivo" })
		EndIf
		If Len(aQtde75) > 1
			cAssunto := "Atenção - O contrato já esta com 75% de consumo"
			STWFR45(aQtde75,_cEmail,_cCopia,cAssunto)
			_cEmail	:= ""
			_cCopia	:= ""
			_aMsg 	:= {}
			aQtde75	:= {}
			aAdd(_aMsg,{ "Filial", "Nro Contrato", "Item", "Produto", "Data Final da Entrega", "Motivo" })
		EndIf
	EndIf
EndIf

Return

/*/Protheus.doc STWFR45
@(long_description) Ticket 20210120001051 - Melhorias- Contratos Parceria - Montagem do corpo do e-mail
WF para Alerta de do termino de contrato, com base na vigência, sendo campo aberto para inclusão de data, conforme cláusulas contratuais (podendo variar por contrato).
@type Function STWFR45
@author user Eduardo Pereira - Sigamat
@since 05/02/2021
@version 12.1.25
/*/

Static Function STWFR45(_aMsg,_cEmail,_cCopia,cAssunto)

	Local aArea 		:= GetArea()
	Local _cAssunto		:= cAssunto
	Local cFuncSent		:= "STWFR45"
	Local cMsg     		:= ""
	Local _nLin			:= 0

	If ( Type("l410Auto") == "U" .Or. !l410Auto )
		// Definicao do cabecalho do email
		cMsg := ""
		cMsg += '<html>'
		cMsg += '	<head>'
		cMsg += '		<title>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</title>'
		cMsg += '	</head>'
		cMsg += '	<body>'
		cMsg += '		<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '		<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '			<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</FONT> </Caption>'
		// Definicao do texto/detalhe do email
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '			<TR BgColor=#B0E2FF>'
			Else
				cMsg += '			<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1
				cMsg += '			<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '			<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '			<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '			<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '			<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
			Else
				cMsg += '			<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '			<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '			<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '			<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '			<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'				
			EndIf
			SC3->( dbSetOrder(1) )	// C3_FILIAL + C3_NUM + C3_ITEM
			If SC3->( dbSeek(xFilial("SC3") + _aMsg[_nLin,2] + _aMsg[_nLin,3]) )
				RecLock("SC3",.F.)
				SC3->C3_XENVWF := "S"
				SC3->( MsUnLock() )
				SC3->( dbCommit() )
			EndIf
		Next
		// Definicao do rodape do email
		cMsg += '		</Table>'
		cMsg += '		<P>'
		cMsg += '		<Table align="center">'
		cMsg += '			<tr></tr>'
		cMsg += '			<tr></tr>'
		cMsg += '			<tr>'
		cMsg += '				<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: ' + DtoC(Date()) + '-' + Time() + ' - <font color="red" size="1">(' + cFuncSent + ')</td>'
		cMsg += '			</tr>'
		cMsg += '		</Table>'
		cMsg += '		<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '	</body>'
		cMsg += '</html>'
		If Dow(Date()) <> 1 .And. Dow(Date()) <> 7 // Domingo ---- Sabado
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf
	EndIf

	RestArea(aArea)

Return
 