#Include "Protheus.Ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DCRE      ³ Autor ³Sergio S Fuzinaka     ³ Data ³ 07.06.04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Preparacao do meio-magnetico para o DCR-E - Zona Franca     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static _cComPri := Space(15)
User Function STDCR02(lLista)

Local cPerg 	:= "DCRE"
Local cProd		:= ""
Local cIndSD1	:= ""
Local nIndSD1	:= 0         
Local cIndImp   := ""
Local cValid	:= GetNewPar("MV_DCRE09","SB1->B1_TIPO<>'MO'")	//Validacao Parametrizada
Local aRet		:=	{}
Local lDCRE     := ExistBlock("DCRECF")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ativa a validacao do componente Pai                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lValPai	:= GetNewPar("MV_DCRE12",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacao do Produto/Estrutura                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private bValid := {||.T.}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Contadores do Registro Tipo 2, 3 e 4                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nReg2Num := 0
Private nReg3Num := 0
Private nReg4Num := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera Registro 3 - Subcomponentes Importados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lReg3 := GetNewPar("MV_DCRE01",.F.)	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Utilizado para verificar se eh um SubComponente Importado               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cProdAnt := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Utilizado para gerar um relatorio de conferencia de Produtos Importados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lImpr := IIf(Valtype(lLista)=="L",lLista,.F.)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se ha alguma validacao cadastrada no parametro MV_DCRE09       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cValid)
	cValid := "{|| "+cValid+"}"
	bValid := &cValid
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera arquivos temporarios                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraTemp()

cProd := cProdAnt := mv_par04	//Codigo do Produto

If !Empty(cProd)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa o arquivo DCRE.INI                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aTotal[99] := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava Registro Tipo 0 - Informacoes Gerais do DCRE                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GravaReg0(cProd)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava Registro Tipo 1 - Modelos, Tipos e Referencias                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GravaReg1(cProd)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa Estrutura de Produtos (SG1)                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa execblock para verificar se     ³
	//³ produto sera fabricado ou comprado      ³
	//³ "COMPONENTE FABRICADO OU COMPRADO"      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lDCRE
		ExecBlock("DCRECF",.F.,.F.,{cProd})
	Else	
		dbSelectArea("SG1")		//Arquivo de Estrutura de Produtos
		dbSetOrder(1)
		ProcEstru(cProd)	
	EndIf 
	/*
    While .T.
		  aRet	:=	SelOpc ()
		  If (aRet[1]==1)
		  	 AltEstru(1)	
		  ElseIf (aRet[1]==2)
		  	 AltEstru(2)	
		  Else
		  	 Exit
		  EndIf
	Enddo	  
	*/
	#IFNDEF TOP
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Deletando os Indices                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		RetIndex("SD1")
		dbClearFilter()
		Ferase(cIndSD1+OrdBagExt())
	#ENDIF
Endif

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ProcEstru  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa Estrutura dos Produtos (SG1) - Funcao Recursiva     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcEstru(cProd)

Local nRecno := Recno()
Local nQtdIt := 1

If dbSeek(xFilial("SG1")+cProd)
	While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProd
		SB1->(dbsetorder(1))
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
		If lValPai
			nQtdIt := ExplEstr(1,,RetFldProd(SB1->B1_COD,"B1_OPC"),SB1->B1_REVATU)		//Validacao do Componente
		Endif
        If nQtdIt > 0
			ProcReg(SG1->G1_COMP,SG1->G1_COD,SG1->G1_QUANT)
			ProcEstru(SG1->G1_COMP)
		EndIf
		dbSkip()
	Enddo
Endif
dbGoTo(nRecno)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ProcReg    ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa Registros                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcReg(cComp,cProd,nQuant)

Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida o Componente da Estrutura                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CheckComp(cComp)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa Cadastro de Produtos                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+cComp)
      	_cComPri   := cComp 
		If !Empty(SB1->B1_ALTER)
			cComp := SB1->B1_ALTER
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+cComp)		
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validacao Parametrizada ( MV_DCRE09 )                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Eval(bValid)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava Componentes do Produtos                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SB1->B1_ORIGEM $ "0 "						
				GravaReg2(cComp,nQuant)				//Registro Tipo 2 - Componente Nacional
			Else
				cIndImp := SB1->B1_ORIGEM
				If lReg3 .And. cProd<>cProdAnt
					GravaReg3(cComp,cProd,nQuant,cIndImp)	//Registro Tipo 3 - SubComponente Importado
				Else										
					GravaReg4(cComp,nQuant,cIndImp)			//Registro Tipo 4 - Componente Importado
				Endif					
			Endif
		Endif
	Endif
Endif
RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GravaReg0  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Grava Registro Tipo 0 - Informacoes Gerais do DCRE           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaReg0(cComp)

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+cComp)
	RecLock("R00",.T.)
	R00->CNPJ		:= StrZero(Val(aRetDig(SM0->M0_CGC,.F.)),14)
	R00->CPF		:= StrZero(Val(aRetDig(mv_par05,.F.)),11)
	R00->PPB		:= Upper(mv_par06)
	R00->DESCPROD	:= Upper(SB1->B1_DESC)
	R00->NCM		:= SB1->B1_POSIPI
	R00->UNIDADE	:= Upper(SB1->B1_UM)
	R00->PESO_BRUTO	:= IIf(SB1->(FieldPos("B1_PESBRU"))>0,SB1->B1_PESBRU,0)
	R00->SALARIO 	:= mv_par12		//Total dos Custos com Salarios e Ordenados ja convertidos
	R00->ENCARGO 	:= mv_par13		//Total dos Custos com Encargos Sociais e Trabalhistas ja convertidos
	R00->TP_DCRE	:= IIf(mv_par08==1,"N",IIf(mv_par08==2,"R","S"))
	R00->DCRE_ANT	:= IIf(mv_par08==1,Replicate(" ",10),StrZero(mv_par09,10))
	R00->PROCESSO	:= IIf(mv_par08==2,StrZero(mv_par10,17),Replicate(" ",17))
	R00->TP_COEFIC  := IIf(mv_par07==1,"F","V")
	MsUnlock()
Endif

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GravaReg1  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Grava Registro Tipo 1 - Outros Modelos                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaReg1(cComp)

Local aArea := GetArea()

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+cComp)
	RecLock("R01",.T.)
	R01->MODELO	    := mv_par14            //Modelo 
	R01->DESCRICAO	:= Upper(SB1->B1_DESC)	//Descricao do Produto
	R01->PRC_VENDA	:= STDCR02V(cComp)					//Preco de Venda - Deve ser alterado no programa DCR-E
	R01->CODPROD	:= cComp				//Codigo do Componente
	MsUnlock()
