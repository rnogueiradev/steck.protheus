#Include "PROTHEUS.Ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �STFSVE62  � Autor � TOTVS                 � Data � 10.03.10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Posicao diaria de Cotacoes                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � STFSVE62(void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � STECK                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                                                                          
User Function STFSVE62()
Local Wnrel
LOCAL cString:="SUA"
LOCAL cDesc1:= OemToAnsi("Este programa ira imprimir a posi��o di�ria de cota��es")
LOCAL cDesc2:= ""
LOCAL cDesc3:= ""
LOCAL tamanho:="P"
LOCAL CbCont
PRIVATE aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE nomeprog:="STFSVE62"     
PRIVATE cPerg   :="STFSVE62"
PRIVATE nTipo

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01  	      	// Emissao de                            �
//� mv_par02            // Emissao ate                           �
//� mv_par03            // Supervisor de                         �
//� mv_par04            // Supervisor ate                        �
//����������������������������������������������������������������

PRIVATE titulo		:="Posicao diaria de Cotacoes"
                     // 01234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^67890
                     //           1         2         3         4         5         6         7         8         9        10        12        13        14        15        16
PRIVATE cabec1		:=   "Cotacao   VI    Rep.  Dt. Cob.                  Cliente             Total c/ IPI "
PRIVATE cabec2		:= ""


//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="STFSVE62"   //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho,"",.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

nTipo := Iif(aReturn[4] == 1, 15, 18)

RptStatus({|lEnd| STFSVE62Imp(@lEnd,wnRel,cString,Tamanho,CbCont)},Titulo)
Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
��� Fun��o    �STFSVE62Imp� Autor � Totvs                 � Data � 12.03.10 ���
���������������������������������������������������������������������������Ĵ��
��� Descri��o � Posicao diaria de Cotacoes                                  ���
���������������������������������������������������������������������������Ĵ��
��� Sintaxe   �STFSVE62Imp(lEnd,wnRel,cString)                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso       � Especifico                                                  ���
���������������������������������������������������������������������������Ĵ��
���Parametros � lEnd    - A��o do Codeblock                                 ���
���           � wnRel   - T�tulo do relat�rio                               ���
���           � cString - Mensagem                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function STFSVE62Imp(lEnd,WnRel,cString,Tamanho,CbCont)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local cQuery		:= ""
Local cAliasTmp	:= GetNextAlias()
Local cSuper		:= ""
Local cEmissao		:= ""
Local aTotPend		:= {0,0}
Local aBaixaMot	:= {0,0,0,0,0,0,0,0,0}
//                   -> 1. Qt Cotacoes - Inclusao em Pedido
//                   -> 2. Tot c IPI 	- Inclusao em Pedido
//                   -> 3. Qt Cotacoes - Perd. p/ Concorrencia
//                   -> 4. Tot c IPI	- Perd. p/ Concorrencia
//                   -> 5. Qt Cotacoes - Emissao Incorreta
//                   -> 6. Tot c IPI 	- Emissao Incorreta
//                   -> 7. Qt Cotacoes - Pedido Efetivado
//                   -> 8. Tot c IPI 	- Pedido Efetivado
//                   -> 9. Total

Local cIncped	 	:= GETMV("FS_INCPED")
Local cPerdConc 	:= GETMV("FS_PERCONC")
Local cEmisInc 	:= GETMV("FS_EMISINC")

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
li       := 80
m_pag		:= 01
PRIVATE cabec1		:=   ""
    
