#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

Static __lSTFSGRV := .F.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE20  �Autor  �Microsiga           � Data �  01/20/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para adicionar botoes na enchoicebar da tela de     ���
���          � geracao manual de lista de contatos (P.E. TK061BAR)        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE20()
Local aRet := {}

If Inclui .and. !Empty(aCols)
	AAdd(aRet, { "CLIENTE"	, {|| U_STFSVE21() }, "Pesquisa de Satisfa��o","Satisfa��o" })
Endif

Return aClone(aRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE20  �Autor  �Microsiga           � Data �  01/20/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para preencher o acols da rotina de geracao de lista ���
���          �de contatos TMKA061                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE21()
Local aArea			:= GetArea()
Local aBase			:= aClone(aCols[1])
Local cCodItem		:= GdFieldGet("U6_CODIGO",1)
Local cEntAlias 	:= Tk061PegEnt()
Local nQuant		:= 0
Local nMaxLoop		:= 0
Local nAte			:= 0
Local cQuery		:= ""
Local aParambox	:= {}
Local aRet			:= {}
Local aContatos	:= {}
Local aItens		:= {}
Local aIdx			:= {} 
Local nAno
Local nMes
Local nI
Local nIdx


If !(cEntAlias == "SA1")
	MsgAlert("Op��o dispon�vel apenas para listas de clientes!")
	__lSTFSGRV := .F.
	Return
Endif

aAdd(aParamBox,{1,"Quantidade",nQuant,"@E 999", "", "", "" , 0  , .T. })
aAdd(aParamBox,{1,"Segmentos"	,Space(6),"","","ACY","",0,.F.})

If !ParamBox(aParamBox,"Elei��o de Clientes",@aRet,,,,,,,,.f.)   
	Return
Endif
If !Empty(GdFieldGet("U6_CONTATO",1))
	MsgAlert("O(s) contato(s) desta lista j� foi(ram) inclu�do(s). Inicie uma nova lista para utilizar esta op��o")
	Return
Endif

nMes := Month(dDataBase)-1
nAno := Year(dDataBase)

If nMes == 0
	nMes := 12
	nAno -= 1
Endif

//HACK TIRAR ESTA ATRIBUICAO
//FIXANDO SOMENTE PARA TESTAR
//nAno := 2010
//nMes := 1

cQuery := " SELECT DISTINCT A1_COD+A1_LOJA AS CLIENTE"
cQuery += " FROM " + RetSqlName("SF2") + " SF2 INNER JOIN " + RetSqlName("SA1") + " SA1 ON  F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA"
cQuery += " WHERE  A1_FILIAL = '"+xFilial("SA1")+"' AND F2_FILIAL = '"+xFilial("SF2")+"'"
cQuery += " AND A1_GRPVEN = '"+MV_PAR02+"' AND A1_XANOPES < '"+Alltrim(Str(Year(dDataBase)))+"'"
cQuery += " AND F2_EMISSAO BETWEEN '"+Alltrim(Str(nAno))+StrZero(nMes,2)+"01' AND '"+Alltrim(Str(nAno))+StrZero(nMes,2)+"31'"
cQuery += " AND SA1.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = ''"
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS "QSA1"

While QSA1->(!Eof())
	QSA1->(Aadd(aItens,{CLIENTE,""}))
	QSA1->(DbSkip())
End
QSA1->(DbCloseArea())

If Empty(aItens)
	MsgAlert("N�o foram encontrados clientes para os par�metros informados!")
	Return
Endif

nAte := Min(MV_PAR01,len(aItens))

For nI:=1 to nAte
	nIdx 		:= 0
	nMaxLoop	:= 0
	While nIdx == 0

   	If nMaxLoop > 500
   		Exit
   	Endif
		
		If nAte < MV_PAR01
			nIdx := fGetCon(aIdx,aItens,nI)
		Else
			nIdx := nI
		Endif
		
		If Empty(nIdx)
			nMaxLoop++
			Loop
		Endif

		cContato := GetEntid(aItens[nIdx,1])
		If Empty(cContato)
			nIdx := 0
			nMaxLoop++
			Loop
		Endif

		If !fVAlCont(cContato)
			nIdx := 0
			nMaxLoop++
			Loop
		Endif

   	aItens[nIdx,2] := cContato
	End

	If nMaxLoop > 500
		If len(aContatos) == 0
			MsgAlert("N�o foram encontrados clientes para os par�metros informados!")
		Else
			MsgAlert("N�mero m�ximo de tentativas para recuperar registros atingida. Ser� gerada uma lista com " + Alltrim(Str(len(aContatos))) + " contatos!")
		Endif
   	Exit
   Endif

	Aadd(aContatos,aItens[nIdx])
Next

For nI:=1 to len(aContatos)

	GDFieldPut( "U6_CODIGO",cCodItem, n )
	GDFieldPut( "U6_CONTATO",aContatos[nI,2], n )
	GDFieldPut( "U6_NCONTAT",Posicione("SU5",1,xFilial("SU5")+aContatos[nI,2],"U5_CONTAT"), n )
	GDFieldPut( "U6_CODENT",aContatos[nI,1], n )
	GDFieldPut( "U6_DESCENT",Posicione("SA1",1,xFilial("SA1")+aContatos[nI,1],"A1_NOME"), n )
	If len(aContatos) > nI
		Aadd(aCols,aBase)
	Endif
	n:=len(aCols)
	cCodItem := Soma1(cCodItem)
Next
n := 1
__lSTFSGRV := .T.

If !Empty(GdFieldGet("U6_CONTATO",1))
	M->U4_DESC := "PESQUISA DE SATISFA��O DE " + Right(DTOC(dDatabase),5)
	M->U4_FORMA:= "1"
	MsgAlert("Foram inseridos " +Alltrim(Str(len(aCols)))+ " contatos nesta lista. O cadastro destes clientes ser� atualizado na grava��o da lista!")
Endif

RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE20  �Autor  �Microsiga           � Data �  01/21/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para retornar um numero aleatorio para a eleicao de  ���
���          �clientes                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetCon(aIdx,aItens,nI)
Local nRet := 0

nRet  := Randomize(1,Len(aItens))
If Ascan(aIdx,{|x| x[1] == nRet}) > 0
	Return 0
Endif
Aadd(aIdx,{nRet})
Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE20  �Autor  �Microsiga           � Data �  01/21/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para trazer o ultimo contato cadastrado              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetEntid(cChave)
Local cRet := ""
AC8->(DbSetOrder(2)) //AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON

If !AC8->(DbSeek(xFilial("AC8")+"SA1"+xFilial("SA1")+cChave))
	Return cRet
Endif

While AC8->(!Eof() .and. AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+Alltrim(AC8_CODENT) == xFilial("AC8")+"SA1"+xFilial("SA1")+cChave)
	cRet := AC8->AC8_CODCON
	AC8->(DbSkip())
End

Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE20  �Autor  �Microsiga           � Data �  01/21/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualizacao do cadastro de clientes na geracao de listas de ���
���          �pesquisa de satisfacao - TK61VALC                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE22(aLista)
Local nI
Local aSA1Area	:= SA1->(GetArea())
Local aArea		:= GetArea()

If __lSTFSGRV == Nil .or. !__lSTFSGRV
	Return
Endif

SA1->(DbSetOrder(1))

For nI:=1 to len(aCols)
	
	If GdDeleted(nI)
		Loop
	Endif

	If SA1->(DbSeek(xFilial("SA1")+Alltrim(GdFieldGet("U6_CODENT",nI))))
		SA1->(RecLock("SA1",.F.))
		SA1->A1_XANOPES := Alltrim(Str(Year(dDatabase)))
		SA1->(MsUnlock())
	Endif
Next

__lSTFSGRV := .F.
RestArea(aSA1Area)
RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE20  �Autor  �Microsiga           � Data �  01/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para verificar se o contato pode ser incluido na     ���
���          �lista                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fValCont(cContato)
Local aArea	:= GetArea()
Local aSU6Area	:= SU6->(GetArea())
Local aSU4Area	:= SU4->(GetArea())
Local lRet		:= .T.

SU6->(DbSetOrder(2))
If SU6->(DbSeek(xFilial("SU6") + Dtos(M->U4_DATA) + cContato))
	While	SU6->(!Eof() .and. U6_FILIAL == xFilial("SU6") .and. U6_DATA == dDatabase .and. U6_CONTATO == cContato)
		If ((SU6->U6_STATUS == "1") .or. (SU6->U6_STATUS == "2") .or. (SU6->U6_STATUS == "3") .and. (M->U4_LISTA<>SU6->U6_LISTA))
			lRet:= .F.
			Exit
		Endif

		SU6->(DbSkip())
	End
Endif


If !lRet
	RestArea(aSU6Area)
	RestArea(aArea)
	Return .F.
Endif


If TkPosto(TkOperador(),"U0_VALCONT") == "2"
	SU4->(DbSetOrder(1))
	If SU4->(DbSeek(xFilial("SU4") + SU6->U6_LISTA))
		If SU4->U4_FORMA == M->U4_FORMA
			RestArea(aSU4Area)
			RestArea(aSU6Area)
			RestArea(aArea)
			Return .F.
		Endif
	Endif
Endif

RestArea(aSU4Area)
RestArea(aSU6Area)
RestArea(aArea)

Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE20  �Autor  �Microsiga           � Data �  02/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para ajustar campo X3_TRIGGER e travar acols         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE23()
Local aX3Alt	:= {}
Local aX3Area	:= SX3->(GetArea())
Local aArea		:= GetArea()
Local nI

Aadd(aX3Alt,{"UA_CONDPG"})
Aadd(aX3Alt,{"UA_CLIENTE"})
Aadd(aX3Alt,{"UB_PRODUTO"})
Aadd(aX3Alt,{"UB_QUANT"})
Aadd(aX3Alt,{"UB_VRUNIT"})
Aadd(aX3Alt,{"UB_DESC"})
Aadd(aX3Alt,{"UB_VALDESC"})
Aadd(aX3Alt,{"UB_ACRE"})
Aadd(aX3Alt,{"UB_VALACRE"})

SX3->(DbSetOrder(2))

For nI:=1 to len(aX3Alt)
	SX3->(DbSeek(aX3Alt[nI,1]))
	If !(SX3->X3_TRIGGER == "S")	
	/* Removido\Ajustado - N�o executa mais Recklock na X3
		SX3->(RecLock("SX3",.F.))
		SX3->X3_TRIGGER := "S"
		SX3->(MsUnLock())*/
	Endif
Next

RestArea(aX3Area)
RestArea(aArea)

Return