Endif

RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GravaReg2  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Grava Registro Tipo 2 - Componentes Nacionais                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaReg2(cComp,nQuant)
                                
Local aArea	 := GetArea()
Local aDados := {}

aDados := RetDINf(cComp,"N")

If aDados[09] <> "000000000000000" .And. !( "S006" $ _cComPri ) .And. !( "2361363 1" $ _cComPri ) .And.  !( "10120006ST" $ _cComPri ) .And. !( "10120007ST" $ _cComPri ) .And. !( "10200002" $ _cComPri ) ;
   .And. !( "10190062ST" $ _cComPri ) .And.  !( "10190061ST" $ _cComPri ) .And. !( "2361363 2" $ _cComPri ) 
	    
dbSelectArea("R02")
dbSetOrder(1)
If !dbSeek(cComp)

	
     
	RecLock("R02",.T.)
	R02->CODPROD	:= cComp	
	R02->NUMERO 	:= StrZero(++nReg2Num,4)	//Numero Identificador do Componente Nacional dentro do arquivo
	R02->NF			:= aDados[05]
	R02->SERIE		:= aDados[06]
	R02->DATAEMIS	:= aDados[07]
	R02->CNPJ		:= aDados[08]
	
	If aDados[09] == "000000000000000"
	   R02->IE    := cComp
	Else 
	   R02->IE			:= aDados[09]  
	Endif
	//###########################################
	//Quando não encontrar NF de Entrada        #
	//Cristiano Pereira - 18/07/2014 16:12      #
	//###########################################
	If aDados[05] == "0000000000"
     R02->DESCPROD    :="Componente "+_cComPri+" sem NF de Entrada (Verifique código alternativo)" 
	Else
	R02->DESCPROD	:= If(Empty(aDados[12]),Upper(SB1->B1_DESC),aDados[12])
	Endif
    R02->UNIDADE	:= Upper(SB1->B1_UM)
	R02->NCM		:= SB1->B1_POSIPI
	R02->CUSTO_UNIT	:= If(Empty(aDados[13]),aDados[11],aDados[13]) 
	

	
Else
	RecLock("R02",.F.)
Endif	
R02->QTDE += nQuant
MsUnlock()

Endif

RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GravaReg3  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Grava Registro Tipo 3 - SubComponentes Importados            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaReg3(cComp,cProd,nQuant,cIndImp)

Local aArea		:= GetArea()
Local cBCIncII	:= GetNewPar("MV_DCRE02","")	//Campo B5 - Indicador de inclusao deste componente no calculo do II - S-Sim ou N-Nao
Local cIndSusp	:= GetNewPar("MV_DCRE03","")	//Campo B5 - Indicador de utilizacao do regime com suspensao de impostos durante a importacao - S-Sim ou N-Nao
Local cIndRedu	:= GetNewPar("MV_DCRE04","")	//Campo B5 - Indicador de utilizacao de coeficiente de reducao do II - N-Nao ou S-Sim
Local aDados	:= {}

dbSelectArea("SB5")
dbSetOrder(1)
If dbSeek(xFilial("SB5")+cComp)

	dbSelectArea("R03")
	dbSetOrder(1)
	If !dbSeek(cComp)
	
		aDados := RetDINf(cComp,"D")
	
		RecLock("R03",.T.)
		R03->CODPROD	:= cComp					//SubComponente Importado de um Componente Nacional
		R03->NROSUB 	:= StrZero(++nReg3Num,4)	//Numero Identificador do Subcomponente Nacional dentro do arquivo
		R03->NUMERO 	:= StrZero(++nReg3Num,4)	//Numero Identificador do Componente Nacional dentro do arquivo
	
		If !Empty(cBCIncII)
			R03->INCLUI_BC	:= IIf(SB5->(FieldPos(cBCIncII))>0,SB5->&(cBCIncII),"S")
		Else
			R03->INCLUI_BC	:= "S"
		Endif
		
		//Indicador de inclusao deste componente no calculo do II
		If R03->INCLUI_BC == "N"
			If !Empty(cIndSusp)
				R03->INDIC_SUSP	:= IIf(SB5->(FieldPos(cIndSusp))>0,SB5->&(cIndSusp),"S")
			Else
				R03->INDIC_SUSP	:= "S"
			Endif
		Else
			R03->INDIC_SUSP	:= "S"
	    Endif

        R03->IMP_DIR    := Iif(	cIndImp=="1", "S", "N")    
		R03->DI			:= aDados[02]
		R03->NUM_ADICAO	:= aDados[03]
		R03->NUM_ITEM	:= aDados[04]
		R03->NF			:= aDados[05]
		R03->SERIE		:= aDados[06]
		R03->DATAEMIS	:= aDados[07]
		R03->CNPJ		:= aDados[08]
		R03->IE			:= aDados[09]
	    R03->DESCPROD	:= If(Empty(aDados[12]),Upper(SB1->B1_DESC),aDados[12])
		R03->UNIDADE	:= ""
		R03->NCM		:= Replicate("0",8)
		
		If !Empty(cIndRedu)
			R03->IND_RED_II	:= IIf(SB5->(FieldPos(cIndRedu))>0,SB5->&(cIndRedu),"N")
		Else
			R03->IND_RED_II	:= "N"
		Endif
		
 		R03->CUSTO_UNIT	:= If(Empty(aDados[13]),aDados[11],aDados[13])
	Else
		RecLock("R03",.F.)
	Endif
	R03->QTDE += nQuant
	MsUnlock()
Endif

RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GravaReg4  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Grava Registro Tipo 4 - Componentes Importados               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaReg4(cComp,nQuant,cIndImp)
                                
Local aArea		:= GetArea()
Local cIndSusp	:= GetNewPar("MV_DCRE03","")	//Campo B5 - Indicador de utilizacao do regime com suspensao de impostos durante a importacao - S-Sim ou N-Nao
Local cIndRedu	:= GetNewPar("MV_DCRE04","")	//Campo B5 - Indicador de utilizacao de coeficiente de reducao do II - N-Nao ou S-Sim
Local aDados	:= {}
 


aDados := RetDINf(cComp,"D",cIndImp)
	

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cComp) 

