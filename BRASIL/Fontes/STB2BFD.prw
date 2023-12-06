#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)


User Function SB2XSBF(cEmpPrg,cFilPrg)

	Private cTime     := Time()
	Private cHora     := SUBSTR(cTime, 1, 2)
	Private cMinutos  := SUBSTR(cTime, 4, 2)
	Private cSegundos := SUBSTR(cTime, 7, 2)
	Private cAliasLif := 'SB2XSBF'+cHora+ cMinutos+cSegundos
	Private cQuery    := ' '
	Private _aSp      := {}
	Private _aAm      := {}
	Private _aSp02    := {}
	Private _aArg     := {}
	Private cEnvServer := Upper(GetEnvserv())
	Default cEmpPrg := "01"
	Default cFilPrg := "02"
	
	IF cEnvServer == "PROD" .Or. Left(cEnvServer,5) == "EMERG"  //Industria
		cEmpPrg := "11"
		cFilPrg := "01"	
	elseIf  cEnvServer == "P12" .or. Left(cEnvServer,9) == "P12_EMERG" //Distribuidora
		cEmpPrg := "01"
		cFilPrg := "02"		
	EndIf

	PREPARE ENVIRONMENT EMPRESA cEmpPrg FILIAL cFilPrg
	If cEmpPrg == "01" .And. cFilPrg == "02"
		cQuery := " SELECT 'SP'
		cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO",  B2_LOCAL "ARMAZEM",B2_QATU "ESTOQUE",B2_QACLASS "CLASSIFICAR", SUM (NVL(BF_QUANT,0)) "SBF", (B2_QATU-B2_QACLASS)- SUM (NVL(BF_QUANT,0)) AS "DIFERENCA"
		cQuery += " FROM SB2010 SB2
		cQuery += " LEFT JOIN(SELECT * FROM SBF010) SBF ON SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL
		cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' AND SUBSTR(SB2.B2_COD,1,3) <> 'MOD' AND Round((B2_QATU-B2_QACLASS),2)-  NVL((SELECT SUM (BF_QUANT)  FROM SBF010 SBF WHERE SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL),0) <> 0 GROUP BY B2_FILIAL,B2_COD,B2_CMFIM1,B2_LOCAL,B2_QATU,B2_QACLASS

		cQuery += " 	UNION
		cQuery += " SELECT 'SP'
		cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO MEDIO",  B2_LOCAL "ARMAZEM",B2_QATU "SALDO ESTOQUE - SB2 - B2_QATU",B2_QACLASS "SALDO A CLASSIFICAR B2_QACLASS", 0 "QTD NOS ENDEREгOS - SBF", (B2_QATU-B2_QACLASS) AS "DIFERENгA"
		cQuery += " FROM SB2010 SB2
		cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' AND SUBSTR(SB2.B2_COD,1,3) <> 'MOD'  AND ( SB2.B2_QATU < 0  OR  SB2.B2_QACLASS < 0)

		cQuery += " UNION
		cQuery += " SELECT 'SP'
		cQuery += '	"EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO MEDIO",  B2_LOCAL "ARMAZEM",B2_QATU "SALDO ESTOQUE - SB2 - B2_QATU",B2_QACLASS "SALDO A CLASSIFICAR B2_QACLASS", 0 "QTD NOS ENDEREгOS - SBF", (B2_QATU-B2_QACLASS) AS "DIFERENгA"
		cQuery += " FROM SB2010 SB2
		cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' AND     B2_FILIAL = '04'
		cQuery += " AND B2_LOCAL = '90'
		cQuery += " AND B2_QACLASS <> 0 AND SUBSTR(SB2.B2_COD,1,3) <> 'MOD'


		cQuery += " UNION
		cQuery += " SELECT 'AM'
		cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO",  B2_LOCAL "ARMAZEM",B2_QATU "ESTOQUE",B2_QACLASS "CLASSIFICAR", SUM (NVL(BF_QUANT,0)) "SBF", (B2_QATU-B2_QACLASS)- SUM (NVL(BF_QUANT,0)) AS "DIFERENCA"
		cQuery += " FROM SB2030 TB2
		cQuery += " LEFT JOIN(SELECT * FROM SBF030) SBF ON SBF.D_E_L_E_T_ = ' '  AND TB2.B2_COD = BF_PRODUTO  AND BF_FILIAL=TB2.B2_FILIAL AND BF_LOCAL=TB2.B2_LOCAL
		cQuery += " WHERE TB2.D_E_L_E_T_ = ' ' AND SUBSTR(TB2.B2_COD,1,3) <> 'MOD' AND Round((TB2.B2_QATU-TB2.B2_QACLASS),2)-  NVL((SELECT SUM (BF_QUANT)  FROM SBF030 SBF WHERE SBF.D_E_L_E_T_ = ' '  AND TB2.B2_COD = BF_PRODUTO  AND BF_FILIAL=TB2.B2_FILIAL AND BF_LOCAL=TB2.B2_LOCAL),0) <> 0 GROUP BY TB2.B2_FILIAL,TB2.B2_COD,TB2.B2_CMFIM1,TB2.B2_LOCAL,TB2.B2_QATU,TB2.B2_QACLASS

		cQuery += "  UNION
		cQuery += " SELECT 'AM'
		cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO MEDIO",  B2_LOCAL "ARMAZEM",B2_QATU "SALDO ESTOQUE - SB2 - B2_QATU",B2_QACLASS "SALDO A CLASSIFICAR B2_QACLASS", 0 "QTD NOS ENDEREгOS - SBF", (B2_QATU-B2_QACLASS) AS "DIFERENгA"
		cQuery += " FROM SB2030 SB2
		cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' AND SUBSTR(SB2.B2_COD,1,3) <> 'MOD' AND ( SB2.B2_QATU < 0  OR  SB2.B2_QACLASS < 0)

		cQuery += " 	UNION

		cQuery += " SELECT 'AR'
		cQuery += '  "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO",  B2_LOCAL "ARMAZEM",B2_QATU "ESTOQUE",B2_QACLASS "CLASSIFICAR", SUM (NVL(BF_QUANT,0)) "SBF", (B2_QATU-B2_QACLASS)- SUM (NVL(BF_QUANT,0)) AS "DIFERENCA"
		cQuery += "  FROM SB2070 TB2
		cQuery += "	  LEFT JOIN(SELECT * FROM SBF070) SBF ON SBF.D_E_L_E_T_ = ' '  AND TB2.B2_COD = BF_PRODUTO  AND BF_FILIAL=TB2.B2_FILIAL AND BF_LOCAL=TB2.B2_LOCAL
		cQuery += "  WHERE TB2.D_E_L_E_T_ = ' ' AND SUBSTR(TB2.B2_COD,1,3) <> 'MOD' AND Round((TB2.B2_QATU-TB2.B2_QACLASS),2)-  NVL((SELECT SUM (BF_QUANT)  FROM SBF070 SBF WHERE SBF.D_E_L_E_T_ = ' '  AND TB2.B2_COD = BF_PRODUTO  AND BF_FILIAL=TB2.B2_FILIAL AND BF_LOCAL=TB2.B2_LOCAL),0) <> 0 GROUP BY TB2.B2_FILIAL,TB2.B2_COD,TB2.B2_CMFIM1,TB2.B2_LOCAL,TB2.B2_QATU,TB2.B2_QACLASS

		cQuery += "   UNION
		cQuery += " SELECT 'AR'
		cQuery += '   "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO MEDIO",  B2_LOCAL "ARMAZEM",B2_QATU "SALDO ESTOQUE - SB2 - B2_QATU",B2_QACLASS "SALDO A CLASSIFICAR B2_QACLASS", 0 "QTD NOS ENDEREгOS - SBF", (B2_QATU-B2_QACLASS) AS "DIFERENгA"
		cQuery += "  FROM SB2070 SB2
		cQuery += "  WHERE SB2.D_E_L_E_T_ = ' ' AND SUBSTR(SB2.B2_COD,1,3) <> 'MOD' AND ( SB2.B2_QATU < 0  OR  SB2.B2_QACLASS < 0)
	else
		cQuery := " SELECT 'SP-DISTRIBUIDORA'
		cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO",  B2_LOCAL "ARMAZEM",B2_QATU "ESTOQUE",B2_QACLASS "CLASSIFICAR", SUM (NVL(BF_QUANT,0)) "SBF", (B2_QATU-B2_QACLASS)- SUM (NVL(BF_QUANT,0)) AS "DIFERENCA"
		cQuery += " FROM SB2110 SB2
		cQuery += " LEFT JOIN(SELECT * FROM SBF110) SBF ON SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL
		cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' AND SUBSTR(SB2.B2_COD,1,3) <> 'MOD' AND Round((B2_QATU-B2_QACLASS),2)-  NVL((SELECT SUM (BF_QUANT)  FROM SBF110 SBF WHERE SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL),0) <> 0 GROUP BY B2_FILIAL,B2_COD,B2_CMFIM1,B2_LOCAL,B2_QATU,B2_QACLASS

		cQuery += " 	UNION
		cQuery += " SELECT 'SP-DISTRIBUIDORA'
		cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO MEDIO",  B2_LOCAL "ARMAZEM",B2_QATU "SALDO ESTOQUE - SB2 - B2_QATU",B2_QACLASS "SALDO A CLASSIFICAR B2_QACLASS", 0 "QTD NOS ENDEREгOS - SBF", (B2_QATU-B2_QACLASS) AS "DIFERENгA"
		cQuery += " FROM SB2110 SB2
		cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' AND SUBSTR(SB2.B2_COD,1,3) <> 'MOD'  AND ( SB2.B2_QATU < 0  OR  SB2.B2_QACLASS < 0)
		
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		Aadd(_aSp,{"EMPRESA","B2_FILIAL","PRODUTO","CUSTO MEDIO","ARMAZEM","SALDO ESTOQUE - SB2 - B2_QATU","SALDO A CLASSIFICAR B2_QACLASS","QTD NOS ENDEREгOS - SBF","DIFERENгA" })
		Aadd(_aAm,{"EMPRESA","B2_FILIAL","PRODUTO","CUSTO MEDIO","ARMAZEM","SALDO ESTOQUE - SB2 - B2_QATU","SALDO A CLASSIFICAR B2_QACLASS","QTD NOS ENDEREгOS - SBF","DIFERENгA" })
		Aadd(_aSp02,{"EMPRESA","B2_FILIAL","PRODUTO","CUSTO MEDIO","ARMAZEM","SALDO ESTOQUE - SB2 - B2_QATU","SALDO A CLASSIFICAR B2_QACLASS","QTD NOS ENDEREгOS - SBF","DIFERENгA" })
		Aadd(_aArg,{"EMPRESA","B2_FILIAL","PRODUTO","CUSTO MEDIO","ARMAZEM","SALDO ESTOQUE - SB2 - B2_QATU","SALDO A CLASSIFICAR B2_QACLASS","QTD NOS ENDEREгOS - SBF","DIFERENгA" })

		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())

			If (cAliasLif)->EMPRESA = 'SP' .Or. (cAliasLif)->EMPRESA = 'SP-DISTRIBUIDORA'
				If (cAliasLif)->B2_FILIAL = '02' 
					Aadd(_aSp02,{ (cAliasLif)->EMPRESA, (cAliasLif)->B2_FILIAL,(cAliasLif)->PRODUTO,(cAliasLif)->CUSTO,(cAliasLif)->ARMAZEM,(cAliasLif)->ESTOQUE,(cAliasLif)->CLASSIFICAR,(cAliasLif)->SBF,(cAliasLif)->DIFERENCA         })
				Else
					Aadd(_aSp,{ (cAliasLif)->EMPRESA, (cAliasLif)->B2_FILIAL,(cAliasLif)->PRODUTO,(cAliasLif)->CUSTO,(cAliasLif)->ARMAZEM,(cAliasLif)->ESTOQUE,(cAliasLif)->CLASSIFICAR,(cAliasLif)->SBF,(cAliasLif)->DIFERENCA         })
				EndIf
			ElseIf (cAliasLif)->EMPRESA = 'AM'
				Aadd(_aAm,{ (cAliasLif)->EMPRESA, (cAliasLif)->B2_FILIAL,(cAliasLif)->PRODUTO,(cAliasLif)->CUSTO,(cAliasLif)->ARMAZEM,(cAliasLif)->ESTOQUE,(cAliasLif)->CLASSIFICAR,(cAliasLif)->SBF,(cAliasLif)->DIFERENCA         })
			Else
				Aadd(_aArg,{ (cAliasLif)->EMPRESA, (cAliasLif)->B2_FILIAL,(cAliasLif)->PRODUTO,(cAliasLif)->CUSTO,(cAliasLif)->ARMAZEM,(cAliasLif)->ESTOQUE,(cAliasLif)->CLASSIFICAR,(cAliasLif)->SBF,(cAliasLif)->DIFERENCA         })
			EndIf
			(cAliasLif)->(dbSkip())
		End

	EndIf
	(cAliasLif)->(dbCloseArea())
	If len(_aSp) > 1
		SB2MSBF(_aSp)
	EndIf
	If len(_aSp02) > 1
		SB2MSBF(_aSp02)
	EndIf
	If len(_aAm) > 1
		SB2MSBF(_aAm)
	EndIf
	If len(_aArg) > 1
		SB2MSBF(_aArg)
	EndIf


