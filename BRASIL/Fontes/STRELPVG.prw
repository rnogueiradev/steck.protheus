#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"

/*/{Protheus.doc} STRELPVG
description
Rotina para Gerar Relatório Status (Pedido/Separação/Produtos Faturados) por Cliente
Ticket: 20210712012355
@type function
@version  
@author Valdemir Jose
@since 20/07/2021
@return variant, return_description
u_STRELPVG

<<< Alteração >>>
Chamados.: 20210910018585 / 20211116024577
Descrição: Inclusão do campo EE8_XPOCLI "Número do PO do Cliente"
Analista.: Marcelo Klopfer Leme - SIGAMAT
Data.....: 30/09/2021
/*/
USER FUNCTION STRELPVG
    Local oReport
    Private cPerg    := "STRELPVGUA"
    Private cAliasP  := GetNextAlias()
    Private cAliasS  := GetNextAlias()
    Private cAliasF  := GetNextAlias()
    Private _cTitulo := "Relatório Status de Pedidos (Schneider)"
    Private _cDescri := "Esta rotina irá imprimir um relatório status de pedidos"
    Private _cSection1   := "Pedidos Emitidos"
    Private _cSection2   := "Pedidos em embalagens"
    Private _cSection3   := "Pedidos com embarque gerado"

    getSX1()

	oReport		:= ReportDef()
	if oReport <> nil     
		oReport:PrintDialog()
	Endif 

RETURN 


