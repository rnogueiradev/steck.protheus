#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.ch"
#INCLUDE 'APVT100.CH'


/*/{Protheus.doc} OPCOLREQ
description
   GERAÇÃO DE REQUISIÇÃO POR COLETOR
@type function
@version 
@author Valdemir Jose
@since 20/07/2020
@return return_type, return_description
/*/
USER FUNCTION OPCOLREQ()
    LOCAL lRet      := .T.
    Local nLin      := 0
    LOCAL lNovo     := .T.

    Private nOpcao      := 0
    Private nCP_QUANT   := 0
    Private cCP_PRODUTO := space(100)
    Private cCP_DESCRI  := space(40)
    Private cCP_UM      := space(2)
    Private _cLocPad    := "01"
    Private lContinua   := .T.    
    
    While .T.

        if !lNovo
           Exit
        endif     

        VTCLEAR()
        aTela := VTSave()
        @ nLin,0  VTSAY Padc("Solicitação de Requisição",VTMaxCol())
        nLin += 1
        WHILE lContinua
            cCP_PRODUTO := space(100)            
            VTCLEAR

            @ nLin,0  VTSAY "Leia Codigo Barra: "
            nLin += 1
            @ nLin,0 VTGET cCP_PRODUTO PICT "@!" VALID VldProd()
            nLin += 1
            VTREAD

            If VTLASTKEY()==27
                If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
                    lNovo := .F.
                    Exit
                Endif
				VTClear()
				VTRestore(,,,,aTela)                
            Endif

            if Empty(cCP_PRODUTO) 
                lNovo := .F.
                exit
            endif             

            @ nLin,0  VTSAY "Produto: " + cCP_PRODUTO
            nLin += 1
            @ nLin,0  VTSAY "Descricao: " + cCP_DESCRI
            nLin += 1
            @ nLin,0  VTSAY "Quantidade: " VTGET nCP_QUANT PICT "@E 99999" 
            nLin += 1

            VTREAD
            If VTLASTKEY()==27
                If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
                    lNovo := .F.
                    Exit
                Endif
				VTClear()
				VTRestore(,,,,aTela)                
            Endif
            
            if nCP_QUANT > 0
                Exit
            endif 
            nLin := 1
        ENDDO 

        if lNovo
            if (nCP_QUANT > 0) .and. (!Empty(cCP_PRODUTO) )
                VTMSG("Processando!")
                if OPGera105()
                    VTALERT("Registro gerado com sucesso!")
                else 
                    VTALERT("ocorreu um problema na geracao da requisicao")
                endif
            Endif
        Endif
        nLin := 0
		VTRestore(,,,,aTela)                

    EndDo

RETURN 



STATIC FUNCTION VldProd()
    Local cCodProd := ""

    //cCodBar	:=	U_STAVALET(AllTrim(cCP_PRODUTO)) //Rotina para avaliar etiqueta e ajustar para padrão de leitura do CBRETIEAN - Renato Nogueira - 01/12/2014

	//VTAlert(cCodBar,".:cCodBar:.",.T.,4000)
    if ("|" $ cCP_PRODUTO)
	    aRet    := CBRetEtiEan(cCP_PRODUTO)
        cCodBar := aRet[1]
        cCP_PRODUTO := cCodBar
    endif 

	If	Empty(cCP_PRODUTO)
		//MsgAlert("Etiqueta invalida","Aviso")
		VTAlert("Etiqueta invalida!",".:Aviso:.",.T.,4000)
		Return .F.
	EndIf
	
    dbSelectArea("PE3")
    dbSetOrder(1)      // Indice por produto
    IF dbSeek(xFilial('PE3')+cCP_PRODUTO)
        nCP_QUANT := PE3->PE3_QUANTI
        cCodProd  := PE3->PE3_PRODUT
    Else 
        dbSetOrder(2)   // Indice por Local
        IF dbSeek(xFilial('PE3')+cCP_PRODUTO)
            nCP_QUANT := PE3->PE3_QUANTI
            cCodProd  := PE3->PE3_PRODUT
        Else
            CBAlert("Local não cadastrado!",".:AVISO:.",.t.,2000,1)        
            Return .F.
        Endif
    ENDIF

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1")+ALLTRIM(PE3->PE3_PRODUTO)))
		CBAlert("Produto invalido!",".:AVISO:.",.t.,2000,1)
		Return .F.
	Endif
    cCP_DESCRI  := SB1->B1_DESC
    cCP_UM      := SB1->B1_UM
    _cLocPad    := SB1->B1_LOCPAD
    cCP_PRODUTO := ALLTRIM(cCodProd)
    DbSelectArea("SB1")
    
RETURN .T.




/*/{Protheus.doc} Gera105
description
   GERA REQUISIÇÕES VIA EXECAUTO
@type function
@version 
@author Valdemir Jose
@since 20/07/2020
@return return_type, return_description
/*/
STATIC FUNCTION OPGera105()
    Local _aCab  	:= {}
    Local _aItem 	:= {}
    Local _cIt   	:= "01"
    LOCAL _cLocPad  := ""
    LOCAL lRET      := .T.
    
    Begin Transaction

    Aadd(_aItem, {  {"CP_PRODUTO" 	,cCP_PRODUTO ,NIL},;
                    {"CP_ITEM"		,_cIt        ,NIL},;
                    {"CP_QUANT"		,nCP_QUANT	 ,NIL},;
                    {"CP_LOCAL" 	,_cLocPad	 ,NIL},;
                    {"CP_DESCRI"   	,cCP_DESCRI	 ,NIL},;
                    {"CP_UM" 	  	,cCP_UM		 ,NIL},;
                    {"CP_DATPRF"  	,ddatabase	 ,NIL}})

	_cNumSA := NextNumero("SCP",1,"CP_NUM",.T.)
	_aCab:= {{"CP_SOLICIT"	,Substr(cUsuario,7,15) ,NIL},;
             {"CP_EMISSAO"  ,ddatabase	,NIL},;
             {"CP_NUM"	    ,_cNumSA ,NIL}}

	lMsErroAuto := .F.
	MsgRun( "Gerando Solicitacao ao Almoxarifado...","Aguarde...", { || MSExecAuto({|x,y,z| mata105(x,y,z)},_aCab,_aItem,3)})

	If lMsErroAuto
        lRET      := .F.
		MostraErro()
	Endif 

    End Transaction 

    if lRET    // Valdemir Rabelo 06/11/2020
        dbSelectArea("SCP")
        dbSetOrder(1)
        dbSeek(xFilial("SCP")+_cNumSA)
        //While SCP->( !Eof() ) .and. (SCP->CP_NUM==_cNumSA)
          //StaticCall (OPETQ001, getMod3, SCP->CP_QUANT)
            U_getMod3(SCP->CP_QUANT)
        //    SCP->( dbSkip() )
        //EndDo
    Endif 

Return lRET
