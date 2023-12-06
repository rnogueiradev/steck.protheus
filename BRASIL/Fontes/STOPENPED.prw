#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} STOPENPED
Relatorio de pedidos em aberto
@author thiago.fonseca
@since 06/05/2016
@version 1.0
@return SC7, Query

Atualizado em: 12/11/2020 por Zeca

/*/

User Function STOPENPED()
Private cAli 		:= GetNextAlias()
Private cTitulo		:= "Pedidos de Compras - STECK" + ' - '+ Alltrim(cEmpAnt + "/" + cFilAnt)

oReport := ReportDef()
oReport:PrintDialog()
Return

/*/{Protheus.doc} ReportDef

Colunas do relatório e parâmetros de definição em geral.

@type 		function
@author 	Jose C. Frasson
@since 		12/11/2020
@version 	Protheus 12
/*/
Static Function ReportDef()
Local oReport
Local oSection1         

Local cPerg			:= "STOPENPED"  
Local cProg 		:= 'STOPENPED'

xPutSx1(cPerg, "01", "Comprador De?",		"",	"",	"mv_ch1","C",6,0,0,"G","","USR",	"","","mv_par01","","","","","","","","","","","","","","","","")
xPutSx1(cPerg, "02", "Comprador Até?",		"",	"",	"mv_ch2","C",6,0,0,"G","","USR",	"","","mv_par02","","","","","","","","","","","","","","","","")
xPutSx1(cPerg, "03", "Data De?",			"",	"",	"mv_ch3","D",8,0,0,"G","","",		"","","mv_par03","","","","","","","","","","","","","","","","")
xPutSx1(cPerg, "04", "Data Até?",			"",	"",	"mv_ch4","D",8,0,0,"G","","",		"","","mv_par04","","","","","","","","","","","","","","","","")
xPutSx1(cPerg, "05", "Pedidos?"	,			"",	"",	"mv_ch5","C",1,0,0,"C","","",		"","","mv_par05","Em Aberto","","","","Com Bloqueio","","","Eliminado Resid","","",	"Todos","","","","","")
xPutSx1(cPerg, "06", "Imprimir Valores?",	"",	"",	"mv_ch6","C",1,0,0,"C","","",		"","","mv_par06","Sim","","","","Nao","","","","","","","","","","","")

Pergunte(cPerg,.T.)

cTitulo		:= "Pedidos de Compras"

If MV_PAR05 = 1
	cTitulo += " - Em Aberto"
ElseIf MV_PAR05 = 2     
	cTitulo += " - Com Bloqueio"
ElseIf MV_PAR05 = 3
	cTitulo += " - Eliminado Resid"
Else
	cTitulo += " - Todos"
EndIf

cTitulo += " - STECK" + ' - '+ Alltrim(cEmpAnt + "/" + cFilAnt)

oReport:= TReport():New(cProg,cTitulo,cPerg, {|oReport| ReportPrint(oReport,cPerg)},cTitulo) 
oReport:cFontBody := 'Courier New'
oReport:nFontBody := 10

oSection1 := TRSection():New(oReport,cTitulo,{cAli})
TRCell():New(oSection1,"COMPR",		cAli,	"Cod. Comprador",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NUM",		cAli,	"Numero PC",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"PRODUTO",	cAli,	"Cod. Produto",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DESCRI",	cAli,	"Descrição",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"QUANT",		cAli,	"Quantidade",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DATPRF",	cAli,	"Dt. Entrega",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"QUJE",		cAli,	"Qtd. Entregue",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"FORNECE",	cAli,	"Fornecedor",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NOMEFOR",	cAli,	"Nome",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"XPRAFOR",	cAli,	"Prazo",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"FILIAL",	cAli,	"Filial",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)

If MV_PAR06 = 1 //Imprimi Valores
	TRCell():New(oSection1, "VLRORC",	cAli,	"Vlr Orçado",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1, "VLRPRE",	cAli,	"Vlr Negociado",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
EndIf

TRCell():New(oSection1, "C7_NUMSC",		cAli,	"Numero da SC",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1, "C1_SOLICIT",	cAli,	"Nome do Solicitante",/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
Return(oReport)

Static Function ReportPrint(oReport,cPerg)
Local oSection1 := oReport:Section(1)
Local cWhere	:= ""

Pergunte(cPerg,.F.)

If Select(cAli) > 0
	(cAli)->(dbCloseArea())
EndIf	

cWhere :="%"

If MV_PAR05 = 1 //Em Aberto
	cWhere += "	SC7.C7_QUJE	<	SC7.C7_QUANT "
	cWhere += "	AND SC7.C7_RESIDUO = ' ' "
ElseIf MV_PAR05 = 2 //Com Bloqueio     
	cWhere += "	SC7.C7_CONAPRO IN('B','R') "
ElseIf MV_PAR05 = 3 //Eliminado Resid
	cWhere += "	SC7.C7_RESIDUO <> ' ' "
ElseIf MV_PAR05 = 4 //Todos
	cWhere += ""
EndIf

cWhere +="%"

If MV_PAR05 <> 4 
	oSection1:BeginQuery()
	
		BeginSQL Alias cAli
		
			COLUMN DATPRF 	AS DATE
			COLUMN XPRAFOR	AS DATE

			%noParser%
			
			SELECT    
			    SC7.C7_NUM NUM,SC7.C7_USER COMPR,SC7.C7_PRODUTO PRODUTO,SC7.C7_DESCRI DESCRI,SC7.C7_QUANT QUANT,SC7.C7_DATPRF DATPRF,
			    SC7.C7_QUJE QUJE,SC7.C7_RESIDUO,SC7.C7_FORNECE FORNECE,SA2.A2_NOME NOMEFOR, SC7.C7_XPRAFOR XPRAFOR, 
			    SC7.C7_FILIAL FILIAL ,NVL(C7_XPRCORC,0) VLRORC, NVL(C7_PRECO,0) VLRPRE, C7_NUMSC, C1_SOLICIT  
			FROM	%Table:SC7% SC7
			INNER JOIN %Table:SA2% SA2 ON ( SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_FILIAl =  '  '  AND SA2.A2_LOJA=SC7.C7_LOJA )
			INNER JOIN %Table:SC1% SC1 ON ( C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND SC1.D_E_L_E_T_= ' ' ) 
			WHERE SC7.%NotDel%
			AND C7_USER		BETWEEN %Exp:mv_par01% 			AND %Exp:mv_par02%
			AND C7_DATPRF	BETWEEN %Exp:DtoS(mv_par03)% 	AND %Exp:DtoS(mv_par04)% 
			AND %Exp:cWhere%
			GROUP BY    SC7.C7_NUM,SC7.C7_USER,SC7.C7_PRODUTO,SC7.C7_DESCRI,SC7.C7_QUANT,SC7.C7_DATPRF,SC7.C7_QUJE,SC7.C7_RESIDUO,SC7.C7_FORNECE ,SA2.A2_NOME, SC7.C7_XPRAFOR, SC7.C7_FILIAL,C7_XPRCORC,C7_PRECO, C7_NUMSC, C1_SOLICIT  
			ORDER BY    SC7.C7_NUM,SC7.C7_USER,SC7.C7_PRODUTO,SC7.C7_DESCRI,SC7.C7_QUANT,SC7.C7_DATPRF,SC7.C7_QUJE,SC7.C7_RESIDUO,SC7.C7_FORNECE ,SA2.A2_NOME, SC7.C7_XPRAFOR, SC7.C7_FILIAL
		EndSQL
		
	oSection1:EndQuery()
Else
	oSection1:BeginQuery()
	
		BeginSQL Alias cAli
		
			COLUMN DATPRF AS DATE
			%noParser%
			
			SELECT    
			    SC7.C7_NUM NUM,SC7.C7_USER COMPR,SC7.C7_PRODUTO PRODUTO,SC7.C7_DESCRI DESCRI,SC7.C7_QUANT QUANT,SC7.C7_DATPRF DATPRF,
			    SC7.C7_QUJE QUJE,SC7.C7_RESIDUO,SC7.C7_FORNECE FORNECE,SA2.A2_NOME NOMEFOR, SC7.C7_XPRAFOR XPRAFOR, 
			    SC7.C7_FILIAL FILIAL ,NVL(C7_XPRCORC,0) VLRORC, NVL(C7_PRECO,0) VLRPRE, C7_NUMSC, C1_SOLICIT  
			FROM	%Table:SC7% SC7
			INNER JOIN %Table:SA2% SA2 ON ( SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_FILIAl =  '  '  AND SA2.A2_LOJA=SC7.C7_LOJA )
			INNER JOIN %Table:SC1% SC1 ON ( C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND SC1.D_E_L_E_T_= ' ' ) 
			WHERE SC7.%NotDel%
			AND C7_USER		BETWEEN %Exp:mv_par01% 			AND %Exp:mv_par02%
			AND C7_DATPRF	BETWEEN %Exp:DtoS(mv_par03)% 	AND %Exp:DtoS(mv_par03)% 
			GROUP BY    SC7.C7_NUM,SC7.C7_USER,SC7.C7_PRODUTO,SC7.C7_DESCRI,SC7.C7_QUANT,SC7.C7_DATPRF,SC7.C7_QUJE,SC7.C7_RESIDUO,SC7.C7_FORNECE ,SA2.A2_NOME, SC7.C7_XPRAFOR, SC7.C7_FILIAL,C7_XPRCORC,C7_PRECO, C7_NUMSC, C1_SOLICIT  
			ORDER BY    SC7.C7_NUM,SC7.C7_USER,SC7.C7_PRODUTO,SC7.C7_DESCRI,SC7.C7_QUANT,SC7.C7_DATPRF,SC7.C7_QUJE,SC7.C7_RESIDUO,SC7.C7_FORNECE ,SA2.A2_NOME, SC7.C7_XPRAFOR, SC7.C7_FILIAL
		EndSQL
		
	oSection1:EndQuery()
Endif

oSection1:Print()	
Return

/*====================================================================================\
|Programa  | xPutSx1	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    	:= Iif( cPyme           == Nil, " ", cPyme          )
	cF3      	:= Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg 	:= Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   	:= Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      	:= Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))
		/* Removido\Ajustado - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

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

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

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
