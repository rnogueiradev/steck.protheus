#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTIR01  ºAutor   ³Renato Nogueira    º Data ³  07/02/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este relatório tem por objetivo mostrar o detalhamento dos  º±±
±±º          ³chamados de TI                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTIR01()

Local oReport

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STTIR01","RELATÓRIO DE CHAMADOS",,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de chamados.")

oSection := TRSection():New(oReport,"RELAÇÃO DE CHAMADOS",{"SZ0"})

TRCell():New(oSection,"NUM" 	,"SZ0"	,"NUMERO"			,"@!",6)
TRCell():New(oSection,"SOLIC"   ,"SZ0"	,"SOLICITANTE"		,"@!",30)
TRCell():New(oSection,"DEPTO"	,"SZ0"	,"DEPARTAMENTO"		,"@!",30)
TRCell():New(oSection,"ASSUNTO"	,"SZ0"	,"ASSUNTO"			,"@!",70)
TRCell():New(oSection,"STATUS"	,"SZ0"	,"STATUS"			,"@!",30)
TRCell():New(oSection,"DETALHE"	,"SZ0"	,"DETALHAMENTO"		,"@!",100000000)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SZ0")

Return oReport

Static Function ReportPrint(oReport)

Local oSection		:= oReport:Section(1)
Local nX			:= 0
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP"
Local aDados[6]
Local cStatus		:= ""
Local cObs			:= ""

oSection:Cell("NUM")	:SetBlock( { || aDados[1] } )
oSection:Cell("SOLIC")	:SetBlock( { || aDados[2] } )
oSection:Cell("DEPTO")	:SetBlock( { || aDados[3] } )
oSection:Cell("ASSUNTO"):SetBlock( { || aDados[4] } )
oSection:Cell("STATUS")	:SetBlock( { || aDados[5] } )
oSection:Cell("DETALHE"):SetBlock( { || aDados[6] } )

oReport:SetTitle("Chamados")// Titulo do relatório

cQuery := " SELECT Z0_NUM, Z0_USUARIO, Z0_MODULO, Z0_DESCRI, Z0_OBS, Z0_STATUS "
cQuery += " FROM " +RetSqlName("SZ0") "
cQuery += " WHERE D_E_L_E_T_=' ' "
cQuery += " ORDER BY Z0_NUM "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

oReport:SetMeter(0)
aFill(aDados,nil)
oSection:Init()

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While !(cAlias)->(Eof())

DO CASE
CASE (cAlias)->Z0_STATUS=="1"
cStatus	:= "Aguardando Aprov. Superv."
CASE (cAlias)->Z0_STATUS=="2"
cStatus	:= "Aprovado Supervisor"
CASE (cAlias)->Z0_STATUS=="3"
cStatus	:= "Aprovado para desenvolvimento"
CASE (cAlias)->Z0_STATUS=="4"
cStatus	:= "Em desenvolvimento"
CASE (cAlias)->Z0_STATUS=="5"
cStatus	:= "Aguardando aceite usuário"
CASE (cAlias)->Z0_STATUS=="6"
cStatus	:= "Aprovado pelo usuário"
CASE (cAlias)->Z0_STATUS=="7"
cStatus	:= "Liberado p/ Amb. Produção"
CASE (cAlias)->Z0_STATUS=="8"
cStatus	:= "Chamado concluído"
CASE (cAlias)->Z0_STATUS=="9"
cStatus	:= "Chamado cancelado"
ENDCASE             

DbSelectArea("SX5")
SX5->(DbGotop())
SX5->(DbSetOrder(1))
SX5->(DbSeek(xFilial("SX5")+"ZX"+(cAlias)->Z0_MODULO))

DbSelectArea("SZ0")
SZ0->(DbGotop())
SZ0->(DbSetOrder(1))
SZ0->(DbSeek(xFilial("SZ0")+(cAlias)->Z0_NUM))

cObs := SZ0->Z0_OBS

	aDados[1]	:=	(cAlias)->Z0_NUM
	aDados[2]	:=	(cAlias)->Z0_USUARIO
	aDados[3]	:=	SX5->X5_DESCRI
	aDados[4]	:=  (cAlias)->Z0_DESCRI
	aDados[5]	:=	cStatus
	aDados[6]	:=	cObs
	
	oSection:PrintLine()
	aFill(aDados,nil)
	
	(cAlias)->(DbSkip())
	
EndDo

oReport:SkipLine()

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport