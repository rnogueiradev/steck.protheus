/****************************************
Ação.........: Gerar arquivo CSV de pedidos de compras com saldo a serer faturado.
.............: Estes od pedidos de compras gerados serão importados para dentro da empresa 11.
Regras.......: Somente serão gerados arquivos para pedidos que <<< NÃO >>> estejam com o STATUS:
.............: - "SALDO A FATURAR" = (C7_QUANT - C7_QUJE) > 0 
.............: - Pedido com "ELIMINAÇÃO DE RESÍDUO" = C7_RESIDUO = ' '
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 16/12/2021
Chamados.....:  20211214026691
****************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TBICODE.ch"
#INCLUDE "FWMVCDEF.CH"


USER FUNCTION MSTECK08()
LOCAL aPergs   := {}
PRIVATE nTipo    := 1
PRIVATE aTitles1 := { "Pedidos de Compra aptos à serem <<< EXPORTADOS >>>"}
PRIVATE aTitles2 := { "Total de Pedidos Selecionados" }
PRIVATE aPages   := {}
PRIVATE aPosGet1 := {}
PRIVATE aBrowse  := {}
PRIVATE aVetor   := {}
PRIVATE aVetPed  := {}
PRIVATE aCABSC7  := {}
PRIVATE aITEMSC7 := {}
PRIVATE oBrowse
PRIVATE oFolder1
PRIVATE oFolder2
PRIVATE oSize1
PRIVATE oOk       := LoadBitmap( GetResources(), "LBOK" )
PRIVATE oNo       := LoadBitmap( GetResources(), "LBNO" )
PRIVATE oCheckBox
PRIVATE lCheckBox := .F.
PRIVATE nQtdPed   := 0
PRIVATE cQtdPed   := 0
PRIVATE oQtdPed
PRIVATE oBtOK
PRIVATE oBtSair
PRIVATE nTotRec := 0
PRIVATE nPos := 0
STATIC oDlg
 
AADD(aPergs, {2, "Tipo do Pedido:",nTipo, {"1=Nacional","2=Importados"},080, ".T.", .F.})
IF ParamBox(aPergs, "Selecione o Tipo de Pedido") = .F.
	RETURN
ENDIF

/******************************
Carrega no vetor todos os campos obrigatórios para o cabeçalho da SC7
Despresando os campos virtuais
******************************/
AADD(aCABSC7,"CABECALHO" )  
AADD(aCABSC7,"C7_FILIAL" )  
AADD(aCABSC7,"C7_NUM"    )  
AADD(aCABSC7,"C7_EMISSAO")  
AADD(aCABSC7,"C7_FORNECE")  
AADD(aCABSC7,"C7_LOJA"   )  
AADD(aCABSC7,"C7_COND"   )  
AADD(aCABSC7,"C7_CONTATO")  
AADD(aCABSC7,"C7_FILENT" )  
AADD(aCABSC7,"C7_MOEDA"  )  
AADD(aCABSC7,"C7_TXMOEDA")  
AADD(aCABSC7,"C7_TIPO"   )  
AADD(aCABSC7,"C7_XPLAN"  )  
AADD(aCABSC7,"C7_TPFRETE")  

/******************************
Carrega no vetor todos os campos obrigatórios para os itens da SC7
Despresando os campos virtuais
******************************/
AADD(aITEMSC7,"ITEM"      )
AADD(aITEMSC7,"C7_ITEM"   )
AADD(aITEMSC7,"C7_PRODUTO")
AADD(aITEMSC7,"C7_DESCRI" )
AADD(aITEMSC7,"C7_QUANT"  )
AADD(aITEMSC7,"C7_COND"   )
AADD(aITEMSC7,"C7_CODTAB" )
AADD(aITEMSC7,"C7_XPRCORC")
AADD(aITEMSC7,"C7_PRECO"  )
AADD(aITEMSC7,"C7_TOTAL"  )
AADD(aITEMSC7,"C7_MOTIVO" )
AADD(aITEMSC7,"C7_FILENT" )
AADD(aITEMSC7,"C7_CC"     )
//AADD(aITEMSC7,"C7_XMODALI")
AADD(aITEMSC7,"C7_DATPRF" )
AADD(aITEMSC7,"C7_UM"     )
AADD(aITEMSC7,"C7_SEGUM"  )
AADD(aITEMSC7,"C7_TOTAL"  )
AADD(aITEMSC7,"C7_IPI"    )
AADD(aITEMSC7,"C7_LOCAL"  )
AADD(aITEMSC7,"C7_OBS"    )
AADD(aITEMSC7,"C7_FLUXO"  )
AADD(aITEMSC7,"C7_TPFRETE")
//AADD(aITEMSC7,"C7_APROV"  ) //
//AADD(aITEMSC7,"C7_CONAPRO") //
AADD(aITEMSC7,"C7_USER"   ) /// Utlizar simone de Ap. de Paula 001070
//AADD(aITEMSC7,"C7_NUMSC"  )
//AADD(aITEMSC7,"C7_ITEMSC" )

