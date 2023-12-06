#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} F240MARK

@type function
@author Everson Santana
@since 11/12/19
@version Protheus 12 - Financeiro

@history ,Ticket 20191125000013,

/*/

USER FUNCTION F240MARK() 

	Local aArea := GetArea()
	Local aRet := {}

	AADD(aRet,{"E2_OK"		,""," ",""})
	AADD(aRet,{"E2_FILIAL"	,"","Filial"		,PesqPict('SE2',"E2_FILIAL"		)})
	AADD(aRet,{"E2_PREFIXO"	,"","Prefixo"		,PesqPict('SE2',"E2_PREFIXO"	)})
	AADD(aRet,{"E2_NUM"		,"","No. Titulo"	,PesqPict('SE2',"E2_NUM"		)})
	AADD(aRet,{"E2_FORNECE"	,"","Fornecedor" 	,PesqPict('SE2',"E2_FORNECE"	)})
	AADD(aRet,{"E2_NOMFOR"	,"","Nome Fornece"	,PesqPict('SE2',"E2_NOMFOR"		)})
	AADD(aRet,{"E2_VENCTO"	,"","Vencimento"	,PesqPict('SE2',"E2_VENCTO"		)})
	AADD(aRet,{"E2_VENCREA"	,"","Vencto Real"	,PesqPict('SE2',"E2_VENCTO" 	)})
	AADD(aRet,{"E2_VALOR"	,"","Vlr.Titulo"	,PesqPict('SE2',"E2_VALOR"		)})
	AADD(aRet,{"E2_SALDO"	,"","Saldo"			,PesqPict('SE2',"E2_SALDO"		)})
	AADD(aRet,{"E2_FORMPAG"	,"","Forma Pagto."	,PesqPict('SE2',"E2_FORMPAG"	)})
	AADD(aRet,{"E2_FORBCO"	,"","Banco For."	,PesqPict('SE2',"E2_FORBCO"		)})
	AADD(aRet,{"E2_FORAGE"	,"","Agencia For."	,PesqPict('SE2',"E2_FORAGE"		)})
	AADD(aRet,{"E2_FORCTA"	,"","Conta For."	,PesqPict('SE2',"E2_FORCTA"		)})
	AADD(aRet,{"E2_FCTADV"	,"","DV Conta"		,PesqPict('SE2',"E2_FCTADV"		)})
	AADD(aRet,{"E2_TIPO"	,"","Tipo" 			,PesqPict('SE2',"E2_TIPO"		)})
	AADD(aRet,{"E2_PARCELA"	,"","Parcela"		,PesqPict('SE2',"E2_PARCELA"	)})
	AADD(aRet,{"E2_LOJA"	,"","Loja"			,PesqPict('SE2',"E2_LOJA"		)})
	AADD(aRet,{"E2_EMISSAO"	,"","DT Emissao" 	,PesqPict('SE2',"E2_EMISSAO"	)})
	AADD(aRet,{"E2_HIST"	,"","Historico"		,PesqPict('SE2',"E2_HIST"		)})
	AADD(aRet,{"E2_NATUREZ"	,"","Natureza"		,PesqPict('SE2',"E2_NATUREZ"	)})
	
	RestArea(aArea)
Return aRet