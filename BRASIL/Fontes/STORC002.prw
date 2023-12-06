#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} STORC002
description
Trata chamada da consulta customizada
chamado: 20200806005285
@type function
@version 
@author Valdemir Jose
@since 26/08/2020
@return return_type, return_description
/*/
USER FUNCTION STORC002()
	Local aAreaF3 := GetArea()
	Local cQry    := ""
	Local nRetCol := 1			// Coluna que fará o retorno
	Local cAlias  := "PE4"
	Local aCampos := { {"Código",    "Descricao"},;
                       {"PE4_CODIGO","PE4_DESCRI"} }
    Private nGetIDROM := 0                       

	cQry := "SELECT PE4_CODIGO, PE4_DESCRI, R_E_C_N_O_ REG      " + CRLF
	cQry += "FROM " + RETSQLNAME('PE4') + " PAI 				" + CRLF
	cQry += "WHERE PAI.D_E_L_E_T_ = ' '							" + CRLF
	cQry += "ORDER BY PE4_CODIGO 	    						" + CRLF
	U_BUSCAF3(cAlias, aCampos, '', '', cQry, nRetCol)

	RestArea( aAreaF3 )

RETURN .T.


/*/{Protheus.doc} STGTLPE4
description
Rotina utilizada no Gatilho do campo CK_CODPE4
chamado: 20200806005285
@type function
@version 
@author Valdemir Jose
@since 26/08/2020
@return return_type, return_description
/*/
USER FUNCTION STGTLPE4()
    Local aAreaPE4 := GetArea()
    Local dRET     := dDatabase

    dbSelectArea('PE4')
    dbSetOrder(1)
    IF dbSeek(xFilial('PE4')+M->CJ_CODPE4)
       if PE4->PE4_AVALIA=="S"
          dRET := GetSG1Prz()
       else 
          dRET := dDATABASE+PE4->PE4_PRAZO2
       endif       
    Else 
       FWMsgRun(,{|| Sleep(4000)},"Atenção!","Código não encontrado (PE4-Prazo de Orçamentos)")
    Endif

    // Atualiza Grid do Orçamento
    RecLock("TMP1") 
    TMP1->CK_ENTREG := dRET
    MsUnlock()
    
    RestArea( aAreaPE4 )

RETURN .T.

/*/{Protheus.doc} GetSG1Prz
description
Verifica se os componentes do produto pai tem saldo.
chamado: 20200806005285
@type function
@version 
@author Valdemir Jose
@since 26/08/2020
@return return_type, return_description
/*/
Static Function GetSG1Prz()
    Local dRET := ctod('04/08/2021')
    Local aAreaSG1 := GetArea()
    Local lEstoque := .F.
    Local nSaldo   := 0

    dbSelectArea("SB1")
    dbSetOrder(1)

    dbSelectArea("SB2")
    dbSetOrder(1)

    dbSelectArea("SG1")
    dbSetOrder(1)
    dbSeek(xFilial("SG1")+TMP1->CK_PRODUTO)
    While SG1->( !Eof() ) .and. (SG1->G1_COD==TMP1->CK_PRODUTO)
        cCod := SG1->G1_COMP
        SB1->( dbSeek(xFilial('SB1')+cCod) )
        SB2->( dbSeek(xFilial('SB2')+cCod+SB1->B1_LOCPAD) )
        nSaldo   := SaldoSB2()
        lEstoque := (nSaldo > TMP1->CK_QTDVEN)
        if !lEstoque
           Exit
        Endif 

        SG1->( dbSkip() )
    EndDo

    if lEstoque
        dRET := dDATABASE+PE4->PE4_PRAZO1
    else 
        dRET := dDATABASE+PE4->PE4_PRAZO2
    endif 

    RestArea( aAreaSG1 )

Return dRET

/*/{Protheus.doc} STORC00A
description
Valida código de Entrega
chamado: 20200806005285
@type function
@version 
@author Valdemir Jose
@since 28/08/2020
@param pCodigo, param_type, param_description
@return return_type, return_description

/*/
User Function STORC00A(pCodigo)
    Local lRET := .T.
    Local aArea:= GetArea()

    dbSelectArea("PE4")
    dbSetOrder(1)

    if !Empty(pCodigo)
        lRET := dbSeek(XFilial("PE4")+pCodigo)

        if !lRET 
        FWMsgRun(,{|| sleep(4000)},'Atenção!',"Código de Entrega Invalido.")
        Endif 
    Endif 

    RestArea( aArea )

Return lRET


