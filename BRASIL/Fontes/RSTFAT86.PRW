#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#include "rptdef.ch"

#DEFINE CL CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT86     บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT86(lJobAuto)
*-----------------------------*
	Local  oReport
	Local nX := 0

	Private cPerg 			:= "RSTFAT86"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	Private cPastaRel 		:= "\arquivos\"
	Private carquivo_       := 	"RSTFAT86"
	Private cAnexo			:= ""
	Private cPara 			:= SuperGetMV("ST_RSFAT86",.F.,"henrique.youssef@steck.com.br;rafael.rivani@steck.com.br;david.junior@steck.com.br")

	Default lJobAuto 	:= .F.

	If lJobAuto
		

		

		
		For nX := 1 To 2 //Roda 2 x
		 	If nX == 1
				//Cria as defini็๕es do relat๓rio
				oReport := ReportDef()

				MV_PAR01 := Space(6)           
				MV_PAR02 := Replicate("Z",6)  
				MV_PAR03 := Space(6) 
				MV_PAR04 := Replicate("Z",15) 
				MV_PAR05 := CTOD("01/01/2000") 
				MV_PAR06 := CTOD("31/12/2030") 
				MV_PAR07 := 4 
				
				//Define um nome do arquivo dentro da Protheus Data - pasta 'x_arquivos'
				cAnexo := carquivo_ + dToS(dDataBase) + StrTran(Time(), ":", "-") + ".xls"
			
				//Define para o relat๓rio nใo mostrar na tela, o Device 4 (Planilha), define o arquivo, e define para imprimir

				oReport:lPreview:= .F.
				oReport:setFile(cPastaRel+cAnexo)
				
				oReport:nDevice			:= 4 	//1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
				oReport:nEnvironment	:= 1 // 1 -Server / 2- Cliente
				oReport:nRemoteType		:= NO_REMOTE
				oReport:cDescription 	:= "Relatorio MMG" 
				oReport:cFile 			:= cPastaRel+cAnexo
				oReport:lParamPage 		:= .F.
				oReport:SetTpPlanilha({.F., .F., .T., .F.})

				oReport:Print(.F.)
				
			Else				
				If File(cPastaRel+cAnexo)
					//Cria as defini็๕es do relat๓rio
					oReport := ReportDef()
			
					_cEmail     := cPara
					_cArq       := cAnexo
					_aAttach    := {}
					_cCopia 	:= ""
					_cAssunto   := "[WFPROTHEUS] - " + Alltrim("Relatorio MMG")
					cMsg		:= ""
					aadd( _aAttach  , _cArq )
		

					cMsg := '<html><head><title>stkSales</title></head>
					cMsg += '<body>
					cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
					cMsg += '<br><br>Olแ <b></b>,<br><br> ' //cMsg += '<br><br>Olแ <b>'+Alltrim(SA1->A1_NOME)+'</b>,<br><br>
					cMsg += 'Voc๊ estแ recebendo o Relatorio MMG da Steck!<br>
					cMsg += 'Obrigado!<br><br>'
					cMsg += 'Atenciosamente,<br>
					cMsg += 'Steck Ind๚stria El้trica Ltda
					cMsg += '</body></html>'

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,cPastaRel)  //nใo funcionou
				
					cParada := ""
					//oReport:PrintDialog()
				EndIf
			EndIf
		Next nX
	Else
		VALIDPERG(cPerg)
		oReport		:= ReportDef()
		oReport:PrintDialog()

	EndIf
	

Return
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATำRIO MMG",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio MMG")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"MMG",{"SC6"})


	TRCell():New(oSection,"01",,"PEDIDO VENDA(AM)"	,,06,.F.,)
	TRCell():New(oSection,"10",,"PEDIDO COMPRA(SP)"	,,06,.F.,)
	TRCell():New(oSection,"02",,"PRODUTO"		,,06,.F.,)
	TRCell():New(oSection,"11",,"GRUPO"			,,04,.F.,)

	TRCell():New(oSection,"13",,"DESC GRP"			,,45,.F.,)
	TRCell():New(oSection,"14",,"AGRUP"				,,60,.F.,)

	TRCell():New(oSection,"12",,"DESCR"			,,50,.F.,)
	TRCell():New(oSection,"07",,"QTD.ORIGINAL"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"09",,"QTD.EMBALADO"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"08",,"QTD.SALDO" 	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"03",,"ITEM" 			,,02,.F.,)
	TRCell():New(oSection,"04",,"MOTIVO"	    ,,03,.F.,)
	TRCell():New(oSection,"05",,"EMISSAO"		,,10,.F.,)
	TRCell():New(oSection,"06",,"PROGRAMACAO"	,,07,.F.,)




	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")

