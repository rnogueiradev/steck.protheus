/****************************************
Ação.........: Gerar pedidos de compras com saldo a serer faturado.
.............: Estes OS pedidos de Compra gerados serão importados para dentro da empresa 11.
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


USER FUNCTION MSTECK10()
PRIVATE aTitles1 := { "<<< IMPORTAÇÃO >>> de Pedidos de Compra"}
PRIVATE aTitles2 := { "Total de Pedidos Selecionados" }
PRIVATE aPages   := {}
PRIVATE aPosGet1 := {}
PRIVATE aBrowse  := {}
PRIVATE aVetor   := {}
PRIVATE aVetPed  := {}
PRIVATE aCABSC7  := {}
PRIVATE aITEMSC7 := {}
PRIVATE aSX3CAB  := {}
PRIVATE aSX3ITEM := {}
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
PRIVATE cOldUser := __cUserId
PRIVATE nContEr := 0
PRIVATE nContOK := 0
STATIC oDlg

/******************************
Carrega no vetor todos os campos da tabela SC7
Despresando os campos virtuais
******************************/
AADD(aSX3CAB,"CABECALHO" )  
AADD(aSX3CAB,"C7_FILIAL" )  
AADD(aSX3CAB,"C7_NUM"    )  
AADD(aSX3CAB,"C7_EMISSAO")  
AADD(aSX3CAB,"C7_FORNECE")  
AADD(aSX3CAB,"C7_LOJA"   )  
AADD(aSX3CAB,"C7_COND"   )  
AADD(aSX3CAB,"C7_CONTATO")  
AADD(aSX3CAB,"C7_FILENT" )  
AADD(aSX3CAB,"C7_MOEDA"  )  
AADD(aSX3CAB,"C7_TXMOEDA")  
AADD(aSX3CAB,"C7_TIPO"   )  
AADD(aSX3CAB,"C7_XPLAN"  )  
AADD(aSX3CAB,"C7_TPFRETE")  

/******************************
Carrega no vetor todos os campos obrigatórios para os itens da SC7
Despresando os campos virtuais
******************************/
AADD(aSX3ITEM,"ITEM"      )
AADD(aSX3ITEM,"C7_ITEM"   )
AADD(aSX3ITEM,"C7_PRODUTO")
AADD(aSX3ITEM,"C7_DESCRI" )
AADD(aSX3ITEM,"C7_QUANT"  )
AADD(aSX3ITEM,"C7_COND"   )
AADD(aSX3ITEM,"C7_CODTAB" )
AADD(aSX3ITEM,"C7_XPRCORC")
AADD(aSX3ITEM,"C7_PRECO"  )
AADD(aSX3ITEM,"C7_TOTAL"  )
AADD(aSX3ITEM,"C7_MOTIVO" )
AADD(aSX3ITEM,"C7_FILENT" )
AADD(aSX3ITEM,"C7_CC"     )
//AADD(aITEMSC7,"C7_XMODALI")
AADD(aSX3ITEM,"C7_DATPRF" )
AADD(aSX3ITEM,"C7_UM"     )
AADD(aSX3ITEM,"C7_SEGUM"  )
AADD(aSX3ITEM,"C7_TOTAL"  )
AADD(aSX3ITEM,"C7_IPI"    )
AADD(aSX3ITEM,"C7_LOCAL"  )
AADD(aSX3ITEM,"C7_OBS"    )
AADD(aSX3ITEM,"C7_FLUXO"  )
AADD(aSX3ITEM,"C7_TPFRETE")
//AADD(aITEMSC7,"C7_APROV"  ) //
//AADD(aITEMSC7,"C7_CONAPRO") //
AADD(aSX3ITEM,"C7_USER"   ) /// Utlizar simone de Ap. de Paula 001070
//AADD(aITEMSC7,"C7_NUMSC"  )
//AADD(aITEMSC7,"C7_ITEMSC" )