Return()



Static Function SB2MSBF(_aMsg)
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Monitoramento de Tabelas SB2 x SBF'
	Local cFuncSent:= "SB2MSBF"
	Local _nLMai   := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := 'everson.santana@STECK.COM.BR'
	Local cAttach  := ''
	Local _cEmail  := ' '

	//	aSort(_aMsg  ,,, { |x,y| y[5] > x[5]} )
	// GETMV - Adicionado 27/07/2021 - Valdemir Rabelo Ticket: 20210727013838
	If _aMsg[2,1] = 'SP' .Or. _aMsg[2,1] = 'SP-DISTRIBUIDORA'
		If _aMsg[2,2] = '02'
			_cEmail  := getmv("STB2BFDSP2",.f.,'reinaldo.franca@steck.com.br; kleber.braga@steck.com.br')
			_cAssunto:= 'Monitoramento de Tabelas SB2 x SBF e Estoque Negativo - SЦo Paulo'
		ElseIf _aMsg[2,1] = 'SP-DISTRIBUIDORA'
			_cEmail  := getmv("STB2BFDSP5",.f.,'reinaldo.franca@steck.com.br;kleber.braga@steck.com.br; jefferson.puglia@steck.com.br')
			_cAssunto:= 'Monitoramento de Tabelas SB2 x SBF e Estoque Negativo - SЦo Paulo-Distribuidora'
		Else
			_cEmail  := getmv("STB2BFDSP5",.f.,'reinaldo.franca@steck.com.br;wendel.cabral@steck.com.br; jefferson.ferreira@steck.com.br')
			_cAssunto:= 'Monitoramento de Tabelas SB2 x SBF e Estoque Negativo - SЦo Paulo-Guararema'
		EndIf
	ElseIf _aMsg[2,1] = 'AM'
		_cEmail  := getmv("STB2BFDAM1",.f.,'reinaldo.franca@steck.com.br')
		_cAssunto:= 'Monitoramento de Tabelas SB2 x SBF e Estoque Negativo - Manaus'
	Else
		_cEmail  := getmv("STB2BFDARG",.f.,'rosana.amato@steckgroup.com; gabriela.marchetta@steckgroup.com; thiago.camara@steck.com.br')
		_cAssunto:= 'Monitoreo de mesa SB2 x SBF e Stock negativo - Argentina'
	EndIf

	If __cuserid = '000000'
		_cAssunto:=_cAssunto+ " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + '</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For _nLin := 1 to Len(_aMsg)

			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,1] 	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,2] 	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,3]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,4]  	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,5]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,6]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,7]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,8]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,9]   	+ ' </Font></B></TD>'
				cMsg += '</TR>'
			Else
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,1] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,2] 				+ ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,3]				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,4])  	+ ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,5]   				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,6])    + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,7])    + ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,8])    + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,9])    + ' </Font> </TD>'
				cMsg += '</TR>'
			EndIF

			If _nLMai = 1000
				_nLMai:= 0

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Definicao do rodape do email                                                Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Definicao do cabecalho do email                                             Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title>' + _cAssunto + '</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'

			EndIF

			_nLMai++
		Next
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)

