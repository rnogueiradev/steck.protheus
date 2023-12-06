#include "Protheus.ch"

/*/{Protheus.doc} M461LSF2
description
Ponto de Entrada Após Gravação dos Dados Documento Saida
Ticket: 20210329005029
@type function
@version  
@author Valdemir Jose
@since 06/05/2021
@return return_type, return_description
/*/
User Function M461LSF2

	// Ticket: 20210211002338 - Valdemir Rabelo 10/05/2021
	SD2->( dbSetOrder(3) )
	SD2->( dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
	While SD2->( !EOF() ) .AND. SD2->( D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)==xFilial("SD2")+SF2->(F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		if ZS3->( dbSeek(xFilial("ZS3")+SD2->D2_PEDIDO) )
			RecLock("ZS3", .f. )
			ZS3->ZS3_NOTAFI := SF2->F2_DOC
			MsUnlock()
		endif
		SD2->( dbSkip() )
	ENDDO

	if SF2->( FIELDPOS("F2_XSTATFT") ) > 0
		RecLock("SF2",.F.)
		if (!FWIsInCallStack("u_STFATJOB")) .AND. (!FWIsInCallStack("U_STFATJOC"))
			SF2->F2_XSTATFT := "MAN"
		elseif FWIsInCallStack("u_STFATJOB") .or. FWIsInCallStack("U_STFATJOC")    // Valdemir Rabelo Ticket: 20210615010129
			SF2->F2_XSTATFT := "AUT"
		Endif
		MsUnlock()
	Endif

Return