//// Monta o vetor com os pedidos a serem exportados
PROCESSA({ || MSTECK8A(aBrowse)}, "Aguarde", "Carregando Pedidos de Compras...")

//// Calcula as dimensoes dos objetos
oSize1 := FwDefSize():New( .T. ) // Com enchoicebar
oSize1:lLateral  := .F.  // Calculo vertical
oSize1:AddObject( "FOLDER1",100, 150, .T., .T. )
oSize1:AddObject( "FOLDER2",100, 080, .T., .F. )
oSize1:Process()

// Desenha a dialog
DEFINE MSDIALOG oDlg TITLE "<<< EXPORTAÇÃO DE SALDOS DE PEDIDOS DE COMPRAS >>> " FROM oSize1:aWindSize[1],oSize1:aWindSize[2] TO oSize1:aWindSize[3],oSize1:aWindSize[4] PIXEL

// Monta o Objeto Folder
oFolder1:=TFolder():New( oSize1:GetDimension("FOLDER1","LININI"),oSize1:GetDimension("FOLDER1","COLINI"),aTitles1,aPages,oDlg,,,,.T.,.T.,oSize1:GetDimension("FOLDER1","XSIZE"),oSize1:GetDimension("FOLDER1","YSIZE"))
// Cria a dimensão das getdados, diminuindo um pouco da área do folder //devido ao titulo da pasta e bordas do objeto
aPosGet1 := { oSize1:GetDimension("FOLDER1","LININI"),oSize1:GetDimension("FOLDER1","COLINI"),oSize1:GetDimension("FOLDER1","XSIZE")-7,oSize1:GetDimension("FOLDER1","YSIZE")-19}

oFolder2:=TFolder():New( oSize1:GetDimension("FOLDER2","LININI"),oSize1:GetDimension("FOLDER2","COLINI"),aTitles2,aPages,oDlg,,,,.T.,.T.,oSize1:GetDimension("FOLDER2","XSIZE"),oSize1:GetDimension("FOLDER2","YSIZE"))

@ 013, 006 SAY "Quantidade de Pedidos Selecionados: " SIZE 150, 007 OF oFolder2:aDialogs[1] PIXEL
@ 011, 106 MSGET oQtdPed VAR cQtdPed SIZE 050, 010 OF oFolder2:aDialogs[1] PICTURE "@E 99999"         PIXEL WHEN .F.
@ 040, 006 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Marcar/Desmarcar Todos" SIZE 075, 008 OF oFolder2:aDialogs[1] ON CLICK(Iif(lCheckBox,Marca(lCheckBox),Marca(lCheckBox))) PIXEL
@ 040, 106 BUTTON oBtOK    PROMPT "Confirmar" SIZE 040, 013 OF oFolder2:aDialogs[1] ACTION(IIF(MSTECK8B()=.T.,oDlg:End(),"")) PIXEL
@ 040, 176 BUTTON oBtSair  PROMPT "Fechar"    SIZE 040, 013 OF oFolder2:aDialogs[1] ACTION(oDlg:End()) PIXEL