Static Function ReportDef()
	Local oReport
	Local oSection1
	Local oSection2
    Local cPergTit := Alltrim(cPerg)+StrTran(Time(),":","")

	oReport := TReport():New(cPergTit,_cTitulo,cPerg,{|oReport| ReportPrint(oReport)},_cDescri)
	oReport:SetLandscape()
	oReport:nFontBody := 10

	Pergunte(cPerg,.F.)

	//Primeira Seção
	oSection1 := TRSection():New(oReport,_cSection1,{cAliasP})
    //oSection1:SetPageBreak(.T.)		            //Salta a pagina na quebra da secao
    oSection1:SetHeaderSection(.T.)	                //Nao imprime o cabecalho da secao
	TRCell():New(oSection1,"A1" ,,"Cliente"       ,PesqPict("SA1","A1_COD")         ,TamSX3("A1_COD")       [1]+2)
	TRCell():New(oSection1,"A2" ,,"Loja"          ,PesqPict("SA1","A1_LOJA")        ,TamSX3("A1_LOJA")      [1]+2)
	TRCell():New(oSection1,"A3" ,,"Razão social"  ,PesqPict("SA1","A1_NOME")        ,TamSX3("A1_NOME")      [1]+2)
	TRCell():New(oSection1,"A4" ,,"PO Cliente"    ,PesqPict("SA1","A1_NOME")        ,TamSX3("A1_NOME")      [1]+2)
	TRCell():New(oSection1,"A5" ,,"Pedido EEC"    ,PesqPict("EE7","EE7_PEDIDO")     ,TamSX3("EE7_PEDIDO")   [1]+2)
	TRCell():New(oSection1,"A6" ,,"Ped. Protheus" ,PesqPict("SC5","C5_NUM")         ,TamSX3("C5_NUM")       [1]+2)
	TRCell():New(oSection1,"A7" ,,"Emissão"       ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)
	TRCell():New(oSection1,"A8" ,,"Produto"       ,PesqPict("SB1","B1_COD")         ,TamSX3("B1_COD")       [1]+2)
	TRCell():New(oSection1,"A9" ,,"Quantidade"    ,PesqPict("SC6","C6_QTDVEN")      ,TamSX3("C6_QTDVEN")    [1]+2)
	TRCell():New(oSection1,"A10",,"P.O. Cliente"  ,PesqPict("EE8","EE8_XPOCLI")     ,TamSX3("EE8_XPOCLI")   [1]+2)

    // Segunda Seção
    oSection2 := TRSection():New(oReport, _cSection2 , {cAliasS})	
    oSection2:SetHeaderSection(.T.)	                //Nao imprime o cabecalho da secao
	TRCell():New(oSection2,"B1" ,,"Cliente"       ,PesqPict("SA1","A1_COD")         ,TamSX3("A1_COD")       [1]+2)
	TRCell():New(oSection2,"B2" ,,"Loja"          ,PesqPict("SA1","A1_LOJA")        ,TamSX3("A1_LOJA")      [1]+2)
	TRCell():New(oSection2,"B3" ,,"Razão social"  ,PesqPict("SA1","A1_NOME")        ,TamSX3("A1_NOME")      [1]+2)
	TRCell():New(oSection2,"B4" ,,"PO Cliente"    ,PesqPict("SA1","A1_NOME")        ,TamSX3("A1_NOME")      [1]+2)
	TRCell():New(oSection2,"B5" ,,"Pedido EEC"    ,PesqPict("EE7","EE7_PEDIDO")     ,TamSX3("EE7_PEDIDO")   [1]+2)
	TRCell():New(oSection2,"B6" ,,"Ped. Protheus" ,PesqPict("SC5","C5_NUM")         ,TamSX3("C5_NUM")       [1]+2)
	TRCell():New(oSection2,"B7" ,,"Produto"       ,PesqPict("SB1","B1_COD")         ,TamSX3("B1_COD")       [1]+2)
	TRCell():New(oSection2,"B8" ,,"Quantidade"    ,PesqPict("SC6","C6_QTDVEN")      ,TamSX3("C6_QTDVEN")    [1]+2)
	TRCell():New(oSection2,"B9" ,,"Dt.Ord.Sep."   ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)
	TRCell():New(oSection2,"B10",,"P.O. Cliente"  ,PesqPict("EE8","EE8_XPOCLI")     ,TamSX3("EE8_XPOCLI")   [1]+2)

    // Terceira Seção
    oSection3 := TRSection():New(oReport, _cSection3 , {cAliasF})	
    oSection3:SetHeaderSection(.T.)	                //Nao imprime o cabecalho da secao
	TRCell():New(oSection3,"C1" ,,"Cliente"       ,PesqPict("SA1","A1_COD")         ,TamSX3("A1_COD")       [1]+2)
	TRCell():New(oSection3,"C2" ,,"Loja"          ,PesqPict("SA1","A1_LOJA")        ,TamSX3("A1_LOJA")      [1]+2)
	TRCell():New(oSection3,"C3" ,,"Razão social"  ,PesqPict("SA1","A1_NOME")        ,TamSX3("A1_NOME")      [1]+2)
	TRCell():New(oSection3,"C4" ,,"PO Cliente"    ,PesqPict("SA1","A1_NOME")        ,TamSX3("A1_NOME")      [1]+2)
	TRCell():New(oSection3,"C5" ,,"Pedido EEC"    ,PesqPict("EE7","EE7_PEDIDO")     ,TamSX3("EE7_PEDIDO")   [1]+2)
	TRCell():New(oSection3,"C6" ,,"Ped. Protheus" ,PesqPict("SC5","C5_NUM")         ,TamSX3("C5_NUM")       [1]+2)
	TRCell():New(oSection3,"C7" ,,"Produto"       ,PesqPict("SB1","B1_COD")         ,TamSX3("B1_COD")       [1]+2)
	TRCell():New(oSection3,"C8" ,,"Quantidade"    ,PesqPict("SC6","C6_QTDVEN")      ,TamSX3("C6_QTDVEN")    [1]+2)
	TRCell():New(oSection3,"C9" ,,"Dt.Embarque"   ,PesqPict("SC5","C5_EMISSAO")     ,TamSX3("C5_EMISSAO")   [1]+2)
	TRCell():New(oSection3,"C10",,"P.O. Cliente"  ,PesqPict("EE8","EE8_XPOCLI")     ,TamSX3("EE8_XPOCLI")   [1]+2)

    //oBreak1 := TRBreak():New(oSection2, oSection2:Cell("B1"),,.F.)
    //oBreak2 := TRBreak():New(oSection3, oSection3:Cell("C1"),,.F.)

