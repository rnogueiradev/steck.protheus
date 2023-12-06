#include "rwmake.ch"

User Function GatVen(_campo,_Vend)
	Local _Comis := 0
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := 'Novo chamado ERP'
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''

	IF !( M->C5_TIPO $ "DB")

		IF alltrim(_campo) $ "VEND1/VEND2"
	
	////// Regra 1 - O vendedor principal sempre será o que estiver no cadastro do cliente, ou seja, será o vendedor tipo R-REPRESENTANTE
	////// e o segundo vendedor sempre será o que estiver digitando o pedido de venda, ou seja, o usuário que estiver logado no sistema o
	////// vendedor tipo I - INTERNO. Caso o segundo vendedor for igual a tipo R-REPRESENTANTE, desconsiderar, porém se o código do vendedor
	////// for diferente deverá ser considerado. Caso o segundo vendedor for igual a tipo E-EXTERNO, desconsiderar.
	//////      R - Representante ' pagamento através do financeiro (Contas a Pagar) 100% no pagamento do titulo
	//////      E - Externos ' pago na Folha 100% na emissão da NF
	//////      I - Internos ' pago na Folha 100% na emissão da NF
	
	///// VARIAVEIS
			_TPVEND1 := ""
			_cVend1  := ""
			_TPVEND2 := ""
			_cVend2  := ""
	
			IF  !EMPTY(M->C5_VEND1)
		
				Dbselectarea("SA3")
				Dbsetorder(1)
				Dbseek(xFilial("SA3")+M->C5_VEND1)
				_TPVEND1 := SA3->A3_TPVEND
		
				IF     _TPVEND1 == "R"
					_CVEND1 := "Representante"
				ELSEIF _TPVEND1 == "E"
					_CVEND1 := "Externo"
				ELSEIF _TPVEND1 == "I"
					_CVEND1 := "Interno"
				ENDIF
			ENDIF
	
			IF !EMPTY(M->C5_VEND2)
				Dbselectarea("SA3")
				Dbsetorder(1)
				Dbseek(xFilial("SA3")+M->C5_VEND2)
				_TPVEND2 := SA3->A3_TPVEND
				IF     _TPVEND2 == "R"
					_CVEND2 := "Representante"
				ELSEIF _TPVEND2 == "E"
					_CVEND2 := "Externo"
				ELSEIF _TPVEND2 == "I"
					_CVEND2 := "Interno"
				ENDIF
		
			ENDIF
	
			IF    _Campo == "VEND1"
		
				_Retorno := M->C5_VEND1
		
				IF !(_TPVEND1 $  "R/E")
					MsgYesNo("Vendedor 1 devera ser sempre Representante, como o que esta sendo colocado é "+_CVEND1+" Vendedor 1 sera cancelado","Atencao")
					_Retorno := ""
			
				ENDIF
		
			elseif _Campo == "VEND2"
		
				_Retorno := M->C5_VEND2
		
				IF M->C5_VEND1 == M->C5_VEND2
					MsgYesNo("Vendedor 2 Cod. "+_vend+ " Nao podera ser igual ao Vendedor 1, O Vendedor 2 sera cancelado","Atencao")
					_Retorno := ""
///		ELSEIF _TPVEND2 == "E"
///			MsgYesNo("Vendedor 2 cod: "+_vend+" Nao podera ser Externo, O Vendedor 2 sera cancelado","Atencao")
///			_Retorno := ""
				ENDIF
		
			ENDIF
	
	//////// Regra 2 - Não poderá ter dois vendedores no pedido do tipo E-EXTERNO e I-INTERNO.
	
			IF (_TPVEND1 $ "E/R" .AND. _TPVEND2 $ "E/R")   //// .OR. (_TPVEND1 == "I" .AND. _TPVEND2 $  "E/R")
		
				Alert("Não poderá ter dois vendedores no pedido do tipo E-EXTERNO e R-Representante, o vendedor 1 é "+_Cvend1+" o vendedor 2 é "+_cVEND2,"Atencao")
		
				_Retorno := ""
		
			ENDIF
	
			RETURN(_Retorno)
	
		ELSEIF alltrim(_campo) == "PROD"
	
			_nCod     := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})]
	
			_Comis := Posicione("SA1",1,xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_COMIS")
	
			IF !EMPTY(_Comis)
		
				Return(_Comis)   /////////   Retorna Comissao do cadastro de clientes
		
			endif
	
			_Comis := Posicione("SZ2",1,xFilial("SZ2") + _VEND + _nCod ,"Z2_COMIS")
	
			IF !EMPTY(_Comis)
		
				Return(_Comis)   /////////   Retorna Comissao do cadastro de clientes
		
			endif
	
			_Grupo  := Posicione("SB1",1,xFilial("SB1") +  _nCod ,"B1_GRUPO")
			_Comis  := Posicione("SZ3",1,xFilial("SZ3")  +  _VEND + _Grupo ,"Z3_COMIS")
	
			IF !EMPTY(_Comis)
		
				Return(_Comis)   /////////   Retorna Comissao do cadastro de clientes
		
			endif
	
			_Comis := Posicione("SA3",1,xFilial("SA3") + _VEND ,"A3_COMIS")
	
			IF !EMPTY(_Comis)
		
				Return(_Comis)   /////////   Retorna Comissao do cadastro de clientes
		
			endif
	 
	/*
	_cEmail	  := GetMv("ST_MAILVEN")
	_cAssunto := 'Wfprotheus - Comissão não encontrada'
	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<b>Produto: </b>'+M->C6_PRODUTO+'<br><b>Cliente: </b>'+M->C5_CLIENTE+'<br>'
	cMsg += '<b>Loja: </b>'+M->C5_LOJACLI+'<br><b>Vendedor 1: </b>'+M->C5_VEND1+'<br>'
	cMsg += '<b>Vendedor 2: </b>'+M->C5_VEND2+'<br>'
	cMsg += '</body></html>'
	
	//Alert("Nao foi encontrado comissao para esse item","Atencao") - Retirado - Solicitação Vanderlei Souto - 30/06/2014 - Chamado 000657
	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

    */
			Return(0)
	
		ENDIF
	Endif

Return(0)//Chamado 001583
