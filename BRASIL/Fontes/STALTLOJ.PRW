#Include "Protheus.ch"
#Include "rwmake.ch"


/*====================================================================================\
|Programa  | STALTLOJ         | Autor | Jefferson Carlos         | Data | 13/10/2016  |
|=====================================================================================|
|Descrição |   Alteração de Loja Bloqueada no cadastro de TES INTELIGENTE                                                        |
|          |   de Entrada                                                             |
|          |                                                                          |
|          |   Chamado 003275                                                         |
|=====================================================================================|
|Sintaxe   | STALTLOJ                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STALTLOJ()
	
	Local _cGgCod
	Local _cTes
	Local _cCodProd
	
	If msgyesno("Deseja alterar a loja do fornecedor " + Alltrim(SFM->FM_FORNECE)+" ?")
		
		DbSelectArea("SFM")
		DbSetOrder(2)
		DbSeek(xFilial("SFM")+SFM->FM_TIPO+SFM->FM_CLIENTE+SFM->FM_LOJACLI+SFM->FM_FORNECE+SFM->FM_LOJAFOR+SFM->FM_GRTRIB+SFM->FM_PRODUTO)
		
		_cGgFor	:= Alltrim(SFM->FM_FORNECE)
		_cTes		:= Alltrim(SFM->FM_TE)
		_cCodProd	:= Alltrim(SFM->FM_PRODUTO)
		
		While  SFM->(!Eof()) .AND. _cGgFor== Alltrim(SFM->FM_FORNECE) .AND. _cTes	== Alltrim(SFM->FM_TE).AND. _cCodProd== Alltrim(SFM->FM_PRODUTO)
			
			
			
			SFM->(Reclock("SFM",.F.))
			SFM->FM_LOJAFOR	:= "01"
			SFM->(MsUnLock())
			
			
			
			SFM->(DbSkip())
			
			
			
		EndDo
		
		MsgAlert("Alteração loja do fornecedor alterada com sucesso")
		
	Else
		
		MsgAlert("Alteração cancelada")
		
	EndIf
	
Return()
