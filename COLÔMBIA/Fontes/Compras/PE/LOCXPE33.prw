#Include 'TOTVS.ch'
/*
// Programa  LOCXPE33  Autor  Microsiga           Fecha   09/02/2020
// Desc.     Carga campos personalizados en encabezado de documentos
//              de entrada y salida.
// ===================================================================================== //
// 1	NF	Nota fiscal de Vendas	Cliente	Faturamento
// 2	NDC	Nota de débito cliente	Cliente	Faturamento
// 3	NCE	Nota de crédito externa	Cliente	Faturamento
// 4	NCC	Nota de crédito cliente	Cliente	Faturamento
// 5	NDE	Nota de débito externa	Cliente	Faturamento
// 6	NDI	Nota de débito interna	Fornecedor	Compras
// 7	NCP	Nota de crédito fornecedor	Fornecedor	Compras
// 8	NCI	Nota de crédito Interna	Fornecedor	Compras
// 9	NDP	Nota de débito fornecedor	Fornecedor	Compras
// 10	NF	Nota Fiscal de compras	Fornecedor	Compras
// 11	NF	Nota fiscal de Beneficiamento	Fornecedor	Faturamento
// 12	NF	Nota fiscal de Beneficiamento	Cliente	Compras
// 13	NF	Nota Fiscal de despesas de importación	Fornecedor	Compras
// 14	NF	Nota Fiscal de frete	Fornecedor	Compras
// 15	REC	Recibo	Fornecedor	Compras
// 50	RFN	Remito faturamento normal	Cliente	Faturamento
// 51	RFD	Remito faturamento Devolución (Documento propio)	Cliente	Faturamento
// 52	RFB	Remito faturamento Beneficiamento	Fornecedor	Faturamento
// 53	RFD	Remito faturamento Devolución (Documento no propio)	Cliente	Faturamento
// 54	RTS	Envio de remito de transferencia	Fornecedor	Estoques
// 60	RCN	Remito compras normal	Fornecedor	Compras
// 61	RCD	Remito compras Devolución	Fornecedor	Compras
// 62	RCB	Remito compras Beneficiamento	Cliente	Compras
// 63	RET	Retorno SimbÃ³lico (consignación)	Cliente	Faturamento
// 64	RTE	Recebemento de remito de transferencia	Fornecedor	Estoques
// ===================================================================================== //
*/
User Function LocxPE33()
	Local aArea 	:= GetArea()
	Local aCposNF	:= ParamIxb[1]
	Local nTipo		:= ParamIxb[2]
	Local aDetalles := {}
	Local nNuevoElem:= 0
	Local nPosCpo	:= 0
	Local nL		:= 0
	//Local aCposNCC	:= {}  
	/*
	Local aCampos:= PARAMIXB[1]
	Local nTipo  := ParamIxb[2]
	*/
	Public _Grat1z_:= '1'  // Variable para controlar Factura Manual de productos Gratis
	
	If nTipo == 1  //Nota fiscal ventas o Remsion Manual
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F2_TIPOPE" 	, .T.      ,.F.      ,.F.   }) // De Facturacion eletrÃ³nica
		AADD(aDetalles,{"F2_TABELA" 	, .T.      ,.F.      ,.T.   }) // 
		AADD(aDetalles,{"F2_DTENTR" 	, .T.      ,.T.      ,.F.   }) // 
		AADD(adetalles,{"F2_XNOME"	, .T.	   ,.F.		 ,.T.  	})
		AADD(aDetalles,{"F2_UUIDREL" 	, .T.      ,.F.      ,.T.   }) // Desabilita Campo Memo Orden de Compra
		AADD(aDetalles,{"F2_XORDCOM" 	, .T.      ,.F.      ,.F.   }) // Orden de Compra
		AADD(aDetalles,{"F2_XFORCOM" 	, .T.      ,.F.      ,.F.   }) // Fecha Orden de Compra
		AADD(aDetalles,{"F2_CLIENT" 	, .T.      ,.F.      ,.F.   }) // Desabilita Campo Memo Orden de Compra
		AADD(aDetalles,{"F2_LOJENT" 	, .T.      ,.F.      ,.F.   }) // Orden de Compra
		AADD(aDetalles,{"F2_XENDENT" 	, .T.      ,.F.      ,.F.   }) // Fecha Orden de Compra
	Endif

	If nTipo == 50        //Remision de Salida Manual
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F2_TIPOPE" 	, .T.      ,.F.      ,.F.   }) // De Facturacion eletrÃ³nica
		AADD(aDetalles,{"F2_UUIDREL" 	, .T.      ,.F.      ,.T.   }) // Desabilita Campo Memo Orden de Compra
		AADD(aDetalles,{"F2_XORDCOM" 	, .T.      ,.F.      ,.F.   }) // Orden de Compra
		AADD(aDetalles,{"F2_XFORCOM" 	, .T.      ,.F.      ,.F.   }) // Fecha Orden de Compra
	Endif


	If nTipo == 4          //Nota crédito Cliente  
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		aadd(aDetalles, {"F1_XFORNEC", .T.		, .F.		, .T.})
		aadd(aDetalles, {"F1_XLOJA"  , .T.		, .F.		, .T.})
		//aadd(aDetalles, {"F1_XDOC"   , .T.		, .F.		, .T.}) //Campo desabilitado conforme solicitação da Leidy 27/09/2022
		aadd(aDetalles, {"F1_XSERIE" , .T.		, .F.		, .T.})
		aadd(aDetalles, {"F1_XTPED"  , .T.		, .F.		, .T.})
		aadd(aDetalles, {"F1_XDOCEXT", .T.		, .F.		, .F.}) //Incluido por Renato Santos dia 27/09/22
		aadd(aDetalles, {"F1_SOPORT" , .T.		, .F.		, .F.}) //Incluido por Renato Santos dia 27/09/22
				
	Endif

	If nTipo == 10        //Factura de compra
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(adetalles,{"F1_XOBS"	, .T.	   ,.T.		 	,.F.  	})
        //AADD(adetalles,{"F1_XDOC"	, .T.	   ,.F.		 	,.T.  	}) //Campo desabilitado conforme solicitação da Leidy 27/09/2022
		aadd(aDetalles,{"F1_XDOCEXT", .T.	   ,.F.		    ,.F.    }) //Incluido por Renato Santos dia 27/09/22
		AADD(adetalles,{"F1_SOPORT"	, .T.	   ,.F.		 	,.F.  	}) //Incluido por Renato Santos dia 27/09/22
	Endif

	If nTipo == 9        //Nota debito proveedor
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(adetalles,{"F1_XOBS"	, .T.	   ,.T.			 ,.F.  	})
	Endif

	If nTipo == 60        //Remito compras normal	Fornecedor	Compras
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(adetalles,{"F1_XOBS"	, .T.	   ,.T.			 ,.F.  	})
	Endif

	If nTipo == 7        //Nota credito proveedor
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		//AADD(adetalles,{"F2_XOBS"	, .T.	   ,.T.		 ,.F.  	})
	Endif


	If nTipo == 22        // Nota Credito
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(adetalles,{"F2_XOBS"	, .T.	   ,.T.			 ,.F.  	})
	Endif

	If nTipo == 23        // Nota Debito
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(adetalles,{"F1_XOBS"	, .T.	   ,.T.			 ,.F.  	})
	Endif

	//------------------------------------------------------------------
	// No cambiar dentro del Loop For...Next, llamar AC/Localizaciones 
	//------------------------------------------------------------------

	For nL := 1 To Len(aDetalles)
		If (nPosCpo := Ascan(aCposNF,{|x| x[2] == aDetalles[nL][1] })) > 0
			aCposNF[nPosCpo][13] := aDetalles[nL][3] 				   // Obligatorio
			If Len(aCposNF[nPosCpo]) == 16
				SX3->(DbSetOrder(2))
				SX3->(DbSeek(AllTrim(aDetalles[nL][1])))

				aCposNF[nPosCpo] := { X3Titulo(),X3_CAMPO,,,,,,X3_TIPO,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.") }

			EndIf
			aCposNF[nPosCpo][17] := If(aDetalles[nL][4],".F.",".T.")   // Desabilita el campo
			If !aDetalles[nL][2]
				ADel(aCposNF,nPosCpo) 								   // Quita el campo
				ASize(aCposNF,Len(aCposNF)-1)                          // Ajusta Array
			EndIf
		Else
			DbSelectArea("SX3")
			DbSetOrder(2)
			If DbSeek( aDetalles[nL][1] )
				nNuevoElem := Len(aCposNF)+1
				aCposNF := aSize(aCposNF,nNuevoElem)
				aIns(aCposNF,nNuevoElem)
				
				aCposNF[nNuevoElem] := { X3Titulo(),X3_CAMPO,,,,,,X3_TIPO,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.") }

			EndIf
		EndIf

	Next nL
	RestArea(aArea)

Return( aCposNF )

//Return(aCampos)

/*/
--------------------------------------
Numeración de Pontos de entrada :
--------------------------------------

[01] - No inicio da rotina da tela que cria a EnchoiceBar
[02] - Antes de comeÃ§ar a montagem da tela, aCols e aHeader
[03] - Apos o Ponto de entrada anterior
[04] - No inicio da Rotina de Gravación
[05] - Apos gravación do Livro Fiscal
[06] - Permite alterar o valor da duplicata
[07] - Integración com o Celerina, depois de gravar a Nota fiscal
[08]       - Apos gravación do arquivo de cabeÃ§alho da Nota e todas as atualizaÃ§Ãµes referentes a este arquivo
[09]       - Apos gravación do arquivo de cabeÃ§alho da Nota e antes das atualizaÃ§Ãµes referentes a este arquivo
[10] - Apos atualizaÃ§Ãµes do arquivo SB2
[11] - Apos a gravación da Nota Fiscal fora da transación
[12] - Na atualización do arquivo SC9
[13] - Retorna a quantidade da segunda unidade de medida
[14] - Apos a gravación do SD1 e todas as atualizaÃ§Ãµes referentes a este arquivo
[15] - Apos a gravación do SD1 
[16] - Apos as validaÃ§Ãµes da rotina TudOk
[17] - Apos as validaÃ§Ãµes de cada item (LinOk)
[18] - Apos a gravación do arquivo financeiro
[19] - Tecla F4 - Pedidos de Compra em Aberto
[20] - Permite alterar a condición de pagamento
[21] - Altera os vencimentos da duplicata
[22] - Deixa alterar a data inicial da condición de pagamento
[23] - Alteración do numero e prefixos do arquivo financeiro
[24] - Apos confirmar o numero da Nota Fiscal
[25] - Apos a geración das comissÃµes
[26] - Na deleción de notas fiscais de saÃ­da
[27] - Na deleción de notas fiscais de saÃ­da
[28] - Antes de deletar um item do SD1
[29] - Antes de deletar o SF1
[30] - Antes de definir os campos que devem ser gravados obrigatoriamente para o correto funcionamento das rotinas. 
[31] -  Na validación do campo de documento, usado para definir serie e numero do documento sendo digitado
[32] - Quando se usa a numeración automÃ¡tica pelo sistema, este ponto é chamado para filtrar as series que estarÃ£o disponÃ­veis.
[33] - Antes de chamar a función que monta a tela, para incluir/tirar campos do cabeÃ§alho.
[34] - Antes de chamar a función que monta a tela para selecionar os remitos de entrada que serÃ£o amarrados
[35] - Quando carregando os dados de cada remito de entrada selecionado no aCols.
[36] - Quando valida o vendedor
[37] - Antes de comeÃ§ar a gravar os dados financeiros (SE1/SE2)
[38] - Depois de gravar os dados financeiros (SE1/SE2)
 
[43] - Pto de Entrada para manipular Array contendo os objetos que devem ser criados na tela com seus devidos comando de criación      Factura de entrada al presionar la tecla F5. Se encuentra dentro de la funciÃ³n A103ForF4 de la rutina LOCXNF2
[44] - Manipulación dos Campos de Faturas Originais
[48] - Pto de Entrada para manipular Array contendo os objetos que devem ser criados na tela com seus devidos comando de criacao
[49] - Ponto de Entrada LocxPE49 na Función SCMToREM - Seleción de remitos para Nota Fiscal de entrada - botÃ£o REMITO / opción Remito. O Ponto de Entrada permite a customización do filtro para a tela de seleción de remitos. O filtro deve ser construÃ­do para o cabeÃ§alho da nota de entrada, utilizando o alias informado no parÃ¢metro ParamIXB[1].
[50] -
[54] -
[55] -
[59] - Ponto de Entrada executado na LocxNf na función: GravaItensNF. SerÃ¡ sempre executado durante a gravación de cada item e antes do MsUnlock para destravar os registros. Ao entrar no Ponto de Entrada, é recomendado que seja efetuado o teste na variÃ¡vel aCfgNf[1] a fim de testar o tipo de operación que estÃ¡ sendo executada.
[61] - Na función principal LOCXNF() - ResponsÃ¡vel pela inicialización da rotina e carregamento do browse correspondente a función selecionada (Fatura de entrada, Remito, Nota de Crédito/Débito, etc.).
 
LOCXVLDDEL - //PE - Permite validar exclusao do documento //"Confirma estorno do documento ?"###"Atenâ€¡â€žo"
 
-----------------------------
Ejemplos de uso:
-----------------------------
 
//LocxPE(4) 
User Function LocxPE04()    
ALERT("PE: LocxPE(04)")
Return .T.
 
//LocxPE(72)
User Function LocxPE72()    
ALERT("PE: LocxPE(72)")
Return .T.