Return oReport
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados[2]
	Local aDados1[99]


	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
	oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
	oSection1:Cell("12") :SetBlock( { || aDados1[12] } )

	oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )

	oReport:SetTitle("MMG")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())



			aDados1[01]	:=  (cAliasLif)->PEDIDO
			aDados1[02]	:=  (cAliasLif)->CODIGO
			aDados1[03]	:=  (cAliasLif)->ITEM

			If (cAliasLif)->CLIENTE = '019886' //Mexio
				aDados1[04]	:= "MEX"
			ElseIf (cAliasLif)->CLIENTE = '012047' //SCHNEIDER
				aDados1[04]	:= "EASY"
			Elseif (cAliasLif)->CLIENTE = '033833' //ARGENTINA
				aDados1[04]	:= "ARG"
			Else
				aDados1[04]	:=  (cAliasLif)->MOTIVO
			EndIf

			aDados1[05]	:=  DTOC(STOD((cAliasLif)->EMISSAO))
			aDados1[06]	:=	(cAliasLif)->PROGRAMACAO
			aDados1[07]	:= 	(cAliasLif)->QUANTIDADE
			aDados1[08]	:= 	(cAliasLif)->SALDO
			aDados1[09]	:=	(cAliasLif)->LIQUIDO
			aDados1[10]	:=	(cAliasLif)->PC
			aDados1[11]	:=	(cAliasLif)->GRUPO
			aDados1[12]	:=	(cAliasLif)->DESCR

			aDados1[13]	:=	(cAliasLif)->BM_DESC
			aDados1[14]	:=	(cAliasLif)->AGRUP


			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End

		oSection1:PrintLine()
		aFill(aDados1,nil)

		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------*