dbSelectArea("SB5")
dbSetOrder(1)
If dbSeek(xFilial("SB5")+cComp)  .And. SB1->B1_ORIGEM ==  "1" .And. !Empty(aDados[02])

	dbSelectArea("R04")
	dbSetOrder(1)
	If !dbSeek(cComp)
	
	     
	
	    RecLock("R04",.T.)
		R04->NUMERO 	:= StrZero(++nReg4Num,4)	//Numero Identificador do Componente Nacional dentro do arquivo
		R04->CODPROD	:= cComp
		
		If !Empty(cIndSusp)
			R04->INDIC_SUSP	:= IIf(SB5->(FieldPos(cIndSusp))>0,SB5->&(cIndSusp),"")
		Endif

        R04->IMP_DIR    := Iif(	cIndImp=="1", "S", "N")    		
		R04->DI			:= aDados[02]
		R04->NUM_ADICAO	:= aDados[03]
		R04->NUM_ITEM	:= aDados[04]
		R04->NF			:= aDados[05]
		R04->SERIE		:= aDados[06]
		R04->DATAEMIS	:= aDados[07]
		R04->CNPJ		:= If(aDados[08]=Replicate("0",14),Replicate(" ",14),aDados[08]) 
		R04->IE			:= aDados[09]
	    R04->DESCPROD	:= If(Empty(aDados[12]),Upper(SB1->B1_DESC),aDados[12])
		R04->UNIDADE	:= Iif(cIndImp == "1", "", SB1->B1_UM)
		R04->NCM		:= Iif(cIndImp == "1", Replicate("0",8), SB1->B1_POSIPI)
		
		If !Empty(cIndRedu)
			R04->IND_RED_II	:= IIf(SB5->(FieldPos(cIndRedu))>0,SB5->&(cIndRedu),"")
		Endif
 		R04->CUSTO_UNIT	:= If(Empty(aDados[13]),aDados[11],aDados[13])

	Else
		RecLock("R04",.F.)
	Endif	
	R04->QTDE += nQuant
	MsUnlock()
Endif

RestArea(aArea)
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RetDINf    ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna dados da DI ou Nf                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetDINf(cComp,cTp,cIndImp)

Local aArea 	:= GetArea()
Local lQuery	:= .F.
Local aStru		:= {} 
Local cQuery	:= ""
Local dDtMax	:= Ctod("")
Local cAlias	:= ""
Local nCUnit	:= 0
Local nX		:= 0
Local lEasy		:= GetNewPar("MV_EASY","N")=="S"	//Integracao EIC
Local cD1DI		:= GetNewPar("MV_DCRE05","")		//Sem Integracao EIC - Campo D1 - Contem o numero da DI
Local cD1Adic	:= GetNewPar("MV_DCRE06","")		//Sem Integracao EIC - Campo D1 - Contem o numero da Adicao
Local cD1AliqII	:= GetNewPar("MV_DCRE07","")		//Sem Integracao EIC - Campo D1 - Contem o taxa da Aliquota de II
Local cD1It		:= GetNewPar("MV_DCRE08","")		//Sem Integracao EIC - Campo D1 - Contem o numero do Item da Adicao
Local cDescrSD1	:= GetNewPar("MV_DCRE10","")		//Descricao da tabela SD1
Local cValDolar	:= GetNewPar("MV_DCRE11","")		//Valor Unitario em Dolar

Local dDtProc	:= mv_par02							//Data Base de Processamento das NF
Local aDados	:= {	""					, ;		//01-Tipo DI ou NF
						""					, ;		//02-DI
						""					, ;		//03-No. Adicao
						""					, ;		//04-No. Item
						Replicate("0",10)	, ;		//05-NF
						""					, ;		//06-Serie
						Ctod("")			, ;		//07-Data de Entrada
						Replicate("0",14)	, ;		//08-CNPJ
						""					, ;		//09-IE
						0					, ;		//10-Aliquota do II (Imposto de Importacao)
						0					, ;		//11-Custo Unitario do Componente
						Space(80)			, ;		//12-Descricao do Produto no SD1
						0					}		//13-Custo Unitario em Dolar no SD1
#IFDEF TOP
    If TcSrvType() <> "AS/400"
    	lQuery := .T.
    Endif
#ENDIF    

If lQuery
	cAlias := "TopSD1"
	aStru  := SD1->(dbStruct())

	If cTp == "D"	//Componentes Importados
		cQuery := "SELECT MAX(D1_DTDIGIT) AS D1_DTDIGIT "
	Else			//Componentes Nacionais
		cQuery := "SELECT MAX(D1_EMISSAO) AS D1_EMISSAO "
	Endif

	cQuery += "FROM "+RetSqlName("SD1")+" "
	cQuery += "WHERE D1_FILIAL='"+xFilial("SD1")+"' AND "
	cQuery += "D1_COD='"+cComp+"' AND "

	If cTp == "D"
		cQuery += "D1_DTDIGIT<='"+Dtos(dDtProc)+"' AND "
		cQuery += "(D1_TIPO_NF IN ('1','3') OR "
	Else
		cQuery += "D1_EMISSAO<='"+Dtos(dDtProc)+"' AND "
		cQuery += "(D1_TIPO = 'N' OR "
	Endif		

	cQuery += " SUBSTRING(D1_CF,1,1)='3') AND D1_TIPO <> 'D' AND D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	For nX := 1 To len(aStru)
		If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
			TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
	dbSelectArea(cAlias)
	dbGoTop()
	If cTp == "D"		//Retorna a maior data
		dDtMax := (cAlias)->D1_DTDIGIT
	Else
		dDtMax := (cAlias)->D1_EMISSAO
	Endif       
	If Empty(dDtMax)
	    dDtMax := mv_par02
	Endif	
	dbCloseArea()

	cQuery := ""
	cQuery := "SELECT * "
	cQuery += "FROM "+RetSqlName("SD1")+" "
	cQuery += "WHERE D1_FILIAL='"+xFilial("SD1")+"' AND "
	cQuery += "D1_COD='"+cComp+"' AND "
	If cTp == "D"
	    cQuery += "(D1_TIPO_NF IN ('1','3') OR "
    Else
        cQuery += "(D1_TIPO = 'N' OR "
    Endif
	cQuery += " SUBSTRING(D1_CF,1,1)='3') AND D1_TIPO <> 'D' AND D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	For nX := 1 To len(aStru)
		If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
			TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
	dbSelectArea(cAlias)
Else
	cAlias := "SD1"
	dbSelectArea("SD1")
	If cTp == "N"
		dbSetOrder(3)	//Por Emissao
		dbSeek(xFilial("SD1")+Dtos(dDtProc),.T.)	
		While !Bof()
			If D1_TIPO == "N" .And. D1_FILIAL+D1_COD == xFilial("SD1")+cComp .And. D1_EMISSAO <= dDtProc
				Exit
			Endif			
			dbSkip(-1)
		Enddo	
	Else
		dbSetOrder(6)	//Por DtDigit
		dbSeek(xFilial("SD1")+Dtos(dDtProc),.T.)	
		While !Bof()
			If D1_TIPO_NF $ "13" .And. D1_FILIAL+D1_COD == xFilial("SD1")+cComp .And. D1_DTDIGIT <= dDtProc
				Exit
			Endif			
			dbSkip(-1)
		Enddo	
	Endif
