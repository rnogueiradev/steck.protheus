/****************************************
Ação.........: Alimentar os Itens do Pedido de comrpa através de uma planilha em CSV
Regras.......: Para que a rotina funcione corretamente o usuário deverá estar posicionado no DbGrid.
.............: Se não estiver podicionado a rotina irá apresentar problemas.
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 07/12/2021
Chamados.....: 20211203025901
****************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TBICODE.ch"

USER FUNCTION MSTECK06()
PRIVATE aVetor := {}
PRIVATE lRet := .F.
PRIVATE _nPosProd	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C7_PRODUTO"  })
PRIVATE _nPosQtd	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C7_QUANT"    })
PRIVATE _nPosPrc	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "C7_PRECO"    })
PRIVATE oArqImp
PRIVATE cArqImp := SPACE(100)
PRIVATE oBtArq
PRIVATE oBtOk
PRIVATE oBtSair
STATIC oDlg

IF EMPTY(cA120Forn) .OR. EMPTY(cCondicao)
  MSGALERT("Preencha o cabeçalho do pedido antes de importar!")
  RETURN
ENDIF


	DEFINE MSDIALOG oDlg TITLE "Importação de Itens do pedido" FROM 000, 000  TO 210, 370 PIXEL
  @ 020, 015 SAY "Selecione o arquivo:" SIZE 083, 007 OF oDlg PIXEL
 	@ 040, 005 MSGET oArqImp VAR cArqImp SIZE 173, 010 OF oDlg PIXEL WHEN .F.
	@ 060, 005 BUTTON oBtArq  PROMPT "Arquivo"   SIZE 040, 015 OF oDlg ACTION(FARQEX()) PIXEL
	@ 060, 073 BUTTON oBtOk   PROMPT "Confirmar" SIZE 040, 015 OF oDlg ACTION(IIF(EMPTY(cArqImp),MsgAlert("Selecione um arquivo!","Atenção"),(MSTECK6A(),oDlg:End()))) PIXEL
	@ 060, 137 BUTTON oBtSair PROMPT "Sair"      SIZE 040, 015 OF oDlg ACTION(oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

RETURN

STATIC FUNCTION MSTECK6A()

	PROCESSA({|| MSTECK6B()}, "Aguarde a importação...","Aguarde!",.F.)

RETURN()

STATIC FUNCTION MSTECK6B()
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
      IF TRIM(aHeader[nY][2]) == "C7_ITEM"
        aCols[Len(aCols)][nY] :=  STRZERO(i,4)
      ELSEIF Trim(aHeader[nY][2]) == "C7_ALI_WT"
        aCols[Len(aCols)][nY] 	:=  "SC7"
      ELSEIF Trim(aHeader[nY][2]) == "C7_REC_WT"
        aCols[Len(aCols)][nY] 	:= 0
      ELSEIF ( aHeader[nY][10] != "V")
        aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
      ENDIF
      aCols[Len(aCols)][Len(aHeader)+1] := .F.
    NEXT nY

    //// Produto
    aCols[i,_nPosProd] := aVetor[i,1]
    M->C7_PRODUTO := aVetor[i,1]
    __readvar := "M->C7_PRODUTO" 
    CheckSX3("C7_PRODUTO",aCols[i,_nPosProd])

    //// Verifica se existe gatilho para o campo
    IF ExistTrigger("C7_PRODUTO") 
      //// Executa o gatilho 
      RunTrigger(2,i,nil,,"C7_PRODUTO")
    ENDIF

    //// Quantidade
    aCols[i,_nPosQtd] := MSTECK6C(aVetor[i,2])
    M->C7_QUANT := aCols[i,_nPosQtd]
    __readvar := "M->C7_QUANT" 
    CheckSX3("C7_QUANT",aCols[i,_nPosQtd])
      
    //// Verifica se existe gatilho para o campo
    IF ExistTrigger("C7_QUANT") 
      //// Executa o gatilho 
      RunTrigger(2,i,nil,,"C7_QUANT")
    ENDIF

    //// Preco
    aCols[i,_nPosPrc] := MSTECK6C(aVetor[i,3])
    M->C7_PRECO := aCols[i,_nPosPrc]
    __readvar := "M->C7_PRECO" 
    CheckSX3("C7_PRECO",aCols[i,_nPosPrc])
      
    //// Verifica se existe gatilho para o campo
    IF ExistTrigger("C7_PRECO") 
      //// Executa o gatilho 
      RunTrigger(2,i,nil,,"C7_PRECO")
    ENDIF
    
    EVAL(bGDRefresh)
    lRet := A120LinOk()
    IF lRet = .F. 
      MSGALERT("Erro na linha")
    ENDIF
  NEXT

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
STATIC FUNCTION MSTECK6C(xcValor)
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