Return()

User Function SD3DIF(cEmpPrg,cFilPrg)

	Private cTime     := Time()
	Private cHora     := SUBSTR(cTime, 1, 2)
	Private cMinutos  := SUBSTR(cTime, 4, 2)
	Private cSegundos := SUBSTR(cTime, 7, 2)
	Private cAliasLif := 'SD3DIF'+cHora+ cMinutos+cSegundos
	Private cQuery    := ' '
	Private _aSp      := {}
	Private _aAm      := {}
	Private cEnvServer := Upper(GetEnvserv())
	Default cEmpPrg := "01"
	Default cFilPrg := "02"
	
	IF cEnvServer == "PROD" .Or. Left(cEnvServer,5) == "EMERG"  //Industria
		cEmpPrg := "11"
		cFilPrg := "01"	
	elseIf  cEnvServer == "P12" .or. Left(cEnvServer,9) == "P12_EMERG" //Distribuidora
		cEmpPrg := "01"
		cFilPrg := "02"		
	EndIf

	PREPARE ENVIRONMENT EMPRESA cEmpPrg FILIAL cFilPrg
	If cEmpPrg == "01"
		cQuery := " SELECT 'SP'
		cQuery += ' "EMPRESA",
		cQuery += " D3_FILIAL, D3_TM , D3_COD    ,       D3_UM    , D3_QUANT    , D3_CF  ,   D3_CONTA    ,          D3_OP ,         D3_LOCAL  ,   D3_DOC,     D3_EMISSAO ,    D3_GRUPO FROM SD3010 SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND SD3.D3_EMISSAO > '20160801' AND SD3.D3_CF = 'RE4'AND (SD3.D3_FILIAL = '02' OR   SD3.D3_FILIAL = '04')AND NOT EXISTS(SELECT *
		cQuery += " FROM SD3010 TD3 WHERE TD3.D_E_L_E_T_ = ' ' AND TD3.D3_CF = 'DE4' AND SD3.D3_DOC = TD3.D3_DOC AND SD3.D3_FILIAL = TD3.D3_FILIAL ) union
		cQuery += " SELECT  'SP'
		cQuery += ' "EMPRESA",
		cQuery += " D3_FILIAL, D3_TM , D3_COD    ,       D3_UM    , D3_QUANT    , D3_CF  ,   D3_CONTA    ,          D3_OP ,         D3_LOCAL  ,   D3_DOC,     D3_EMISSAO ,    D3_GRUPO FROM SD3010 SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND SD3.D3_EMISSAO > '20160801' AND SD3.D3_CF = 'DE4'AND (SD3.D3_FILIAL = '02' OR   SD3.D3_FILIAL = '04')AND NOT EXISTS(SELECT *
		cQuery += " FROM SD3010 TD3 WHERE TD3.D_E_L_E_T_ = ' ' AND TD3.D3_CF = 'RE4' AND SD3.D3_DOC = TD3.D3_DOC AND SD3.D3_FILIAL = TD3.D3_FILIAL )UNION
		cQuery += " SELECT  'AM'
		cQuery += ' "EMPRESA",
		cQuery += " D3_FILIAL, D3_TM , D3_COD    ,       D3_UM    , D3_QUANT    , D3_CF  ,   D3_CONTA    ,          D3_OP ,         D3_LOCAL  ,   D3_DOC,     D3_EMISSAO ,    D3_GRUPO FROM SD3030 SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND SD3.D3_EMISSAO > '20160801' AND SD3.D3_CF = 'RE4'AND (SD3.D3_FILIAL = '01' OR   SD3.D3_FILIAL = '01')AND NOT EXISTS(SELECT *
		cQuery += " FROM SD3030 TD3 WHERE TD3.D_E_L_E_T_ = ' ' AND TD3.D3_CF = 'DE4' AND SD3.D3_DOC = TD3.D3_DOC AND SD3.D3_FILIAL = TD3.D3_FILIAL ) union
		cQuery += " SELECT  'AM'
		cQuery += ' "EMPRESA",
		cQuery += " D3_FILIAL, D3_TM , D3_COD    ,       D3_UM    , D3_QUANT    , D3_CF  ,   D3_CONTA    ,          D3_OP ,         D3_LOCAL  ,   D3_DOC,     D3_EMISSAO ,    D3_GRUPO FROM SD3030 SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND SD3.D3_EMISSAO > '20160801' AND SD3.D3_CF = 'DE4'AND (SD3.D3_FILIAL = '01' OR   SD3.D3_FILIAL = '01')AND NOT EXISTS(SELECT *
		cQuery += " FROM SD3030 TD3 WHERE TD3.D_E_L_E_T_ = ' ' AND TD3.D3_CF = 'RE4' AND SD3.D3_DOC = TD3.D3_DOC AND SD3.D3_FILIAL = TD3.D3_FILIAL )
	else
		cQuery := " SELECT 'SP-DISTRIBUIDORA'
		cQuery += ' "EMPRESA",
		cQuery += " D3_FILIAL, D3_TM , D3_COD    ,       D3_UM    , D3_QUANT    , D3_CF  ,   D3_CONTA    ,          D3_OP ,         D3_LOCAL  ,   D3_DOC,     D3_EMISSAO ,    D3_GRUPO FROM SD3110 SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND SD3.D3_EMISSAO > '20160801' AND SD3.D3_CF = 'RE4'AND (SD3.D3_FILIAL = '01' OR   SD3.D3_FILIAL = '02')AND NOT EXISTS(SELECT *
		cQuery += " FROM SD3110 TD3 WHERE TD3.D_E_L_E_T_ = ' ' AND TD3.D3_CF = 'DE4' AND SD3.D3_DOC = TD3.D3_DOC AND SD3.D3_FILIAL = TD3.D3_FILIAL )
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		Aadd(_aSp,{"EMPRESA","D3_FILIAL","D3_COD","D3_UM","D3_QUANT","D3_CF","D3_CONTA","D3_OP","D3_LOCAL" ,"D3_DOC","D3_EMISSAO" ,"D3_GRUPO" })
		Aadd(_aAm,{"EMPRESA","D3_FILIAL","D3_COD","D3_UM","D3_QUANT","D3_CF","D3_CONTA","D3_OP","D3_LOCAL" ,"D3_DOC","D3_EMISSAO" ,"D3_GRUPO" })

		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())

			If (cAliasLif)->EMPRESA = 'SP' .OR. (cAliasLif)->EMPRESA = 'SP-DISTRIBUIDORA'
				Aadd(_aSp,{ (cAliasLif)->EMPRESA, (cAliasLif)->D3_FILIAL,(cAliasLif)->D3_COD,(cAliasLif)->D3_UM,(cAliasLif)->D3_QUANT,(cAliasLif)->D3_CF,(cAliasLif)->D3_CONTA,(cAliasLif)->D3_OP,(cAliasLif)->D3_LOCAL,(cAliasLif)->D3_DOC,(cAliasLif)->D3_EMISSAO,(cAliasLif)->D3_GRUPO           })
			Else
				Aadd(_aAm,{ (cAliasLif)->EMPRESA, (cAliasLif)->D3_FILIAL,(cAliasLif)->D3_COD,(cAliasLif)->D3_UM,(cAliasLif)->D3_QUANT,(cAliasLif)->D3_CF,(cAliasLif)->D3_CONTA,(cAliasLif)->D3_OP,(cAliasLif)->D3_LOCAL,(cAliasLif)->D3_DOC,(cAliasLif)->D3_EMISSAO,(cAliasLif)->D3_GRUPO           })
			EndIf
			(cAliasLif)->(dbSkip())
		End

	EndIf
	(cAliasLif)->(dbCloseArea())
	If len(_aSp) > 1
		SD3MAIL(_aSp)
	EndIf
	If len(_aAm) > 1
		SD3MAIL(_aAm)
	EndIf

Return()

Static Function SD3MAIL(_aMsg)
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Monitoramento de Perneta'
	Local cFuncSent:= "SD3MAIL"
	Local _nLMai   := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := 'everson.santana@STECK.COM.BR'
	Local cAttach  := ''
	Local _cEmail  := ' '

	_cEmail  := getmv("ST_B2BFSD3",.f.,'reinaldo.franca@steck.com.br')

	If __cuserid = '000000'
		_cAssunto:=_cAssunto+ " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + '</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For _nLin := 1 to Len(_aMsg)

			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,1] 	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,2] 	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,3]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,4]  	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,5]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,6]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,7]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,8]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,9]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,10]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,11]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,12]   	+ ' </Font></B></TD>'
				cMsg += '</TR>'
			Else
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,1] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,2] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,3]				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,4] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ CVALTOCHAR(_aMsg[_nLin,5]) 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+  _aMsg[_nLin,6]				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,7] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,8] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,9]				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,10] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,11] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,12]				+ ' </Font> </TD>'
				cMsg += '</TR>'
			EndIF

			If _nLMai = 1000
				_nLMai:= 0


				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Definicao do rodape do email                                                Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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


				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)


				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Definicao do cabecalho do email                                             Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title>' + _cAssunto + '</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'



			EndIF

			_nLMai++
		Next
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)