Return oReport



Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)  //:Section(1) 
    Local oSection3 := oReport:Section(3) //:Section(1):Section(1)
    Local nC     := 0    
    Local nTotal := 0
    Local nTotG  := 0
    Private aDadosA[99]
    Private aDadosB[99]
    Private aDadosC[99]

    dbSelectArea("EE7")

    oSection1:Cell("A1"):SetBlock( { || aDadosA[01] } )
    oSection1:Cell("A2"):SetBlock( { || aDadosA[02] } )
    oSection1:Cell("A3"):SetBlock( { || aDadosA[03] } )
    oSection1:Cell("A4"):SetBlock( { || aDadosA[04] } )
    oSection1:Cell("A5"):SetBlock( { || aDadosA[05] } )
    oSection1:Cell("A6"):SetBlock( { || aDadosA[06] } )
    oSection1:Cell("A7"):SetBlock( { || aDadosA[07] } )
    oSection1:Cell("A8"):SetBlock( { || aDadosA[08] } )
    oSection1:Cell("A9"):SetBlock( { || aDadosA[09] } )
    oSection1:Cell("A10"):SetBlock( { || aDadosA[10] } )

    oBreak    := TRBreak():New(oSection1, { || aDadosA[01] }, "Cliente Por Pedido")
    //oFunction := TRFunction():New(oSection1:Cell("A1"),,"COUNT", oBreak,,,,.F.,.F.)

    oSection2:Cell("B1"):SetBlock( { || aDadosB[01] } )
    oSection2:Cell("B2"):SetBlock( { || aDadosB[02] } )
    oSection2:Cell("B3"):SetBlock( { || aDadosB[03] } )
    oSection2:Cell("B4"):SetBlock( { || aDadosB[04] } )
    oSection2:Cell("B5"):SetBlock( { || aDadosB[05] } )
    oSection2:Cell("B6"):SetBlock( { || aDadosB[06] } )
    oSection2:Cell("B7"):SetBlock( { || aDadosB[07] } )
    oSection2:Cell("B8"):SetBlock( { || aDadosB[08] } )
    oSection2:Cell("B9"):SetBlock( { || aDadosB[09] } )
    oSection2:Cell("B10"):SetBlock( { || aDadosB[10] } )

    oBreak1    := TRBreak():New(oSection2, { || aDadosB[01] }, "Cliente Por Separação")
    //oFunction1 := TRFunction():New(oSection2:Cell("B1"),,"COUNT", oBreak1,,,,.F.,.F.)

    oSection3:Cell("C1"):SetBlock( { || aDadosC[01] } )
    oSection3:Cell("C2"):SetBlock( { || aDadosC[02] } )
    oSection3:Cell("C3"):SetBlock( { || aDadosC[03] } )
    oSection3:Cell("C4"):SetBlock( { || aDadosC[04] } )
    oSection3:Cell("C5"):SetBlock( { || aDadosC[05] } )
    oSection3:Cell("C6"):SetBlock( { || aDadosC[06] } )
    oSection3:Cell("C7"):SetBlock( { || aDadosC[07] } )
    oSection3:Cell("C8"):SetBlock( { || aDadosC[08] } )
    oSection3:Cell("C9"):SetBlock( { || aDadosC[09] } )
    oSection3:Cell("C10"):SetBlock( { || aDadosC[10] } )

    oBreak2    := TRBreak():New(oSection3, { || aDadosC[01] }, "Cliente Por Embarque")
    //oFunction2 := TRFunction():New(oSection3:Cell("C1"),,"COUNT", oBreak2,,,,.F.,.F.)

    Processa({|| nTotG += StQuery(), nTotG += StQuery2(), nTotG += StQuery3()},"Filtrando Pedidos")

    oReport:SetTitle(_cTitulo)          // Titulo do relatório
	aFill(aDadosA,nil)
	aFill(aDadosB,nil)
	aFill(aDadosC,nil)
	oSection1:Init()

    oReport:SetMeter(nTotG)
    // Pedido
    While ( (cAliasP)->( !Eof() ) .And. !oReport:Cancel() )
        EE7->( dbGoto((cAliasP)->RECEE7) )
        aDadosA[01] := (cAliasP)->CLIENTE
        aDadosA[02] := (cAliasP)->LOJA
        aDadosA[03] := (cAliasP)->RAZAOS
        aDadosA[04] := ALLTRIM(MSMM(EE7->EE7_CODMEM,TamSX3("EE7_CODMEM")[1])) +" / "+ALLTRIM(MSMM(EE7->EE7_CODMAR,TamSX3("EE7_MARCAC")[1]))
        aDadosA[05] := (cAliasP)->PEDIDOEEC
        aDadosA[06] := (cAliasP)->PEDIDO
        aDadosA[07] := DTOC(STOD((cAliasP)->EMISSAO))
        aDadosA[08] := (cAliasP)->PRODUTO
        aDadosA[09] := (cAliasP)->QUANTIDADE
        
        //// Amarra o pedido de venda com PO da tabela EE7/EE8
        EE8->(DBSETORDER(1))
        IF EE8->(DBSEEK(EE7->EE7_FILIAL+EE7->EE7_PEDIDO))
          WHILE EE8->(!EOF()) .AND. EE8->EE8_PEDIDO = EE7->EE7_PEDIDO
            IF LEN(ALLTRIM(EE8->EE8_SEQUEN)) <= 1
              IF "0"+ALLTRIM(EE8->EE8_SEQUEN) == (cAliasP)->C6_ITEM
                aDadosA[10] := EE8->EE8_XPOCLI
              ENDIF
            ELSE
              IF ALLTRIM(EE8->EE8_SEQUEN) == (cAliasP)->C6_ITEM
                aDadosA[10] := EE8->EE8_XPOCLI
              ENDIF
            ENDIF
            EE8->(DBSKIP())
          ENDDO
        ENDIF
        
        oReport:IncMeter()
        oSection1:PrintLine()
        aFill(aDadosA, nil)

        (cAliasP)->( dbSkip() )
    EndDo 

    oSection2:Init()
    // Separação
    While ( (cAliasS)->( !Eof() ) .And. !oReport:Cancel() )
        EE7->( dbGoto((cAliasS)->RECEE7) )
        aDadosB[01] := (cAliasS)->CLIENTE
        aDadosB[02] := (cAliasS)->LOJA
        aDadosB[03] := (cAliasS)->RAZAOS
        aDadosB[04] := ALLTRIM(MSMM(EE7->EE7_CODMEM,TamSX3("EE7_CODMEM")[1])) +" / "+ALLTRIM(MSMM(EE7->EE7_CODMAR,TamSX3("EE7_MARCAC")[1]))
        aDadosB[05] := (cAliasS)->PEDIDOEEC
        aDadosB[06] := (cAliasS)->PEDIDO
        aDadosB[07] := (cAliasS)->PRODUTO
        aDadosB[08] := (cAliasS)->QUANTIDADE
        aDadosB[09] := DTOC(STOD((cAliasS)->DTORDSEP))

        //// Amarra o pedido de venda com PO da tabela EE7/EE8
        EE8->(DBSETORDER(1))
        IF EE8->(DBSEEK(EE7->EE7_FILIAL+EE7->EE7_PEDIDO))
          WHILE EE8->(!EOF()) .AND. EE8->EE8_PEDIDO = EE7->EE7_PEDIDO
            IF LEN(ALLTRIM(EE8->EE8_SEQUEN)) <= 1
              IF "0"+ALLTRIM(EE8->EE8_SEQUEN) == (cAliasS)->C6_ITEM
                aDadosB[10] := EE8->EE8_XPOCLI
              ENDIF
            ELSE
              IF ALLTRIM(EE8->EE8_SEQUEN) == (cAliasS)->C6_ITEM
                aDadosB[10] := EE8->EE8_XPOCLI
              ENDIF
            ENDIF
            EE8->(DBSKIP())
          ENDDO
        ENDIF

        oReport:IncMeter()
        oSection2:PrintLine()
        aFill(aDadosB, nil)
        (cAliasS)->( dbSkip() )
    EndDo 

    oSection3:Init()
    // Embarque
    While ( (cAliasF)->( !Eof() ) .And. !oReport:Cancel() )
        EE7->( dbGoto((cAliasF)->RECEE7) )
        aDadosC[01] := (cAliasF)->CLIENTE
        aDadosC[02] := (cAliasF)->LOJA
        aDadosC[03] := (cAliasF)->RAZAOS
        aDadosC[04] := ALLTRIM(MSMM(EE7->EE7_CODMEM,TamSX3("EE7_CODMEM")[1])) +" / "+ALLTRIM(MSMM(EE7->EE7_CODMAR,TamSX3("EE7_MARCAC")[1]))
        aDadosC[05] := (cAliasF)->PEDIDOEEC
        aDadosC[06] := (cAliasF)->PEDIDO
        aDadosC[07] := (cAliasF)->PRODUTO
        aDadosC[08] := (cAliasF)->QUANTIDADE
        aDadosC[09] := DTOC(STOD((cAliasF)->DTEMBARQUE))

        //// Amarra o pedido de venda com PO da tabela EE7/EE8
        EE8->(DBSETORDER(1))
        IF EE8->(DBSEEK(EE7->EE7_FILIAL+EE7->EE7_PEDIDO))
          WHILE EE8->(!EOF()) .AND. EE8->EE8_PEDIDO = EE7->EE7_PEDIDO
            IF LEN(ALLTRIM(EE8->EE8_SEQUEN)) <= 1
              IF "0"+ALLTRIM(EE8->EE8_SEQUEN) == (cAliasF)->C6_ITEM
                aDadosC[10] := EE8->EE8_XPOCLI
              ENDIF
            ELSE
              IF ALLTRIM(EE8->EE8_SEQUEN) == (cAliasF)->C6_ITEM
                aDadosC[10] := EE8->EE8_XPOCLI
              ENDIF
            ENDIF
            EE8->(DBSKIP())
          ENDDO
        ENDIF

        oReport:IncMeter()
        oSection3:PrintLine()
        aFill(aDadosC, nil)        
        (cAliasF)->( dbSkip() )
    EndDo     

