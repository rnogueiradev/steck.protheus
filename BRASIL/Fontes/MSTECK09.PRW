/****************************************
Ação.........: Gerar Pedidos de Venda a partir de arquivo CSV gerados pela rotina MSTECK07
.............: Estes pedidos de venda gerados serão importados para dentro da empresa 11.
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 15/12/2021
Chamados.....: 20211214026690
****************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TBICODE.ch"
#INCLUDE "FWMVCDEF.CH"


USER FUNCTION MSTECK09()
PRIVATE aVetor := {}
PRIVATE lRet := .F.
PRIVATE oArqImp
PRIVATE cArqImp := SPACE(100)
PRIVATE oBtArq
PRIVATE oBtOk
PRIVATE oBtSair
PRIVATE lMsErroAuto 	 := .F.
PRIVATE lAutoErrNoFile := .T.
STATIC oDlg

DEFINE MSDIALOG oDlg TITLE "Importação de Pedido de Venda" FROM 000, 000  TO 210, 370 PIXEL
@ 020, 015 SAY "Selecione o arquivo:" SIZE 083, 007 OF oDlg PIXEL
@ 040, 005 MSGET oArqImp VAR cArqImp SIZE 173, 010 OF oDlg PIXEL WHEN .F.
@ 060, 005 BUTTON oBtArq  PROMPT "Arquivo"   SIZE 040, 015 OF oDlg ACTION(FARQEX()) PIXEL
@ 060, 073 BUTTON oBtOk   PROMPT "Confirmar" SIZE 040, 015 OF oDlg ACTION(IIF(EMPTY(cArqImp),MsgAlert("Selecione um arquivo!","Atenção"),(MSTECK9A(),oDlg:End()))) PIXEL
@ 060, 137 BUTTON oBtSair PROMPT "Sair"      SIZE 040, 015 OF oDlg ACTION(oDlg:End()) PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

RETURN

STATIC FUNCTION MSTECK9A()

	PROCESSA({|| MSTECK9B()}, "Aguarde a importação...","Aguarde!",.F.)

RETURN()

STATIC FUNCTION MSTECK9B()
LOCAL i := 0 
LOCAL cErro := ""
LOCAL nlCont := 0
LOCAL clLinha := ""
LOCAL aVetAux := {}
LOCAL aSX3SC5 := {}
LOCAL aSX3SC6 := {}
LOCAL aCabSC5 := {}
LOCAL aItemSC6 := {}
LOCAL aAuxItem := {}
LOCAL nlTotLin := 0
LOCAL _cCliente := ""
LOCAL _cLoja    := ""
LOCAL _cCondPag := ""
LOCAL _cTipoCli := ""
LOCAL _cZConsum := ""
LOCAL _nVAlUnit := 0
LOCAL _nQtdVen  := 0 
LOCAL _nValor   := 0 

/******************************
Carrega no vetor todos os campos da tabela SC5 
Despresando os campos virtuais
******************************/
AADD(aSX3SC5,"CABECALHO"  )  // 
AADD(aSX3SC5,"C5_TIPO"    )
AADD(aSX3SC5,"C5_TIPOCLI" )
AADD(aSX3SC5,"C5_CLIENTE" )
AADD(aSX3SC5,"C5_LOJACLI" )
AADD(aSX3SC5,"C5_CLIENT"	)
AADD(aSX3SC5,"C5_LOJAENT" )
AADD(aSX3SC5,"C5_EMISSAO" )
AADD(aSX3SC5,"C5_CONDPAG" )
AADD(aSX3SC5,"C5_ZCONDPG" )
AADD(aSX3SC5,"C5_TPFRETE" ) 
AADD(aSX3SC5,"C5_XTIPO"   ) 
AADD(aSX3SC5,"C5_XTIPF"   ) 
AADD(aSX3SC5,"C5_ZCONSUM" ) 
//AADD(aSX3SC5,"C5_ESTPRES" )
//AADD(aSX3SC5,"C5_MUNPRES" )

/******************************
Carrega no vetor todos os campos obrigatórios da tabela SC6 
Despresando os campos virtuais
******************************/
AADD(aSX3SC6,"ITEM"		    )
AADD(aSX3SC6,"C6_ITEM"	  )
AADD(aSX3SC6,"C6_PRODUTO" )
AADD(aSX3SC6,"C6_OPER"	  )
AADD(aSX3SC6,"C6_TES"		  )
AADD(aSX3SC6,"C6_QTDVEN"  )
AADD(aSX3SC6,"C6_PRCVEN"  )
AADD(aSX3SC6,"C6_PRUNIT"  )
AADD(aSX3SC6,"C6_VALOR"	  )
AADD(aSX3SC6,"C6_LOCAL"	  )
//AADD(aSX3SC6,"C6_CF"			)
//AADD(aSX3SC6,"C6_XALTDT"	)
//AADD(aSX3SC6,"C6_CHASSI"	)
AADD(aSX3SC6,"C6_NUMPCOM" )
AADD(aSX3SC6,"C6_ITEMPC"	)
AADD(aSX3SC6,"C6_XORDEM"	)


FT_FUSE(cArqImp)
FT_FGOTOP()

nlTotLin := FT_FLASTREC()
PROCREGUA( nlTotLin+1 )
FT_FGOTOP()

