#Include "Colors.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} User Function STPCPENC
    (long_description)
    Rotina que far� o encerramento parcial
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 16/10/2019
    @example
    (examples)
/*/
User Function STPCPENC()
    Local _cMsg    := ""
    Local _cOP     := SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
    Local _nSldEmp := 0
    Local aAreaEnc := GetArea()
    
    if SC2->C2_TPOP == "P" //Prevista
        _cMsg := "A��o n�o permitida para esta OP. Por favor, verifique."
    Elseif A650DefLeg(5)  //Enc.Parcialmente
        _cMsg := "OP j� est� encerrada parcialmente. Por favor, verifique."
    elseif A650DefLeg(6)  //Enc.Totalmente
        _cMsg := "OP j� est� encerrada. Por favor, verifique."
    //Elseif A650DefLeg(4)  //Ociosa     - Solicitado a remo��o 23/10/2019 - Valdemir
    //    _cMsg := "A��o n�o permitida para esta OP. Por favor, verifique."
    Elseif A650DefLeg(3)  //Iniciada
        _cMsg := "A��o n�o permitida para esta OP. Por favor, verifique."
    endif
    if !Empty(_cMsg)
       LjMsgRun(_cMsg,"Aten��o!!!", {|| sleep(4000)})
       Return
    Endif

    dbSelectArea("SD4")
    dbSetOrder(2)
    dbSeek(XFilial("SD4")+_cOP)
    SD4->( dbEVal( {|| _nSldEmp += D4_QUANT},,{|| !Eof() .and. D4_OP==_cOP})) 

    // Valido O Empenho desta OP
    if _nSldEmp > 0
       MsgInfo("Favor ajustar para realizar este processo.","Produto(s) Empenhado(s)")
       Return
    Endif

    RecLock("SC2",.F.)
    SC2->C2_DATRF   := dDatabase
    SC2->C2_XSTATSE := 'X'
    MsUnlock()

    RestArea( aAreaEnc )

Return