RETURN


/*/{Protheus.doc} StQuery
description
Rotina para Filtrar os Pedidos
@type function
@version  
@author Valdemir Jose
@since 21/07/2021
@return variant, return_description
/*/
Static Function StQuery()
    Local cQry   := ""
    Local nTotal := 0

    cQry += "SELECT SC5.C5_CLIENT CLIENTE, SC5.C5_LOJACLI LOJA, SA1.A1_NOME RAZAOS, " + CRLF 
    cQry += "EE7.EE7_PEDIDO PEDIDOEEC, SC5.C5_NUM PEDIDO, SC5.C5_EMISSAO EMISSAO," + CRLF 
    cQry += "SC6.C6_PRODUTO PRODUTO, SC6.C6_QTDVEN QUANTIDADE, " + CRLF 
    cQry += "EE7.R_E_C_N_O_ RECEE7,SC6.C6_ITEM  " + CRLF 
    cQry += "FROM " + RETSQLNAME("SC5") + " SC5 " + CRLF 
    cQry += "INNER JOIN " + RETSQLNAME("SC6") + " SC6 " + CRLF 
    cQry += "ON SC6.C6_FILIAL=SC5.C5_FILIAL AND SC6.C6_NUM=SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' " + CRLF 
    cQry += "INNER JOIN " + RETSQLNAME("EE7") + " EE7 " + CRLF 
    cQry += "ON EE7.EE7_FILIAL=SC5.C5_FILIAL AND EE7.EE7_PEDFAT=SC5.C5_NUM AND EE7.D_E_L_E_T_ = ' ' " + CRLF     
    cQry += "INNER JOIN " + RETSQLNAME("SA1") + " SA1 " + CRLF 
    cQry += "ON  SA1.A1_COD=SC5.C5_CLIENT AND SA1.A1_LOJA=SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' " + CRLF     
    cQry += "WHERE SC5.D_E_L_E_T_ = ' ' " + CRLF 
    cQry += " AND SC5.C5_FILIAL ='"+XFILIAL("SC5")+"' " + CRLF
    //cQry += " AND SC6.C6_BLQ <> 'R' " + CRLF
    cQry += " AND SC5.C5_CLIENT >= '"+MV_PAR01+"'  " + CRLF 
    cQry += " AND SC5.C5_LOJACLI >= '"+MV_PAR02+"' " + CRLF 
    cQry += " AND SC5.C5_CLIENT <= '"+MV_PAR03+"'  " + CRLF 
    cQry += " AND SC5.C5_LOJACLI <= '"+MV_PAR04+"' " + CRLF 
    cQry += " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' " + CRLF 
    cQry += "ORDER BY C5_CLIENT, C5_LOJACLI, C5_NUM,C6_ITEM " + CRLF 

    if Select(cAliasP) > 0
        (cAliasP)->( dbCloseArea() )
    endif 

    TcQuery cQry New Alias (cAliasP)
    Count To nTotal 
    dbGotop()