oBrowse := TWBrowse():New( aPosGet1[1] ,aPosGet1[2],aPosGet1[3],aPosGet1[4],,{'','Filial','Pedido','Fornecedor','Loja','Nome'},{10,20,20,20,50,250},oFolder1:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
oBrowse:SetArray(aBrowse)
oBrowse:AddColumn( TCColumn():New(""          ,{||IIF(aBrowse[oBrowse:nAt,1],oOk,oNo)},"",,,"CENTER",10,.T.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Filial    ",{|| aBrowse[oBrowse:nAt,2]},"@!",,,"CENTER",030,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Pedido    ",{|| aBrowse[oBrowse:nAt,3]},"@!",,,"CENTER",050,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Fornecedor",{|| aBrowse[oBrowse:nAt,4]},"@!",,,"CENTER",050,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Loja      ",{|| aBrowse[oBrowse:nAt,5]},"@!",,,"CENTER",030,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Nome      ",{|| aBrowse[oBrowse:nAt,6]},"@!",,,"LEFT"  ,250,.F.,.T.,,,,.F.,))

// Troca a imagem no duplo click do mouse
oBrowse:bLDblClick := {|| MARCDES()}

oFolder2:Align := CONTROL_ALIGN_BOTTOM
oFolder1:Align := CONTROL_ALIGN_ALLCLIENT
oBrowse:Align  := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED

RETURN

/*****************
Rotina para Marcar  / Desmarcar todos os Títulos
*****************/
STATIC FUNCTION MARCA(lMarca)
LOCAL i := 0
nQtdPed := 0

FOR i := 1 TO LEN(aBrowse)
	IF lMarca = .T.
		nQtdPed++
	ENDIF
	aBrowse[i][1] := lMarca
NEXT i
cQtdPed := STRZERO(nQtdPed,5)
oQtdPed:Refresh()
oBrowse:Refresh()
RETURN

/****************
Função de Marca Desmarca e Atualiza a Quantidade de Pedidos
****************/ 
STATIC FUNCTION MARCDES()
LOCAL i := 0
nQtdPed := 0

IF aBrowse[oBrowse:nAt][1] = .T.
	aBrowse[oBrowse:nAt][1] := .F.
ELSE
	aBrowse[oBrowse:nAt][1] := .T.
ENDIF	

//// Atualiza o campo de Quantidade de Pedidos
FOR i := 1 TO LEN(aBrowse)
	IF aBrowse[i,1] = .T.
		nQtdPed++
	ENDIF
NEXT
cQtdPed := STRZERO(nQtdPed,5)
oQtdPed:Refresh()

RETURN

/***************
Carrega os Pedidos de Compra
***************/
STATIC FUNCTION MSTECK8A(aBrowse)
LOCAL cQuery   := ""

//// Caso tenha selecionado pedidos IMPORTADOS
IF cValToChar(MV_PAR01) = "2"
	cQuery := "SELECT C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, C7.R_E_C_N_O_ AS SC7REC,C1_NUM  FROM "+RetSqlName("SC7")+" C7 "
	cQuery += "INNER JOIN "+RetSqlName("SC1") +" C1 ON C1.D_E_L_E_T_ = ' ' AND C1.C1_FILIAL = C7.C7_FILIAL AND C1.C1_NUM = C7.C7_NUM AND C1.C1_NUM_SI <> ' ' "
	cQuery += "WHERE C7.D_E_L_E_T_ = ' ' AND C7.C7_FILIAL = '"+XFILIAL("SC7")+"' "
	cQuery += "  AND (C7.C7_QUANT - C7.C7_QUJE) > 0 "
	cQuery += "  AND C7_RESIDUO = ' ' "
	cQuery += "  AND C7.C7_XIMPEXP = ' ' "
	cQuery += "GROUP BY C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, C7.R_E_C_N_O_,C1_NUM "
	cQuery += "ORDER BY C7_FILIAL, C7_NUM "
ELSE
	cQuery := "SELECT C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, C7.R_E_C_N_O_ AS SC7REC  FROM "+RetSqlName("SC7")+" C7 "
	cQuery += "WHERE C7.D_E_L_E_T_ = ' ' AND C7.C7_FILIAL = '"+XFILIAL("SC7")+"' "
	cQuery += "  AND (C7.C7_QUANT - C7.C7_QUJE) > 0 "
	cQuery += "  AND C7_RESIDUO = ' ' "
	cQuery += "  AND C7.C7_XIMPEXP = ' ' "
	cQuery += "GROUP BY C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, C7.R_E_C_N_O_ "
	cQuery += "ORDER BY C7_FILIAL, C7_NUM "
ENDIF

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.)
IF !EMPTY(TSC7->C7_NUM)

	//// Pega quantidade de registros a serem gravados
	TSC7->(DBGOTOP())
	nTotRec := 0
	DbEval({|| nTotRec++  })
	PROCREGUA(nTotRec)
	TSC7->(DBGOTOP())

	WHILE TSC7->(!EOF())
		
		nPos := 0 
		nPos := aScan(aBrowse, {|x| ALLTRIM(x[3]) == ALLTRIM(TSC7->C7_NUM)  })
		IF nPos = 0 
			nQtdPed++
			INCPROC("Carregando informações...."+ALLTRIM(STR(nQtdPed))+" / "+ALLTRIM(STR(nTotRec)))
			AADD(aBrowse,{.T.,C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA,POSICIONE("SA2",1,XFILIAL("SA2")+TSC7->C7_FORNECE+TSC7->C7_LOJA,"A2_NOME")})
		ENDIF

		nPos := 0 
		nPos := aScan(aVetPed, {|x| ALLTRIM(x[1]) == ALLTRIM(TSC7->C7_NUM)  })
		IF nPos = 0 
			AADD(aVetPed,{TSC7->C7_NUM,{}})
      AADD(aVetPed[LEN(aVetPed),2],{TSC7->SC7REC})
		ELSEIF nPos > 0 
      AADD(aVetPed[nPos,2],{TSC7->SC7REC})
		ENDIF

		TSC7->(DBSKIP())
	ENDDO

ENDIF 

IF LEN(aBrowse) = 0
	AADD(aBrowse,{.F.,"","","","",""})
ENDIF
TSC7->(DBCLOSEAREA())

cQtdPed := STRZERO(nQtdPed,5)
RETURN aBrowse

/*************************
Exporta os pedidos de compras selecionados
*************************/
STATIC FUNCTION MSTECK8B()
LOCAL lRet := .F.

//// Verifica se existe pelo menos um item do vetor com um número de pedido
IF !EMPTY(aBrowse[1,2])
	IF MSGYESNO("Deseja <<< EXPORTAR >>>  os Pedidos de Compra?", "Atenção")
		PROCESSA({ || MSTECK8C()}, "Aguarde", "Exportando Pedidos de Compras...")
		lRet := .T.
	ENDIF
ENDIF
RETURN lRet

/*************************
Gera os arquivos para os pedidos de compras selecionados
*************************/
STATIC FUNCTION MSTECK8C()
LOCAL i := 0 
LOCAL nX := 0 
LOCAL nHdl := 0
LOCAL nPed := 0
LOCAL nCab := 0 
LOCAL nItem := 0
LOCAL cPath := "C:\TEMP\PEDIDO_COMPRA\"
LOCAL nCount := 0 
LOCAL cNomArq := ""
LOCAL nItemSC7 := 0
LOCAL aVetAux := {}
LOCAL cNumPed := ""

PROCREGUA(nQtdPed)
//// Varre o Brose e verifica se existe algum pedido a ser importado
nTotRec := 0
FOR nPed  := 1 TO LEN(aBrowse)

	IF aBrowse[nPed,1] =.T.
		
		nCount++
		INCPROC("Gravando arquivos...."+ALLTRIM(STR(nCount))+" / "+ALLTRIM(STR(nQtdPed)))

		//// Varre o arquivo de Pedido com Registro e carrega os itens
		nPos := 0 
		nPos := aScan(aVetPed, {|x| ALLTRIM(x[1]) == ALLTRIM(aBrowse[nPed,3])})
		IF nPos > 0 

			//// Zera o Contador do Item
			cNumPed := aVetPed[nPos,1]
			nItemSC7 := 0

			aVetAux := {}
			aVetAux := aVetPed[nPos,2]
			//// Posiciona no Registro do Pedido de Compra
			FOR nX := 1 TO LEN(aVetAux)	

				/************************
				Grava os campos do cabeçalho do Pedido de Vendas
				************************/
				IF nX = 1 

					aVetor  := {}
					SC7->(DBSETORDER(1))
					SC7->(DBGOTO(aVetAux[nX,1]))

					/************************
					Grava no campo C7_XIMPEXP = "E" para saber que o pedido não poderá ser Exportado novamente.
					Eliminação de Resíduo, força a gravação do campo C7_RESIDUO = 'S'
					************************/
					RECLOCK("SC7",.F.)
					SC7->C7_XIMPEXP := "E"
					SC7->C7_RESIDUO := "S"
					SC7->(MSUNLOCK())

					nCab := 0 
					FOR nCab := 1 TO LEN(aCABSC7)
						IF nCab = 1
							AADD(aVetor,{"CABECALHO"})
						ELSE
							AADD(aVetor[LEN(aVetor)],SC7->&(aCABSC7[nCab]))
						ENDIF
					NEXT nCab

					/************************
					Grava os campos do Item do Pedido de Compras
					************************/
					//nItemSC7++
					nItem := 0
					FOR nItem := 1 TO LEN(aITEMSC7)
						IF nItem = 1
							AADD(aVetor,{"ITEM"})
							//AADD(aVetor[LEN(aVetor)],TSC7->C7_NUM)
						ELSE
							/************************
							Inclui o código do usuário especifico
							Simone de Ap. de Paula 001070
							************************/
							IF aITEMSC7[nItem] = "C7_USER"
								AADD(aVetor[LEN(aVetor)],"001070")
							ELSE
								AADD(aVetor[LEN(aVetor)],SC7->&(aITEMSC7[nItem]))
							ENDIF
						ENDIF
					NEXT nItem

				ELSE
					/************************
					Grava os campos do Item do Pedido de Vendas
					************************/
					SC7->(DBSETORDER(1))
					SC7->(DBGOTO(aVetAux[nX,1]))

					/************************
					Grava no campo C7_XIMPEXP = "E" para saber que o pedido não poderá ser Exportado novamente
					************************/
					RECLOCK("SC7",.F.)
					SC7->C7_XIMPEXP := "E"
					SC7->(MSUNLOCK())

					//nItemSC7++
					nItem := 0
					FOR nItem := 1 TO LEN(aITEMSC7)
						IF nItem = 1
							AADD(aVetor,{"ITEM"})
							//AADD(aVetor[LEN(aVetor)],TSC7->C7_NUM)
						ELSE
							/************************
							Inclui o código do usuário especifico
							Simone de Ap. de Paula 001070
							************************/
							IF aITEMSC7[nItem] = "C7_USER"
								AADD(aVetor[LEN(aVetor)],"001070")
							ELSE
								AADD(aVetor[LEN(aVetor)],SC7->&(aITEMSC7[nItem]))
							ENDIF
						ENDIF
					NEXT nItem
				ENDIF
			NEXT nX								
		ENDIF

    /******************************************
    Grava o Arquivo baseado no vetor montado.
    ******************************************/
    cNomArq := "PEDIDO_COMPRA_"+cNumPed+"_"+DTOS(DATE())+".CSV"
	  IF ExistDir("C:\TEMP\PEDIDO_COMPRA\") = .F.
      MakeDir("C:\TEMP\PEDIDO_COMPRA\")
    ENDIF
    
    nHdl := FCreate(Upper(cPath+cNomArq))
    FOR i := 1 TO LEN(aVetor)
      cLinha := ""
      FOR nX := 1 TO LEN(aVetor[i])
        //// Verifica se o campo é DATA
        IF VALTYPE(aVetor[i,nX]) = "D"
          cLinha += DTOC(aVetor[i,nX])+";"
        //// Verifica se o campo é NUMÉRICO
        ELSEIF VALTYPE(aVetor[i,nX]) = "N"
          aVetor[i,nX] := MSTECK8D(ALLTRIM(STR(aVetor[i,nX]))) 
          cLinha += aVetor[i,nX]+";"
        ELSE
          cLinha += ALLTRIM(aVetor[i,nX])+";"
        ENDIF
      NEXT
      cLinha += Chr(13)+Chr(10)
      FWrite(nHdl,cLinha)
    NEXT
    FClose(nHdl)

	ENDIF
NEXT nPed

RETURN 

/*************************
Rotina para Alterar campos Numéricos trocando a casa Decimal de "." para ","
Estou efetuando esta troca pois os arquivos que serão gerados de forma manual
pelos usuários estarão com a casa Decimal com ",".
Assim o fonte de importação não terá problema na hora de converter o valor de texto para numérico.
************************/
STATIC FUNCTION MSTECK8D(xcValor)
LOCAL _cValor := ""
LOCAL nZ := 0 
FOR nZ := 1 TO LEN(xcValor)
  IF SUBSTR(xcValor,nZ,1) = "."
    _cValor += ","
  ELSE
    _cValor += SUBSTR(xcValor,nZ,1)
  ENDIF
NEXT

RETURN _cValor
