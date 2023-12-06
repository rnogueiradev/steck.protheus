#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*====================================================================================\
|Programa  | STQIE020         | Autor | RENATO.NOGUEIRA            | Data | 10/07/2019|
|=====================================================================================|
|Descrição | Função utilizada para buscar informações de rastreabilidade	          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STQIE020()

	Local aCoord		:= FWGetDialogSize(oMainWnd)
	Local cCadastro1	:= "Rastreabilidade"
	Local aCampoEdit	:= {}
	Local oArea			:= FWLayer():New()
	Local aButtons      := {}
	Private _aHeader	:= {}
	Private _aCols		:= {}
	Private oFontPeq   	:= TFont():New("Times New Roman",,-16,.T.)
	Private oFontPeqN  	:= TFont():New("Times New Roman",,-16,.T.,.T.)
	Private oFontMed   	:= TFont():New("Times New Roman",,-20,.T.)
	Private oFontMedN  	:= TFont():New("Times New Roman",,-20,.T.,.T.)
	Private oFontGrd  	:= TFont():New("Times New Roman",,-25,.T.)
	Private oFontGrdN  	:= TFont():New("Times New Roman",,-25,.T.,.T.)
	Private cNf			:= Space(9)
	Private cCliente	:= Space(6)
	Private cLoja		:= Space(2)
	Private cNome		:= Space(40)
	Private cRom		:= Space(10)
	Private cStatus		:= Space(1)
	Private cOs			:= Space(6)
	Private cPed		:= Space(6)
	Private cProd		:= Space(15)
	Private cLote		:= Space(10)

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi(cCadastro1),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",30,.F.)
	oArea:AddLine("L02",70,.F.)

	oArea:AddCollumn("CABEC",100,.F.,"L01")
	oArea:AddCollumn("ITENS",100,.F.,"L02")

	oArea:AddWindow("CABEC" ,"CABEC"  ,"Cabeçalho"		, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("ITENS","ITENS"   ,"Itens"			, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)

	oPainCabec 		:= oArea:GetWinPanel("CABEC"  	,"CABEC"	,"L01")
	oPainItens	 	:= oArea:GetWinPanel("ITENS" 	,"ITENS"	,"L02")

	Aadd(_aHeader,{"Nota fiscal"	,"F2_DOC"		,"@!"						,TamSx3("F2_DOC")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Cliente"		,"A1_COD"		,"@!"						,TamSx3("A1_COD")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Loja"			,"A1_LOJA"		,"@!"						,TamSx3("A1_LOJA")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Nome"			,"A1_NOME"		,"@!"						,TamSx3("A1_NOME")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Romaneio"		,"PD1_CODROM"	,"@!"						,TamSx3("PD1_CODROM")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Status"			,"PD1_STATUS"	,"@!"						,TamSx3("PD1_STATUS")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Ord. Sep."		,"CB7_ORDSEP"	,"@!"						,TamSx3("CB7_ORDSEP")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Pedido"			,"D2_PEDIDO"	,"@!"						,TamSx3("D2_PEDIDO")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Produto"		,"D2_COD"		,"@!"						,TamSx3("D2_COD")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Qtde"			,"D2_QUANT"		,"@E 99999999.99"			,TamSx3("D2_QUANT")[1],0,"",,"N","R"})
	Aadd(_aHeader,{"Lote"			,"PA0_LOTEX"	,"@!"						,TamSx3("PA0_LOTEX")[1],0,"",,"C","R"})

	//BLOCO 1
	@ 05,2 SAY "NF: "	Pixel Of oPainCabec FONT oFontPeq
	@ 05,30 Msget oNf Var cNf Picture "@!" Pixel Of oPainCabec Size 052,008 F3 "SF2"
	@ 20,2 SAY "Cliente: "		Pixel Of oPainCabec FONT oFontPeq
	@ 20,30 Msget oCliente Var cCliente Picture "@!" Pixel Of oPainCabec Size 052,008 F3 "SA1"
	@ 35,2 SAY "Loja: " 	Pixel Of oPainCabec FONT oFontPeq
	@ 35,30 Msget oLoja Var cLoja Picture "@!" Pixel Of oPainCabec Size 052,008
	@ 50,2 SAY "Nome: "	Pixel Of oPainCabec FONT oFontPeq
	@ 50,30 Msget oNome Var cNome Picture "@!" Pixel Of oPainCabec Size 100,008

	//BLOCO 2
	@ 05,150 SAY "Romaneio: "			Pixel Of oPainCabec FONT oFontPeq
	@ 05,195 Msget oRom Var cRom		Pixel Of oPainCabec FONT oFontPeq Size 052,008 When .T.
	@ 20,150 SAY "Status: "				Pixel Of oPainCabec FONT oFontPeq
	@ 20,195 Msget oStatus Var cStatus	Pixel Of oPainCabec FONT oFontPeq Size 052,008 When .T.
	@ 35,150 SAY "Ord. Sep.: "			Pixel Of oPainCabec FONT oFontPeq
	@ 35,195 Msget oOs Var cOs			Pixel Of oPainCabec FONT oFontPeq Size 052,008 When .T.
	@ 50,150 SAY "Pedido: "				Pixel Of oPainCabec FONT oFontPeq
	@ 50,195 Msget oPed Var cPed		Pixel Of oPainCabec FONT oFontPeq Size 052,008 When .T.

	//BLOCO 3
	@ 05,360 SAY "Produto: "			Pixel Of oPainCabec FONT oFontPeq
	@ 05,410 Msget oProd Var cProd		Pixel Of oPainCabec FONT oFontPeq Size 052,008 When .T.
	@ 20,360 SAY "Lote: "				Pixel Of oPainCabec FONT oFontPeq
	@ 20,410 Msget oLote Var cLote		Pixel Of oPainCabec FONT oFontPeq Size 052,008 When .T.

	//BLOCO 4
	@ 05,587 BUTTON oButton PROMPT "Buscar" 	SIZE 50,10 OF oPainCabec PIXEL ACTION BUSCAR()
	@ 20,587 BUTTON oButton PROMPT "Exportar" 	SIZE 50,10 OF oPainCabec PIXEL ACTION EXPORTAR()

	_oGet	:= MsNewGetDados():New(0,0,oPainItens:nClientHeight/2-15,oPainItens:nClientWidth/2-5,,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(_aCols),,, ,oPainItens,_aHeader,_aCols)
	MsNewGetDados():SetEditLine (.F.)

	oTela:Activate(,,,.T.,/*valid*/,,{ || EnchoiceBar(@oTela, {|| (lOk:=.T., oTela:End()) },{|| oTela:End()},,@aButtons,,,.F.,.F.,.F.,.F.,.F.) })

Return()

/*====================================================================================\
|Programa  | BUSCAR         | Autor | RENATO.NOGUEIRA            | Data | 10/07/2019|
|=====================================================================================|
|Descrição | Função utilizada para buscar informações de rastreabilidade	          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck	                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function BUSCAR()

	Private oProcess
	oProcess := MsNewProcess():New( { || PROCESSAR() } , "Buscando dados" , "Aguarde..." , .F. )
	oProcess:Activate()

Return()

/*====================================================================================\
|Programa  | PROCESSAR         | Autor | RENATO.NOGUEIRA            | Data | 10/07/2019|
|=====================================================================================|
|Descrição | Função utilizada para buscar informações de rastreabilidade	          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck	                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function PROCESSAR()

	Local _cQuery1 := ""
	Local _cAlias1 := "STQIE020A"
	Local nY
	_aCols := {}

	oProcess:SetRegua1(0) //Alimenta a primeira barra de progresso
	oProcess:IncRegua1("")

	_cQuery1 := " SELECT D2_DOC, A1_COD, A1_LOJA, A1_NOME, NVL(PD2_CODROM,' ') PD2_CODROM, NVL(PD1_STATUS,' ') PD1_STATUS,
	_cQuery1 += " NVL(CB7_ORDSEP,' ') CB7_ORDSEP, D2_PEDIDO, D2_COD, D2_QUANT, NVL(PA0_LOTEX,' ') PA0_LOTEX
	_cQuery1 += " FROM "+RetSqlName("SD2")+" D2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A1.D_E_L_E_T_=' ' 
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
	_cQuery1 += " ON PD2_FILIAL=D2_FILIAL AND PD2_NFS=D2_DOC AND PD2_SERIES=D2_SERIE AND PD2_CLIENT=D2_CLIENTE AND PD2_LOJCLI=D2_LOJA AND PD2.D_E_L_E_T_=' '
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD1")+" PD1
	_cQuery1 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM AND PD1.D_E_L_E_T_=' ' 
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7
	_cQuery1 += " ON CB7_FILIAL=D2_FILIAL AND CB7_PEDIDO=D2_PEDIDO AND CB7.D_E_L_E_T_=' ' 
	_cQuery1 += " LEFT JOIN "+RetSqlName("PA0")+" PA0
	_cQuery1 += " ON PA0_FILIAL=D2_FILIAL AND PA0_ORDSEP=CB7_ORDSEP AND PA0_DOC=D2_PEDIDO AND PA0_TIPDOC='SC5' AND PA0_PROD=D2_COD AND PA0.D_E_L_E_T_=' ' 
	_cQuery1 += " WHERE D2.D_E_L_E_T_=' ' 
	_cQuery1 += " AND D2_FILIAL='"+xFilial("SD2")+"'

	If !Empty(cNf)
		_cQuery1 += " AND D2_DOC='"+cNf+"'
	EndIf
	If !Empty(cCliente)
		_cQuery1 += " AND A1_COD='"+cCliente+"'
	EndIf
	If !Empty(cLoja)
		_cQuery1 += " AND A1_LOJA='"+cLoja+"'
	EndIf
	If !Empty(cNome)
		_cQuery1 += " AND A1_NOME='"+cNome+"'
	EndIf
	If !Empty(cRom)
		_cQuery1 += " AND PD1_CODROM='"+cRom+"'
	EndIf
	If !Empty(cStatus)
		_cQuery1 += " AND PD1_STATUS='"+cStatus+"'
	EndIf
	If !Empty(cOs)
		_cQuery1 += " AND CB7_ORDSEP='"+cOs+"'
	EndIf
	If !Empty(cProd)
		_cQuery1 += " AND D2_COD='"+cProd+"'
	EndIf
	If !Empty(cLote)
		_cQuery1 += " AND PA0_LOTEX='"+cLote+"'
	EndIf
	If !Empty(cPed)
		_cQuery1 += " AND D2_PEDIDO='"+cPed+"'
	EndIf

	_cQuery1 += " ORDER BY D2_DOC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	IncProc("Buscando notas, aguarde...")

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		AADD(_aCols,Array(Len(_aHeader)+1))

		For nY := 1 To Len(_aHeader)

			DO CASE

				CASE AllTrim(_aHeader[nY][2]) =  "F2_DOC"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->D2_DOC
				CASE AllTrim(_aHeader[nY][2]) =  "A1_COD"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->A1_COD
				CASE AllTrim(_aHeader[nY][2]) =  "A1_LOJA"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->A1_LOJA
				CASE AllTrim(_aHeader[nY][2]) =  "A1_NOME"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->A1_NOME
				CASE AllTrim(_aHeader[nY][2]) =  "PD1_CODROM"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->PD2_CODROM
				CASE AllTrim(_aHeader[nY][2]) =  "PD1_STATUS"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->PD1_STATUS
				CASE AllTrim(_aHeader[nY][2]) =  "CB7_ORDSEP"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->CB7_ORDSEP
				CASE AllTrim(_aHeader[nY][2]) =  "D2_PEDIDO"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->D2_PEDIDO
				CASE AllTrim(_aHeader[nY][2]) =  "D2_COD"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->D2_COD
				CASE AllTrim(_aHeader[nY][2]) =  "D2_QUANT"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->D2_QUANT
				CASE AllTrim(_aHeader[nY][2]) =  "PA0_LOTEX"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->PA0_LOTEX

			ENDCASE

		Next

		_aCols[Len(_aCols)][Len(_aHeader)+1] := .F.

		(_cAlias1)->(DbSkip())
	EndDo

	_oGet:SetArray(_aCols)
	_oGet:Refresh()

Return()

/*====================================================================================\
|Programa  | EXPORTAR         | Autor | RENATO.NOGUEIRA            | Data | 19/05/2016|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function EXPORTAR()

	Local aCabec		:= {}
	Local aDados		:= {}
	Local _nX			:= 0

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return
	EndIf

	aCabec := {"Nota","Cliente","Loja","Nome","Romaneio","Status","Ord.Sep.","Pedido","Código","Qtde","Lote"}
	For _nX:=1 To Len(_aCols)
		AADD(aDados,{_aCols[_nX][1],_aCols[_nX][2],_aCols[_nX][3],_aCols[_nX][4],_aCols[_nX][5],_aCols[_nX][6],_aCols[_nX][7],_aCols[_nX][8],_aCols[_nX][9],_aCols[_nX][10],_aCols[_nX][11]})
	Next

	DlgToExcel({{"ARRAY","NOTAS FISCAIS",aCabec,aDados}})

Return()