//// Monta o vetor com os pedidos a serem importados
PROCESSA({ || MSTECK10A(aBrowse)}, "Aguarde", "Carregando Pedidos de Compras...")

//// Calcula as dimensoes dos objetos
oSize1 := FwDefSize():New( .T. ) // Com enchoicebar
oSize1:lLateral  := .F.  // Calculo vertical
oSize1:AddObject( "FOLDER1",100, 150, .T., .T. )
oSize1:AddObject( "FOLDER2",100, 080, .T., .F. )
oSize1:Process()

// Desenha a dialog
DEFINE MSDIALOG oDlg TITLE "<<< IMPORTAÇÃO DE SALDOS DE PEDIDOS DE COMPRAS >>> " FROM oSize1:aWindSize[1],oSize1:aWindSize[2] TO oSize1:aWindSize[3],oSize1:aWindSize[4] PIXEL

// Monta o Objeto Folder
oFolder1:=TFolder():New( oSize1:GetDimension("FOLDER1","LININI"),oSize1:GetDimension("FOLDER1","COLINI"),aTitles1,aPages,oDlg,,,,.T.,.T.,oSize1:GetDimension("FOLDER1","XSIZE"),oSize1:GetDimension("FOLDER1","YSIZE"))
// Cria a dimensão das getdados, diminuindo um pouco da área do folder //devido ao titulo da pasta e bordas do objeto
aPosGet1 := { oSize1:GetDimension("FOLDER1","LININI"),oSize1:GetDimension("FOLDER1","COLINI"),oSize1:GetDimension("FOLDER1","XSIZE")-7,oSize1:GetDimension("FOLDER1","YSIZE")-19}

oFolder2:=TFolder():New( oSize1:GetDimension("FOLDER2","LININI"),oSize1:GetDimension("FOLDER2","COLINI"),aTitles2,aPages,oDlg,,,,.T.,.T.,oSize1:GetDimension("FOLDER2","XSIZE"),oSize1:GetDimension("FOLDER2","YSIZE"))

@ 013, 006 SAY "Quantidade de Pedidos Selecionados: " SIZE 150, 007 OF oFolder2:aDialogs[1] PIXEL
@ 011, 106 MSGET oQtdPed VAR cQtdPed SIZE 050, 010 OF oFolder2:aDialogs[1] PICTURE "@E 99999"         PIXEL WHEN .F.
@ 040, 006 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Marcar/Desmarcar Todos" SIZE 075, 008 OF oFolder2:aDialogs[1] ON CLICK(Iif(lCheckBox,Marca(lCheckBox),Marca(lCheckBox))) PIXEL
@ 040, 106 BUTTON oBtOK    PROMPT "Confirmar" SIZE 040, 013 OF oFolder2:aDialogs[1] ACTION(IIF(MSTECK10B()=.T.,oDlg:End(),"")) PIXEL
@ 040, 176 BUTTON oBtSair  PROMPT "Fechar"    SIZE 040, 013 OF oFolder2:aDialogs[1] ACTION(oDlg:End()) PIXEL

