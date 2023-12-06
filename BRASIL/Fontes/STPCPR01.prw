#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STPCPR01   º Autor ³ Vitor Merguizo	 º Data ³  30/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Relação de Requisições por OP                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STPCPR01()

Local oReport
Local aArea	:= GetArea()
Private aSuper := {}

Ajusta()

If Pergunte("STPCPR01",.T.)
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Microsiga           º Data ³  03/30/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definicao do layout do Relatorio                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

Local oReport
Local oSection1

oReport := TReport():New("STPCPR01","Relação de Requisições por OP","STPCPR01",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o Relação de Requisições por OP conforme parametros.")

pergunte("STPCPR01",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						  ³
//³ mv_par01			// Mes							 		  ³
//³ mv_par02			// Ano									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



oSection1 := TRSection():New(oReport,"Estrutura",{"SG1"},)
TRCell():New(oSection1,"FILIAL"		,,"Filial"		,,020,.F.,)
TRCell():New(oSection1,"EMISSAO"	,,"Emissao"		,,020,.F.,)
TRCell():New(oSection1,"COD"		,,"Codigo"		,,020,.F.,)
TRCell():New(oSection1,"DESC"		,,"Descricao"	,,030,.F.,)
TRCell():New(oSection1,"OP"			,,"N.OP."		,,020,.F.,)
TRCell():New(oSection1,"CF"			,,"C.F."		,,020,.F.,)
TRCell():New(oSection1,"PROD"		,,"Produto"		,,020,.F.,)
TRCell():New(oSection1,"GRUPO"		,,"Grupo"		,,020,.F.,)
TRCell():New(oSection1,"QUANT"		,,"Quantidade"	,"@E 9,999,999.99",030,.F.,)
TRCell():New(oSection1,"CUSTO"		,,"Custo"		,"@E 9,999,999.99",030,.F.,)
oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SG1")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Microsiga		          ³ Data ³12.05.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)

Local cTitulo		:= OemToAnsi("Relação de Requisições por OP")
Local cAlias1		:= "QRY1SG1"
Local cQuery1		:= ""
Local _i			:= 0
Local nCont			:= 0
Local nPos			:= 0
Local nValor		:= 0
Local aDados1[10]
Local oSection1  := oReport:Section(1)

oSection1:Cell("FILIAL"	)		:SetBlock( { || aDados1[1] })
oSection1:Cell("EMISSAO")		:SetBlock( { || aDados1[2] })
oSection1:Cell("COD"	)		:SetBlock( { || aDados1[3] })
oSection1:Cell("DESC"	)		:SetBlock( { || aDados1[4] })
oSection1:Cell("OP"		)		:SetBlock( { || aDados1[5] })
oSection1:Cell("CF"		)		:SetBlock( { || aDados1[6] })
oSection1:Cell("PROD"	)		:SetBlock( { || aDados1[7] })
oSection1:Cell("GRUPO"	)		:SetBlock( { || aDados1[8] })
oSection1:Cell("QUANT"	)		:SetBlock( { || aDados1[9] })
oSection1:Cell("CUSTO"	)		:SetBlock( { || aDados1[10] })

//Monta Query para Extrair dados de Estrutura
cQuery1 := " SELECT D3_FILIAL, D3_EMISSAO, D3_COD, SB12.B1_DESC B1_DESC2, D3_OP, D3_CF, C2_PRODUTO, SB1.B1_GRUPO, D3_QUANT, D3_CUSTO1 "
cQuery1 += " FROM SD3010 SD3 "
cQuery1 += " INNER JOIN SC2010 SC2 ON C2_NUM = SUBSTR(D3_OP,1,6) AND C2_ITEM = SUBSTR(D3_OP,7,2) AND C2_SEQUEN = SUBSTR(D3_OP,9,3) AND SC2.D_E_L_E_T_= ' ' "
cQuery1 += " INNER JOIN SB1010 SB1 ON SB1.B1_FILIAL = ' ' AND SB1.B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_= ' ' "
cQuery1 += " INNER JOIN SB1010 SB12 ON SB12.B1_FILIAL = ' ' AND SB12.B1_COD = D3_COD AND SB12.D_E_L_E_T_= ' ' "
cQuery1 += " WHERE "
cQuery1 += " D3_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND "
cQuery1 += " C2_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
cQuery1 += " SB1.B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
cQuery1 += " D3_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
cQuery1 += " D3_OP BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' AND "
cQuery1 += " SD3.D_E_L_E_T_= ' ' "
cQuery1 += " ORDER BY D3_OP, D3_COD "

cQuery1 := ChangeQuery(cQuery1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)

TCSetField(cAlias1,"D3_EMISSAO","D",8,0)
TCSetField(cAlias1,"D3_QUANT","N",TamSx3("D3_QUANT")[1],TamSx3("D3_QUANT")[2])
TCSetField(cAlias1,"D3_CUSTO1","N",TamSx3("D3_CUSTO1")[1],TamSx3("D3_CUSTO1")[2])

oReport:SetTitle(cTitulo)

dbeval({||nCont++})

oReport:SetMeter(nCont)

//Imprime os dados de Metas
aFill(aDados1,nil)
oSection1:Init()

//Atualiza Array com dados de Estrutura
dbSelectArea(cAlias1)
(cAlias1)->(dbGoTop())
While (cAlias1)->(!Eof())
	
	oReport:IncMeter()
	
	aDados1[1] := (cAlias1)->D3_FILIAL
	aDados1[2] := DTOC((cAlias1)->D3_EMISSAO)
	aDados1[3] := (cAlias1)->D3_COD
	aDados1[4] := (cAlias1)->B1_DESC2
	aDados1[5] := (cAlias1)->D3_OP
	aDados1[6] := (cAlias1)->D3_CF
	aDados1[7] := (cAlias1)->C2_PRODUTO
	aDados1[8] := (cAlias1)->B1_GRUPO
	aDados1[9] := (cAlias1)->D3_QUANT
	aDados1[10] := (cAlias1)->D3_CUSTO1
	
	oSection1:PrintLine()
	aFill(aDados1,nil)
	
	(cAlias1)->(dbSkip())
EndDo

oReport:SkipLine()
oSection1:Finish()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ajusta    ºAutor  ³Microsiga           º Data ³  03/30/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Insere novas perguntas na tabela SX1 a Ajusta o Picture    º±±
±±º          ³ dos valores no SX3                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Data de ?                    ","Data de ?                    ","Data de ?                    ","mv_ch1","D",8 ,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Data ate ?                   ","Data ate ?                   ","Data ate ?                   ","mv_ch2","D",8 ,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Produto de ?                 ","Produto de ?                 ","Produto de ?                 ","mv_ch3","C",15,0,0,"G",""                   ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Produto ate ?                ","Produto ate ?                ","Produto ate ?                ","mv_ch4","C",15,0,0,"G",""                   ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Grupo de ?                   ","Grupo de ?                   ","Grupo de ?                   ","mv_ch5","C",4 ,0,0,"G",""                   ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
Aadd(aPergs,{"Grupo ate ?                  ","Grupo ate ?                  ","Grupo ate ?                  ","mv_ch6","C",4 ,0,0,"G",""                   ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
Aadd(aPergs,{"Componente de ?              ","Componente de ?              ","Componente de ?              ","mv_ch7","C",15,0,0,"G",""                   ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Componente ate ?             ","Componente ate ?             ","Componente ate ?             ","mv_ch8","C",15,0,0,"G",""                   ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"OP de ?                      ","OP de ?                      ","OP de ?                      ","mv_ch9","C",13,0,0,"G",""                   ,"mv_par09","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
Aadd(aPergs,{"OP ate ?                     ","OP ate ?                     ","OP ate ?                     ","mv_cha","C",13,0,0,"G",""                   ,"mv_par10","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})

//AjustaSx1("STPCPR01",aPergs)

Return