Return()

//************************************************************************************************************




User Function SDCDUPLIC()


	Private cTime     := Time()
	Private cHora     := SUBSTR(cTime, 1, 2)
	Private cMinutos  := SUBSTR(cTime, 4, 2)
	Private cSegundos := SUBSTR(cTime, 7, 2)
	Private cAliasLif := 'SB2XSBF'+cHora+ cMinutos+cSegundos
	Private cQuery    := ' '
	Private _aSp      := {}
	Private _aAm      := {}



	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	cQuery := " SELECT 'SP'
	cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO",  B2_LOCAL "ARMAZEM",B2_QATU "ESTOQUE",B2_QACLASS "CLASSIFICAR", SUM (BF_QUANT) "SBF", (B2_QATU-B2_QACLASS)- SUM (BF_QUANT) AS "DIFERENCA"
	cQuery += " FROM SB2010 SB2
	cQuery += " INNER JOIN(SELECT * FROM SBF010) SBF ON SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' and B2_FILIAL <> '01' AND (B2_QATU-B2_QACLASS)-  NVL((SELECT SUM (BF_QUANT)  FROM SBF010 SBF WHERE SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL),0) <> 0 GROUP BY B2_FILIAL,B2_COD,B2_CMFIM1,B2_LOCAL,B2_QATU,B2_QACLASS

	cQuery += " UNION
	cQuery += " SELECT 'AM'
	cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO",  B2_LOCAL "ARMAZEM",B2_QATU "ESTOQUE",B2_QACLASS "CLASSIFICAR", SUM (BF_QUANT) "SBF", (B2_QATU-B2_QACLASS)- SUM (BF_QUANT) AS "DIFERENCA"
	cQuery += " FROM SB2030 TB2
	cQuery += " INNER JOIN(SELECT * FROM SBF030) SBF ON SBF.D_E_L_E_T_ = ' '  AND TB2.B2_COD = BF_PRODUTO  AND BF_FILIAL=TB2.B2_FILIAL AND BF_LOCAL=TB2.B2_LOCAL
	cQuery += " WHERE TB2.D_E_L_E_T_ = ' '  AND (TB2.B2_QATU-TB2.B2_QACLASS)-  NVL((SELECT SUM (BF_QUANT)  FROM SBF030 SBF WHERE SBF.D_E_L_E_T_ = ' '  AND TB2.B2_COD = BF_PRODUTO  AND BF_FILIAL=TB2.B2_FILIAL AND BF_LOCAL=TB2.B2_LOCAL),0) <> 0 GROUP BY TB2.B2_FILIAL,TB2.B2_COD,TB2.B2_CMFIM1,TB2.B2_LOCAL,TB2.B2_QATU,TB2.B2_QACLASS



	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		Aadd(_aSp,{"EMPRESA","B2_FILIAL","PRODUTO","CUSTO MEDIO","ARMAZEM","SALDO ESTOQUE - SB2 - B2_QATU","SALDO A CLASSIFICAR B2_QACLASS","QTD NOS ENDEREгOS - SBF","DIFERENгA" })
		Aadd(_aAm,{"EMPRESA","B2_FILIAL","PRODUTO","CUSTO MEDIO","ARMAZEM","SALDO ESTOQUE - SB2 - B2_QATU","SALDO A CLASSIFICAR B2_QACLASS","QTD NOS ENDEREгOS - SBF","DIFERENгA" })

		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())

			If (cAliasLif)->EMPRESA = 'SP'
				Aadd(_aSp,{ (cAliasLif)->EMPRESA, (cAliasLif)->B2_FILIAL,(cAliasLif)->PRODUTO,(cAliasLif)->CUSTO,(cAliasLif)->ARMAZEM,(cAliasLif)->ESTOQUE,(cAliasLif)->CLASSIFICAR,(cAliasLif)->SBF,(cAliasLif)->DIFERENCA         })
			Else
				Aadd(_aAm,{ (cAliasLif)->EMPRESA, (cAliasLif)->B2_FILIAL,(cAliasLif)->PRODUTO,(cAliasLif)->CUSTO,(cAliasLif)->ARMAZEM,(cAliasLif)->ESTOQUE,(cAliasLif)->CLASSIFICAR,(cAliasLif)->SBF,(cAliasLif)->DIFERENCA         })
			EndIf
			(cAliasLif)->(dbSkip())
		End




	EndIf
	(cAliasLif)->(dbCloseArea())
	If len(_aSp) > 1
		SB2MSBF(_aSp)
	EndIf
	If len(_aAm) > 1
		SB2MSBF(_aAm)
	EndIf

