#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

/*/
função: M410FSQL
descrição: Ponto de entrada para filtrar os pedidos conforme o vendedor
Ticket: 20230822010660-BLOQUEIO DE ALTERACAO DE PEDIDO DE VENDA
/*/

User Function M410FSQL()

	Local cFiltro 	:= ""
	Local cUsrFull 	:= SuperGetMV("FS_FLPED", .F., "")
	Local cUsrAtu  	:= RetCodUsr()


	If !(cUsrAtu $ cUsrFull)
		dbselectarea("SA3")
		SA3->( dbsetorder(7) )
		if SA3->( dbseek( xFilial("SA3") + cUsrAtu ) )
			while SA3->(!eof()) .AND. SA3->A3_CODUSR == cUsrAtu
				if !empty(cFiltro)"
					cFiltro += ".OR."
				endif 
				cFiltro += "C5_VEND1 = '"+SA3->A3_COD+"'"
				//cFiltro := "C5_XUSRINC = '"+Alltrim(cUsrAtu)+"'"
				SA3->(Dbskip())
			enddo
		endif
		
	EndIf	

Return(cFiltro)