Endif



If (cAlias)->D1_FILIAL+(cAlias)->D1_COD == xFilial("SD1")+cComp
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1")+(cAlias)->D1_DOC+(cAlias)->D1_SERIE+(cAlias)->D1_FORNECE+(cAlias)->D1_LOJA)
	     
	    
		If cTp == "N"   		//Nota Fiscal - Componente Nacional
		
			aDados[05]	:= StrZero(Val((cAlias)->D1_DOC),10)	//NF
			aDados[06]	:= (cAlias)->D1_SERIE					//Serie
			aDados[07]	:= (cAlias)->D1_EMISSAO					//Data de Emissao
				
			dbSelectArea("SA2")
			dbSetOrder(1)
			If dbSeek(xFilial("SA2")+(cAlias)->D1_FORNECE+(cAlias)->D1_LOJA)
				aDados[08] := StrZero(Val(aRetDig(SA2->A2_CGC,.F.)),14)		//CNPJ
				aDados[09] := StrZero(Val(aRetDig(SA2->A2_INSCR,.F.)),15)		//IE
			Endif

	   	   aDados[11] := (cAlias)->D1_VUNIT
		   	
		Else		 	//DI - Componente Importado

			If lImpr .Or. cIndImp == "2"
				aDados[05]	:= StrZero(Val((cAlias)->D1_DOC),10)	//NF
				aDados[06]	:= (cAlias)->D1_SERIE					//Serie
				aDados[07]	:= (cAlias)->D1_DTDIGIT         		//Data de Entrada
			Endif			
			
            If cIndImp == "2"
				dbSelectArea("SA2")
				dbSetOrder(1)
				If dbSeek(xFilial("SA2")+(cAlias)->D1_FORNECE+(cAlias)->D1_LOJA)
					aDados[08] := StrZero(Val(aRetDig(SA2->A2_CGC,.F.)),14)		//CNPJ
					aDados[09] := StrZero(Val(aRetDig(SA2->A2_INSCR,.F.)),15)		//IE   
				    If aDados[09] == "000000000000000"
				        aDados[09] := ""
				    EndIf
				Endif	                             
            Endif
 
			//Tipo do Documento: D=DI
			aDados[01]	:= "D"
			//Numero da DI
			aDados[02]	:=StrZero(Val(IIf((cAlias)->(FieldPos(cD1DI))>0,(cAlias)->&(cD1DI),"")),10)
			//Numero da Adicao
			aDados[03]	:= StrZero(Val(IIf((cAlias)->(FieldPos(cD1Adic))>0,(cAlias)->&(cD1Adic),"")),3)
			//Numero do Item da Adicao
			aDados[04]	:= StrZero(Val(IIf((cAlias)->(FieldPos(cD1It))>0,(cAlias)->&(cD1It),"")),2)
			//Aliquota de II
			aDados[10]	:= IIf((cAlias)->(FieldPos(cD1AliqII))>0,(cAlias)->&(cD1AliqII),0)
			//Custo Unitario
			aDados[11]	:= IIf((cAlias)->(FieldPos(cValDolar))>0,(cAlias)->&(cValDolar),0)
			//Descricao do Item
			aDados[12]	:= IIf((cAlias)->(FieldPos(cDescrSD1))>0,(cAlias)->&(cDescrSD1),"")

		    nCUnit		:= aDados[11]
   		    If nCUnit==0
		   	   nCUnit	:= (cAlias)->D1_VUNIT		//Custo Unitario
		   	Endif   
			
		Endif
		
	Endif
Endif

If lQuery
	dbSelectArea(cAlias)
	dbCloseArea()
Endif

RestArea(aArea)

Return(aDados)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CheckComp  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Verifica se o componte eh valido                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CheckComp(cComp)

Local aArea		:= GetArea()
Local lRet		:= .T.
Local dDtValid	:= mv_par02		//Data de Validade do Componente
Local cRevisao	:= mv_par03		//Revisao da Estrutura

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento somente sera feito se a revisao for preenchida             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cRevisao)	.And. !(cRevisao >= SG1->G1_REVINI .And. cRevisao <= SG1->G1_REVFIM)
	lRet := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento da validade do componente na estrutura                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !(dDtValid >= SG1->G1_INI .And. dDtValid <= SG1->G1_FIM)
	lRet := .F.
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o componente e produzido ou comprado                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+cComp)
		lRet := .F.
		While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cComp
			If dDtValid >= SG1->G1_INI .And. dDtValid <= SG1->G1_FIM
				lRet := .F.
            	Exit
   			Else
				lRet := .T.   			
   			Endif
	    	dbSkip()
		Enddo
	Endif
Endif
RestArea(aArea)

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GeraTemp   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Gera arquivos temporarios                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTemp()

Local aStru	 := {}
Local cArq	 := ""
Local cAlias := ""
Local oTable

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Tipo 0 - Informacoes Gerais do DCRE                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aStru,{"CNPJ"			,"C",014,0})	//CNPJ do Estabelecimento do DCRE
AADD(aStru,{"CPF"			,"C",011,0})	//CPF do Representante Legal
AADD(aStru,{"PPB"			,"C",080,0})	//Identificacao do Processo Produtivo Basico
AADD(aStru,{"DESCPROD"		,"C",080,0})	//Descricao do Produto
AADD(aStru,{"NCM"			,"C",008,0})	//NCM
AADD(aStru,{"UNIDADE"		,"C",080,0})	//Unidade de Comercializacao do Produto
AADD(aStru,{"PESO_BRUTO"	,"N",014,5})	//Peso Bruto
AADD(aStru,{"SALARIO"		,"N",015,4})	//Total dos Custos com Salarios/Ordenados
AADD(aStru,{"ENCARGO"		,"N",015,4})	//Total dos Custos com Encargos Sociais e Trabalhistas
AADD(aStru,{"TP_DCRE"		,"C",001,0})	//Tipo de DCRE: N-Novo, R-Retificador e S-Substituto
AADD(aStru,{"DCRE_ANT"		,"C",010,0})	//Numero do DCRE Anterior que esta sendo Retificado ou Substituido
AADD(aStru,{"PROCESSO"		,"C",017,0})	//Numero do Processo Retificador
AADD(aStru,{"VERSAO"		,"C",004,0})	//Versao
AADD(aStru,{"ORIDCRE"		,"C",001,0})	//Origem do DCRE
AADD(aStru,{"TP_COEFIC"		,"C",001,0})	//Tipo do coeficiente da DCRE

