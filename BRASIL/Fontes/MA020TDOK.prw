#INCLUDE "PROTHEUS.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
#Include "MsOle.ch"

/*/{Protheus.doc} MA020TDOK

PE chamado na inclusao ou alteracao de fornecedores

@type 		function
@author 	Jose C. FrassonEverson Santana
@since 		21/08/2020
@version	Protheus 12 - Faturamento

@history , ,

/*/

User Function MA020TDOK()
	Local aAreaSA2 	:= SA2->(GetArea())
	Local _cQuery1 	:= ""
    Local lAuto     := .F.

    //FR - 17/10/2022 - TRATATIVA QDO A CHAMADA VIER DA ROTINA AUTOMÁTICA STBPO001
    If IsInCallStack("U_STBPO001")
        lAuto  := .T.       
    Endif 
    //FR - 17/10/2022 - TRATATIVA QDO A CHAMADA VIER DA ROTINA AUTOMÁTICA STBPO001
    If !lAuto
        If !IsInCallStack("U_STIMP040")
            If u_STCOM100("SA2","A2_FORMPAG")
                If ALTERA
                    If MsgYesNo("Atualiza a Forma de Pagamento dos Títulos em aberto deste Fornecedor ?")
                        _cQuery1 := " UPDATE " + RetSqlName("SE2") + " SE2"
                        _cQuery1 += " SET E2_FORMPAG = '" + M->A2_FORMPAG + "'"
                        _cQuery1 += " WHERE SE2.D_E_L_E_T_= ' '"
                        _cQuery1 += " AND E2_SALDO > 0"
                        _cQuery1 += " AND E2_FORNECE = '" + SA2->A2_COD + "'"
                        TcSqlExec(_cQuery1)

                        MsgAlert("Fim do Processamento...")
                    Endif
                Endif
            EndIf
        EndIf
    Endif 
    //FR - 17/10/2022 - TRATATIVA QDO A CHAMADA VIER DA ROTINA AUTOMÁTICA STBPO001

	RestArea(aAreaSA2)
Return
