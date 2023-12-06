#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"

User Function PREVSTECK()

   //*******************************************************************
   //***  SIGA ADVANCED - Modulo PCP                                 ***
   //***                                                             ***
   //***  Empr.: SIGAMAT  - Consultoria                              ***
   //***  Nome.: PREVSTECK.PRW                                       ***
   //***  Descr: Geracao/Exclus�p de Previsao de Vendas Atrav�z      ***
   //***         da Carteira de Pedidos                              ***
   //***  Autor: Fabio Moura  - Consultor  - FMT                     ***
   //***  Data : 15/10/2021                                          ***
   //***  Alter:                                                     ***
   //*******************************************************************

	Private V_DTAINI
	Private V_DTAFIM
	Private V_PROINI
	Private V_PROFIM
	Private V_GRUPOS
	Private V_TIPOSP
	Private V_CLIINI
	Private V_CLIFIM
	Private V_LOCPAD
	Private V_CONMAN
	Private V_DOCINI
	Private CINDTMP
	Private V_DOC
	Private V_TSNAO
	Private V_CFNAO
	Private V_PRECO
	Private V_ENTREG
	Private V_FILIAL
	Private V_PRODUTO
	Private V_QUANT
	Private V_VALOR
	Private CGRUPO
	Private CARQ
	Private NORDEM
	Private NLENCP
	Private ASX1
	Private ACAMPOS

	Private oDlg1

	SX1_Cad("PREVSTECK")
	SX1_Cad("PREVDELST")

	@000,000 TO 200,285 DIALOG oDlg1 TITLE "Manute��o das Previs�es de Vendas"
	@010,005 say "Este programa gera a Previsao de Vendas para"    size 150,12
	@020,005 say "calculo de MRP atraves da Carteira de Pedidos."  size 150,12
	@035,005 say ">>>  ATENCAO!  Pode-se Eliminar a Previsao     "  size 150,12
	@045,025 say "anterior se necessario..."                       size 150,12
	@067,005 BUTTON "_Eliminar"   SIZE 40,15 ACTION fOkEliminar()// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==> @067,005 BUTTON "_Eliminar"   SIZE 40,12 ACTION Execute(fOkEliminar)
	@067,050 BUTTON "_Cancelar"   SIZE 40,15 ACTION Close(oDlg1)
	@067,095 BUTTON "_Gerar"      SIZE 40,15 ACTION fContinuar() // Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==> @067,095 BUTTON "_Gerar"      SIZE 40,12 ACTION Execute(fContinuar)
	
	ACTIVATE DIALOG oDlg1 CENTERED

Return

//----------------------> Continua Processamento
// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==> Function fOkEliminar
Static Function fOkEliminar()
	If !Pergunte("PREVDELST",.T.)
		Return NIL
	EndIf

	Close(oDlg1)

	If !MsgBox("Confirma a Exclus�o?","Confirmacao","YESNO")
		Return NIL
	EndIf

	Processa( {|| fEliminar() },"Excluindo...")// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==>     Processa( {|| Execute(fEliminar) },"Eliminando...")
Return

//----------------------> Continua Processamento
// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==> Function fContinuar
Static Function fContinuar()

	If !Pergunte("PREVSTECK",.T.)
		Return NIL
	EndIf

	Close(oDlg1)

	If !MsgBox("Confirma Processamento?","Confirmacao","YESNO")
		Return NIL
	EndIf

	Processa( {|| fRunProc() },"Processando...")// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==>     Processa( {|| Execute(fRunProc) },"Processando...")
Return NIL

