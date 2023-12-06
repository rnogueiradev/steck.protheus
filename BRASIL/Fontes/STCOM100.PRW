#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STCOM100        | Autor | RENATO.OLIVEIRA           | Data | 19/11/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM100(_cTabela,_cCampo)

	Local _lRet    		:= .F.
    Local lAuto         := .F.
	Default _cTabela	:= ""
	Default _cCampo 	:= ""

    Default __cUserId   := "000000"
    

	If Empty(_cCampo)
		_cCampo := PADR(StrTran(ReadVar(),"M->",""),10)
	Else
		_cCampo := PADR(_cCampo,10)
	EndIf

	_cTabela := PADR(_cTabela,10)
    If IsInCallStack("U_STBPO001")
        lAuto  := .T.
        _lRet  := .T.
    Endif 

    //FR - 17/10/2022 - TRATATIVA QDO A CHAMADA VIER DA ROTINA AUTOMÁTICA STBPO001
    If !lAuto
    
        DbSelectArea("Z20")
        Z20->(DbGoTop())
        Z20->(DbSetOrder(3)) //Z20_FILIAL+Z20_ROTINA+Z20_CAMPO+Z20_USER
        If !Z20->(DbSeek(xFilial("Z20")+_cTabela+_cCampo+PADR(UPPER(UsrRetName(__cUserId)),TamSx3("Z20_USER")[1])))
            _lRet := .F.
        Else
            If INCLUI .And. Z20->Z20_TIPO $ "I#T"
                _lRet := .T.
            ElseIf ALTERA .And. Z20->Z20_TIPO $ "A#T"
                _lRet := .T.
            Else
                _lRet := .F.
            EndIf
        EndIf
    Endif 

Return(_lRet)
