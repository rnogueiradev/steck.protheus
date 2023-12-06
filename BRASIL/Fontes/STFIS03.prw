#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STFIS03  บ Autor ณ Cristiano Pereiraบ Data ณ  17/07/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rela็ใo de Carta de Corre็ใo por Perํodo                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function STFIS03()

	Local oReport
	Local aArea	:= GetArea()

	Ajusta()

	If Pergunte("STFIS03",.T.)
		oReport 	:= ReportDef()
		oReport		:PrintDialog()
	EndIf

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Definicao do layout do Relatorio                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static aDados1[08]

Static Function ReportDef()

	Local oReport
	Local oSection1
	Private oBreak1
	Private oSecFil

	oReport := TReport():New("STFIS03","Rela็ใo das cartas de corre็๕es","STFIS03",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir a anแlise das cartas de corre็๕es.")

	oReport:SetLandscape()
	pergunte("STFIS03",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros						  ณ
//ณ mv_par01			// Mes							 		  ณ
//ณ mv_par02			// Ano									  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	oSection1 := TRSection():New(oReport,"Carta de Corre็ใo",{"SF2"},)

	TRCell():New(oSection1,"FILIAL"	     	,,"FILIAL"	    ,"@!",002,.F.,)
	TRCell():New(oSection1,"NFISCAL"	,,"NOTA FISCAL"	,"@!",009,.F.,)
	TRCell():New(oSection1,"CLI"		,,"CLIENTE"	,"@!",006,.F.,)
	TRCell():New(oSection1,"LOJA"		,,"LOJA"	,"@!",002,.F.,)
	TRCell():New(oSection1,"NOME"		,,"NOME"	,"@!",030,.F.,)

	TRCell():New(oSection1,"EMIS"	,,"EMISSรO"	,,010,.F.,)
	TRCell():New(oSection1,"IDEVEN"		,,"ID EVENTO"	,"@!",050,.F.,)
	TRCell():New(oSection1,"CORREC"		,,"CORREวรO"	,"@!",100,.F.,)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SF2")



Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportPrintณ Autor ณMicrosiga		          ณ Data ณ12.05.12 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri็ใo ณA funcao estatica ReportDef devera ser criada para todos os  ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1: Objeto Report do Relat๓rio                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

	Local cTitulo		:= OemToAnsi("Carta de Corre็ใo")
	Local cAlias1		:= "QRY1SF2"
	Local cQuery1		:= ""
	Local _cQry150    := ""
	Local nRecSM0		:= SM0->(Recno())
	Local oSection1  := oReport:Section(1)
	Private	aSaldo  := {}
	Private _nTpeso



	oSection1:Cell("FILIAL"  )	     	:SetBlock( { || aDados1[1] })
	oSection1:Cell("NFISCAL" )		:SetBlock( { || aDados1[2] })
	oSection1:Cell("CLI" )	   	:SetBlock( { || aDados1[3] })
	oSection1:Cell("LOJA" )	    	:SetBlock( { || aDados1[4] })
	oSection1:Cell("NOME" )	    	:SetBlock( { || aDados1[5] })

	oSection1:Cell("EMIS" )    	:SetBlock( { || aDados1[6] })
	oSection1:Cell("IDEVEN" )      	:SetBlock( { || aDados1[7] })
	oSection1:Cell("CORREC" )      	:SetBlock( { || aDados1[8] })


	If Select(cAlias1) > 0
		DbSelectArea(cAlias1)
		DbCloSeArea()
	Endif


	cQuery1 :=  " SELECT SF2.*                     "
	cQuery1 +=  " FROM   "+RetSqlName("SF2")+" SF2 "

	cQuery1 +=  " WHERE SF2.F2_FILIAL >= '"+MV_PAR01+"' AND SF2.F2_FILIAL <= '"+MV_PAR02+"' AND SF2.D_E_L_E_T_ <> '*'     AND "
	cQuery1 +=  "       SF2.F2_EMISSAO >= '"+DTOS(MV_PAR03)+"' AND SF2.F2_EMISSAO <='"+DTOS(MV_PAR04)+"'                  AND "
	cQuery1 +=  "       SF2.F2_IDCCE <> ''                                                                                    "

	cQuery1 +=  "  ORDER BY SF2.F2_FILIAL,SF2.F2_DOC,SF2.F2_EMISSAO                                                           "

	cQuery1 := ChangeQuery(cQuery1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha Alias se estiver em Uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Area de Trabalho executando a Query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)


	oReport:SetTitle(cTitulo)

	nCont:= 0
	dbeval({||nCont++})

	oReport:SetMeter(nCont)

	aFill(aDados1,nil)
	oSection1:Init()

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

//Imprime Dcre
	aFill(aDados1,nil)
	oSection1:Init()

//Atualiza Array com dados de Capta็ใo
	While (cAlias1)->(!Eof())


		If Select("SPD150") > 0
			DbSelectArea("SPD150")
			DbCloSeArea()
		Endif
   
        
		If Substr(cNumEmp,03,02) <> "03"
       
			_cQry150 := " SELECT SUBSTR(utl_raw.cast_to_varchar2(XML_ERP),INSTR(utl_raw.cast_to_varchar2(XML_ERP),'<xCorrecao>'),INSTR(utl_raw.cast_to_varchar2(XML_ERP),'</xCorrecao>')-INSTR(utl_raw.cast_to_varchar2(XML_ERP),'<xCorrecao>')) AS MOTIVO    "
			_cQry150   += " FROM SPED150 SPD                                                               "
			_cQry150   += " WHERE SPD.ID_EVENTO = '"+AllTrim((cAlias1)->(F2_IDCCE))+"'         AND                  "
			_cQry150   += "       SPD.ID_ENT IN ('000001','000002','000007','000008')                               "
     
			TCQUERY _cQry150 NEW ALIAS "SPD150"
     
			_nRec := 0
			DbEval({|| _nRec++  }) 
			
			DbSelectArea("SPD150") 
			DbGotop()
	
       
		Else
       
			_cQry150 := " SELECT SUBSTR(utl_raw.cast_to_varchar2(XML_ERP),INSTR(utl_raw.cast_to_varchar2(XML_ERP),'<xCorrecao>'),INSTR(utl_raw.cast_to_varchar2(XML_ERP),'</xCorrecao>')-INSTR(utl_raw.cast_to_varchar2(XML_ERP),'<xCorrecao>')) AS MOTIVO    "
			_cQry150   += " FROM SPED150 SPD                                                               "
			_cQry150   += " WHERE SPD.ID_EVENTO = '"+AllTrim((cAlias1)->(F2_IDCCE))+"'      AND                     "
			_cQry150   += "       SPD.ID_ENT IN ('000004','000009')   "
     
			TCQUERY _cQry150 NEW ALIAS "SPD150"
     
			_nRec := 0
			DbEval({|| _nRec++  })
		DbSelectArea("SPD150") 
			DbGotop()
       
		Endif
   
		
	
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+(cAlias1)->(F2_CLIENTE)+(cAlias1)->(F2_LOJA))
			aDados1[01]  := (cAlias1)->(F2_FILIAL)
			aDados1[02]  := (cAlias1)->(F2_DOC)
			aDados1[03]  := (cAlias1)->(F2_CLIENTE)
			aDados1[04]  := (cAlias1)->(F2_LOJA)
			aDados1[05]  := SA1->A1_NOME
			aDados1[06]  := DTOC(STOD((cAlias1)->(F2_EMISSAO)))
			aDados1[07]  := (cAlias1)->(F2_IDCCE)
			aDados1[08]  := IIF(_nRec > 0 ,STRTRAN(STRTRAN(SPD150->MOTIVO,'<xCorrecao>',''),'</xCorrecao>',''),"NรO ENCONTRADO, VERIFICAR SEFAZ!")
		Endif
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAlias1)->(dbSkip())
	EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha Alias se estiver em Uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

//Imprime os dados de Metas
	aFill(aDados1,nil)
	oSection1:Init()

	oSection1:PrintLine()
	aFill(aDados1,nil)

	oReport:SkipLine()
	oSection1:Finish()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณCristiano Pereira  บ Data ณ  03/20/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function Ajusta()

	Local aPergs 	:= {}

	Aadd(aPergs,{"Filial De ?              ","Filial De?              ","Filial De ?             ","mv_ch1","C",2,0,0,"G","NaoVazio() ","mv_par01","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Filial Ate ?             ","Filial Ate?              ","Filial Ate ?             ","mv_ch2","C",2,0,0,"G","NaoVazio() ","mv_par02","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Data De ?                ","Data De ?             	  ","Data De ?                ","mv_ch3","D",8,0,0,"C","NaoVazio() ","mv_par03","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Data Ate ?               ","Data Ate ?             	  ","Data Ate?                    ","mv_ch4","D",8,0,0,"C","NaoVazio() ","mv_par04","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STFIS03",aPergs)

Return