//cArq := CriaTrab(aStru) 				//Função CriaTrab descontinuada, adicionado o oTable no lugar
oTable := FWTemporaryTable():New("R00") //adicionado\Ajustado
oTable:SetFields(aStru)				    //adicionado\Ajustado
oTable:Create()							//adicionado\Ajustado
cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
cArq	:= oTable:GetRealName()			//adicionado\Ajustado
dbUseArea(.T.,"TOPCONN",cArq,cAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Tipo 1 - Informacoes sobre os Modelos diferentes do Produto    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStru	:= {}
cArq	:= ""
cAlias  := "" //adicionado\Ajustado
AADD(aStru,{"CODPROD"		,"C",015,0})	//Codigo do Produto
AADD(aStru,{"MODELO"		,"C",004,0})	//Modelo
AADD(aStru,{"DESCRICAO"		,"C",080,0})	//Descricao do Produto
AADD(aStru,{"PRC_VENDA"		,"N",015,2})	//Preco de Venda

//cArq := CriaTrab(aStru) //Função CriaTrab descontinuada, adicionado o oTable no lugar
oTable := FWTemporaryTable():New("R01") //adicionado\Ajustado
oTable:SetFields(aStru)					//adicionado\Ajustado
oTable:Create()							//adicionado\Ajustado
cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
cArq	:= oTable:GetRealName()			//adicionado\Ajustado
dbUseArea(.T.,"TOPCONN",cArq,cAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Tipo 2 - Informacoes sobre Componentes Nacionais               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStru	:= {}
cArq	:= ""
cAlias	:= "" //adicionado\Ajustado
AADD(aStru,{"CODPROD"		,"C",015,0})	//Codigo do Produto
AADD(aStru,{"NUMERO"		,"C",004,0})	//Numero do Componente Nacional dentro do arquivo
AADD(aStru,{"NF"			,"C",010,0})
AADD(aStru,{"SERIE"			,"C",005,0})
AADD(aStru,{"CNPJ"			,"C",014,0})	//CNPJ do Fornecedor
AADD(aStru,{"IE"			,"C",015,0})	//IE do Fornecedor
AADD(aStru,{"DATAEMIS"		,"D",008,0})	//Data de Entrada da NF
AADD(aStru,{"DESCPROD"		,"C",080,0})	//Especificacao do Produto
AADD(aStru,{"UNIDADE"		,"C",080,0})
AADD(aStru,{"NCM"			,"C",008,0})
AADD(aStru,{"QTDE"			,"N",015,7})
AADD(aStru,{"CUSTO_UNIT"	,"N",015,6})

//cArq := CriaTrab(aStru) //Função CriaTrab descontinuada, adicionado o oTable no lugar
oTable := FWTemporaryTable():New("R02") //adicionado\Ajustado
oTable:SetFields(aStru)					//adicionado\Ajustado
oTable:Create()							//adicionado\Ajustado
cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
cArq	:= oTable:GetRealName()			//adicionado\Ajustado
dbUseArea(.T.,"TOPCONN",cArq,cAlias)
IndRegua("R02",cArq,"CODPROD")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Tipo 3 - Informacoes sobre Subcomponentes Importados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStru	:= {}
cArq	:= ""
cAlias	:= "" //adicionado\Ajustado
AADD(aStru,{"CODPROD"		,"C",015,0})	//Codigo do Produto
AADD(aStru,{"NROSUB"		,"C",004,0})	//Numero do Subcomponente Nacional dentro do arquivo
AADD(aStru,{"NUMERO"		,"C",004,0})	//Numero do Componente Nacional dentro do arquivo
AADD(aStru,{"INCLUI_BC"		,"C",001,0})	//Indicador de Inclusao deste componente no calculo do II N-Nao ou S-Sim
AADD(aStru,{"IMP_DIR"		,"C",001,0})	//Indicador importacao Direta
AADD(aStru,{"INDIC_SUSP"	,"C",001,0})	//Indicador de utilizacao do regime com suspensao de impostos durante a importacao N-Nao ou S-Sim
AADD(aStru,{"DI"			,"C",010,0})
AADD(aStru,{"NUM_ADICAO"	,"C",003,0})	//Numero de Adicao
AADD(aStru,{"NUM_ITEM"		,"C",002,0})
AADD(aStru,{"NF"			,"C",010,0})
AADD(aStru,{"SERIE"			,"C",005,0})
AADD(aStru,{"CNPJ"			,"C",014,0})
AADD(aStru,{"IE"			,"C",015,0})
AADD(aStru,{"DATAEMIS"		,"D",008,0})
AADD(aStru,{"DESCPROD"		,"C",080,0})	//Especificacao do Produto
AADD(aStru,{"UNIDADE"		,"C",080,0})
AADD(aStru,{"NCM"			,"C",008,0})
AADD(aStru,{"QTDE"			,"N",015,7})
AADD(aStru,{"IND_RED_II"	,"C",001,0})	//Indicador de utilizacao de coeficiente de reducao II N-Nao ou S-Sim
AADD(aStru,{"CUSTO_UNIT"	,"N",015,6})	//Custo Unitario do componente em US$(Dolar)

//cArq := CriaTrab(aStru) //Função CriaTrab descontinuada, adicionado o oTable no lugar
oTable := FWTemporaryTable():New("R03") //adicionado\Ajustado
oTable:SetFields(aStru)					//adicionado\Ajustado
oTable:Create()							//adicionado\Ajustado
cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
cArq	:= oTable:GetRealName()			//adicionado\Ajustado
dbUseArea(.T.,"TOPCONN",cArq,cAlias)
IndRegua("R03",cArq,"CODPROD")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Tipo 4 - Informacoes sobre Componentes Importados              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStru	:= {}
cArq	:= ""
cAlias	:= "" //adicionado\Ajustado
AADD(aStru,{"CODPROD"		,"C",015,0})	//Codigo do Produto
AADD(aStru,{"NUMERO"		,"C",004,0})	//Numero do Componente Nacional dentro do arquivo
AADD(aStru,{"IMP_DIR"		,"C",001,0})	//Indicador importacao Direta
AADD(aStru,{"INDIC_SUSP"	,"C",001,0})
AADD(aStru,{"DI"			,"C",010,0})
AADD(aStru,{"NUM_ADICAO"	,"C",003,0})
AADD(aStru,{"NUM_ITEM"		,"C",002,0})
AADD(aStru,{"NF"			,"C",010,0})
AADD(aStru,{"SERIE"			,"C",005,0})
AADD(aStru,{"CNPJ"			,"C",014,0})
AADD(aStru,{"IE"			,"C",015,0})
AADD(aStru,{"DATAEMIS"		,"D",008,0})
AADD(aStru,{"DESCPROD"		,"C",080,0})
AADD(aStru,{"UNIDADE"		,"C",080,0})
AADD(aStru,{"NCM"			,"C",008,0})
AADD(aStru,{"QTDE"			,"N",015,7})
AADD(aStru,{"ALIQUOTA"		,"N",005,2})
AADD(aStru,{"IND_RED_II"	,"C",001,0})
AADD(aStru,{"CUSTO_UNIT"	,"N",015,6})	//Custo Unitario do componente em US$(Dolar)

//cArq := CriaTrab(aStru) //Função CriaTrab descontinuada, adicionado o oTable no lugar
oTable := FWTemporaryTable():New("R04") //adicionado\Ajustado
oTable:SetFields(aStru)					//adicionado\Ajustado
oTable:Create()							//adicionado\Ajustado
cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
cArq	:= oTable:GetRealName()			//adicionado\Ajustado
dbUseArea(.T.,"TOPCONN",cArq,cAlias)
IndRegua("R04",cArq,"CODPROD")

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSx1 ³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Ajuste do SX1                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1(cPerg)

Local aHelpP  := {}
Local aHelpE  := {}
Local aHelpS  := {}  
	
cPerg := PadR(cPerg,6)

// mv_par01 - Data de Processamento
Aadd( aHelpP, "Informe a Data Base para Processamento  " )
Aadd( aHelpP, "das Notas Fiscais e D.I.                " )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe a Data Base para Processamento  " )
Aadd( aHelpE, "das Notas Fiscais e D.I.                " )
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpS, "Informe a Data Base para Processamento  " )
Aadd( aHelpS, "das Notas Fiscais e D.I.                " )
Aadd( aHelpS, "                                        " ) 
PutSx1(cPerg,"01","Data de Processamento         ","Data de Processamento         ","Data de Processamento         ","mv_ch1","D",08,0,0,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par02 - Data de Validade
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe a Data de Validade dos          " )
Aadd( aHelpP, "Componentes da Estrutura                " )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe a Data de Validade dos          " )
Aadd( aHelpE, "Componentes da Estrutura                " )
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpS, "Informe a Data de Validade dos          " )
Aadd( aHelpS, "Componentes da Estrutura                " )
Aadd( aHelpS, "                                        " ) 
PutSx1(cPerg,"02","Data de Validade              ","Data de Validade              ","Data de Validade              ","mv_ch2","D",08,0,0,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par03 - No. Revisao da Estrutura
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Numero de Revisao da          " )
Aadd( aHelpP, "Estrutura do Produto                    " )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe o Numero de Revisao da          " )
Aadd( aHelpE, "Estrutura do Produto                    " )
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpS, "Informe o Numero de Revisao da          " )
Aadd( aHelpS, "Estrutura do Produto                    " )
Aadd( aHelpS, "                                        " ) 
PutSx1(cPerg,"03","No. Revisao da Estrutura      ","No. Revisao da Estrutura      ","No. Revisao da Estrutura      ","mv_ch3","C",03,0,0,"G",,,,,"mv_par03",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par04 - Produto
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Codigo do Produto a ser       " )
Aadd( aHelpP, "processado                              " )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe o Codigo do Produto a ser       " )    
Aadd( aHelpE, "processado                              " )
Aadd( aHelpE, "                                        " )   
Aadd( aHelpS, "Informe o Codigo do Produto a ser       " )
Aadd( aHelpS, "processado                              " )
Aadd( aHelpS, "                                        " )
PutSx1(cPerg,"04","Produto                       ","Produto                       ","Produto                       ","mv_ch4","C",15,0,0,"G","ExistCpo('SB1',mv_par04)","SB1",,,"mv_par04",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par05 - CPF do Representante Legal
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o CPF do Representante Legal    " )
Aadd( aHelpP, "                                        " )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe o CPF do Representante Legal    " )    
Aadd( aHelpE, "                                        " )
Aadd( aHelpE, "                                        " )   
Aadd( aHelpS, "Informe o CPF do Representante Legal    " )
Aadd( aHelpS, "                                        " )
Aadd( aHelpS, "                                        " )
PutSx1(cPerg,"05","CPF do Representante Legal    ","CPF do Representante Legal    ","CPF do Representante Legal    ","mv_ch5","C",11,0,0,"G",,,,,"mv_par05",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par06 - Proc. Produtivo Basico (PPB)
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe a Identificacao do Processo     " )
Aadd( aHelpP, "Produtivo Basico do Produto e           " )
Aadd( aHelpP, "Resolucao SUFRAMA                       " ) 
Aadd( aHelpE, "Informe a Identificacao do Processo     " )    
Aadd( aHelpE, "Produtivo Basico do Produto e           " )
Aadd( aHelpE, "Resolucao SUFRAMA                       " )   
Aadd( aHelpS, "Informe a Identificacao do Processo     " )
Aadd( aHelpS, "Produtivo Basico do Produto e           " )
Aadd( aHelpS, "Resolucao SUFRAMA                       " )
PutSx1(cPerg,"06","Proc. Produtivo Basico (PPB)  ","Proc. Produtivo Basico (PPB)  ","Proc. Produtivo Basico (PPB)  ","mv_ch6","C",80,0,0,"G",,,,,"mv_par06",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par07 - Tipo de Coeficiente de Reducao
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Tipo de Coeficiente de        " )
Aadd( aHelpP, "Reducao: Fixo ou Variavel               " )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe o Tipo de Coeficiente de        " )
Aadd( aHelpE, "Reducao: Fixo ou Variavel               " )
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpS, "Informe o Tipo de Coeficiente de        " )
Aadd( aHelpS, "Reducao: Fixo ou Variavel               " )
Aadd( aHelpS, "                                        " ) 
PutSx1(cPerg,"07","Tipo de Coeficiente de Reducao","Tipo de Coeficiente de Reducao","Tipo de Coeficiente de Reducao","mv_ch7","N",01,0,0,"C",,,,,"mv_par07","Fixo","Fixo","Fixo",,"Variavel","Variavel","Variavel",,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par08 - Tipo do DCR-E
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Tipo do DCR-E: Novo,          " )
Aadd( aHelpP, "Retificador ou Substitutivo             " )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe o Tipo do DCR-E: Novo,          " )
Aadd( aHelpE, "Retificador ou Substitutivo             " )
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpS, "Informe o Tipo do DCR-E: Novo,          " )
Aadd( aHelpS, "Retificador ou Substitutivo             " )
Aadd( aHelpS, "                                        " ) 
PutSx1(cPerg,"08","Tipo do DCR-E                 ","Tipo do DCR-E                 ","Tipo do DCR-E                 ","mv_ch8","N",01,0,0,"C",,,,,"mv_par08","Novo","Novo","Novo",,"Retificador","Retificador","Retificador","Substitutivo","Substitutivo","Substitutivo",,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par09 - No. DCR-E Anterior
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Numero do DCR-E Anterior que  " )
Aadd( aHelpP, "esta sendo Retificado ou Substituido    " )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe o Numero do DCR-E Anterior que  " )
Aadd( aHelpE, "esta sendo Retificado ou Substituido    " )
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpS, "Informe o Numero do DCR-E Anterior que  " )
Aadd( aHelpS, "esta sendo Retificado ou Substituido    " )
Aadd( aHelpS, "                                        " ) 
PutSx1(cPerg,"09","No. DCR-E Anterior            ","No. DCR-E Anterior            ","No. DCR-E Anterior            ","mv_ch9","N",09,0,0,"G",,,,,"mv_par09",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par10 - No. Processo Retificador
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Numero do Processo Retificador" )
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe o Numero do Processo Retificador" )
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpS, "Informe o Numero do Processo Retificador" )
Aadd( aHelpS, "                                        " ) 
Aadd( aHelpS, "                                        " ) 
PutSx1(cPerg,"10","No. Processo Retificador      ","No. Processo Retificador      ","No. Processo Retificador      ","mv_chA","N",17,0,0,"G",,,,,"mv_par10",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par11 - Moeda de Conversao dos Valores
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Codigo da Moeda, com a qual   " )
Aadd( aHelpP, "deseja converter os valores do DCR-E    " ) 
Aadd( aHelpP, "                                        " ) 
Aadd( aHelpE, "Informe o Codigo da Moeda, com a qual   " )
Aadd( aHelpE, "deseja converter os valores do DCR-E    " ) 
Aadd( aHelpE, "                                        " ) 
Aadd( aHelpS, "Informe o Codigo da Moeda, com a qual   " )
Aadd( aHelpS, "deseja converter os valores do DCR-E    " ) 
Aadd( aHelpS, "                                        " ) 
PutSx1(cPerg,"11","Moeda de Conversao dos Valores","Moeda de Conversao dos Valores","Moeda de Conversao dos Valores","mv_chB","N",02,0,0,"G",,,,,"mv_par11",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par12 - Salarios/Ordenados
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Total dos Custos com Salarios " )
Aadd( aHelpP, "e Ordenados, convertidos na Moeda       " ) 
Aadd( aHelpP, "selecionada                             " ) 
Aadd( aHelpE, "Informe o Total dos Custos com Salarios " )
Aadd( aHelpE, "e Ordenados, convertidos na Moeda       " ) 
Aadd( aHelpE, "selecionada                             " ) 
Aadd( aHelpS, "Informe o Total dos Custos com Salarios " )
Aadd( aHelpS, "e Ordenados, convertidos na Moeda       " ) 
Aadd( aHelpS, "selecionada                             " ) 
PutSx1(cPerg,"12","Salarios/Ordenados            ","Salarios/Ordenados            ","Salarios/Ordenados            ","mv_chC","N",15,4,0,"G",,,,,"mv_par12",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par13 - Encargos Sociais/Trabalhistas
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o Total dos Custos com Encargos " )
Aadd( aHelpP, "Sociais e Trabalhistas, convertidos na  " ) 
Aadd( aHelpP, "Moeda selecionada                       " ) 
Aadd( aHelpE, "Informe o Total dos Custos com Encargos " )
Aadd( aHelpE, "Sociais e Trabalhistas, convertidos na  " ) 
Aadd( aHelpE, "Moeda selecionada                       " ) 
Aadd( aHelpS, "Informe o Total dos Custos com Encargos " )
Aadd( aHelpS, "Sociais e Trabalhistas, convertidos na  " ) 
Aadd( aHelpS, "Moeda selecionada                       " ) 
PutSx1(cPerg,"13","Encargos Sociais/Trabalhistas ","Encargos Sociais/Trabalhistas ","Encargos Sociais/Trabalhistas ","mv_chD","N",15,4,0,"G",,,,,"mv_par13",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

// mv_par14 - Modelo
aHelpP  := {}
aHelpE  := {}
aHelpS  := {}  
Aadd( aHelpP, "Informe o código do modelo, " )
Aadd( aHelpP, "valor entre '0001' a '9999'." ) 
Aadd( aHelpP, "" ) 
Aadd( aHelpE, "Informe o código do modelo, " )
Aadd( aHelpE, "valor entre '0001' a '9999'." ) 
Aadd( aHelpE, "" ) 
Aadd( aHelpS, "Informe o código do modelo, " )
Aadd( aHelpS, "valor entre '0001' a '9999'." ) 
Aadd( aHelpS, "" ) 
PutSx1(cPerg,"14","Nro.Modelo ","Nro.Modelo ","Nro.Modelo ","mv_chE","C",4,0,0,"G",,,,,"mv_par14",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AltEstru   ³ Autor ³Edstron E. Correia     ³ Data ³ 26.040.05³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Alteracao dos Arquivos para geracao do DCRE                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AltEstru(nOpc)

Local aArea 	:= GetArea()
Local oDlg
Local aAltera	:=	{'CODPROD','NUMERO','NF','SERIE','CNPJ','IE','DATAEMIS','DESCPROD','UNIDADE','NCM','QTDE','CUSTO_UNIT'}

Private aHeader	:= {}
Private aRotina := { {"Pesquisar","AxPesqui",0,1},{"Alterar","AltEstru",0,4,2}}    

If nOpc==1

   dbSelectArea("R02")
   dbsetorder(0)

   AADD(aHeader,{ 'Codigo do Produto',	'CODPROD',"@!",15,0,"","",'C','R02',"" } )
   AADD(aHeader,{ 'Numero da Nota','NF',"@!",05,0,"","",'C','R02',"" } )
   AADD(aHeader,{ 'Serie','SERIE',"@!",05,0,"","",'C','R02',"" } )
   AADD(aHeader,{ 'CNPJ','CNPJ',"@!",14,0,"","",'C','R02',"" } )
   AADD(aHeader,{ 'IE','IE',"@!",15,0,"","",'C','R02',"" } )
   AADD(aHeader,{ 'Dt.Emissao','DATAEMIS',"@D",08,0,"","",'C','R02',"" } )
   AADD(aHeader,{ 'Unidade','UNIDADE',"@!",80,0,"","",'C','R02',"" } )
   AADD(aHeader,{ 'NCM','NCM',"@!",08,0,"","",'C','R02',"" } )
   AADD(aHeader,{ 'Quantidade','QTDE',"@E 999,999,999.999999",15,6,"","",'N','R02',"" } )
   AADD(aHeader,{ 'Custo Unitario','CUSTO_UNIT',"@E 999,999,999.9999",15,4,"","",'N','R02',"" } )

   aSize	:= MsAdvSize()
   nOpcx	:= 2
   aObjects	:= {} 

   AAdd( aObjects, { 100, 100, .t., .t. } )

   aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
   aPosObj := MsObjSize( aInfo, aObjects )

   DEFINE MSDIALOG oDlg TITLE OemtoAnsi("Alteração de Informaçoes DCRE - Registro Tipo 2") From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
   oGetDb := MsGetDB():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpcx,,,,,aAltera,,,LastRec(),"R02")
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})
Else
   aAltera	:=	{"CODPROD","TIPO_DOC","INDIC_SUSP","DI","NUM_ADICAO","NUM_ITEM","NF","SERIE","CNPJ","IE","DATAEMIS","DESCPROD","UNIDADE","NCM","QTDE","ALIQUOTA","IND_RED_II","CUSTO_UNIT"}

   dbSelectArea("R04")
   dbsetorder(0)
   AADD(aHeader,{ 'Codigo do Produto',	'CODPROD',"@!",15,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Tipo do Documento',	'TIPO_DOC',"@!",1,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Indicador Suspensao','INDIC_SUSP',"@!",01,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Número da DI','DI',"@!",10,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Número da Adição','NUM_ADICAO',"@!",03,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Número do Item da Adição','NUM_ITEM',"@!",02,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Numero da Nota','NF',"@!",10,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Serie','SERIE',"@!",05,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'CNPJ','CNPJ',"@!",14,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'IE','IE',"@!",15,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Dt.Emissao','DATAEMIS',"@D",08,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Descr.Produto','DESCPROD',"@!",80,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Unidade','UNIDADE',"@!",80,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'NCM','NCM',"@!",08,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Quantidade','QTDE',"@E 999,999,999.999999",15,6,"","",'N','R04',"" } )
   AADD(aHeader,{ 'Aliquota II','ALIQUOTA',"@E 999.99",05,2,"","",'N','R04',"" } )
   AADD(aHeader,{ 'Indicador Redução','IND_RED_II',"@!",01,0,"","",'C','R04',"" } )
   AADD(aHeader,{ 'Custo Unitario','CUSTO_UNIT',"@E 999,999,999.9999",15,4,"","",'N','R04',"" } )

   aSize	:= MsAdvSize()
   nOpcx	:= 2
   aObjects	:= {} 

   AAdd( aObjects, { 100, 100, .t., .t. } )

   aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
   aPosObj := MsObjSize( aInfo, aObjects )

   DEFINE MSDIALOG oDlg TITLE OemtoAnsi("Alteração de Informaçoes DCRE - Registro Tipo 4") From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
   oGetDb := MsGetDB():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpcx,,,,,aAltera,,,LastRec(),"R04")
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})
Endif
RestArea(aArea)
Return(.t.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SelOpc    º Autor ³Gustavo G. Rueda    º Data ³  01/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³Funcao de selecao da opcao de baixa, permite baixar a apro- º±±
±±º          ³ priacao erronea                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SelOpc()
	Local	nOpcao	:=	1
	Local	oTipo
	Local	nOpcBt	:=	1
	Local	aRet	:=	{}
	//
	DEFINE MSDIALOG oSelOpcDlg FROM 325,396 TO 559,612 TITLE OemToAnsi("Manutenção TXT - DCRE") PIXEL
	@ 05, 05 TO 115, 105 OF oSelOpcDlg PIXEL
  	@ 11, 25 RADIO oTipo VAR nOpcao PROMPT OemToAnsi("Registro Tipo 2"),OemToAnsi("Registro Tipo 4") OF oSelOpcDlg PIXEL SIZE 75,12
  	@ 40, 10 TO 110, 100 OF oSelOpcDlg PIXEL
  	@ 45, 15 SAY OemToAnsi ("As alterações efetuadas nos ") OF oSelOpcDlg PIXEL
  	@ 55, 15 SAY OemToAnsi ("registros Tipo 2 e Tipo 4 do") OF oSelOpcDlg PIXEL
  	@ 65, 15 SAY OemToAnsi ("DCRE serão efetuadas somente") OF oSelOpcDlg PIXEL
  	@ 75, 15 SAY OemToAnsi ("nas tabelas temporárias.") OF oSelOpcDlg PIXEL 
   	DEFINE SBUTTON FROM 92,11 TYPE 02 ACTION (nOpcBt := 1, oSelOpcDlg:End()) ENABLE OF oSelOpcDlg
   	DEFINE SBUTTON FROM 92,70 TYPE 01 ACTION (nOpcBt := 2, oSelOpcDlg:End()) ENABLE OF oSelOpcDlg   	
	ACTIVATE MSDIALOG oSelOpcDlg CENTERED
    If nOpcBt==1
       nOpcao :=3
    Endif   
	aRet	:=	{nOpcao}
Return (aRet)

Static Function STDCR02V(cComp)

Local	nRet	:= 1
Local	cAlias 	:= "QRYVLD2"
Local	cQuery	:= ""

cQuery	:= "SELECT D2_PRCVEN FROM ( "
cQuery	+= "SELECT D2_EMISSAO , R_E_C_N_O_ RECSD2, D2_PRCVEN "
cQuery	+= "FROM SD2030 SD2 "
cQuery	+= "WHERE "
cQuery	+= "D2_FILIAL <> ' ' AND "
cQuery	+= "D2_COD = '"+cComp+"' AND "
cQuery	+= "D2_QUANT > 0 AND "
cQuery	+= "SD2.D_E_L_E_T_= ' ' "
cQuery	+= "ORDER BY D2_EMISSAO DESC, R_E_C_N_O_  DESC "
cQuery	+= ")XXX WHERE ROWNUM = 1 "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

TCSetField(cAlias,"D2_PRCVEN","N",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2])

dbSelectArea(cAlias)
(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())
	nRet := (cAlias)->D2_PRCVEN
	(cAlias)->(DbSkip())
End

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

Return(nRet)