oBrowse := TWBrowse():New( aPosGet1[1] ,aPosGet1[2],aPosGet1[3],aPosGet1[4],,{'','Filial Ori.','Pedido Ori.','Fornecedor','Loja','Nome','Arquivo'},{10,20,20,20,50,100,100},oFolder1:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
oBrowse:SetArray(aBrowse)
oBrowse:AddColumn( TCColumn():New(""           ,{||IIF(aBrowse[oBrowse:nAt,1],oOk,oNo)},"",,,"CENTER",10,.T.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Filial Ori.",{|| aBrowse[oBrowse:nAt,2]},"@!",,,"CENTER",030,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Pedido Ori.",{|| aBrowse[oBrowse:nAt,3]},"@!",,,"CENTER",050,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Fornecedor ",{|| aBrowse[oBrowse:nAt,4]},"@!",,,"CENTER",050,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Loja       ",{|| aBrowse[oBrowse:nAt,5]},"@!",,,"CENTER",030,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Nome       ",{|| aBrowse[oBrowse:nAt,6]},"@!",,,"LEFT"  ,100,.F.,.T.,,,,.F.,))
oBrowse:AddColumn( TCColumn():New("Arquivo    ",{|| aBrowse[oBrowse:nAt,7]},"@!",,,"LEFT"  ,100,.F.,.T.,,,,.F.,))

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
Carrega os arquivos "CSV" de Pedidos de Compra do diretório 
***************/
STATIC FUNCTION MSTECK10A(aBrowse)
LOCAL i := 0
LOCAL _aDir := {}
LOCAL _cDir := "C:\TEMP\PEDIDO_COMPRA\"
LOCAL clLinha		:= ""
LOCAL nlCont		:= 0
LOCAL cArqImp   := ""

_aDir := Directory("C:\TEMP\PEDIDO_COMPRA\*.CSV")
nlCont := LEN(_aDir)
PROCREGUA(nlCont)

FOR i := 1 TO LEN(_aDir)

	nQtdPed++
  cArqImp := _cDir+_aDir[i,1]
	FT_FUSE(cArqImp)
	FT_FGOTOP()
	INCPROC("Carregando informações...."+ALLTRIM(STR(nQtdPed))+" / "+ALLTRIM(STR(nlCont)))
	clLinha := FT_FREADLN()
	aVetAux := {}
	aVetAux := Separa(clLinha,";",.T.)
	AADD(aBrowse,{.T.,aVetAux[2],aVetAux[3],aVetAux[5],aVetAux[6],POSICIONE("SA2",1,XFILIAL("SA2")+aVetAux[5]+aVetAux[6],"A2_NOME"),_aDir[i,1]})
	FT_FUSE()

NEXT i 

IF LEN(aBrowse) = 0
	AADD(aBrowse,{.F.,"","","","","",""})
ENDIF

cQtdPed := STRZERO(nQtdPed,5)
RETURN aBrowse

/*************************
Importar os pedidos de compras selecionados
*************************/
STATIC FUNCTION MSTECK10B()
LOCAL lRet := .F.

//// Verifica se existe pelo menos um item do vetor com um número de pedido
IF !EMPTY(aBrowse[1,2])
	IF MSGYESNO("Deseja <<< IMPORTAR >>>  os Pedidos de Compra?", "Atenção")
		PROCESSA({ || MSTECK10C()}, "Aguarde", "Importando Pedidos de Compras...")
		lRet := .T.
	ENDIF
ENDIF
RETURN lRet

/*************************
Gera os arquivos para os pedidos de compras selecionados
*************************/
STATIC FUNCTION MSTECK10C()
LOCAL i := 0 
LOCAL nPed := 0
LOCAL nHdl := 0
LOCAL cPath := "C:\TEMP\PEDIDO_COMPRA\"
LOCAL cPathOK := "C:\TEMP\PEDIDO_COMPRA\PEDIDOS_IMPORTADOS\"
LOCAL cPathER := "C:\TEMP\PEDIDO_COMPRA\PEDIDOS_COM_ERRO\"
LOCAL nCount := 0 
LOCAL nItemSC7 := 0
LOCAL aVetAux := {}
LOCAL cNumPed := ""
LOCAL cArqImp := "" 
LOCAL cErro := ""
LOCAL clLinha := ""
LOCAL aAuxItem := {}
LOCAL nErro := 0


PROCREGUA(nQtdPed)

//// Troca o Usuário para utilizar um que não seja obrigatório a Solicitação de Compra
__cUserId := "001070"

//// Zera os contadores de Arquivos Processados e Nào processados
nContEr := 0
nContOK := 0

FOR nPed := 1 TO LEN(aBrowse)

	IF aBrowse[nPed,1] =.T.
		
		nCount++
		INCPROC("Gravando Pedido de Compra...."+ALLTRIM(STR(nCount))+" / "+ALLTRIM(STR(nQtdPed)))

    cArqImp := ALLTRIM(aBrowse[nPed,7])
    FT_FUSE(cPath+cArqImp)
    FT_FGOTOP()

    aVetor := {}
    WHILE !FT_FEOF()

      clLinha := FT_FREADLN()
      aVetAux := {}
      aVetAux := Separa(clLinha,";",.T.)
      IF aVetAux[1] = "CABECALHO"
        nItemSC7 := 0
        //// Começa pelo segundo item do vetor para ignorar o "CABECALHO"
        FOR i := 2 TO LEN(aSX3CAB)
          IF !EMPTY(aVetAux[i])
            //// Inclui o Novo número do pedido de Compra
            IF aSX3CAB[i] = "C7_NUM"
              cNumPed := aVetAux[i]
              AADD(aCabSC7,{aSX3CAB[i],"",NIL})
            ELSEIF aSX3CAB[i] = "C7_USER"
              AADD(aCabSC7,{aSX3CAB[i],__cUserId,NIL})
            ELSE
              //// Verifica se o campo é DATA
              IF TAMSX3(aSX3CAB[i])[3] = "D"
                AADD(aCabSC7,{aSX3CAB[i],CTOD(aVetAux[i]),NIL})
              //// Verifica se o campo é NUMÉRICO
              ELSEIF TAMSX3(aSX3CAB[i])[3] = "N"
                aVetAux[i] := MSTECK10D(aVetAux[i])
                AADD(aCabSC7,{aSX3CAB[i],aVetAux[i],NIL})
              ELSE
                AADD(aCabSC7,{aSX3CAB[i],aVetAux[i],NIL})
              ENDIF
            ENDIF
          ENDIF
        NEXT

      ELSEIF aVetAux[1] = "ITEM"

        aAuxItem := {}
        //// Começa pelo segundo item do vetor para ignorar o "ITEM"
        nItemSC7++  
        FOR i := 2 TO LEN(aSX3ITEM)
          IF !EMPTY(aVetAux[i])
            IF aSX3ITEM[i] = "C7_USER"
              AADD(aAuxItem,{aSX3ITEM[i],__cUserId,NIL})
            ELSEIF aSX3ITEM[i] = "C7_ITEM"
              AADD(aAuxItem,{aSX3ITEM[i],STRZERO(nItemSC7,4),NIL})
            ELSE
              //// Verifica se o campo é DATA
              IF TAMSX3(aSX3ITEM[i])[3] = "D"
                AADD(aAuxItem,{aSX3ITEM[i],CTOD(aVetAux[i]),NIL})
              //// Verifica se o campo é NUMÉRICO
              ELSEIF TAMSX3(aSX3ITEM[i])[3] = "N"
                aVetAux[i] := MSTECK10D(aVetAux[i])
                AADD(aAuxItem,{aSX3ITEM[i],aVetAux[i],NIL})
              ELSE
                AADD(aAuxItem,{aSX3ITEM[i],aVetAux[i],NIL})
              ENDIF
            ENDIF
          ENDIF
        NEXT

        /*******************
        No Item o campo C5_XIMPEXP que controla se o pedido foi importado.
        Imoforma o Número do Item e o Pedido
        *******************/
        AADD(aAuxItem,{"C7_XIMPEXP",aVetAux[2]+"/"+cNumPed,NIL})

        AADD(aItemSC7,aAuxiTem)
      ENDIF

      FT_FSKIP()
    ENDDO
    FT_FUSE()


    IF LEN(aCabSC7) > 0 .AND. LEN(aItemSC7) > 0 

      lMsErroAuto		:= .F.
      lAutoErrNoFile	:= .T.
                    
      MSExecAuto({|a,b,c,d| MATA120(a,b,c,d)},1,aCabSC7,aItemSC7,3)
      
      IF lMsErroAuto = .T.
        aLogAuto := {}
        aLogAuto := GetAutoGRLog()
        IF LEN(aLogAuto) > 0 
          SC7->(RollbackSx8())
          cErro := ""
          FOR i := 1 TO LEN(aLogAuto)
            cErro += ALLTRIM(aLogAuto[i])+CHR(13)+CHR(10)
          NEXT
          nContEr++
          IF ExistDir("C:\TEMP\PEDIDO_COMPRA\PEDIDOS_COM_ERRO\") = .F.
            MakeDir("C:\TEMP\PEDIDO_COMPRA\PEDIDOS_COM_ERRO\")
          ENDIF

          nHdl := FCreate(Upper(cPathER+SUBSTR(cArqImp,1,(LEN(cArqImp)-4))+".TXT" ))
          FWrite(nHdl,cErro)
          FClose(nHdl)
          ///nErro := WaitRun("MOVE "+cPath+cArqImp+" "+cPathER+cArqImp+" /y ")
          nErro := frename(cPath+cArqImp,cPathER+cArqImp)
        ENDIF
      ELSE
        SC7->(ConfirmSX8())
        nContOK++
        IF ExistDir("C:\TEMP\PEDIDO_COMPRA\PEDIDOS_IMPORTADOS\") = .F.
          MakeDir("C:\TEMP\PEDIDO_COMPRA\PEDIDOS_IMPORTADOS\")
        ENDIF
        nErro := frename(cPath+cArqImp,cPathOK+cArqImp)

        //// Reciclando a variável
        cNumPed := ""
        cNumPed := SC7->C7_NUM

        /***********************************
        Forço a Gravação do Campo C7_XIMPEXP pois o ExecAuto não está alimentando este campo.
        Este campo será utilizado para identificar na empresa que foi importado o pedido
        o Item original e o Pedido original
        ***********************************/
        FOR i := 1 TO LEN(aItemSC7)
          SC7->(DBSETORDER(1))
          IF SC7->(DBSEEK(XFILIAL("SC7")+cNumPed+aItemSC7[i,1,2]))
            RECLOCK("SC7",.F.)
            SC7->C7_XIMPEXP := aItemSC7[i,aScan(aItemSC7[i], {|x| ALLTRIM(x[1]) == "C7_XIMPEXP"}),2]
            SC7->(MSUNLOCK())
          ENDIF
        NEXT i
      ENDIF
    ENDIF
	ENDIF
NEXT nPed

MSGINFO("Arquivos Processados: "+STRZERO(nContOK+nContER,5)+CHR(10)+CHR(13)+;
        "Com SUCESSO : "+STRZERO(nContOK,5)+CHR(10)+CHR(13)+;
        "Com ERRO : "+STRZERO(nContER,5)+CHR(10)+CHR(13),"Fim do processamento")

//// Retorna o código do usuário original
 __cUserId := cOldUser  

RETURN 

/*************************
Rotina para Alterar campos Numéricos trocando a casa Decimal de "." para ","
Estou efetuando esta troca pois os arquivos que serão gerados de forma manual
pelos usuários estarão com a casa Decimal com ",".
Assim o fonte de importação não terá problema na hora de converter o valor de texto para numérico.
************************/
STATIC FUNCTION MSTECK10D(xcValor)
LOCAL _cValor := ""
LOCAL _nValor := 0
LOCAL nZ := 0 
FOR nZ := 1 TO LEN(xcValor)
  IF SUBSTR(xcValor,nZ,1) = "."
    LOOP
  ELSEIF SUBSTR(xcValor,nZ,1) = ","
    _cValor += "."
  ELSE
    _cValor += SUBSTR(xcValor,nZ,1)
  ENDIF
NEXT
_nValor := VAL(_cValor)

RETURN _nValor
