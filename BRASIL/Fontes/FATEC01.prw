#INCLUDE "Protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ FATEC01  ³ Efetua manutenção na tabela SK do arquivo SX5                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 19.02.13 ³ João Victor                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpC1: código da tabela                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso         ³ STECK                                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FATEC01(cTabela)
Local aTabelas := {}
Local oDlgTabe
Local nQ:= 0
Local n:= 0  
Private NOPCX,NUSADO,AHEADER,ACOLS,ARECNO
Private _CCODFIL,_CCHAVE,_CDESCRI,NQ,_NITEM,NLINGETD
Private CTITULO,AC,AR,ACGD,CLINHAOK,CTUDOOK
Private LRETMOD2,N

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx    := 3
nUsado   := 0
aHeader  := {}
aCols    := {}
aRecNo   := {}
cTabela  := "SK"
_cTabela := cTabela // Defina aqui a Tabela para edicao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona a filial corrente ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cCodFil := xFilial("SX5")
//_cCodFil := cFilAnt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SX5")
While !Eof() .And. (X3_ARQUIVO == "SX5")
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
		If AllTrim(X3_CAMPO) $ "X5_DESCRI*X5_CHAVE"
			nUsado:=nUsado+1
			Aadd(aHeader,{ AllTrim(x3_titulo), x3_campo, x3_Picture,;
			x3_tamanho, x3_decimal, x3_Valid ,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		EndIf
	EndIf
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Cabecalho da Tabela a ser editada (_cTabela) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho da tabela, filial ‚ vazio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !dbSeek(xFilial("SX5")+"00"+_cTabela)
	MsgStop("O cabeçalho da tabela "+ _cTabela +" não foi encontrado. Cadastre a tabela SK(SX5) para prosseguir.","Atenção","STOP" )
	Return
EndIf
_cChave  := AllTrim(SX5->X5_CHAVE)
_cDescri := SubStr(SX5->X5_DESCRI,1,35)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols - Posiciona os itens da tabela conforme a filial corrente ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSeek(_cCodFil+_cTabela)
While !Eof() .And. SX5->X5_FILIAL == _cCodFil .And. SX5->X5_TABELA==_cTabela
	Aadd(aCols ,Array(nUsado+1))
	Aadd(aRecNo,Array(nUsado+1))
	For nQ:=1 to nUsado
		aCols[Len(aCols),nQ]  := FieldGet(FieldPos(aHeader[nQ,2]))
		aRecNo[Len(aCols),nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
	Next
	aRecNo[Len(aCols),nUsado+1] := RecNo()
	aCols[Len(aCols),nUsado+1]  := .F.
	dbSelectArea("SX5")
	dbSkip()
EndDo

_nItem := Len(aCols)
If Len(aCols)==0
	Aadd(aCols,Array(nUsado+1))
	For nQ:=1 to nUsado
		aCols[Len(aCols),nQ]:= CriaVar(FieldName(FieldPos(aHeader[nQ,2])))
	Next
	aCols[Len(aCols),nUsado+1] := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Rodape do Modelo 2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLinGetD:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo := _cDescri

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aC:={}
Aadd(aC,{"_cChave" ,{15,10} ,"Tabela"   ,"@!"," ","",.f.})
Aadd(aC,{"_cDescri",{15,58} ,"Descricao","@!"," ","",.f.})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao utiliza o rodape, apesar de passar para Modelo 2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aR:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com coordenadas da GetDados no modelo2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCGD:={44,5,118,315}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLinhaOk:= "(!Empty(aCols[n,2]) .Or. aCols[n,3])"
cTudoOk := "AllwaysTrue()"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRetMod2 := .F.
N        := 1
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,{"X5_CHAVE","X5_DESCRI"})

If lRetMod2
	
	Begin Transaction
	/* Ajustado - Não executa mais RecLock na X5. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
	dbSelectAre("SX5")
	dbSetOrder(1)
	For n := 1 to Len(aCols)
		If aCols[n,Len(aHeader)+1] == .T.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filial e Chave e a chave indepEndente da descricao		 ³
			//³ que pode ter sido alterada               					 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If dbSeek(_cCodFil+_cTabela+aCols[n,1])
				RecLock("SX5",.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
		Else
			If dbSeek(_cCodFil+_cTabela+aCols[n,1])
				If aCols[n,2] != SX5->X5_DESCRI
					RecLock("SX5",.F.)
					SX5->X5_CHAVE  := aCols[n,1]
					SX5->X5_DESCRI := aCols[n,2]
					MsUnlock()
				EndIf
			Else
				If _nItem >= n
					dbGoto(aRecNo[n,3])
					RecLock("SX5",.F.)
					SX5->X5_CHAVE := aCols[n,1]
					SX5->X5_DESCRI:= aCols[n,2]
					MsUnlock()
				ElseIf (!Empty(aCols[n,1]))
					RecLock("SX5",.T.)
					SX5->X5_FILIAL := _cCodFil
					SX5->X5_TABELA := _cTabela
					SX5->X5_CHAVE  := aCols[n,1]
					SX5->X5_DESCRI := aCols[n,2]
					MsUnlock()
				EndIf
			EndIf
		EndIf
	Next*/
	
	End Transaction
EndIf

Return(Nil)

/*
User Function FATEC01()
Local aAreaSX5    := SX5->(GetArea())

SX5->(dbSetFilter({|| SX5->X5_TABELA == "SK" .AND. SX5->X5_FILIAL = xFilial("SX5") },"SX5->X5_TABELA == 'SK' .AND. SX5->X5_FILIAL = xFilial('SX5')"))

AxCadastro("SX5","Cadastro de Motivos de FATEC (Ficha de Assistência Técnica STECK",".F.","U_COK()")

SX5->(DbClearFilter())

RestArea(aAreaSX5)
Return()    

User Function cOK()
Local lRet := .T.

If M->X5_TABELA <> "SK"
lRet := .F.
MSGINFO("Tabela Não disponível! Favor alterar o campo X5_TABELA para SK.")
Endif
Return (lRet) 
*/
