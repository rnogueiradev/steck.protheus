#include "RWMAKE.CH" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SF2520E  ³ Autor ³ Fabrica de Software   ³ Data ³ 09/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada onde:                                     ³±±
±±³          ³ - Limpa informacao nota fiscal na tabela de Controle PE1;  ³±±
±±³          ³ - Exclui Pre-Nota de Entrada na empresa destino;           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico cliente Steck 			                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Array						                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SF2520E()

Local lRet := .T.
Local cArea      := GetArea()
Local aCabec := {}
Local aItens := {}
Local nItem  := 0

// ESTORNANDO A LIBERAÇÃO DO PEDIDO DE VENDA
 
dbSelectArea("SC5")
dbSetOrder(1)
dbGoTop()

if dbseek(xFilial("SC5")+SD2->D2_PEDIDO)

	RecLock('SC5', .F.)
	if !empty(SC5->C5_XPLAAPR)
	C5_XPLAAPR := "N"
	ENDIF
	C5_ZFATBLQ := " "
//	C5_NOTA    := ""
	SC5->(MsUnlock())

Endif

// EXCLUIDO O PEDIDO DE COMPRA DE BENEFICIAMENTO

dbSelectArea("SC7")
dbSetOrder(1)
dbGoTop()


if dbseek(xFilial("SC7")+SF2->F2_XPEDCOM)

aCabec := {}
aItens := {}

aadd(aCabec,{"C7_NUM" ,SF2->F2_XPEDCOM})
aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
aadd(aCabec,{"C7_FORNECE" ,SF2->F2_CLIENTE})
aadd(aCabec,{"C7_LOJA" ,SF2->F2_LOJA})
aadd(aCabec,{"C7_COND" ,SC7->C7_CODTAB})
aadd(aCabec,{"C7_CONTATO" ,""})
aadd(aCabec,{"C7_FILENT" ,SC7->C7_FILENT})

WHILE !EOF() .AND. SC7->C7_NUM == SF2->F2_XPEDCOM

nItem ++

aLinha := {}
aadd(aLinha,{"C7_ITEM",StrZero(nItem,Len(SC7->C7_ITEM)),Nil})
aadd(aLinha,{"C7_PRODUTO",SC7->C7_PRODUTO ,Nil})
aadd(aLinha,{"C7_QUANT",SC7->C7_QUANT ,Nil})
aadd(aLinha,{"C7_PRECO",SC7->C7_PRECO ,Nil})
aadd(aLinha,{"C7_TOTAL",SC7->C7_TOTAL ,Nil})
aadd(aLinha,{"C7_REC_WT" ,SC7->(RECNO()) ,Nil})
aadd(aItens,aLinha)

dbSkip()
Enddo

MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabec,aItens,5) 

Endif

U_STFS71F2(.t.)  //Limpa informacoes de Nota/Serie em PE1
//U_STFS71F3(.t.)  //Estorna a Pre-Nota na empresa destino (SP) // desabilitado por giovani zago 01/07/15 pre-nota esta sendo gerada pela importação do xml.
U_STFSVE91("-")	//Atualiza quantidade de notas fiscais emitidas para o cliente

u_STFSVE94()	// Atualiza Embarques

u_STFS71EDT()   // Limpa o campo da data de entrega C6_ZDTENRE para pedidos retira. 

RestArea(cArea)

Return lRet

 