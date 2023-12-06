#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TOPCONN.CH'


/*/{Protheus.doc} B0003002
Relatório de Embarque (SIGAEEC)   
Ticket - 20221209021667
@type function
@version  1.0
@author Livia Della Corte
@since 118/12/2022
/*/
User Function B0003002()

Local  oReport
Private oSection
Private _cRotina  := "B0003002"
Private cPerg     := _cRotina
Private cTitulo   := "Relatório de Embarque (SIGAEEC)"
Private _aTpOper  := {}
Private _cVend    := ""

If FindFunction("TRepInUse") .AND. TRepInUse()
	ValidPerg()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ReportDef ³ Autor ³Livia Della Corte  ³ Data ³ 18/12/22     ³±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local oReport
Local oSection
Local oBreak
Local _aOrd       := {""}		


oReport := TReport():New(_cRotina,cTitulo,cPerg,{|oReport| PrintReport(oReport)},"Emissao do relatório, de acordo com o intervalo informado na opção de Parâmetros.")
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)

oSection := TRSection():New(oReport,"Relatório de Embarque (SIGAEEC)",{"EEC","EE8","EE9"},_aOrd/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSection:SetTotalInLine(.F.)
//Definição das colunas do relatório
TRCell():New(oSection,"Numero Processo"  ,"EECTEMP",RetTitle("EEC_PREEMB"  ),PesqPict("EEC","EEC_PREEMB"  ),TamSx3("EEC_PREEMB"  )[1],/*lPixel*/,{|| EECTEMP->EEC_PREEMB      })
TRCell():New(oSection,"Dt. Processo"     ,"EECTEMP",RetTitle("EEC_DTPROC"  ),PesqPict("EEC","EEC_DTPROC"   ),TamSx3("EEC_DTPROC"   )[1],/*lPixel*/,{|| EECTEMP->EEC_DTPROC     })
TRCell():New(oSection,"Cod. Importador"  ,"EECTEMP",RetTitle("EEC_IMPORT")  ,PesqPict("EEC","EEC_IMPORT"),TamSx3("EEC_IMPORT")[1],/*lPixel*/,{|| EECTEMP->EEC_IMPORT })
TRCell():New(oSection,"Nome Importador"  ,"EECTEMP",RetTitle("EEC_IMPODE"  ),PesqPict("EEC","EEC_IMPODE"    ),TamSx3("EEC_IMPODE"    )[1],/*lPixel*/,{|| EECTEMP->EEC_IMPODE        })
TRCell():New(oSection,"Código Item"      ,"EECTEMP",RetTitle("EE9_COD_I")   ,PesqPict("EE9","EE9_COD_I"),TamSx3("EE9_COD_I")[1],/*lPixel*/,{|| EECTEMP->EE9_COD_I       })
TRCell():New(oSection,"Descrição Item"    ,"EECTEMP",RetTitle("EE9_DESC")    ,PesqPict("SYP","YP_TEXTO"),TamSx3("YP_TEXTO")[1],/*lPixel*/,{|| EECTEMP->YP_TEXTO          })
TRCell():New(oSection,"Preço Unit"       ,"EECTEMP",RetTitle("EE9_PRECO"   ),PesqPict("EE9","EE9_PRECO"   ),TamSx3("EE9_PRECO"   )[1],/*lPixel*/,{|| EECTEMP->EE9_PRECO          })
TRCell():New(oSection,"Quantidade"       ,"EECTEMP",RetTitle("EE9_SLDINI"  ),PesqPict("EE9","EE9_SLDINI"  ),TamSx3("EE9_SLDINI"  )[1],/*lPixel*/,{|| EECTEMP->EE9_SLDINI         })
TRCell():New(oSection,"Valor Total"      ,"EECTEMP",RetTitle("EE9_PRCTOT")  ,PesqPict("EE9","EE9_PRCTOT"),TamSx3("EE9_PRCTOT")[1],/*lPixel*/,{|| EECTEMP->EE9_PRCTOT       })
TRCell():New(oSection,"Peso Liq Unitario","EECTEMP",RetTitle("EE9_PSLQUN")  ,PesqPict("EE9","EE9_PSLQUN"),TamSx3("EE9_PSLQUN")[1],/*lPixel*/,{|| EECTEMP->EE9_PSLQUN          })
TRCell():New(oSection,"Peso Liq Total"      ,"EECTEMP",RetTitle("EE9_PSBRUN"  ),PesqPict("EE9","EE9_PSBRUN"   ),TamSx3("EE9_PSBRUN"   )[1],/*lPixel*/,{|| EECTEMP->EE9_PSBRUN          })
TRCell():New(oSection,"Numero do P.O Cliente","EECTEMP",RetTitle("EE8_XPOCLI"  ),PesqPict("EE8","EE8_XPOCLI"  ),TamSx3("EE8_XPOCLI"  )[1],/*lPixel*/,{|| EECTEMP->EE8_XPOCLI         })

oSection:Cell("Numero Processo"):SetHeaderAlign("CENTER")
oSection:Cell("Dt. Processo" ):SetHeaderAlign("CENTER")
oSection:Cell("Cod. Importador"  ):SetHeaderAlign("CENTER")
oSection:Cell("Nome Importador" ):SetHeaderAlign("CENTER")
oSection:Cell("Código Item"    ):SetHeaderAlign("CENTER")
oSection:Cell("Descrição Item"    ):SetHeaderAlign("CENTER"  )
oSection:Cell("Preço Unit"   ):SetHeaderAlign("CENTER" )
oSection:Cell("Quantidade"    ):SetHeaderAlign("CENTER")
oSection:Cell("Valor Total"    ):SetHeaderAlign("CENTER"  )
oSection:Cell("Peso Liq Total"   ):SetHeaderAlign("CENTER" )
oSection:Cell("Numero do P.O Cliente"   ):SetHeaderAlign("CENTER" )


Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³PrintReportºAutor ³Livia Della Corte º     Data ³  18/12/22lribas.adm º±±
±±ºDesc.     ³Processamento das informações para impressão (Print).       º±±
±±ºUso       ³ Programa Principal                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)
local cImpINi := alltrim(MV_PAR03)
local cImpFim := alltrim(MV_PAR04)
local cDescREF :="EE9_DESC"

