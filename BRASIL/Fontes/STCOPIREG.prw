#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCOPIREG	บAutor  ณRenato Nogueira     บ Data ณ  30/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada copiar qualquer registro entre empresas    บฑฑ
ฑฑบ          ณ									    				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STCOPIREG(cTabela,cEmpOrig,cEmpDest,cFilDest) //Tabela,Empresa de origem, Empresa de destino, Filial de destino

Local _aArea		:= GetArea()
Local aCamposOri	:= {} //Campos de origem
Local aCamposDest   := {} //Campos de destino
Local cNewAls 		:= GetNextAlias()
Local cSvFilAnt 	:= cFilAnt //Salva a Filial Anterior
Local cSvEmpAnt 	:= cEmpAnt //Salva a Empresa Anterior
Local cSvArqTab 	:= cArqTab //Salva os arquivos de trabalho
Local cModo

If cEmpAnt<>cEmpOrig //Verificar se empresa logada ้ igual a empresa de origem
	MsgAlert("Aten็ใo, a empresa logada ้ diferente da empresa de origem, verifique!")
	Return()
EndIf

DbSelectArea("SX3")
SX3->(DbSetOrder(1))

If SX3->(DbSeek(cTabela))
	
	While ( SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cTabela )
		
		If SX3->X3_CONTEXT<>"V"
			
			aAdd(aCamposOri,{ AllTrim(SX3->X3_CAMPO), ;
			&(cTabela+"->"+SX3->X3_CAMPO) } )
			
		EndIf
		
		SX3->(DbSkip())
	End
	
	StartJob("U_STCOPJOB",GetEnvServer(), .T.,cEmpDest, cFilDest,aCamposOri,cTabela)
	
Else
	
	MsgAlert("SX3 da empresa "+cFilAnt+" nใo encontrado, favor verificar!")
	
EndIf

RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCOPJOB	บAutor  ณRenato Nogueira     บ Data ณ  30/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada copiar qualquer registro entre empresas    บฑฑ
ฑฑบ          ณ									    				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STCOPJOB(cNewEmp,cNewFil,aCamposOri,cTabela)

Local cChave		:= ""
Local aCamposDest	:= {}
Local nX			:= 0
Local nPos			:= 0

//Inicia outra Thread com outra empresa e filial
RpcSetType( 3 )
RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

Conout("Gravando STCOPJOB na empresa "+cNewEmp+" "+cNewFil)

DbSelectArea("SX3")
SX3->(DbSetOrder(1))
If SX3->(DbSeek(cTabela))
	
	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)==AllTrim(cTabela)
		
		nPos	:= aScan(aCamposOri,{|x|	AllTrim(x[1]) == AllTrim(SX3->X3_CAMPO)})
		
		If nPos>0
			
			AADD(aCamposDest,{SX3->X3_CAMPO,aCamposOri[nPos][2]})
			
		EndIf
		
		SX3->(DbSkip())
		
	EndDo
	
	DbSelectArea("SIX")
	SIX->(DbSetOrder(1))
	If SIX->(DbSeek(cTabela))
		
		DbSelectArea(cTabela)
		(cTabela)->(DbGoTop())
		(cTabela)->(DbSetOrder(Val(SIX->ORDEM)))
		
		If (cTabela)->(DbSeek((cTabela)->(SIX->CHAVE)))
			
			(cTabela)->(RecLock((cTabela),.F.))
			
		Else
			
			(cTabela)->(RecLock((cTabela),.T.))
			
		EndIf
		
		For nX:=1 To Len(aCamposDest)
			
			&((cTabela)+"->"+aCamposDest[nX][1])	:= aCamposDest[nX][2] 
			
		Next
		
		(cTabela)->(MsUnLock())
		
	Else
		Conout("SIX da empresa "+cNewEmp+" nใo encontrado, favor verificar!")
	EndIf
Else
	Conout("SX3 da empresa "+cNewEmp+" nใo encontrado, favor verificar!")
EndIf
        
RpcClearEnv() //volta a empresa anterior

Return()