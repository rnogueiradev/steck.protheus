#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA17  ºAutor  ³Microsiga           º Data ³  01/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de pendencias de transferencia do deposito fechadoº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSFA17()

Local oReport

PutSx1("STFSFA17","01","(1) Todas as pendências - (2) Só o que depende do DF?","","","mv_ch1","C",1,0,0,,"","","","","mv_par01","","","","","","","","","","","","","","","","")      

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STFSFA17","RELATÓRIO DE PRODUTOS A TRANSFERIR DO DF","STFSFA17",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de produtos para transferir do df.")

Pergunte("STFSFA17",.F.)

oSection := TRSection():New(oReport,"PRODS",{"TRB"})

TRCell():New(oSection,"COD","TRB","CODIGO",,30)
TRCell():New(oSection,"QTDE","TRB","QUANTIDADE","@E 999,999.99",20)
TRCell():New(oSection,"DESC","TRB","DESCRIÇÃO",,120)

oSection:SetHeaderSection(.T.)

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local nX			:= 0
Local nZ			:= 0
Local aDados[2]
Local aPswDet
Local lEncrypt	:= .F.
Local aUsuarios	:= {}
Local aGrupos	:= {}
Local oReport
Local oSection
Local oSection2
Local cGrupo
Local cDados1
Local cDados2
Local aArea		:= GetArea()
Local aSC2Area	:= SC2->(GetArea())
Local aSC5Area	:= SC5->(GetArea())
Local aSC6Area	:= SC6->(GetArea())
Local aSD4Area	:= SD4->(GetArea())
Local aDados	:= {}
Local nResDF	:= 0
Local cFilDP 	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
Local nI                            
Local _cCod, _nQuant


oSection:Cell("COD"):SetBlock( { || aDados[nI][1] } )
oSection:Cell("QTDE"):SetBlock( { || aDados[nI][3] } )
oSection:Cell("DESC"):SetBlock( { || aDados[nI][2] } )

oReport:SetTitle("Relação de produtos")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
oSection:Init()

//If nFolder <> 2
	SC5->(DbOrderNickName("STFSSC501"))
	SC5->(DbSeek(xFilial('SC5')+'0',.T.))
	SC6->(DbSetOrder(1))
	
	While SC5->(!Eof() .and. C5_FILIAL == xFilial("SC5"))
		If mv_par01 == "1"
			If !(SC5->C5_XSTARES $ "2/3/4")
				SC5->(DbSkip())
				Loop
			Endif		
		ElseIf mv_par01 == "2" 
			If !(SC5->C5_XSTARES == "3")
				SC5->(DbSkip())
				Loop
			Endif				
		Endif
		SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
		While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+SC5->C5_NUM)
			nResDF	:=SC6->(U_STGetRes(C6_NUM+C6_ITEM,C6_PRODUTO,cFilDP))
			If !Empty(nResDF)
				If (nPos := aScan(aDados,{|x| x[1] == SC6->C6_PRODUTO})) > 0	
					aDados[nPos,3] += nResDF
				Else
					Aadd(aDados,{SC6->C6_PRODUTO,Left(Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC"),40),nResDF})
				Endif
			Endif
		   SC6->(DbSkip())                                                                          
		End
		SC5->(DbSkip())
	End
//Endif	
//If nFolder <> 1
	SC2->(DbOrderNickName("STFSSC201"))
	SC2->(DbSeek(xFilial('SC2')+'0',.T.))
	SD4->(DbSetOrder(2))
	
	While SC2->(!Eof() .and. C2_FILIAL == xFilial("SC2"))
		SD4->(DbSeek(xFilial('SD4')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		While SD4->(! Eof() .and. D4_FILIAL+D4_OP == xFilial('SD4')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+"  "))
			nResDF	:=SD4->(U_STGetRes(AllTrim(D4_OP),D4_COD,cFilDP))                        
			If !Empty(nResDF)
				If (nPos := aScan(aDados,{|x| x[1] == SD4->D4_COD})) > 0	
					aDados[nPos,3] += nResDF
				Else
					Aadd(aDados,{SD4->D4_COD,Left(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC"),40),nResDF})
				Endif
			Endif
		   SD4->(DbSkip())
		End
		SC2->(DbSkip())
	End              
//Endif              

For nI:=1 to len(aDados)

	oSection:PrintLine()

Next

oSection:Finish()

Return()