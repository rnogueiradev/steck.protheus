#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STEEC010        | Autor | RENATO.OLIVEIRA           | Data | 30/07/2018  |
|=====================================================================================|
|Descrição | RECEBE XML E INSERE PEDIDO DE EXPORTACAO                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEEC010(pcEmpPed, pcFilPed, paCabec, paItens)
	Local _cEmpresa	:= pcEmpPed
	Local _cFilial 	:= pcFilPed
	Local _aCabec	:= paCabec
	Local _aItens	:= paItens
	Local _cErro    := ""
	LoCAL _cNumPed  := ""

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .t. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	
	RpcSetType(3)
	RpcSetEnv(_cEmpresa,_cFilial,,,"EEC",,{'SB1','EE7','EE8','EE9','SC7'})
	
	_cNumPed := GETSX8NUM("EE7","EE7_PEDIDO")
	aAdd(_aCabec, {"EE7_PEDIDO"	,_cNumPed	,Nil})

	// Organizar os Arrays - Valdemir Rabelo 20/08/2019
	_aCabec := FWVetByDic(_aCabec, "EE7",.F.)
	_aItens := FWVetByDic(_aItens, "EE8",.T.)

	lMsErroAuto	:= .F.
	MsExecAuto({|x, y, z| EECAP100(x, y, z)}, _aCabec, _aItens, 3)

	If lMsErroAuto
		_cErro := MostraErro("arquivos/edi_arg",dtos(date())+"_"+time()+".log")
	EndIf
	
	Reset Environment
	
Return ( {!lMsErroAuto, _cErro, _cNumPed} )



User Function STEEC011()

_cXml1 := " <pedexp>
_cXml1 += " 	<empresa>03</empresa>
_cXml1 += " 	<filial>01</filial>
_cXml1 += " 	<cabecalho>
_cXml1 += " 		<campo>EE7_IMPORT</campo>
_cXml1 += " 		<valor>033833</valor>
_cXml1 += " 		<campo>EE7_IMLOJA</campo>
_cXml1 += " 		<valor>01</valor>
_cXml1 += " 		<campo>EE7_FORN</campo>
_cXml1 += " 		<valor>005764</valor>
_cXml1 += " 		<campo>EE7_FOLOJA</campo>
_cXml1 += " 		<valor>02</valor>
_cXml1 += " 		<campo>EE7_IDIOMA</campo>
_cXml1 += " 		<valor>INGLES-INGLES</valor>
_cXml1 += " 		<campo>EE7_CONDPA</campo>
_cXml1 += " 		<valor>53   </valor>
_cXml1 += " 		<campo>EE7_MPGEXP</campo>
_cXml1 += " 		<valor>003</valor>
_cXml1 += " 		<campo>EE7_INCOTE</campo>
_cXml1 += " 		<valor>FOB</valor>
_cXml1 += " 		<campo>EE7_MOEDA</campo>
_cXml1 += " 		<valor>US$</valor>
_cXml1 += " 		<campo>EE7_FRPPCC</campo>
_cXml1 += " 		<valor>CC</valor>
_cXml1 += " 		<campo>EE7_VIA</campo>
_cXml1 += " 		<valor>02</valor>
_cXml1 += " 		<campo>EE7_ORIGEM</campo>
_cXml1 += " 		<valor>MAO</valor>
_cXml1 += " 		<campo>EE7_DEST</campo>
_cXml1 += " 		<valor>ARG</valor>
_cXml1 += " 		<campo>EE7_TIPTRA</campo>
_cXml1 += " 		<valor>3</valor>
_cXml1 += " 		<campo>EE7_PAISET</campo>
_cXml1 += " 		<valor>063</valor>
_cXml1 += " 		<campo>EE7_XTIPO</campo>
_cXml1 += " 		<valor>1</valor>
_cXml1 += " 	</cabecalho>
_cXml1 += " 	<itens>
_cXml1 += " 		<item>
_cXml1 += " 			<campo>EE8_SEQUEN</campo>
_cXml1 += " 			<valor>1</valor>
_cXml1 += " 			<campo>EE8_COD_I</campo>
_cXml1 += " 			<valor>S3254</valor>
_cXml1 += " 			<campo>EE8_FORN</campo>
_cXml1 += " 			<valor>005764</valor>
_cXml1 += " 			<campo>EE8_FOLOJA</campo>
_cXml1 += " 			<valor>02</valor>
_cXml1 += " 			<campo>EE8_SLDINI</campo>
_cXml1 += " 			<valor>2</valor>
_cXml1 += " 			<campo>EE8_EMBAL1</campo>
_cXml1 += " 			<valor>S850LI</valor>
_cXml1 += " 			<campo>EE8_PSLQUN</campo>
_cXml1 += " 			<valor>0.26</valor>
_cXml1 += " 			<campo>EE8_QE</campo>
_cXml1 += " 			<valor>1</valor>
_cXml1 += " 			<campo>EE8_TES</campo>
_cXml1 += " 			<valor>728</valor>
_cXml1 += " 			<campo>EE8_CF</campo>
_cXml1 += " 			<valor>7102</valor>
_cXml1 += " 			<campo>EE8_PRECO</campo>
_cXml1 += " 			<valor>3</valor>
_cXml1 += " 		</item>
_cXml1 += " 	</itens>
_cXml1 += " </pedexp>

	U_STEEC010(_cXml1)

Return()