Return nTotal

/*/{Protheus.doc} StQuery2
description
Rotina para Filtrar as Separações
@type function
@version  
@author Valdemir Jose
@since 21/07/2021
@return variant, return_description
/*/
Static Function StQuery2()
    Local cQry   := ""
    Local nTotal := 0

    cQry += "SELECT SC5.C5_CLIENT CLIENTE, SC5.C5_LOJACLI LOJA, SA1.A1_NOME RAZAOS, " + CRLF 
    cQry += "EE7.EE7_PEDIDO PEDIDOEEC, SC5.C5_NUM PEDIDO, SC5.C5_EMISSAO EMISSAO," + CRLF 
    cQry += "SC6.C6_PRODUTO PRODUTO, CB8.CB8_QTDORI QUANTIDADE, CB8.CB8_XDTFIM DTORDSEP, " + CRLF
    cQry += " EE7.R_E_C_N_O_ RECEE7,C6_ITEM " + CRLF 
    cQry += "FROM " + RETSQLNAME("SC5") + " SC5 " + CRLF 
    cQry += "INNER JOIN " + RETSQLNAME("SC6") + " SC6 " + CRLF 
    cQry += "ON SC6.C6_FILIAL=SC5.C5_FILIAL AND SC6.C6_NUM=SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' '      " + CRLF 
    cQry += "INNER JOIN " + RETSQLNAME("EE7") + " EE7 " + CRLF 
    cQry += "ON EE7.EE7_FILIAL=SC5.C5_FILIAL AND EE7.EE7_PEDFAT=SC5.C5_NUM AND EE7.D_E_L_E_T_ = ' ' " + CRLF     
    cQry += "INNER JOIN " + RETSQLNAME("CB8") + " CB8 " + CRLF 
    cQry += "ON CB8.CB8_FILIAL=SC5.C5_FILIAL AND CB8.CB8_PEDIDO=SC5.C5_NUM AND CB8.CB8_ITEM=SC6.C6_ITEM AND CB8.D_E_L_E_T_ = ' ' " + CRLF     
    cQry += "INNER JOIN " + RETSQLNAME("SA1") + " SA1 " + CRLF 
    cQry += "ON  SA1.A1_COD=SC5.C5_CLIENT AND SA1.A1_LOJA=SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '   " + CRLF     

    cQry += "WHERE SC5.D_E_L_E_T_ = ' ' " + CRLF 
    cQry += " AND SC5.C5_FILIAL ='"+XFILIAL("SC5")+"' " + CRLF
    //cQry += " AND SC6.C6_BLQ <> 'R' " + CRLF
    cQry += " AND SC5.C5_CLIENT >= '"+MV_PAR01+"'  " + CRLF 
    cQry += " AND SC5.C5_LOJACLI >= '"+MV_PAR02+"' " + CRLF 
    cQry += " AND SC5.C5_CLIENT <= '"+MV_PAR03+"'  " + CRLF 
    cQry += " AND SC5.C5_LOJACLI <= '"+MV_PAR04+"' " + CRLF 
    cQry += " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' " + CRLF 
    cQry += "ORDER BY C5_CLIENT, C5_LOJACLI, C5_NUM,C6_ITEM " + CRLF 

    if Select(cAliasS) > 0
        (cAliasS)->( dbCloseArea() )
    endif 

    TcQuery cQry New Alias (cAliasS)
    Count To nTotal 
    dbGotop()