//-------------------------------------------------------
//--------------> Processa Informacoes
//-------------------------------------------------------
// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==> Function fRunProc
Static Function fRunProc()

	DbSelectArea("SA7") // Amarração Produto x Cliente para busca de preços
	DbSetOrder(1)

	DbSelectArea("SC5") // Pedidos de Venda
	DbSetOrder(1)

	DbSelectArea("SF4") // Seleciona TES que gera duplicata
	DbSetOrder(1)

	DbSelectArea("SC6") // data de entrega //Itens Pedidos de Venda
	DbSetOrder(3)

	DbSelectArea("SC4") // Previsao de Venda
	DbSetOrder(1)

	//----------------------------------------------------
	//------------> Cria Nova previsao de Vendas

	cQuery := "SELECT C6_FILIAL, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, C6_ENTREG, C6_LOCAL, C6_CLI, C6_LOJA, C6_CF, C6_NUM, C6_TES " 
	cQuery += "FROM "+RETSQLNAME("SC6")+" "//+RETSQLNAME("SF4")+" SF4  "
	cQuery += "WHERE D_E_L_E_T_<>'*' "//AND SF4.D_E_L_E_T_='' AND SC6.C6_TES=SF4.F4_CODIGO "
	cQuery += "AND C6_ENTREG >='"+DTOS(MV_PAR01)+"' AND C6_ENTREG <='"+DTOS(MV_PAR02)+"' "
	cQuery += "AND C6_PRODUTO >= '"+MV_PAR03+"' AND C6_PRODUTO <= '"+MV_PAR04+"' "
	cQuery += "AND C6_CLI >= '"+MV_PAR07+"' AND C6_CLI <= '"+MV_PAR08+"' "
	cQuery += "AND C6_LOCAL >= '"+MV_PAR09+"' AND C6_LOCAL <= '"+MV_PAR10+"' "
	cQuery += "AND C6_FILIAL >= '"+MV_PAR12+"' AND C6_FILIAL <= '"+MV_PAR13+"' "
	cQuery += "AND C6_QTDVEN > C6_QTDENT "
	cQuery += "ORDER BY C6_FILIAL, C6_ENTREG, C6_PRODUTO "

	ChangeQuery(cQuery)

	If  Select("SC6A") > 0 
		SC6A->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"SC6A")
	
	TcSetField("SC6A","C6_ENTREG","D",8,0)

	DbSelectArea("SC6")
	ProcRegua(LastRec())
	
	DbSelectArea("SC6A")
	SC6A->(DbGoTop()) // Primeiro Registro
	
	While !SC6A->(Eof()) 
		
		IncProc("Gerando..."+DTOC(SC6A->C6_ENTREG) )

		IF SB1->(DbSeek(xFilial("SB1")+SC6A->C6_PRODUTO)) 
			IF SB1->B1_GRUPO < MV_PAR05 .OR. SB1->B1_GRUPO > MV_PAR06
				SC6A->(DbSkip())
				Loop
			Endif	
		EndIf

		If "99" $ SC6A->C6_CF 
			SC6A->(DbSkip())
			Loop
		EndIf

		IF SF4->(DBSEEK(XFILIAL("SF4") + SC6A->C6_TES))
			IF SF4->F4_DUPLIC # 'S'
				SC6A->(DbSkip())
				Loop
			ENDIF	
		EndIf
		
		//----------> Verifica Tipo de Pedido
		/*
		IF !SC5->(DbSeek(xFilial("SC5")+SC6A->C6_NUM)) 
			SC6A->(DbSkip())
			Loop
		Else
			If SC5->C5_TIPO $ "PIDB"
				SC6A->(DbSkip())
				Loop
			EndIf
		Endif	
		*/

		//------------> Cria registro de Previsao de Venda

		RecLock("SC4",.T.)
		SC4->C4_FILIAL  := SC6A->C6_FILIAL 
		SC4->C4_PRODUTO := SC6A->C6_PRODUTO
		SC4->C4_LOCAL   := SC6A->C6_LOCAL
		SC4->C4_DOC     := MV_PAR11
		SC4->C4_DATA    := SC6A->C6_ENTREG
		SC4->C4_OBS     := Subst(cUsuario,7,10)+" "+Dtoc(dDataBase)+" "+Time()
		SC4->C4_QUANT   := SC6A->C6_QTDVEN - SC6A->C6_QTDENT
		SC4->(MsUnLock())

		SC6A->(DbSkip())

	End

	DbSelectArea("SC6A")
	SC6A->(DbCloseArea())

	MsgAlert("Fim de Processamento... ","INFO")
	
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Cadastro de parametros SX1 ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==> Function SX1_Cad
Static Function SX1_Cad(cGRUPO)

	Local nLENCP
	Local nORDEM
	Local cARQ := Alias()      // Salva Alias do Arquivo Atual

	DbSelectArea("SX1")  // Arquivo de parametros
	DbSetOrder(1)
	If SX1->(DbSeek(PADR(cGRUPO,10)))
		DbSelectArea(cARQ)
		Return NIL
	Endif

	nORDEM := 0         // Numero de Ordem
	nLENCP := 0         // Numero de Campos
	aSX1   := {}        // Array com as Informacoes
	aCampos:= {"X1_ORDEM"  ,"X1_PERGUNT","X1_GSC"  ,"X1_TIPO"  ,"X1_TAMANHO",;
		"X1_DECIMAL","X1_VARIAVL","X1_VAR01","X1_PRESEL","X1_DEF01",;
		"X1_DEF02"  ,"X1_DEF03"  ,"X1_DEF04","X1_DEF05" ,"X1_F3",;
		"X1_VALID"}

	// -------> Array Perguntas
	// aSX1:= {Ord, Pergunta,              GSC,Tip,Tm,D,Var,     Var01,    PrSl,Df1,Df2,Df3,Df4,Df5,F3,  Valid}
	IF Alltrim(cGRUPO) == "PREVSTECK"
		aadd(aSX1,{"01","Dt. Entrega De  ?","G","D",08,0,"mv_ch1","mv_par01",0,"","","","","","",""})
		aadd(aSX1,{"02","Dt. Entrega Ate ?","G","D",08,0,"mv_ch2","mv_par02",0,"","","","","","",""})
		aadd(aSX1,{"03","Produto De      ?","G","C",15,0,"mv_ch3","mv_par03",0,"","","","","","SB1",""})
		aadd(aSX1,{"04","Produto Ate     ?","G","C",15,0,"mv_ch4","mv_par04",0,"","","","","","SB1",""})
		aadd(aSX1,{"05","Grupo De        ?","G","C",04,0,"mv_ch5","mv_par05",0,"","","","","","SBM",""})
		aadd(aSX1,{"06","Grupo Ate       ?","G","C",04,0,"mv_ch6","mv_par06",0,"","","","","","SBM",""})
		aadd(aSX1,{"07","Cliente De      ?","G","C",06,0,"mv_ch7","mv_par07",0,"","","","","","SA1",""})
		aadd(aSX1,{"08","Cliente Ate     ?","G","C",06,0,"mv_ch8","mv_par08",0,"","","","","","SA1",""})
		aadd(aSX1,{"09","Destino De      ?","G","C",02,0,"mv_ch9","mv_par09",0,"","","","","","NNR",""})
		aadd(aSX1,{"10","Destino Ate     ?","G","C",02,0,"mv_chA","mv_par10",0,"","","","","","NNR",""})
		aadd(aSX1,{"11","Nro.Documento   ?","G","C",09,0,"mv_chB","mv_par11",0,"","","","","","",""})
		aadd(aSX1,{"12","Filial De       ?","G","C",02,0,"mv_chc","mv_par12",0,"","","","","","SM0",""})
		aadd(aSX1,{"13","Filial Ate      ?","G","C",02,0,"mv_chd","mv_par13",0,"","","","","","SM0",""})
	ELSE
		aadd(aSX1,{"01","Dt. Entrega De  ?","G","D",08,0,"mv_ch1","mv_par01",0,"","","","","","",""})
		aadd(aSX1,{"02","Dt. Entrega Ate ?","G","D",08,0,"mv_ch2","mv_par02",0,"","","","","","",""})
		aadd(aSX1,{"03","Produto De      ?","G","C",15,0,"mv_ch3","mv_par03",0,"","","","","","SB1",""})
		aadd(aSX1,{"04","Produto Ate     ?","G","C",15,0,"mv_ch4","mv_par04",0,"","","","","","SB1",""})
		aadd(aSX1,{"05","Destino De      ?","G","C",02,0,"mv_ch5","mv_par05",0,"","","","","","NNR",""})
		aadd(aSX1,{"06","Destino Ate     ?","G","C",02,0,"mv_ch6","mv_par06",0,"","","","","","NNR",""})
		aadd(aSX1,{"07","Nro.Documento De  ?","G","C",09,0,"mv_ch7","mv_par07",0,"","","","","","",""})
		aadd(aSX1,{"08","Nro.Documento Ate ?","G","C",09,0,"mv_ch8","mv_par08",0,"","","","","","",""})
		aadd(aSX1,{"09","Filial De       ?","G","C",02,0,"mv_ch9","mv_par09",0,"","","","","","SM0",""})
		aadd(aSX1,{"10","Filial Ate      ?","G","C",02,0,"mv_cha","mv_par10",0,"","","","","","SM0",""})
	ENDIF

	//----------> Salva as Informacoes
	For nORDEM := 1 to Len(aSX1) // Quantidade de Perguntas
		/* Removido 11/05/23 - N�o executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		If RecLock("SX1",.T.)

			SX1->X1_GRUPO := cGRUPO
			For nLENCP := 1 to 16  // Quantidade de Campos
				FieldPut(FieldPos(aCampos[nLENCP]),aSX1[nORDEM,nLENCP])
			Next

		EndIf
		MSUnLock()
		*/
	Next

	DbSelectArea(cARQ)
