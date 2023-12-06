#INCLUDE "Protheus.ch" 

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � FATEC01  � Efetua manuten��o na tabela SK do arquivo SX5                ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 19.02.13 � Jo�o Victor                                                  ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1: c�digo da tabela                                                 ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Uso         � STECK                                                                   ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
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

//���������������������������������Ŀ
//� Opcao de acesso para o Modelo 2 �
//�����������������������������������
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

//�����������������������������Ŀ
//� Posiciona a filial corrente �
//�������������������������������
_cCodFil := xFilial("SX5")
//_cCodFil := cFilAnt

//������������������Ŀ
//� Montando aHeader �
//��������������������
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

//����������������������������������������������������������Ŀ
//� Posiciona o Cabecalho da Tabela a ser editada (_cTabela) �
//������������������������������������������������������������
dbSelectArea("SX5")
dbSetOrder(1)
//�������������������������������������Ŀ
//� Cabecalho da tabela, filial � vazio �
//���������������������������������������
If !dbSeek(xFilial("SX5")+"00"+_cTabela)
	MsgStop("O cabe�alho da tabela "+ _cTabela +" n�o foi encontrado. Cadastre a tabela SK(SX5) para prosseguir.","Aten��o","STOP" )
	Return
EndIf
_cChave  := AllTrim(SX5->X5_CHAVE)
_cDescri := SubStr(SX5->X5_DESCRI,1,35)

//��������������������������������������������������������������������������Ŀ
//� Montando aCols - Posiciona os itens da tabela conforme a filial corrente �
//����������������������������������������������������������������������������
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

//���������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2 �
//�����������������������������������
nLinGetD:=0

//������������������Ŀ
//� Titulo da Janela �
//��������������������
cTitulo := _cDescri

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
Aadd(aC,{"_cChave" ,{15,10} ,"Tabela"   ,"@!"," ","",.f.})
Aadd(aC,{"_cDescri",{15,58} ,"Descricao","@!"," ","",.f.})

//��������������������������������������������������������������Ŀ
//� Nao utiliza o rodape, apesar de passar para Modelo 2         �
//����������������������������������������������������������������
aR:={}

//����������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2 �
//������������������������������������������������
aCGD:={44,5,118,315}

//������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2 �
//��������������������������������������
cLinhaOk:= "(!Empty(aCols[n,2]) .Or. aCols[n,3])"
cTudoOk := "AllwaysTrue()"

//��������������������Ŀ
//� Chamada da Modelo2 �
//����������������������
lRetMod2 := .F.
N        := 1
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,{"X5_CHAVE","X5_DESCRI"})

If lRetMod2
	
	Begin Transaction
	/* Ajustado - N�o executa mais RecLock na X5. Cria��o/altera��o de dados deve ser feita apenas pelo m�dulo Configurador ou pela rotina de atualiza��o de vers�o.
	dbSelectAre("SX5")
	dbSetOrder(1)
	For n := 1 to Len(aCols)
		If aCols[n,Len(aHeader)+1] == .T.
			//����������������������������������������������������������Ŀ
			//� Filial e Chave e a chave indepEndente da descricao		 �
			//� que pode ter sido alterada               					 �
			//������������������������������������������������������������
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

AxCadastro("SX5","Cadastro de Motivos de FATEC (Ficha de Assist�ncia T�cnica STECK",".F.","U_COK()")

SX5->(DbClearFilter())

RestArea(aAreaSX5)
Return()    

User Function cOK()
Local lRet := .T.

If M->X5_TABELA <> "SK"
lRet := .F.
MSGINFO("Tabela N�o dispon�vel! Favor alterar o campo X5_TABELA para SK.")
Endif
Return (lRet) 
*/