Return nTotal


/*/{Protheus.doc} StQuery3
description
Rotina para filtrar os embarques
@type function
@version  
@author Valdemir Jose
@since 21/07/2021
@return variant, return_description
/*/
Static Function StQuery3()
    Local cQry   := ""
    Local nTotal := 0

    cQry += "SELECT SC5.C5_CLIENT CLIENTE, SC5.C5_LOJACLI LOJA, SA1.A1_NOME RAZAOS, " + CRLF 
    cQry += "EE7.EE7_PEDIDO PEDIDOEEC, SC5.C5_NUM PEDIDO, SC5.C5_EMISSAO EMISSAO," + CRLF 
    cQry += "SC6.C6_PRODUTO PRODUTO, ZZT.EEC_DTPROC DTEMBARQUE, ZZT.EEC_TOTITE QUANTIDADE,  " + CRLF 
    cQry += "EE7.R_E_C_N_O_ RECEE7,C6_ITEM " + CRLF 
    cQry += "FROM " + RETSQLNAME("SC5") + " SC5 " + CRLF 
    cQry += "INNER JOIN " + RETSQLNAME("SC6") + " SC6 " + CRLF 
    cQry += "ON SC6.C6_FILIAL=SC5.C5_FILIAL AND SC6.C6_NUM=SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' '      " + CRLF 
    cQry += "INNER JOIN " + RETSQLNAME("EE7") + " EE7 " + CRLF 
    cQry += "ON EE7.EE7_FILIAL=SC5.C5_FILIAL AND EE7.EE7_PEDFAT=SC5.C5_NUM AND EE7.D_E_L_E_T_ = ' ' " + CRLF     
    cQry += "INNER JOIN " + RETSQLNAME("EEC") + " ZZT " + CRLF 
    cQry += "ON ZZT.EEC_FILIAL=EE7.EE7_FILIAL AND ZZT.EEC_PEDREF=EE7.EE7_PEDIDO AND ZZT.D_E_L_E_T_ = ' ' " + CRLF     
    cQry += "INNER JOIN " + RETSQLNAME("SA1") + " SA1 " + CRLF 
    cQry += "ON  SA1.A1_COD=SC5.C5_CLIENT AND SA1.A1_LOJA=SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '   " + CRLF     

    cQry += "WHERE SC5.D_E_L_E_T_ = ' ' " + CRLF 
    cQry += " AND SC5.C5_FILIAL ='"+XFILIAL("SC5")+"' " + CRLF
    //cQry += " AND SC6.C6_BLQ <> 'R' " + CRLF
    cQry += " AND SC5.C5_CLIENT >= '"+MV_PAR01+"'  " + CRLF 
    cQry += " AND SC5.C5_LOJACLI >= '"+MV_PAR02+"' " + CRLF 
    cQry += " AND SC5.C5_CLIENT <= '"+MV_PAR03+"'  " + CRLF 
    cQry += " AND SC5.C5_LOJACLI <= '"+MV_PAR04+"' " + CRLF 
    cQry += " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' " + CRLF 
    cQry += "ORDER BY C5_CLIENT, C5_LOJACLI, C5_NUM,C6_ITEM " + CRLF 

    if Select(cAliasF) > 0
        (cAliasF)->( dbCloseArea() )
    endif 

    TcQuery cQry New Alias (cAliasF)
    Count To nTotal 
    dbGotop()