Return()



Static Function XSDCDUPLIC(_aMsg)
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Monitoramento de Tabelas SDC (EMPENHO DUPLICADO)'
	Local cFuncSent:= "SDCDUPLIC"
	Local _nLMai   := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := 'everson.santana@STECK.COM.BR'
	Local cAttach  := ''
	Local _cEmail  := ' '

	//	aSort(_aMsg  ,,, { |x,y| y[5] > x[5]} )
	If _aMsg[2,1] = 'SP'
		_cEmail  := GETMV("STSPSDCDUP",.F.,'ULISSES.ALMEIDA@STECK.COM.BR;reinaldo.franca@steck.com.br')
		_cAssunto:= 'Monitoramento de Tabelas SB2 x SBF - SЦo Paulo'
	Else
		_cEmail  := GETMV("ST_SDCDUPL",.F.,'willians.silva@steck.com.br ;reinaldo.franca@steck.com.br')
		_cAssunto:= 'Monitoramento de Tabelas SB2 x SBF - Manaus'
	EndIf


	If __cuserid = '000000'
		_cAssunto:=_cAssunto+ " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf


	If ( Type("l410Auto") == "U" .OR. !l410Auto )


		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + '</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For _nLin := 1 to Len(_aMsg)

			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,1] 	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,2] 	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,3]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,4]  	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,5]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,6]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,7]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,8]   	+ ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,9]   	+ ' </Font></B></TD>'
				cMsg += '</TR>'
			Else
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,1] 				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,2] 				+ ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,3]				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,4])  	+ ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ _aMsg[_nLin,5]   				+ ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,6])    + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,7])    + ' </Font> </TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,8])    + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' 	+ cValToChar(_aMsg[_nLin,9])    + ' </Font> </TD>'
				cMsg += '</TR>'
			EndIF

			If _nLMai = 1000
				_nLMai:= 0


				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Definicao do rodape do email                                                Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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


				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)


				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Definicao do cabecalho do email                                             Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title>' + _cAssunto + '</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'



			EndIF

			_nLMai++
		Next
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)



Return()
