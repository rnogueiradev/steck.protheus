#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STCUSTO             | Autor | GIOVANI.ZAGO          | Data | 28/05/2014  |
|=====================================================================================|
|Descri็ใo |  Retorna CUSTO DO PRODUTO		                                          |
|          | 'I'  Importado  1- Utilizo Ultima Entrada na Empresa.                    |
|          | 'C'  Comprado   1- Uso Campo B1_XPCSTK  Custo de Manaus                  |
|          |                 2- Utilizo Ultima Entrada na Empresa com ate 120 dias    |
|          |                 3- Verifico campo B1_XCUSCOM pre็o or็ado p/ Compras 120d|
|          | 'F'  Fabricado  1- Grupos 035/036 Custo Medio da Filial 04               |
|          |                 2- Custo Medio da Filial 01			                  |
|          |Obs.: caso seja unicon considerar 120 dias para efeito de custo           |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCUSTO                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/
*---------------------------*
User Function STCUSTO(_cProd,_lWf)
	*---------------------------*
	Local _aArea	:= GetArea()
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := 'STCUSTO'+cHora+ cMinutos+cSegundos
	Local cQuery    := ' '
	Local  _nQut    := 0
	Local  _nVal    := 0
	Local  _nCust   := 0
	Local _lUnicon  := !(IsInCallSteck("U_STCONSPROD") .Or. IsInCallSteck("U_RSTFAT23") .Or. IsInCallSteck("U_STTELALC")  )  //Chamado 003190

	Default _lWf := .T.
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	If SB1->(DbSeek(xFilial("SB1")+_cProd))
		If GetMv("ST_CUSXX",,.F.) .And. SB1->B1_XPCSTK  <> 0 .And. _lWf
			_nCust:= SB1->B1_XPCSTK
			Return(round(_nCust,2))
		EndIf
		// IMPORTADOS *******************************************************************************************************************************************
		If   SB1->B1_CLAPROD = 'I'  //Importado Pego a Ultima entrada na Empresa // alterado para custo medio giovani zago 18/12/18

			//Custo medio
			cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
			cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
			cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
			cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
			cQuery += " AND   SB2.B2_LOCAL = '"+SB1->B1_LOCPAD+"'"
			If cEmpAnt=="01"
				cQuery += " AND   SB2.B2_FILIAL= '02'"
			EndIf
			cQuery += " ORDER BY SB2.R_E_C_N_O_ DESC

			cQuery := ChangeQuery(cQuery)

			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
			dbSelectArea(cAliasLif)

			If  Select(cAliasLif) > 0
				(cAliasLif)->(dbgotop())
				_nCust  := (cAliasLif)->B2_CMFIM1
			EndIf

			(cAliasLif)->(dbCloseArea())

			If   _nCust = 0

				cQuery := " SELECT D1_VUNIT
				cQuery += ' "SALDO"
				cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
				cQuery += " INNER JOIN (SELECT *
				cQuery += " FROM  "+RetSqlName("SA2")+") SA2 "
				cQuery += " ON SA2.D_E_L_E_T_ = ' '
				cQuery += " AND SA2.A2_COD = SD1.D1_FORNECE
				cQuery += " AND SA2.A2_LOJA = SD1.D1_LOJA
				cQuery += " AND SA2.A2_EST = 'EX'
				cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
				cQuery += " AND SD1.D1_COD = '"+SB1->B1_COD+"'"
				cQuery += " AND SD1.D1_FORNECE <> '005764'
				cQuery += " AND SD1.D1_TIPO = 'N'
				If _lUnicon
					//	cQuery += " AND SD1.D1_EMISSAO >= '"+DTOS(DATE()-120)+"'
				EndIf
				cQuery += " ORDER BY   SD1.R_E_C_N_O_ DESC

				cQuery := ChangeQuery(cQuery)

				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
				dbSelectArea(cAliasLif)

				If  Select(cAliasLif) > 0
					(cAliasLif)->(dbgotop())
					_nCust  := (cAliasLif)->SALDO
				EndIf

				//	If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
				//	EndIf

				//caso nao encontre entrada de importado pega a ultima transferencia entre steck
				If !_lUnicon  .And. _nCust = 0

					cQuery := " SELECT D1_VUNIT
					cQuery += ' "SALDO"
					cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
					cQuery += " INNER JOIN (SELECT *
					cQuery += " FROM  "+RetSqlName("SA2")+") SA2 "
					cQuery += " ON SA2.D_E_L_E_T_ = ' '
					cQuery += " AND SA2.A2_COD = SD1.D1_FORNECE
					cQuery += " AND SA2.A2_LOJA = SD1.D1_LOJA
					cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
					cQuery += " AND SD1.D1_COD = '"+SB1->B1_COD+"'"
					cQuery += " AND SD1.D1_FORNECE = '005764'
					cQuery += " AND SD1.D1_TIPO = 'N'
					cQuery += " ORDER BY   SD1.R_E_C_N_O_ DESC

					cQuery := ChangeQuery(cQuery)

					If Select(cAliasLif) > 0
						(cAliasLif)->(dbCloseArea())
					EndIf

					dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
					dbSelectArea(cAliasLif)
					If  Select(cAliasLif) > 0
						(cAliasLif)->(dbgotop())
						_nCust  := (cAliasLif)->SALDO
					EndIf

					//	If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
					//	EndIf
				EndIf
			EndIf
			// USO O VALOR DO PREวO ORวADO POR COMPRAS
			If  !(_nCust > 0) .And. SB1->B1_XCUSCOM  > 0 .And.  date()  <= SB1->B1_XDTCOM
				_nCust  := SB1->B1_XCUSCOM
			EndIf

			// COMPRADOS *******************************************************************************************************************************************
		ElseIf SB1->B1_CLAPROD = 'C'

			//If SB1->B1_XPCSTK  <> 0 //Custo de manaus carga diaria
			//Custo medio manaus

			_cEmpresa := cEmpAnt

			/***********************************************
			<<< Altera็ใo >>>
			A็ใo..........: Quando a empresa for "11" - NEWCOR nใo entra na valida็ใo
			Desenvolvedor.: Marcelo Klopfer Leme - SIGAMAT
			Data..........: 21/12/2021
			***********************************************/
			IF _cEmpresa <> "11"

				If U_STGETORI(SB1->B1_COD,"03")=="F" //Se for fabricado em MAO pega o custo de MAO
					_cEmpresa := "03"
				EndIf

			ENDIF

			cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
			cQuery += " FROM SB2"+_cEmpresa+"0 SB2 "
			cQuery += " LEFT JOIN SB1"+_cEmpresa+"0 B1
			cQuery += " ON B1_COD=B2_COD
			cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_=' '
			cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
			cQuery += " AND   SB2.B2_LOCAL = B1.B1_LOCPAD
			cQuery += " AND   SB2.B2_FILIAL= '01'"
			cQuery += " ORDER BY SB2.R_E_C_N_O_ DESC

			cQuery := ChangeQuery(cQuery)

			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
			dbSelectArea(cAliasLif)
			If  Select(cAliasLif) > 0
				(cAliasLif)->(dbgotop())
				_nCust  := (cAliasLif)->B2_CMFIM1
			EndIf

			If _nCust = 0 //Chamado 008744

				cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
				cQuery += " FROM SB2"+_cEmpresa+"0 SB2 "
				cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
				cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"' AND B2_CMFIM1>0
				//cQuery += " AND   SB2.B2_FILIAL= '01'"
				cQuery += " ORDER BY SB2.B2_LOCAL

				cQuery := ChangeQuery(cQuery)

				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
				dbSelectArea(cAliasLif)
				If  Select(cAliasLif) > 0
					(cAliasLif)->(dbgotop())
					_nCust  := (cAliasLif)->B2_CMFIM1
				EndIf

			EndIf

			If _nCust = 0

				cQuery := " SELECT D1_VUNIT
				cQuery += ' "SALDO"
				cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
				cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
				cQuery += " AND SD1.D1_COD 	  = '"+SB1->B1_COD+"'"
				cQuery += " AND SD1.D1_FORNECE <> '005764'
				cQuery += " AND SD1.D1_FORNECE <> '005866'
				cQuery += " AND SD1.D1_TIPO = 'N'
				If _lUnicon .And. STCLAAM(_cProd)<>"F"  // Chamado 003219
					cQuery += " AND SD1.D1_EMISSAO >= '"+DTOS(DATE()-120)+"'
				EndIf
				cQuery += " ORDER BY   SD1.R_E_C_N_O_ DESC

				cQuery := ChangeQuery(cQuery)

				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
				dbSelectArea(cAliasLif)
				If  Select(cAliasLif) > 0
					(cAliasLif)->(dbgotop())
					_nCust  := (cAliasLif)->SALDO
				EndIf

				//	If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
				//	EndIf

				// USO O VALOR DO PREวO ORวADO POR COMPRAS
				If  !(_nCust > 0) .And. SB1->B1_XCUSCOM  > 0 .And.  date()  <= SB1->B1_XDTCOM
					_nCust  := SB1->B1_XCUSCOM
				EndIf
			EndIf

			// FABRICADOS *******************************************************************************************************************************************
		ElseIf SB1->B1_CLAPROD = 'F'
			/*
			DbSelectArea("SG1")
			SG1->(dbgotop())
			SG1->(DbSetOrder(1))
			If SG1->(dbSeek('04'+SB1->B1_COD)) 
			_nToFam:=0
			While SG1->(!Eof()) .And. SG1->G1_FILIAL+SG1->G1_COD = '04'+SB1->B1_COD
			If U_STGETORI(SG1->G1_COMP,"03") = "F"
			_cEmpresa := "03"
			Else
			_cEmpresa := "01"
			EndIf

			cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
			cQuery += " FROM SB2"+_cEmpresa+"0 SB2 "
			cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
			cQuery += " AND   SB2.B2_COD   = '"+SG1->G1_COMP+"' AND B2_CMFIM1>0
			cQuery += " ORDER BY SB2.B2_LOCAL

			cQuery := ChangeQuery(cQuery)

			If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
			dbSelectArea(cAliasLif)
			If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nToFam+= ROUND(((cAliasLif)->B2_CMFIM1*SG1->G1_QUANT),2)
			EndIf


			(cAliasLif)->(dbCloseArea())




			SG1->(dbSkip())
			EndDo



			_nCust  := _nToFam





			Else
			*/
			//Custo medio
			cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
			cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
			cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
			cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
			cQuery += " AND   SB2.B2_LOCAL = '"+SB1->B1_LOCPAD+"'"
			If cempant = '01'
				cQuery += " AND   SB2.B2_FILIAL= '04'"
			Else
				cQuery += " AND   SB2.B2_FILIAL= '01'"
			EndIf
			cQuery += " ORDER BY SB2.R_E_C_N_O_ DESC

			cQuery := ChangeQuery(cQuery)

			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
			dbSelectArea(cAliasLif)
			If  Select(cAliasLif) > 0
				(cAliasLif)->(dbgotop())
				_nCust  := (cAliasLif)->B2_CMFIM1
			EndIf

			(cAliasLif)->(dbCloseArea())

			// USO O VALOR DO PREวO ORวADO POR COMPRAS
			If  !(_nCust > 0) .And. SB1->B1_XCUSCOM  > 0 .And.  date()  <= SB1->B1_XDTCOM
				_nCust  := SB1->B1_XCUSCOM
			EndIf

			//EndIf

			// USO O VALOR DO PREวO ORวADO POR COMPRAS
			If !(_nCust > 0) .And. SB1->B1_XCUSCOM  > 0 .And.  date()  <= SB1->B1_XDTCOM
				_nCust  := SB1->B1_XCUSCOM
			EndIf
		EndIf

	EndIf
	RestArea(_aArea)

	If _nCust = 0 .And. !(IsInCallStack("U_STWF24"))
		_aMsg:= {}

		aadd(_aMsg,{"Produto","Descri็ใo","Origem","Tipo","Grupo"})
		aadd(_aMsg,{Alltrim(SB1->B1_COD),Alltrim(SB1->B1_DESC) ,Alltrim(SB1->B1_CLAPROD),Alltrim(SB1->B1_TIPO),	Alltrim(SB1->B1_GRUPO)	}  )

		If Len(_aMsg) > 1
			//	U_STWFR24(_aMsg,'',''  ,'')
		EndIf
	EndIf