oSection:BeginQuery()
	BeginSql Alias "EECTEMP"
		SELECT    EEC_PREEMB 
				, EEC_DTPROC
				, EEC_IMPORT 
				, EEC_IMPODE 
				, EE9_COD_I
				, YP_TEXTO
				, EE9_PRECO
				, EE9_SLDINI
				, EE9_PRCTOT
				, EE9_PSLQUN
				, EE9_PSBRUN
				, EE8_XPOCLI
		FROM %table:EEC%  EEC 
			INNER JOIN %table:EE9% EE9 ON  
				EE9_FILIAL = %xFilial:EE9%  AND  
				EEC_PREEMB = EE9_PREEMB AND  
				EEC.D_E_L_E_T_ = EE9.D_E_L_E_T_ 
			INNER JOIN %table:EE8%  EE8 ON   
				EE8_FILIAL = %xFilial:EE8% AND  
				EE9_PEDIDO = EE8_PEDIDO AND  
				EE9_SEQUEN = EE8_SEQUEN AND  
				EE9_COD_I  = EE8_COD_I AND  
				EE9.D_E_L_E_T_ = EE8.D_E_L_E_T_  
			INNER JOIN %table:SYP% SYP ON 
			 	YP_CAMPO =   %Exp:cDescREF%   AND 
			 	EE9_DESC = YP_CHAVE 	
		WHERE EEC.EEC_FILIAL        = %xFilial:EEC% 
			AND EEC.EEC_DTPROC BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)% 
			AND EEC.EEC_IMPORT   BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
			AND EEC.%NotDel%


		ORDER BY EEC_FILIAL, EEC_IMPORT, EEC_DTPROC
	EndSql
	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
oSection:EndQuery()

//MemoWrite("\2.MemoWrite\"+_cRotina+"_QRY_001",oSection:CQUERY)

oSection:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³VALIDPERG ºAutor  ³Livia Della Corte º Data ³  18/12/22     º±±
±±ºDesc.     ³ Valida se as perguntas estão criadas no arquivo SX1 e caso º±±
±±º          ³ não as encontre ele as cria.                               º±±
±±ºUso       ³ Programa Principal                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

Local _sAlias := GetArea()
Local aRegs   := {}

cPerg := PADR(cPerg,10)

AADD(aRegs,{cPerg,"01","Data Embarque  de:" ,"","","mv_ch1","D",1,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Embarque até:","","","mv_ch2","D",1,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Cód. Importador  De:  "       ,"","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","AVE001",""})
AADD(aRegs,{cPerg,"04","Cód. Importador Até: "        ,"","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","AVE001",""})


For i := 1 To Len(aRegs)
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	If !SX1->(MsSeek(cPerg+aRegs[i,2],.T.,.F.))
		RecLock("SX1",.T.)
		For j := 1 To FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else              
				Exit
			EndIf
		Next
		SX1->(MsUnlock())
	EndIf
Next

RestArea(_sAlias)

Return
