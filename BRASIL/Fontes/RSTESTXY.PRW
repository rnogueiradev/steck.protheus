#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*/{Protheus.doc} RSTESTXY.PRW
(Relatório XYZ)

@author jefferson.carlos
@since 21/02/2020
@version 1.0
@return ${return}, ${return_description}

/*/

User Function RSTESTXY()

Local   oReport
Private cPerg		:= "RESTXY"
Private cTime		:= Time()
Private cHora		:= SUBSTR(cTime, 1, 2)
Private cMinutos	:= SUBSTR(cTime, 4, 2)
Private cSegundos	:= SUBSTR(cTime, 7, 2)
Private cAliasLif	:= cPerg+cHora+cMinutos+cSegundos
Private cPergTit	:= cAliasLif

xPutSx1(cPerg, "01", "Data da Demissao de?"		,"Data da Demissao de?" 	,"Data da Demissao de?" 	,"MV_CH1","D",8,0,0,"G","",'' 			,"","","MV_PAR01","","","","","","","","","","","","","","","","")
xPutSx1(cPerg, "02", "Data da Demissao ate?"	,"Data da Demissao ate?" 	,"Data da Demissao ate?" 	,"MV_CH2","D",8,0,0,"G","",'' 			,"","","MV_PAR02","","","","","","","","","","","","","","","","")
xPutSx1(cPerg, "03", "Ordem de Producao de?"	,"Ordem de Producao de?" 	,"Ordem de Producao de?" 	,"MV_CH3","C",14,0,0,"G","",'' 			,"","","MV_PAR03","","","","","","","","","","","","","","","","")
xPutSx1(cPerg, "04", "Ordem de Producao ate?"	,"Ordem de Producao ate?" 	,"Ordem de Producao ate?" 	,"MV_CH4","C",14,0,0,"G","",'' 			,"","","MV_PAR04","","","","","","","","","","","","","","","","")


oReport	:= ReportDef()
oReport:PrintDialog()

Return


/*/{Protheus.doc} RSTESTXY
(Relatório XYZ)

@author jefferson.carlos
@since 21/02/2020
@version 1.0

/*/

Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2

oReport		:= TReport():New(cPergTit,"Relatório XYZ",cPerg ,{|oReport| ReportPrint(oReport)},"Impressão XYZ ")

//Pergunte(cPerg,.F.)

oSection1	:= TRSection():New(oReport,"Relatório XYZ",{"MOV"})

TRCell():New(oSection1,"01",,"FILIAL"			,,TamSx3("D3_FILIAL")[1]	,.F.,,,,,,,.T.)
TRCell():New(oSection1,"02",,"CODIGO"			,,TamSx3("D3_COD")[1]		,.F.,,,,,,,.T.)
TRCell():New(oSection1,"03",,"UNDMED"			,,TamSx3("D3_UM")[1]		,.F.,,,,,,,.T.)
TRCell():New(oSection1,"04",,"QUANT"			,,TamSx3("D3_QUANT")[1]		,.F.,,,,,,,.T.)
TRCell():New(oSection1,"05",,"ORDEM_PRODUCAO"	,,TamSx3("D3_OP")[1]		,.F.,,,,,,,.T.)
TRCell():New(oSection1,"06",,"TIPORE"			,,TamSx3("D3_CF")[1]		,.F.,,,,,,,.T.)
TRCell():New(oSection1,"07",,"EMISSAO"			,,TamSx3("D3_EMISSAO")[1]	,.F.,,,,,,,.T.)
TRCell():New(oSection1,"08",,"ESTORNO"			,,TamSx3("D3_ESTORNO")[1]	,.F.,,,,,,,.T.)

oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("MOV")

Return oReport


/*/{Protheus.doc} RSTESTXY
(Relatório XYZ)

@author jefferson.carlos
@since 21/02/2020
@version 1.0

/*/

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
Local nX		:= 0
Local aDados1[99]
Local aDados2[99]

oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
oSection1:Cell("08") :SetBlock( { || aDados1[08] } )

oReport:SetTitle("MOV")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados1,nil)
aFill(aDados2,nil)
oSection1:Init()
oSection2:Init()

Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())

If  Select(cAliasLif) > 0
	
	While (cAliasLif)->(!Eof())
		
		aDados1[01]	:=	(cAliasLif)->FILIAL
		aDados1[02]	:=	(cAliasLif)->CODIGO
		aDados1[03]	:=	(cAliasLif)->UNDMED
		aDados1[04]	:=	cValToChar((cAliasLif)->QUANT)
		aDados1[05]	:=	(cAliasLif)->ORDEM_PRODUCAO
		aDados1[06]	:=  (cAliasLif)->TIPORE
		aDados1[07]	:=	DTOC(STOD((cAliasLif)->EMISSAO))
		aDados1[08]	:=	(cAliasLif)->ESTORNO
		
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


/*/{Protheus.doc} RSTESTXY.PRW
(Gera Consulta no Banco de Dados)