cQuery 	:= "SELECT SA3.A3_SUPER SUPERVISOR ,SA3.A3_NOME NOMSUP, SUA.UA_EMISSAO EMISSAO,SUA.UA_NUM COTACAO,SUA.UA_VEND VENDEDOR,SUA.UA_XVEDEXT REP,SUA.UA_PROXLIG PROXLIG,SA1.A1_NOME CLIENTE,SUA.UA_VALBRUT VALBRUTO, SUA.UA_XCODMCA XCODMCA, SUA.UA_NUMSC5 NUMSC5"
cQuery 	+= "  FROM "	+ 	RetSqlName( "SUA" ) + " SUA, "+ 	RetSqlName( "SA3" ) + " SA3, "+ 	RetSqlName( "SA1" ) + " SA1 "
cQuery 	+= " WHERE SA3.A3_FILIAL ='" + xFilial( "SA3" ) + "'
cQuery 	+= "   AND SA3.A3_SUPER >= '" + mv_par03 + "'"
cQuery 	+= "   AND SA3.A3_SUPER <= '" + mv_par04 + "'"
cQuery 	+= "   AND SA3.A3_COD = SUA.UA_VEND "
cQuery 	+= "   AND SA3.D_E_L_E_T_ = ' ' "
cQuery	+= "   AND SUA.UA_FILIAL ='" + xFilial( "SUA" ) + "'
cQuery 	+= "   AND SUA.UA_EMISSAO >= '" + Dtos(mv_par01) + "'"
cQuery 	+= "   AND SUA.UA_EMISSAO <= '" + Dtos(mv_par02) + "'"
cQuery 	+= "   AND SUA.D_E_L_E_T_  = ' ' "
cQuery 	+= "   AND SA1.A1_FILIAL ='" + xFilial( "SA1" ) + "'
cQuery 	+= "   AND SA1.A1_COD = SUA.UA_CLIENTE "
cQuery 	+= "   AND SA1.A1_LOJA = SUA.UA_LOJA "
cQuery 	+= "   AND SA1.D_E_L_E_T_  = ' ' "
cQuery 	+= " ORDER BY A3_SUPER,UA_EMISSAO,UA_NUM,UA_VEND,UA_XVEDEXT,UA_PROXLIG "