Static Function StQuery(_ccod)
	*-----------------------------*

	Local cQuery     := ' '


	If Mv_Par07 = 1 .Or. Mv_Par07 = 2 .Or. Mv_Par07 = 3 .Or. Mv_Par07 = 4

		cQuery := "SELECT SC6.C6_CLI CLIENTE,SC6.C6_PRODUTO CODIGO,(SELECT B1_GRUPO FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=SC6.C6_PRODUTO ) AS GRUPO,"+CL
		cQuery += "SC6.C6_NUM PEDIDO,SC6.C6_ITEM ITEM,SC6.C6_DESCRI DESCR,SC6.C6_QTDVEN QUANTIDADE, (SC6.C6_QTDVEN - SC6.C6_QTDENT) SALDO,SC6.C6_ZMOTPC MOTIVO,"+CL
		cQuery += "NVL((SELECT SUM(ZZU_QTDE)  FROM UDBP12.ZZU030 ZZU INNER JOIN(SELECT * FROM UDBP12.ZZT030) ZZT ON ZZT.D_E_L_E_T_    = ' ' "+CL
		cQuery += "AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N'  AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0) EMBALAGEM, "+CL
		cQuery += "SUM(NVL(TC6.C6_QTDVEN - TC6.C6_QTDENT,0))  TC6,SC5.C5_EMISSAO EMISSAO,SC5.C5_ZMESPC||'/'|| SC5.C5_ZANOPC PROGRAMACAO,SC5.C5_ZNUMPC PC, "+CL
		cQuery += "CASE WHEN NVL((SELECT SUM(ZZU_QTDE)  FROM UDBP12.ZZU030 ZZU INNER JOIN(SELECT * FROM UDBP12.ZZT030) ZZT ON ZZT.D_E_L_E_T_ = ' ' "+CL
		cQuery += "AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT= SC6.C6_PRODUTO),0) = 0 THEN 0 ELSE "+CL //Chamado 007618
		cQuery += "CASE WHEN NVL((SELECT SUM(ZZU_QTDE)  FROM UDBP12.ZZU030 ZZU INNER JOIN(SELECT * FROM UDBP12.ZZT030) ZZT ON ZZT.D_E_L_E_T_ = ' ' AND ZZT.ZZT_NUMEMB = ZZU.ZZU_NUMEMB "+CL
		cQuery += "AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0) > SUM(NVL(TC6.C6_QTDVEN - TC6.C6_QTDENT,0)) THEN SC6.C6_QTDVEN - SC6.C6_QTDENT ELSE "+CL //Chamado 007618
		cQuery += "CASE WHEN ((SUM(NVL(TC6.C6_QTDVEN - TC6.C6_QTDENT,0)) ) - (SC6.C6_QTDVEN - SC6.C6_QTDENT)) > NVL((SELECT SUM(ZZU_QTDE)  FROM UDBP12.ZZU030 ZZU "+CL
		cQuery += "INNER JOIN(SELECT * FROM UDBP12.ZZT030) ZZT ON ZZT.D_E_L_E_T_    = ' ' AND ZZT.ZZT_NUMEMB   = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' "+CL
		cQuery += "AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT   = SC6.C6_PRODUTO),0)  THEN 0 "+CL //Chamado 007618
		cQuery += "ELSE  NVL((SELECT SUM(ZZU_QTDE)  FROM UDBP12.ZZU030 ZZU INNER JOIN(SELECT * FROM UDBP12.ZZT030) ZZT ON ZZT.D_E_L_E_T_    = ' ' "+CL
		cQuery += "AND ZZT.ZZT_NUMEMB = ZZU.ZZU_NUMEMB AND ZZT.ZZT_STATUS  <> '3'  WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU_VIRTUA <> 'N' AND ZZU.ZZU_PRODUT = SC6.C6_PRODUTO),0)-(SUM(NVL(TC6.C6_QTDVEN - TC6.C6_QTDENT,0))-(SC6.C6_QTDVEN - SC6.C6_QTDENT)) "+CL ////Chamado 007618
		cQuery += "END END END LIQUIDO,BM_DESC, NVL(X5_DESCRI,' ') AGRUP FROM UDBP12.SC6030 SC6 "+CL

		cQuery += "INNER JOIN( SELECT * FROM UDBP12.SC5030)SC5 "+CL
		cQuery += "ON SC5.D_E_L_E_T_ = ' ' "+CL
		cQuery += "AND SC5.C5_FILIAL = SC6.C6_FILIAL "+CL
		cQuery += "AND SC5.C5_NUM    = SC6.C6_NUM "+CL

		cQuery += "LEFT JOIN(SELECT * FROM UDBP12.SC6030) TC6 "+CL
		cQuery += "ON TC6.D_E_L_E_T_ = ' ' "+CL
		cQuery += "AND TC6.C6_FILIAL = '01' "+CL
		cQuery += "AND TC6.C6_CLI IN ('033467','019886','012047','033833' ) "+CL
		cQuery += "AND TC6.C6_QTDVEN > TC6.C6_QTDENT "+CL
		cQuery += "AND TC6.C6_BLQ <> 'R' "+CL
		cQuery += "AND TC6.C6_OPER = '15' "+CL
		cQuery += "AND TC6.R_E_C_N_O_ <= SC6.R_E_C_N_O_ "+CL
		cQuery += "AND TC6.C6_PRODUTO = SC6.C6_PRODUTO "+CL

		cQuery += "LEFT JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=SC6.C6_PRODUTO "+CL
		cQuery += "LEFT JOIN "+RetSqlName("SBM")+" BM ON BM_GRUPO=B1_GRUPO "+CL
		cQuery += "LEFT JOIN "+RetSqlName("SX5")+" X5 ON X5_TABELA='ZZ' AND X5_CHAVE=BM_XAGRUP AND X5.D_E_L_E_T_ = ' ' "


		cQuery += "WHERE SC6.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_=' ' AND BM.D_E_L_E_T_ = ' ' AND SC6.C6_FILIAL = '01' "+CL
		cQuery += "AND SC6.C6_CLI IN ('033467','019886','012047','033833' ) "+CL
		cQuery += "AND SC6.C6_QTDVEN > SC6.C6_QTDENT "+CL
		cQuery += "AND SC6.C6_BLQ <> 'R' "+CL
		cQuery += "AND SC6.C6_OPER = '15' "+CL
		cQuery += "AND SC6.C6_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CL
		cQuery += "AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CL
		cQuery += "AND SC5.C5_EMISSAO BETWEEN '"+ DTOS(MV_PAR05)+"' AND '"+ DTOS(MV_PAR06)+"' "+CL
		If Mv_Par07 = 1
			cQuery += " AND SC6.C6_LOJA = '01' "+CL
		ElseIf Mv_Par07 = 2
			cQuery += " AND SC6.C6_LOJA = '02' "+CL
			//// Loja 06 Distribuidora Empresa 11
		ELSEIF MV_PAR07 = 3
			cQuery += " AND SC6.C6_LOJA = '06' "+CL
		EndIf

		cQuery += "GROUP BY SC6.C6_CLI,SC6.C6_PRODUTO, SC6.C6_NUM, SC6.C6_ITEM , SC6.C6_DESCRI,SC6.C6_QTDVEN, SC6.R_E_C_N_O_ ,SC6.C6_QTDVEN - SC6.C6_QTDENT,SC5.C5_EMISSAO,SC6.C6_ZMOTPC,SC5.C5_ZMESPC||'/'||SC5.C5_ZANOPC,SC5.C5_ZNUMPC,BM_DESC,X5_DESCRI "+CL
		cQuery += "ORDER BY SC6.C6_PRODUTO,SC6.R_E_C_N_O_ "+CL

	ElseIf  Mv_Par07 = 5 .Or. Mv_Par07 = 6

		cQuery := "SELECT SC6.C6_PRODUTO CODIGO,SC6.C6_NUM PEDIDO,SC6.C6_ITEM ITEM,SC6.C6_DESCRI DESCR,SC6.C6_QTDVEN QUANTIDADE,(SC6.C6_QTDVEN - SC6.C6_QTDENT) SALDO, "+CL
		cQuery += "' ' MOTIVO,0 EMBALAGEM,0 TC6,SC5.C5_EMISSAO EMISSAO,'00/0000' PROGRAMACAO,0 LIQUIDO, BM_DESC, NVL(X5_DESCRI,' ') AGRUP FROM UDBP12.SC6030 SC6 "+CL

		cQuery += "LEFT JOIN( SELECT * FROM UDBP12.SC5030) SC5 "+CL
		cQuery += "ON SC5.D_E_L_E_T_ = ' ' "+CL
		cQuery += "AND SC5.C5_FILIAL = SC6.C6_FILIAL "+CL
		cQuery += "AND SC5.C5_NUM    = SC6.C6_NUM "+CL

		cQuery += "LEFT JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=SC6.C6_PRODUTO "+CL
		cQuery += "LEFT JOIN "+RetSqlName("SBM")+" BM ON BM_GRUPO=B1_GRUPO "+CL
		cQuery += "LEFT JOIN "+RetSqlName("SX5")+" X5 ON X5_TABELA='ZZ' AND X5_CHAVE=BM_XAGRUP AND X5.D_E_L_E_T_ = ' ' "+CL

		cQuery += "WHERE SC6.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_=' ' AND BM.D_E_L_E_T_ = ' '  "+CL
		cQuery += "AND SC6.C6_FILIAL = '01' "+CL
		If Mv_Par07 = 5
			cQuery += "AND SC6.C6_CLI = '012047' "+CL
			cQuery += "AND SC6.C6_OPER = '15' "+CL
		ElseIf Mv_Par07 = 6
			cQuery += "AND (SC6.C6_CLI = '033833' OR SC6.C6_CLI = '019886') "+CL
		EndIf
		cQuery += "AND SC6.C6_QTDVEN > SC6.C6_QTDENT "+CL
		cQuery += "AND SC6.C6_BLQ <> 'R' "+CL
		//cQuery += " AND SC6.C6_OPER <> '15'

		cQuery += "ORDER BY SC6.C6_PRODUTO,SC6.R_E_C_N_O_ "+CL

	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