@author jefferson.carlos
@since 07/02/2019
@version 1.0
/*/

Static Function StQuery()

Local cQuery1	:= ' '

cQuery1+= " SELECT "
cQuery1+= " D3_FILIAL FILIAL, D3_COD CODIGO,D3_UM UNDMED,D3_QUANT QUANT, "
cQuery1+= " D3_OP ORDEM_PRODUCAO, D3_CF TIPORE,D3_EMISSAO EMISSAO, D3_ESTORNO ESTORNO "
cQuery1+= " FROM " + RetSqlName("SD3") + " SD3 "
cQuery1+= " WHERE SD3.D_E_L_E_T_ = ' ' "
cQuery1+= " AND SD3.D3_FILIAL = '" + xFilial('SD3') + "' " "
cQuery1+= " AND SD3.D3_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " "
cQuery1+= " AND SD3.D3_OP BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " "
cQuery1+= " AND SD3.D3_COD NOT LIKE 'MOD%' "
cQuery1+= " ORDER BY SD3.R_E_C_N_O_ "


If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()

/*/{Protheus.doc} RSTESTXY
(Relatório XYZ)

@author jefferson.carlos
@since 21/02/2020
@version 1.0

/*/

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
cF3, cGrpSxg,cPyme,;
cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
cDef02,cDefSpa2,cDefEng2,;
cDef03,cDefSpa3,cDefEng3,;
cDef04,cDefSpa4,cDefEng4,;
cDef05,cDefSpa5,cDefEng5,;
aHelpPor,aHelpEng,aHelpSpa,cHelp)

LOCAL aArea	:= GetArea()
Local cKey
Local lPort	:= .f.
Local lSpa	:= .f.
Local lIngl	:= .f.

cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

cPyme	:= Iif( cPyme	== Nil, " ", cPyme)
cF3		:= Iif( cF3		== NIl, " ", cF3)
cGrpSxg	:= Iif( cGrpSxg	== Nil, " ", cGrpSxg)
cCnt01	:= Iif( cCnt01	== Nil, "" , cCnt01)
cHelp	:= Iif( cHelp	== Nil, "" , cHelp)

dbSelectArea( "SX1" )
dbSetOrder( 1 )

// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
// RFC - 15/03/2007
cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

If !( DbSeek( cGrupo + cOrdem ))
	
	cPergunt	:= If(! "?" $ cPergunt	.And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
	cPerSpa		:= If(! "?" $ cPerSpa	.And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
	cPerEng		:= If(! "?" $ cPerEng	.And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
	/* Removido - 12/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	Reclock( "SX1" , .T. )
	
	Replace X1_GRUPO   With cGrupo
	Replace X1_ORDEM   With cOrdem
	Replace X1_PERGUNT With cPergunt
	Replace X1_PERSPA With cPerSpa
	Replace X1_PERENG With cPerEng
	Replace X1_VARIAVL With cVar
	Replace X1_TIPO    With cTipo
	Replace X1_TAMANHO With nTamanho
	Replace X1_DECIMAL With nDecimal
	Replace X1_PRESEL With nPresel
	Replace X1_GSC     With cGSC
	Replace X1_VALID   With cValid
	
	Replace X1_VAR01   With cVar01
	
	Replace X1_F3      With cF3
	Replace X1_GRPSXG With cGrpSxg
	
	If Fieldpos("X1_PYME") > 0
		If cPyme != Nil
			Replace X1_PYME With cPyme
		Endif
	Endif
	
	Replace X1_CNT01   With cCnt01
	If cGSC == "C"               // Mult Escolha
		Replace X1_DEF01   With cDef01
		Replace X1_DEFSPA1 With cDefSpa1
		Replace X1_DEFENG1 With cDefEng1
		
		Replace X1_DEF02   With cDef02
		Replace X1_DEFSPA2 With cDefSpa2
		Replace X1_DEFENG2 With cDefEng2
		
		Replace X1_DEF03   With cDef03
		Replace X1_DEFSPA3 With cDefSpa3
		Replace X1_DEFENG3 With cDefEng3
		
		Replace X1_DEF04   With cDef04
		Replace X1_DEFSPA4 With cDefSpa4
		Replace X1_DEFENG4 With cDefEng4
		
		Replace X1_DEF05   With cDef05
		Replace X1_DEFSPA5 With cDefSpa5
		Replace X1_DEFENG5 With cDefEng5
	Endif
	
	Replace X1_HELP With cHelp
	
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	MsUnlock()
Else
	
	lPort	:= ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
	lSpa	:= ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
	lIngl	:= ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)
	
	If lPort .Or. lSpa .Or. lIngl
		RecLock("SX1",.F.)
		If lPort
			SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
		EndIf
		If lSpa
			SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
		EndIf
		If lIngl
			SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
		EndIf
		SX1->(MsUnLock())
	EndIf*/
Endif

RestArea( aArea )

Return
