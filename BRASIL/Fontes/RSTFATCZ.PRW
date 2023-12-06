#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATCZ        | Autor | RENATO.OLIVEIRA           | Data | 07/04/2021  |
|=====================================================================================|
|Descrição | Relatório de pedidos SE		                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATCZ()

	Local   oReport
	Private cPerg 			:= "RFATCZ"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

/*====================================================================================\
|Programa  | ReportDef       | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de pedidos SE",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de acessos a fornecedor")

	Pergunte(cPerg,.F.)

	oSection1 := TRSection():New(oReport,"SC5",{"SC5"})

	TRCell():New(oSection1,"01"	  			 ,,"Filial"									,,TamSx3("C5_FILIAL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02"	  			 ,,"Pedido"									,,TamSx3("C5_NUM")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"03"	  			 ,,"Item"									,,TamSx3("C6_ITEM")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"04"	  			 ,,"Produto"								,,TamSx3("C6_PRODUTO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"05"	  			 ,,"Saldo"									,,TamSx3("C6_QTDVEN")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"06"	  			 ,,"Ped. compra"							,,TamSx3("C6_NUMPCOM")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"07"	  			 ,,"Item Ped. compra"						,,TamSx3("C6_ITEMPC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"08"	  			 ,,"Entrega"								,,TamSx3("C6_ENTRE1")[1],.F.,,,,,,,.T.)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SC5")

Return oReport

/*====================================================================================\
|Programa  | ReportPrint     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local aDados1[99]
	Local aDados2[99]
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _nX

	oSection1:Cell('01')      :SetBlock( { || aDados1[01] } )
	oSection1:Cell('02')      :SetBlock( { || aDados1[02] } )
	oSection1:Cell('03')      :SetBlock( { || aDados1[03] } )
	oSection1:Cell('04')      :SetBlock( { || aDados1[04] } )
	oSection1:Cell('05')      :SetBlock( { || aDados1[05] } )
	oSection1:Cell('06')      :SetBlock( { || aDados1[06] } )
	oSection1:Cell('07')      :SetBlock( { || aDados1[07] } )
	oSection1:Cell('08')      :SetBlock( { || aDados1[08] } )

	oReport:SetTitle("Relatório de pedido de venda")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection1:Init()
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:= (cAliasLif)->C6_FILIAL
			aDados1[02]	:= (cAliasLif)->C6_NUM
			aDados1[03]	:= (cAliasLif)->C6_ITEM
			aDados1[04]	:= (cAliasLif)->C6_PRODUTO
			aDados1[05]	:= (cAliasLif)->SALDO
			aDados1[06]	:= (cAliasLif)->C6_NUMPCOM
			aDados1[07]	:= (cAliasLif)->C6_ITEMPC
			aDados1[08]	:= STOD((cAliasLif)->ENTREGA)

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()

Return oReport

/*====================================================================================\
|Programa  | StQuery	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function StQuery()

	Local cQuery     := ' '
	Local nReg

	cQuery := " SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, C6_QTDVEN-C6_QTDENT SALDO, C6_NUMPCOM, C6_ITEMPC,
	cQuery += " (CASE WHEN C6_ZENTRE2<>' ' THEN C6_ZENTRE2 ELSE C6_ENTRE1 END) ENTREGA
	cQuery += " FROM "+RetSqlName("SC6")+" C6
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C6_FILIAL='05' AND C6_CLI='012047' AND C6_LOJA='09' AND C6_NUMPCOM<>' '
	cQuery += " AND C6_BLQ=' ' 
	cQuery += " ORDER BY C6_FILIAL, C6_NUM, C6_ITEM
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