//033833 ARGENTINA
//012047 SCHNEIDER

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VALIDAR PERGUNTAS NO ARQUIVO SX1                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
STATIC FUNCTION VALIDPERG(cPerg)
	LOCAL sAlias := Alias()
	LOCAL aRegs  := {}
	LOCAL i,j

	DBSELECTAREA("SX1")
	DBSETORDER(1)
	cPerg := PADR(cPerg, 10)

	AADD(aRegs,{cPerg,"01","Pedido de:"			,"Pedido de:"			,"Pedido de:"			,"MV_CH1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
	AADD(aRegs,{cPerg,"02","Pedido Ate:"		,"Pedido Ate:"		,"Pedido Ate:"		,"MV_CH2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
	AADD(aRegs,{cPerg,"03","Produto de:"		,"Produto de:"		,"Produto de:"		,"MV_CH3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	AADD(aRegs,{cPerg,"04","Produto Ate:"		,"Produto Ate:"		,"Produto Ate:"		,"MV_CH4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	AADD(aRegs,{cPerg,"05","Da Emissao:"		,"Da Emissao:"		,"Da Emissao:"		,"MV_CH5","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","At้ a Emissao:"	,"At้ a Emissao:"	,"At้ a Emissao:"	,"MV_CH6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Destino  :"			,"Destino  :"			,"Destino  :"			,"MV_CH7","N",01,0,0,"C","","MV_PAR07","1-Fabrica","","","2-CD","","","3-Distribuidora","","","4-Ambos","","","",""})

	FOR i:=1 TO LEN(aRegs)
		cRegistro := cPerg+aRegs[i,2]
		IF !DBSEEK(cRegistro)
			RecLock("SX1",.T.)
			FOR j:=1 TO FCOUNT()
				IF j <= LEN(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			NEXT
			MsUnlock()
		ENDIF
	NEXT

	DBSELECTAREA(sAlias)
RETURN()