Return NIL

//------------------------------------------------------
// Eliminar Lancamentos Anteriores de previsao de Vendas
// Substituido pelo assistente de conversao do AP6 IDE em 10/09/02 ==> Function fEliminar
Static Function fEliminar()

	Local cQuery := '' 

	ChangeQuery(cQuery)

	cQuery := "UPDATE "+RETSQLNAME("SC4")+" SET D_E_L_E_T_='*' "//FROM "+RETSQLNAME("SB1")+" "
	cQuery += "WHERE C4_DATA >='"+DTOS(MV_PAR01)+"' AND C4_DATA <='"+DTOS(MV_PAR02)+"' " 
	cQuery += "AND C4_PRODUTO >= '"+MV_PAR03+"' AND C4_PRODUTO <= '"+MV_PAR04+"' "
	cQuery += "AND C4_LOCAL >= '"+MV_PAR05+"' AND C4_LOCAL <= '"+MV_PAR06+"' "
	cQuery += "AND C4_DOC >= '"+MV_PAR07+"' AND C4_DOC <= '"+MV_PAR08+"' "
	cQuery += "AND C4_FILIAL >= '"+MV_PAR09+"' AND C4_FILIAL <= '"+MV_PAR10+"' "

	if TcSqlExec(cQuery) > 0
		MsgAlert('Problema na exclus�o das previs�es !','AVISO')
	Else
		MsgAlert("Fim de Processamento... ","INFO")
	Endif

Return NIL