Return nTotal

/*/{Protheus.doc} getSX1
description
Rotina para criar o pergunte
@type function
@version  
@author Valdemir Jose
@since 21/07/2021
@return variant, return_description
/*/
Static Function getSX1()

	U_STPutSx1(cPerg	, "01"	,"Cliente De:  "    ,"MV_PAR01"	,"mv_ch1","C",TamSX3("A1_COD")[1]	,0,"G","","SA1","")
	U_STPutSx1(cPerg	, "02"	,"Loja De: "        ,"MV_PAR02"	,"mv_ch2","C",TamSX3("A1_LOJA")[1]	,0,"G","","","")
	U_STPutSx1(cPerg	, "03"	,"Cliente Até:  "   ,"MV_PAR03"	,"mv_ch3","C",TamSX3("A1_COD")[1]	,0,"G","","SA1","")
	U_STPutSx1(cPerg	, "04"	,"Loja Até: "       ,"MV_PAR04"	,"mv_ch4","C",TamSX3("A1_LOJA")[1]	,0,"G","","","")
	U_STPutSx1(cPerg	, "05"	,"Emissão De: "     ,"MV_PAR05"	,"mv_ch5","D",10	,0,"G","","","")
	U_STPutSx1(cPerg	, "06"	,"Emissão Até:"     ,"MV_PAR06"	,"mv_ch6","D",10	,0,"G","","","")
    Pergunte(cPerg, .F.)

Return 