Return(round(_nCust,2))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCLAAM	บAutor  ณRenato Nogueira     บ Data ณ  18/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para verificar classifica็ใo do produto em  บฑฑ
ฑฑบ          ณManaus								 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ C๓digo do produto                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Classifica็ใo em Manaus                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STCLAAM(_cCod)

Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"

	/***********************************************
	<<< Altera็ใo >>>
	A็ใo..........: Quando a empresa for "11" - NEWCOR nใo entra na valida็ใo
	Desenvolvedor.: Marcelo Klopfer Leme - SIGAMAT
	Data..........: 21/12/2021
	***********************************************/
	IF _cEmpresa <> "11"
		cQuery := " SELECT B1_COD, B1_CLAPROD "
		cQuery += " FROM SB1030 "
		cQuery += " WHERE D_E_L_E_T_=' ' AND B1_COD='"+_cCod+"' "
	ELSE
		cQuery := " SELECT B1_COD, B1_CLAPROD FROM "+RetSqlName("SB1")+" "
		cQuery += " WHERE D_E_L_E_T_=' ' AND B1_COD='"+_cCod+"' "
	ENDIF

	If Select(cAlias) > 0 //!Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

Return((cAlias)->B1_CLAPROD)

/*====================================================================================\
|Programa  | STGETORI        | Autor | RENATO.OLIVEIRA           | Data | 16/01/2019  |
|=====================================================================================|
|Descri็ใo |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function STGETORI(_cProd,_cEmp)

	Local _cQuery9 	:= ""
	Local _cAlias9 	:= GetNextAlias()
	Local _cRet		:= ""

	_cQuery9 := " SELECT B1_COD, B1_CLAPROD
	_cQuery9 += " FROM SB1"+_cEmp+"0 B1
	_cQuery9 += " WHERE B1.D_E_L_E_T_=' ' AND B1_COD='"+_cProd+"'

	If !Empty(Select(_cAlias9))
		DbSelectArea(_cAlias9)
		(_cAlias9)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery9),_cAlias9,.T.,.T.)

	dbSelectArea(_cAlias9)
	(_cAlias9)->(dbGoTop())

	If (_cAlias9)->(!Eof())
		_cRet := (_cAlias9)->B1_CLAPROD
	EndIf

	If Select(_cAlias9) > 0
		DbSelectArea(_cAlias9)
		(_cAlias9)->(dbCloseArea())
	Endif

Return(_cRet)