cQuery 	:= ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.F.,.T. )
TcSetField(cAliasTmp,"EMISSAO","D",8,0)
TcSetField(cAliasTmp,"PROXLIG","D",8,0)                                       
//��������������������������������������������������������������Ŀ
//� Inicia a impressao do relatorio                              �
//����������������������������������������������������������������
(cAliasTmp)->(dbGotop())
While (cAliasTmp)->(!Eof())
	IF li > 54
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF

	If AllTrim(cSuper) <> AllTrim((cAliasTmp)->SUPERVISOR) .Or. cEmissao <> (cAliasTmp)->EMISSAO
		cSuper 	:= (cAliasTmp)->SUPERVISOR
		cEmissao	:= (cAliasTmp)->EMISSAO
		Li++
		@ Li++, 00 PSay "Supervisor   : " +(cAliasTmp)->SUPERVISOR + " - " + Posicione("SA3",1,xFilial("SA3")+(cAliasTmp)->SUPERVISOR,"SA3->A3_NOME")
		@ Li++, 00 PSay "Data Cotacao : " + Dtoc((cAliasTmp)->EMISSAO)
		@ Li++, 00 PSAY Replicate("-",80)
		@ Li++, 00 PSAY "Cotacao   VI   Rep. Dt. Cob.                Cliente                 Total c/ IPI"		
		@ Li++, 00 PSAY "------- ------ ---- ---------- ----------------------------------- -------------"
                     // 01234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^67890
                     //           1         2         3         4         5         6         7         8         9
	EndIf	
	If lEnd
		@ PROW()+1,001 PSay OemToAnsi("CANCELADO PELO OPERADOR")
		Exit
	EndIf

	@ li, 00 PSay 	(cAliasTmp)->COTACAO
	@ li, 08 PSay 	(cAliasTmp)->VENDEDOR
	@ li, 14 PSay 	(cAliasTmp)->REP
	@ li, 20 PSay 	(cAliasTmp)->PROXLIG
	@ li, 31 PSay  Substr((cAliasTmp)->CLIENTE,1,35)
	@ li, 66 PSay 	(cAliasTmp)->VALBRUTO Picture PesqPict("SUA","UA_VALBRUT",14)
	aTotPend[1]++
	aTotPend[2]+=(cAliasTmp)->VALBRUTO
	If (cAliasTmp)->XCODMCA == cIncPed
		aBaixaMot[1]++
		aBaixaMot[2]+=(cAliasTmp)->VALBRUTO
		aBaixaMot[9]+=(cAliasTmp)->VALBRUTO
	ElseIf (cAliasTmp)->XCODMCA == cPerdConc
		aBaixaMot[3]++
		aBaixaMot[4]+=(cAliasTmp)->VALBRUTO
		aBaixaMot[9]+=(cAliasTmp)->VALBRUTO		
	ElseIf (cAliasTmp)->XCODMCA == cEmisInc
		aBaixaMot[5]++
		aBaixaMot[6]+=(cAliasTmp)->VALBRUTO
		aBaixaMot[9]+=(cAliasTmp)->VALBRUTO
	EndIf
	
	If !Empty((cAliasTmp)->NUMSC5)
		aBaixaMot[7]++
		aBaixaMot[8]+=(cAliasTmp)->VALBRUTO
		aBaixaMot[9]+=(cAliasTmp)->VALBRUTO		
	EndIf
	
	If lEnd
		Exit
	End	
	
	If li > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	li++
	(cAliasTmp)->(dbSkip())
	//��������������������������������������������������������������Ŀ
	//� Verifica se deve imprimir Totalizacao                        �
	//����������������������������������������������������������������
	If AllTrim(cSuper) <> AllTrim((cAliasTmp)->SUPERVISOR) .Or. cEmissao <> (cAliasTmp)->EMISSAO
		Li++
		@ Li   	, 00 PSay  "TOTAIS    --------------  PENDENTE  -------------- "
		Li++
		@ Li++	, 00 PSay  "               Qtd. Cotacoes       Total  c/   IPI "
		@ Li++	, 00 PSay  "               -------------       --------------- "
                        // 01234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^67890
                        //           1         2         3         4         5         6         7         8         9
		@ Li  	, 20 PSay  StrZero(aTotPend[1],3)
		@ Li		, 36 PSay  aTotPend[2] Picture PesqPict("SUA","UA_VALBRUT",14)
		Li++
		//������������������������������������������������������������Ŀ
		//� Zera Array para proximo Supervisor / Data Emissao          �
		//��������������������������������������������������������������
		aTotPend[1] := 0
		aTotPend[2] := 0
	
		If li > 54
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		//������������������������������������������������������������Ŀ
		//� Impressao Baixas - Motivos                                 �
		//��������������������������������������������������������������
		Li++
		@ Li   	, 00 PSay  "----------------------------  BAIXAS - MOTIVOS   -------------------------------"
		Li++
		@ Li++	, 00 PSay  "Motivo                                           Qtd. Cotacoes      Total c/ IPI"
		@ Li   	, 00 PSay  "--------------------------------------------------------------------------------"		
		Li++
		@ Li		, 00 PSay  "INCL. EM PEDIDO"
		@ Li		, 53 PSay  StrZero(aBaixaMot[1],3)
		@ Li		, 66 PSay  aBaixaMot[2] Picture PesqPict("SUA","UA_VALBRUT",14)
		Li++
		@ Li		, 00 PSay  "PERDIDO P/ CONC."
		@ Li		, 53 PSay  StrZero(aBaixaMot[3],3)
		@ Li		, 66 PSay  aBaixaMot[4] Picture PesqPict("SUA","UA_VALBRUT",14)
		Li++
		@ Li		, 00 PSay  "EMISSAO INCORRETA"
		@ Li		, 53 PSay  StrZero(aBaixaMot[5],3)
		@ Li		, 66 PSay  aBaixaMot[6] Picture PesqPict("SUA","UA_VALBRUT",14)
		Li++
		@ Li		, 00 PSay  "PEDIDO EFETIVADO"				
		@ Li		, 53 PSay  StrZero(aBaixaMot[7],3)
		@ Li		, 66 PSay  aBaixaMot[8] Picture PesqPict("SUA","UA_VALBRUT",14)
		Li++'
		@ Li		, 00 PSAY "                                                                   -------------"
		Li++
		@ Li		, 66 PSay  aBaixaMot[9] Picture PesqPict("SUA","UA_VALBRUT",14)
		Li++'

		//������������������������������������������������������������Ŀ
		//� Zera Array para proximo Supervisor / Data Emissao          �
		//��������������������������������������������������������������
		aBaixaMot[1] := 0
		aBaixaMot[2] := 0
		aBaixaMot[3] := 0
		aBaixaMot[4] := 0
		aBaixaMot[5] := 0								
		aBaixaMot[6] := 0
		aBaixaMot[7] := 0
		aBaixaMot[8] := 0
		aBaixaMot[9] := 0
	EndIf	

EndDo                                 

//������������������������������������������������������������Ŀ
//� Impressao do Rodape.                                       �
//��������������������������������������������������������������
If li < 59
	Roda(cbcont,cbtxt,Tamanho)
EndIf

//��������������������������������������������������������������Ŀ
//� Deleta arquivo de trabalho                                   �
//����������������������������������������������������������������
(cAliasTmp)->(dbCloseArea())
FErase(cAliasTmp+GetDBExtension())
FErase(cAliasTmp+OrdBagExt())

If aReturn[5] = 1
	Set Printer TO
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()