aVetor := {}
WHILE !FT_FEOF()

  nlCont++
  IncProc("Carregando Informações..."+Alltrim(Str(nlTotLin))+"/"+Alltrim(Str(nlCont))+" - "+ Alltrim(Str((nlCont/nlTotLin)*100,3))+"%")

	clLinha := FT_FREADLN()
	aVetAux := {}
	aVetAux := Separa(clLinha,";",.T.)
  IF aVetAux[1] = "CABECALHO"

    _cCliente := ""
    _cLoja    := ""
    _cCondPag := ""
    _cTipoCli := ""
    _cZConsum := ""

    //// Começa pelo segundo item do vetor para ignorar o "CABECALHO"
    FOR i := 2 TO LEN(aSX3SC5)

      IF aSX3SC5[i] = "C5_CLIENTE"
        _cCliente := aVetAux[i]
      ELSEIF aSX3SC5[i] = "C5_LOJACLI"
        _cLoja := aVetAux[i]
      ELSEIF aSX3SC5[i] = "C5_CONDPAG"
        _cCondPag := aVetAux[i]
      ELSEIF aSX3SC5[i] = "C5_TIPOCLI"
        _cTipoCli := aVetAux[i]
      ELSEIF aSX3SC5[i] = "C5_ZCONSUM"
        _cZConsum := aVetAux[i]
      ENDIF

      //// Verifica se o campo é DATA
      IF TAMSX3(aSX3SC5[i])[3] = "D"
        //AADD(aCabSC5,{aSX3SC5[i],CTOD(aVetAux[i]),NIL})
        AADD(aCabSC5,{aSX3SC5[i],DATE(),NIL})
      //// Verifica se o campo é NUMÉRICO
      ELSEIF TAMSX3(aSX3SC5[i])[3] = "N"
        aVetAux[i] := MSTECK9C(aVetAux[i])
        AADD(aCabSC5,{aSX3SC5[i],aVetAux[i],NIL})
      ELSE
        AADD(aCabSC5,{aSX3SC5[i],aVetAux[i],NIL})
      ENDIF
    NEXT

    /*******************
    Inclui no cabecalho o campo C5_ESPECI4 que controla se o pedido foi:
    "I" - Importado via rotina APOEMA
    "E" - Exportado via rotina APOEMA
    *******************/
    AADD(aCabSC5,{"C5_ESPECI4","I",NIL})

  ELSEIF aVetAux[1] = "ITEM"

  
    aAuxItem := {}
    //// Começa pelo segundo item do vetor para ignorar o "ITEM"
    FOR i := 2 TO LEN(aSX3SC6)

      IF aSX3SC6[i] = "C6_QTDVEN"
        aVetAux[i] := MSTECK9C(aVetAux[i])
        _nQtdVen   := aVetAux[i]
        AADD(aAuxItem,{aSX3SC6[i],_nQtdVen,NIL})
      ELSEIF aSX3SC6[i] = "C6_PRUNIT"
        aVetAux[i]  := MSTECK9C(aVetAux[i])
        _nVAlUnit  := aVetAux[i]
        AADD(aAuxItem,{aSX3SC6[i],aVetAux[i],NIL})
      ELSEIF aSX3SC6[i] = "C6_VALOR"
        _nVAlor := _nVAlUnit * _nQtdVen
        //_nVAlor  := MSTECK9C((_nVAlor))
        AADD(aAuxItem,{aSX3SC6[i],_nVAlor,NIL})
      ELSE
        //// Verifica se o campo é DATA
        IF TAMSX3(aSX3SC6[i])[3] = "D"
          AADD(aAuxItem,{aSX3SC6[i],CTOD(aVetAux[i]),NIL})
        //// Verifica se o campo é NUMÉRICO
        ELSEIF TAMSX3(aSX3SC6[i])[3] = "N"
          aVetAux[i] := MSTECK9C(aVetAux[i])
          AADD(aAuxItem,{aSX3SC6[i],aVetAux[i],NIL})
        ELSE
          IF aSX3SC6[i] = "C6_PRODUTO"
            _cProduto := aVetAux[i]
            AADD(aAuxItem,{aSX3SC6[i],aVetAux[i],NIL})
          ELSEIF aSX3SC6[i] = "C6_TES"
            _cTesPad := U_STRETSST('01',_cCliente,_cLoja,_cProduto,_cCondPag,'TES',.T.,_cTipoCli,_cZConsum)
            AADD(aAuxItem,{aSX3SC6[i],_cTesPad,NIL})
          ELSE
            AADD(aAuxItem,{aSX3SC6[i],aVetAux[i],NIL})
          ENDIF
        ENDIF
      ENDIF
    NEXT
    AADD(aItemSC6,aAuxiTem)
  ENDIF

	FT_FSKIP()
ENDDO
FT_FUSE()


IF LEN(aCabSC5) > 0 .AND. LEN(aItemSC6) > 0 

  lMsErroAuto		:= .F.
  lAutoErrNoFile	:= .T.
                
  MATA410(aCabSC5,aItemSC6,3)
  IF lMsErroAuto = .T.
    aLogAuto := GetAutoGRLog()
    IF LEN(aLogAuto) > 0 
      cErro := ""
      FOR i := 1 TO LEN(aLogAuto)
        cErro += ALLTRIM(aLogAuto[i])+CHR(10)+CHR(13)
      NEXT
      AVISO("Erro na geração do Pedido de Venda", cErro, {"Fechar"}, 3, "Erro na geração do Pedido de Venda",,,.T. )
    ENDIF
  ELSE
    MSGALERT("Pedido de venda gerado com sucesso: "+SC5->C5_NUM)
  ENDIF
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
STATIC FUNCTION MSTECK9C(xcValor)
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

