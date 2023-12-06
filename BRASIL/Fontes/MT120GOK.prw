#Include "Protheus.ch"

/*/{Protheus.doc} MT120GOK
@description
Ponto de Entrada após gravação e antes da contabilização. 
Para Pedido de Compras e Autorização de Entrega
Ticket: 20210623010642
@type function
@version  1.00
@author Valdemir Jose
@since 29/06/2021
/*/
User Function MT120GOK()
	Local cPedido    :=  PARAMIXB[1] // Numero do Pedido
	Local lInclui    :=  PARAMIXB[2] // Inclusão
	Local lAltera    :=  PARAMIXB[3] // Alteração
	Local lExclusao  :=  PARAMIXB[4] // Exclusão
	Local cModulo    := if(nTipoPed==1,"PedCompra","AutorizacaoEntrega")
	Local lObrig     := getmv("ST_OBRGANX",.F.,.T.)
	Local lZera      := .F.
	Local cFiltro    := "C7_FILIAL=='"+XFILIAL("SC7")+" .AND. C7_NUM=='"+cPedido+"' "   // Ticket: 20210701011365-Valdemir Rabelo 22/07/2021

	if lInclui
		IF ISINCALLSTACK( 'MATA122' ) // Adicionado conforme Ticket: 20210707012005 - Valdemir Rabelo 08/07/2021
			FWMsgRun(,{|| sleep(3000)},'Aguarde','Por favor, anexar os documentos')
			U_STAnexoV('SC7', cMODULO, {'C7_FILIAL','C7_USER','NOUSER'},lObrig,SC7->C7_NUM)
		Endif
	endif

	// Ticket: 20210701011365 - Valdemir Rabelo 22/07/2021
	if IsInCallStack("MATA120")
		lZera := ((cEmpAnt=='03') .and. (SC7->C7_FORNECE=='005764')) .OR. ((cEmpAnt=='01') .and. (SC7->C7_FORNECE=='005866')) 
		SC7->( dbSetOrder(1) )
		if lZera .And. SC7->( dbSeek(xFilial("SC7")+cPedido) )    // Localiza e posiciona no 1º item
		   While SC7->( !EOF() .and. C7_NUM==cPedido)
		      RECLOCK("SC7",.F.)
		      SC7->C7_IPI     := 0
			  SC7->C7_VALIPI  := 0
			  SC7->C7_BASEIPI := 0
			  SC7->( MSUNLOCK() )
			  SC7->( dbSkip() )
		   EndDo 
		endif 
	endif 

Return
