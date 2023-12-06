/****************************************
Ação.........: Alimentar os Itens do Pedido de Vendas através de uma planilha em CSV
.............: Incluída na rotina A410Cons
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 09/12/2021
Chamados.....: 20211203025898
****************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TBICODE.ch"

USER FUNCTION MSTECK05()
PRIVATE aVetor := {}
PRIVATE lRet := .F.
PRIVATE _nPosProd	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_PRODUTO"  })
PRIVATE _nPosOper	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_OPER"     })
PRIVATE _nPosQtd	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_QTDVEN"   })
PRIVATE _nPosDesc	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_DESCRI"   })
PRIVATE _nPosArm	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_LOCAL"    })
PRIVATE _nPosUM	  := aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_UM"       })
PRIVATE _nPosPrc	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_PRCVEN"   })
PRIVATE _nPosUni	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_PRUNIT"   })
PRIVATE _nPosTot  := aScan(aHeader, {|x| ALLTRIM(x[2]) == "C6_VALOR"    })
PRIVATE oArqImp
PRIVATE cArqImp := SPACE(100)
PRIVATE oBtArq
PRIVATE oBtOk
PRIVATE oBtSair
STATIC oDlg

IF EMPTY(M->C5_NUM) .OR. EMPTY(M->C5_ZCONDPG) .OR. EMPTY(M->C5_XTIPF)
  MSGALERT("Preencha o cabeçalho do pedido antes de importar!")
  RETURN
ENDIF


	DEFINE MSDIALOG oDlg TITLE "Importação de Itens do pedido" FROM 000, 000  TO 210, 370 PIXEL
  @ 020, 015 SAY "Selecione o arquivo:" SIZE 083, 007 OF oDlg PIXEL
 	@ 040, 005 MSGET oArqImp VAR cArqImp SIZE 173, 010 OF oDlg PIXEL WHEN .F.
	@ 060, 005 BUTTON oBtArq  PROMPT "Arquivo"   SIZE 040, 015 OF oDlg ACTION(FARQEX()) PIXEL
	@ 060, 073 BUTTON oBtOk   PROMPT "Confirmar" SIZE 040, 015 OF oDlg ACTION(IIF(EMPTY(cArqImp),MsgAlert("Selecione um arquivo!","Atenção"),(MSTECK5A(),oDlg:End()))) PIXEL
	@ 060, 137 BUTTON oBtSair PROMPT "Sair"      SIZE 040, 015 OF oDlg ACTION(oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

RETURN

STATIC FUNCTION MSTECK5A()

	PROCESSA({|| MSTECK5B()}, "Aguarde a importação...","Aguarde!",.F.)

RETURN()

STATIC FUNCTION MSTECK5B()
LOCAL clLinha		:= ""
LOCAL nlCont		:= 0
LOCAL nlTotLin	:= 0
LOCAL nY := 0
LOCAL i := 0 

FT_FUSE(cArqImp)
FT_FGOTOP()

nlTotLin := FT_FLASTREC()
PROCREGUA( nlTotLin+1 )
FT_FGOTOP()

aVetor := {}
WHILE !FT_FEOF()

	clLinha := FT_FREADLN()
	aVetAux := {}
	aVetAux := Separa(clLinha,";",.T.)
	AADD(aVetor,aVetAux)
	nlCont++
	IncProc("Carregando Informações..."+Alltrim(Str(nlTotLin))+"/"+Alltrim(Str(nlCont))+" - "+ Alltrim(Str((nlCont/nlTotLin)*100,3))+"%")

	FT_FSKIP()

ENDDO

FT_FUSE()

IF LEN(aVetor) > 0 

  aCols := {}

  FOR i := 1 TO LEN(aVetor)
    
    n := i
    
    AADD(aCols,Array(LEN(aHeader)+1))
    FOR nY := 1 TO LEN(aHeader)
      IF TRIM(aHeader[nY][2]) == "C6_ITEM"
        aCols[Len(aCols)][nY] :=  STRZERO(i,2)
      ELSEIF Trim(aHeader[nY][2]) == "C6_ALI_WT"
        aCols[Len(aCols)][nY] 	:=  "SC6"
      ELSEIF Trim(aHeader[nY][2]) == "C6_REC_WT"
        aCols[Len(aCols)][nY] 	:= 0
      ELSEIF ( aHeader[nY][10] != "V")
        aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
      ENDIF
      aCols[Len(aCols)][Len(aHeader)+1] := .F.
    NEXT nY

    //// Produto
    SB1->(DBSETORDER(1))
    SB1->(DBSEEK(XFILIAL("SB1")+PADR(aVetor[i,1],TamSX3("C6_PRODUTO")[1]) ))
    aCols[i,_nPosDesc] := SB1->B1_DESC
    aCols[i,_nPosArm]  := SB1->B1_LOCPAD
    aCols[i,_nPosUM]   := SB1->B1_UM

    aCols[i,_nPosProd] := PADR(aVetor[i,1],TamSX3("C6_PRODUTO")[1])
    M->C6_PRODUTO := PADR(aVetor[i,1],TamSX3("C6_PRODUTO")[1])
    __readvar := "M->C6_PRODUTO" 
    CheckSX3("C6_PRODUTO",aCols[i,_nPosProd])

    //// Verifica se existe gatilho para o campo
    IF ExistTrigger("C6_PRODUTO") 
      //// Executa o gatilho 
      RunTrigger(2,i,nil,,"C6_PRODUTO")
    ENDIF

    //// Tipo de Operação
    aCols[i,_nPosOper] := aVetor[i,2]
    M->C6_OPER := aCols[i,_nPosOper]
    __readvar := "M->C6_OPER" 
    CheckSX3("C6_OPER",aCols[i,_nPosOper])
      
    //// Verifica se existe gatilho para o campo
    IF ExistTrigger("C6_OPER") 
      //// Executa o gatilho 
      RunTrigger(2,i,nil,,"C6_OPER")
    ENDIF

    //// Quantidade
    aCols[i,_nPosQtd] := MSTECK5C(aVetor[i,3])
    M->C7_PRECO := aCols[i,_nPosQtd]
    __readvar := "M->C6_QTDVEN" 
    CheckSX3("C6_QTDVEN",aCols[i,_nPosQtd])
      
    //// Verifica se existe gatilho para o campo
    IF ExistTrigger("C6_QTDVEN") 
    //  //// Executa o gatilho 
      RunTrigger(2,i,nil,,"C6_QTDVEN")
    ENDIF
    
    //// Atualiza o Preço de Venda e Total
    aCols[i,_nPosPrc] := MSTECK5C(aVetor[i,4])
    aCols[i,_nPosUni] := MSTECK5C(aVetor[i,4])
    aCols[i,_nPosTot] := aCols[i,_nPosPrc] * aCols[i,_nPosQtd]

    //A410LinOk(oGetDad)
    //oGetDad:oBrowse:Refresh()
    //EVAL(bGDRefresh)
    //lRet := A410LinOk()
    //IF lRet = .F. 
    //  MSGALERT("Erro na linha")
    //ENDIF
    oGetDad:Refresh()

  NEXT

    //SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
    //oGetDad:Refresh()
    //GETDREFRESH()
ENDIF

RETURN

STATIC FUNCTION FARQEX()
	LOCAL clFile	:= ""
	clFile := TRIM(	cGetFile(	"Arquivos CSV (*.csv) |*.csv|","Selecione Diretorio e Arquivo", 0, "C:\" , .T., 49))
	cArqImp := clFile
	oArqImp:Refresh()
RETURN()

/*************************
Rotina para corrigir a Quantidade e Preço Unitário
Esta rotina retira o ponto da casa de Milhar/Centena  e a virgula da casa Decimal e substitui por ponto
************************/
STATIC FUNCTION MSTECK5C(xcValor)
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
