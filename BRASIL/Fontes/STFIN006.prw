#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Define CR chr(13)+ chr(10)

/*/{Protheus.doc} STFIN006

Inicializador Padrão do Campo E2_XAPROV

@type function
@author Everson Santana
@since 06/03/19
@version Protheus 12 - Financeiro

@history ,Chamado 006559 ,

/*/

User Function STFIN006()

	Local _cQry := ""
	Local _cRet := ""
	Local _FinAprov := GetMv('ST_FINAPRO',,.f.) //Parametro para bloquear a rotina de aprovação de Titulos
    //---------------------------------------------------------------------------------------------------------------------//
    //FR -27/10/2022 - PARA ATENDER A ROTINA BPO DA FOLHA U_STBPO001 , já por default trazer o usuário aprovação que será 
    //usado na query abaixo, porque qdo a rotina é chamada via job, o __cUserID VEM VAZIO
    //---------------------------------------------------------------------------------------------------------------------//
    Local cUserApv  := GetNewPar("ST_GPEUSR" , "001466/001542")  
	
    If Empty(__cUserId)
        __cUserId := cUserApv
    Endif 
    //FR - 27/10/2022 - Flávia Rocha - Sigamat Consultoria

    If _FinAprov

        If Select("TRD") > 0
            TRD->(DbCloseArea())
        Endif

        _cQry := " "
        _cQry += " SELECT Z41.Z41_APRO FROM "+RetSqlName("Z42")+" Z42 "
        _cQry += " LEFT JOIN "+RetSqlName("Z41")+" Z41 "
        _cQry += " ON Z42.Z42_COD = Z41.Z41_COD "
        _cQry += " AND Z41.D_E_L_E_T_ = ' ' "
        _cQry += " WHERE Z42.Z42_USER = '"+__cUserId+"' "
        _cQry += " AND Z42.D_E_L_E_T_ = ' ' "

        TcQuery _cQry New Alias "TRD"

        _cRet := TRD->Z41_APRO

        //FR - 27/10/2022 - se a query não trouxer resultado, assume o usuário do parâmetro ST_GPEUSR
        If Empty(_cRet)
            _cRet := cUserApv
        Endif 
        //FR - 27/10/2022 - Flávia Rocha - Sigamat Consultoria

	EndIf

Return(_cRet)
