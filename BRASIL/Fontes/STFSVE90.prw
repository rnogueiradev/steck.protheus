#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE90  �Autor  �Microsiga           � Data �  12/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao para gravar a data de entrega no pedido de venda  ���
���          �PE M410LIOK                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE90()
Local lRet 		:= .T.
Local dDtEntr	:= GDFieldGet("C6_ENTRE1")

If Empty(M->C5_XDTEN) .or. M->C5_XDTEN < dDtEntr
	M->C5_XDTEN := dDtEntr    
	GetDRefresh()
Endif

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE90  �Autor  �Microsiga           � Data �  12/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para atualizar a quantidade de notas fiscais de saida���
���          �emitidas para o cliente                                     ���
���          �SF2 DEVE ESTAR POSICIONADO!!                                ���
���          �Usado no PE M460FIM e SF2520E                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE91(cTipo)
Local aArea 	:= GetArea()
Local aSA1Area	:= SA1->(GetArea())

SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
If SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))
	SA1->(RecLock("SA1",.F.))
	If cTipo == "+"
		SA1->A1_XQTDFAT += 1
	Else
		If SA1->A1_XQTDFAT > 0
			SA1->A1_XQTDFAT -= 1
		Endif
	Endif
	SA1->(MsUnlock())
Endif

RestArea(aSA1Area)
RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE90  �Autor  �Microsiga           � Data �  12/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de cliente para novos negocios                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE92()
Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "STFSVE92 - Rela��o de Novos Clientes"
Local cPict			:= ""
Local titulo		:= "Rela��o de Novos Neg�cios"
Local nLin			:= 80
Local Cabec1		:= " Cliente    Nome do Cliente                        Nota Fiscal         Emiss�o"
Local Cabec2		:= ""
Local imprime		:= .T.
Local aOrd			:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private limite		:= 132
Private tamanho	:= "P"
Private nTipo		:= 18
Private aReturn	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey	:= 0
Private cPerg		:= "FSVE92"
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "STFSVE92"
Private cString 	:= ""

AjustaSx1(cPerg)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  10/10/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cQuery	:= ""
Local cQtdCon	:= "2" //Quantidade de notas faturadas consideradas
Local cDataIni	:= "01" + mv_par01 + mv_par02  
Local cDataFim	:= "31" + mv_par01 + mv_par02  
Local aClientes:= {} //Tratar clientes duplicados na mao

SetRegua(1)

cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_ULTCOM, A1_XQTDFAT, F2_DOC, F2_SERIE, F2_EMISSAO"
cQuery += " FROM "+ RetSqlName("SA1") + " SA1 INNER JOIN " + RetSqlName("SF2") + " SF2 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA"
cQuery += " WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND F2_FILIAL ='"+xFilial("SF2")+"'"
cQuery += " AND A1_XQTDFAT = "+cQtdCon
cQuery += " AND F2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"
cQuery += " AND SA1.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = ''"
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS "QSA1"

While QSA1->(!Eof())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
	
   If nLin > 65
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
      nLin := 08
   Endif

	If (Ascan(aClientes,{|x| x[1]== QSA1->A1_COD + "-"+QSA1->A1_LOJA})) > 0
		QSA1->(DbSkip())
		Loop
	Else
		Aadd(aClientes,{QSA1->A1_COD + "-"+QSA1->A1_LOJA})
	Endif

	@ nLin ,001 PSAY QSA1->A1_COD + "-"+QSA1->A1_LOJA
	@ nLin ,012 PSAY Substr(QSA1->A1_NOME,1,38)
	@ nLin ,050 PSAY QSA1->F2_DOC+"-"+QSA1->F2_SERIE
	@ nLin ,070 PSAY DtoC(StoD(QSA1->F2_EMISSAO))

   nLin := nLin + 1

   QSA1->(DbSkip())
End
QSA1->(DbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFACD041  �Autor  �Microsiga           � Data �  10/12/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSx1(cPerg)
Local aHelp := {}

Aadd(aHelp,{{	"Informe o m�s da consulta"},{""},{""}})
Aadd(aHelp,{{	"Informe o ano da consulta (4 digitos)"},{""},{""}})

PutSx1(cPerg, 	"01","M�s",	"M�s","M�s","mv_ch1","C",02,0,0,"G","","","","",	"mv_par01","","","","","","","","","","","","","","","","",aHelp[1,1],aHelp[1,2],aHelp[1,3],"")
PutSx1(cPerg, 	"02","Ano",	"Ano","Ano","mv_ch2","C",04,0,0,"G","","","","",	"mv_par02","","","","","","","","","","","","","","","","",aHelp[2,1],aHelp[2,2],aHelp[2,3],"")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE90  �Autor  �Microsiga           � Data �  12/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao para gravar a data de entrega no pedido de venda  ���
���          �P.E. MT410TOK e                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE93(lOrc)
Local nI
Local lShowMsg	:= .F.
Default lOrc 	:= .F.

	/****************************************
	A��o.........: Tratamento para alterar a data de entrega conforme a data do pedido programado.
	Desenvolvedor: Marcelo Klopfer Leme
	Data.........: 26/05/2022
	Chamado......: 20220429009114 - Oferta Log�stica
	****************************************/
	IF IsInCallStack("MATA410") = .T.
		IF EMPTY(M->C5_XDTENPR)

			For nI:=1 to len(aCols)
				If !lOrc
					dDtEntr := GDFieldGet("C6_ENTRE1",nI)
					If M->C5_XDTEN < dDtEntr
						M->C5_XDTEN := dDtEntr
						lShowMsg	:= .T.
					Endif
				Endif
			Next

			If lShowMsg
				If !lOrc
					MsgAlert("A data de entrega foi corrigida para o dia " + DtoC(M->C5_XDTEN))
				Endif
			Endif
		ELSE
		
			FOR nI:=1 TO LEN(aCols)
				dDtEntr := GDFieldGet("C6_ENTREG",nI)
				IF M->C5_XDTEN < dDtEntr
					M->C5_XDTEN := dDtEntr
				ENDIF
			NEXT
		ENDIF
	ENDIF
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSVE94  �Autor  �Jose C. Frasson     � Data �  30/12/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao para alterar o status da Embalagem, se houver     ���
���          � Tabela ZZT (Usado no PE SF2520E)                           ���
�������������������������������������������������������������������������͹��
���Uso       � STECK                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFSVE94()
	dbSelectArea("ZZT")
	dbSetOrder(2)
	//ZZT_FILIAL+ZZT_NF+ZZT_SERIEN
	
	If ZZT->(dbSeek(xFilial("ZZT") + SF2->(F2_DOC + F2_SERIE)))
		ZZT->(RecLock("ZZT",.F.))
		ZZT->ZZT_NF 	:= " "
		ZZT->ZZT_SERIEN := " "
		ZZT->ZZT_STATUS	:= "1"
		ZZT->(MsUnlock())
	Endif
		
Return
