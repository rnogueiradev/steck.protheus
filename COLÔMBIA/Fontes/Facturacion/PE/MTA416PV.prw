/*/{Protheus.doc} MTA416PV
El punto de entrada permite alterar los valores de las variables aHeader y aCols.
El punto de entrada MTA416PV recibe como parÃ¡metro el nÃºmero lÃ­nea del presupuesto de venta (Len(aCols)).
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@return return_type, return_description
/*/
User Function MTA416PV()
    Local nAux     := PARAMIXB
    Local nCC      := Ascan( _aHeader, { |x| Alltrim( x[2] ) == 'C6_CC' } )
    Local nCCUS    := Ascan( _aHeader, { |x| Alltrim( x[2] ) == 'C6_CCUSTO' } )
    Local nXDESC   := Ascan( _aHeader, { |x| Alltrim( x[2] ) == 'C6_XDESCUE' } )
    //Local cCCNac   := SuperGetMV("ST_CCVENA" ,.T., "114102" ) // Centro costo Ventas
    Local nORC     := Ascan( _aHeader, { |x| Alltrim( x[2] ) == 'C6_NUMORC' } )
    //Local nITEM    := Ascan( _aHeader, { |x| Alltrim( x[2] ) == 'C6_ITEM' } )
    Local cCCPres  := ""
    Local nCCLeng  := Tamsx3("C6_CC")[1]

    Local cCfEquiv := SuperGetMV("ST_CODFISC",.T., "{{ '601' , '601SB' }, { '101' , '101SB' }}" )
    //Local cTSEqB2B := SuperGetMV("ST_TESB2B" ,.T., "{{ '501' , '650' }  , { '   ' , '650' }}" )
    //Local cTSEqEXP := SuperGetMV("ST_TESEXP" ,.T., "{{ '501' , '650' }  , { '   ' , '650' }}" )
    //Local cTSEqOBS := SuperGetMV("ST_TESOBS" ,.T., "{{ '501' , '652' }  , { '   ' , '652' }}" )
    //Local cBodgEXP := SuperGetMV("ST_BODGEX" ,.T., "01" )
    //Local cBodgNAC := SuperGetMV("ST_BODGNC" ,.T., "03" )
    Local aCfEquiv := &(" "+cCfEquiv+" ")
    Local nPosCF   := aScan( _aHeader, { |x| AllTrim( x[2] ) == 'C6_CF' } )
    Local nX:=0

    IF SCJ->CJ_XTPED $ 'BxE'   //B=Back to Back;N=Venta Nacional;E=Venta de Exportacion;O=Obsequio 
        cCCPres:= LEFT(SuperGetMV("ST_COLCCB2" ,.T., "114105" ) + SPACE(nCCLeng),nCCLeng)
    ELSEIF SCJ->CJ_XTPED=='N'
        cCCPres:= LEFT(SuperGetMV("ST_COLCCNA" ,.T., "114102" ) + SPACE(nCCLeng),nCCLeng)
    ELSEIF SCJ->CJ_XTPED=='O'
        cCCPres:= LEFT(SuperGetMV("ST_COLCCOB" ,.T., "114104" ) + SPACE(nCCLeng),nCCLeng)
    ELSE
        cCCPres := SPACE(nCCLeng)
    ENDIF

    M->C5_XDTORDC := SCJ->CJ_XDTORDC
    M->C5_TPACTIV := POSICIONE("SA1",1,XFILIAL("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_ATIVIDA")
    M->C5_TPFRETE := SCJ->CJ_TPFRETE
    M->C5_XORDEM  := SCJ->CJ_XORPC
    M->C5_XTPED   := SCJ->CJ_XTPED
    M->C5_NATUREZ := SCJ->CJ_XNATURE
    M->C5_XCODINC := __cUserID
    M->C5_XNOMINC := cUserName
	M->C5_XNOME   := POSICIONE("SA1",1,XFILIAL("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME")
	M->C5_XORPC   := SCJ->CJ_XORPC
    M->C5_XDOC    := SCJ->CJ_XDOC
    M->C5_XSERIE  := SCJ->CJ_XSERIE
    M->C5_XFORNEC := SCJ->CJ_XFORNEC
    M->C5_XLOJA   := SCJ->CJ_XLOJA
    M->C5_INCOTER := SCJ->CJ_XINCOTE
    M->C5_XDESCUE := SCJ->CJ_XDESCUE
    M->C5_UUIDREL := IF(!EMPTY(ALLTRIM(SCJ->CJ_XORPC)),"ORDC/"+ALLTRIM(SCJ->CJ_XORPC)+"/"+IF(EMPTY(SCJ->CJ_XDTORDC),U_STDTOSS(dDataBase),U_STDTOSS(SCJ->CJ_XDTORDC))," ") 
    
    If SA3->(DbSeek(xFilial("SA3")+__cUserId))
        SC5->C5_VEND1 	:= SA3->A3_COD
    EndIf

    
    IF !EMPTY(M->C5_XTPED) .and. !EMPTY(cCCPres)
        _aCols[nAux][nCC] := cCCPres 
        if nCCUS>0
            _aCols[nAux][nCCUS] := cCCPres
        EndIf 
    EndIf


    IF SA1->A1_XFULLRT=='2' // Full Retenciones sin base y cambia el Codigo Fiscal
        /*
        Removido por solicitação da Jaqueline devido a mudanças nas regras - Valdemir Rabelo 27/06/2023
        FOR nX:=1 to Len(aCfEquiv)
            cCFa:=aCfEquiv[nX][1]
            cCFb:=_aCols[nAux][nPosCF]
            IF ALLTRIM(aCfEquiv[nX][1])==ALLTRIM(_aCols[nAux][nPosCF]) .AND. !EMPTY(ALLTRIM(aCfEquiv[nX][2]))
                _aCols[nAux][nPosCF]:= LEFT(ALLTRIM(aCfEquiv[nX][2])+SPACE(5),5)
                Exit
            EndIf
        NEXT
        */
    EndIf


    TMP1->(dbGoTop())
    While !TMP1->(EOF())
        if RIGHT(_aCols[nAux][norc],2)==TMP1->CK_ITEM
            _aCols[nAux][nXDESC] := TMP1->CK_XDESCUE
            EXIT
        EndIf
        TMP1->(DbSkip())
    ENDDO
    
    Reclock("SCJ",.F.)
		SCJ->CJ_XNUMSC5 := M->C5_NUM
	MsUnlock()

Return Nil
