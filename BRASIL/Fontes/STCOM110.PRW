#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STCOM110        | Autor | RENATO.OLIVEIRA           | Data | 08/01/2019  |
|=====================================================================================|
|Descrição | Validação de motivo de compra                                            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM110(_cMotivo)

	Local _lRet := .T.

	//	Adicionado para chamada Faturamento Beneficiamento - Valdemir Rabelo 26/07/2019
	if IsInCallStack( "U_STGerPC" )
		Return .T.
	ENDIF	

	If AllTrim(_cMotivo) $ GetMv("ST_MOTCOM1",,"APU#ATV#CND#CNM#CNP#COT#CPA#CPM#DEV#IND#MDA#MUD#PGM#RED#REV#TRO") .And.;
	!__cUserId $ GetMv("ST_USRCOM",,"000010")
		_lRet := .F.
		MsgAlert("Somente o Departamento de Compras tem permissão para realizar compras com este(s) motivo(s) de compra(s).")
	EndIf

Return(_lRet)