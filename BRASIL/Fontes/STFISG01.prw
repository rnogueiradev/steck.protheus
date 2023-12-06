#Include 'Protheus.ch'
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFISG01   º Autor ³ Vitor Merguizo	 º Data ³  30/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para atualização de Guias para Sped                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STFISG01()

Local aSays		:= {}
Local aButtons	:= {}
Local nOpcao	:= 0
Private cCadastro 	:= OemToAnsi("Atualização de Informação Complementar - Guia")
Private cPerg 		:= "STFISG01"

// Funcao para criacao de perguntas da rotina.
Ajusta()

Pergunte(cPerg,.t.)

AAdd(aSays,"Este programa tem como objetivo atualizar o Documento de Saida com")
AAdd(aSays,"Guia de Recolhimento")

AAdd(aButtons,{ 5,.T.,{|| Pergunte(cPerg,.t.) 		} } )
AAdd(aButtons,{ 1,.T.,{|| nOpcao := 1,FechaBatch() 	} } )
AAdd(aButtons,{ 2,.T.,{|| nOpcao := 0,FechaBatch() 	} } )

FormBatch(cCadastro,aSays,aButtons)

If nOpcao == 1
	Processa({|| STFISG1A()})
	Processa({|| STFISG1B()})
	Processa({|| STFISG1C()})
EndIf

Return

Static Function STFISG1A()

Local cQuery	:= ""
Local cCampo	:= ""
Local cAlias	:= GetNextAlias()
Local aCampos	:= {"CDC_FILIAL","CDC_TPMOV","CDC_DOC","CDC_SERIE","CDC_CLIFOR","CDC_LOJA","CDC_GUIA","CDC_UF","CDC_IFCOMP"}
Local nX		:= 0
Local nY		:= 0

cQuery := "SELECT F6_FILIAL CDC_FILIAL,'S' CDC_TPMOV,F6_DOC CDC_DOC,F6_SERIE CDC_SERIE,F6_CLIFOR CDC_CLIFOR,F6_LOJA CDC_LOJA,F6_NUMERO CDC_GUIA,F6_EST CDC_UF, "
cQuery += "CASE WHEN F6_EST = 'PE' THEN '000001' WHEN F6_EST = 'DF' THEN '000002' ELSE '000003' END CDC_IFCOMP "
cQuery += "FROM "+RetSqlName("SF6")+" SF6 "
cQuery += "INNER JOIN "+RetSqlName("SE2")+" SE2 ON E2_FILIAL = F6_FILIAL AND E2_FORNECE = 'ESTADO' AND E2_LOJA = '00' AND E2_PREFIXO = 'FIN' AND "
cQuery += "E2_NUM = F6_NUMERO AND E2_TIPO = 'TX' AND E2_SALDO = 0 AND SE2.D_E_L_E_T_ = ' ' "
cQuery += "LEFT JOIN "+RetSqlName("CDC")+" CDC ON F6_FILIAL = CDC_FILIAL AND CDC_TPMOV = 'S' AND F6_DOC = CDC_DOC AND F6_SERIE = CDC_SERIE AND 
cQuery += "F6_CLIFOR = CDC_CLIFOR AND F6_LOJA = CDC_LOJA AND F6_NUMERO = CDC_GUIA AND F6_EST = CDC_UF AND CDC.D_E_L_E_T_ = ' ' "
cQuery += "WHERE "
cQuery += "F6_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "F6_DTARREC BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "F6_DOC <> ' ' AND "
cQuery += "CDC_FILIAL IS NULL AND "
cQuery += "SF6.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY F6_FILIAL,F6_SERIE,CDC_DOC "

//cQuery := ChangeQuery(cQuery)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

ProcRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	nY++
	IncProc("Atualizando Nota Fiscal: "+(cAlias)->CDC_SERIE+"-"+(cAlias)->CDC_DOC)
	DbSelectArea("CDC")
	CDC->(DbSetOrder(1))
	If CDC->(!DbSeek( (cAlias)->(CDC_FILIAL+CDC_TPMOV+CDC_DOC+CDC_SERIE+CDC_CLIFOR+CDC_LOJA+CDC_GUIA+CDC_UF) ))
		RecLock("CDC",.T.)
		For nX := 1 To Len(aCampos)
			cCampo := aCampos[nX]
			CDC->&cCampo := (cAlias)->&cCampo
		Next nX
		MsUnlock()
	EndIf
	(cAlias)->( DbSkip() )
End

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

MsgAlert("Foram atualizadas "+cValtochar(nY)+" Notas Fiscais.")

Return

Static Function STFISG1B()

Local cQuery	:= ""
Local cCampo	:= ""
Local cAlias	:= GetNextAlias()
Local aCampos	:= {"F0J_FILIAL","F0J_PER","F0J_LIVRO","F0J_UF","F0J_DTVENC","F0J_VALOR","F0J_GNRE","F0J_TIPO"}
Local nX		:= 0
Local nY		:= 0

cQuery := "SELECT F6_FILIAL F0J_FILIAL, SUBSTR(F6_DTARREC,1,6)||'01' F0J_PER, '*' F0J_LIVRO, F6_EST F0J_UF, F6_DTVENC F0J_DTVENC, F6_VALOR F0J_VALOR, F6_NUMERO F0J_GNRE, '1' F0J_TIPO, SF6.R_E_C_N_O_ REC_SF6 "
cQuery += "FROM "+RetSqlName("SF6")+" SF6 "
cQuery += "LEFT JOIN "+RetSqlName("F0J")+" F0J ON F6_FILIAL = F0J_FILIAL AND F0J_LIVRO = '*' AND F6_EST = F0J_UF AND F6_NUMERO = F0J_GNRE AND F0J.D_E_L_E_T_ = ' ' "
cQuery += "WHERE "
cQuery += "F6_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "F6_DTARREC BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "F6_CODREC IN ('100102','100129') AND "
cQuery += "F6_DOC <> ' ' AND "
cQuery += "F0J_FILIAL IS NULL AND "
cQuery += "SF6.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY F6_FILIAL,F6_EST,F6_NUMERO "

//cQuery := ChangeQuery(cQuery)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

ProcRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

TCSetField(cAlias,"F0J_PER","D",8,0)
TCSetField(cAlias,"F0J_DTVENC","D",8,0)
TCSetField(cAlias,"F0J_VALOR","N",14,2)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	nY++
	IncProc("Atualizando Guia: "+(cAlias)->F0J_GNRE)
	DbSelectArea("F0J")
	F0J->(DbSetOrder(2))
	If F0J->(!DbSeek( (cAlias)->(F0J_FILIAL+DTOS(F0J_PER)+F0J_LIVRO+F0J_UF+F0J_GNRE) ))
		RecLock("F0J",.T.)
		For nX := 1 To Len(aCampos)
			cCampo := aCampos[nX]
			F0J->&cCampo := (cAlias)->&cCampo
		Next nX
		MsUnlock()
	EndIf
	DbSelectArea("SF6")
	SF6->(DbGoTo((cAlias)->REC_SF6))
	If (SF6->F6_CODREC = "100102" .Or. SF6->F6_CODREC = "100129") .And. SF6->F6_TIPOIMP <> "B"
		RecLock("SF6",.F.)
		SF6->F6_TIPOIMP := "B"
		MsUnlock()
	EndIf
	(cAlias)->( DbSkip() )
End

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

MsgAlert("Foram atualizadas "+cValtochar(nY)+" Guias.")

Return

Static Function STFISG1C()

Local cQuery	:= ""
Local cCampo	:= ""
Local cAlias	:= GetNextAlias()
Local aCampos	:= {"F0I_FILIAL","F0I_PER","F0I_LIVRO","F0I_UF","F0I_DEBDIF","F0I_DEBFCP","F0I_DEVDIF","F0I_DIFREC"}
Local nX		:= 0
Local nY		:= 0

cQuery := "SELECT F6_FILIAL F0I_FILIAL, SUBSTR(F6_DTARREC,1,6)||'01' F0I_PER, '*' F0I_LIVRO, F6_EST F0I_UF, "
cQuery += "SUM(CASE WHEN F6_CODREC = '100102' THEN F6_VALOR ELSE 0 END)F0I_DEBDIF, SUM(CASE WHEN F6_CODREC = '100129' THEN F6_VALOR ELSE 0 END)F0I_DEBFCP,"
cQuery += "SUM(F6_VALOR) F0I_DEVDIF, SUM(F6_VALOR) F0I_DIFREC "
cQuery += "FROM "+RetSqlName("SF6")+" SF6 "
cQuery += "INNER JOIN "+RetSqlName("F0J")+" F0J ON F6_FILIAL = F0J_FILIAL AND F0J_LIVRO = '*' AND F6_EST = F0J_UF AND F6_NUMERO = F0J_GNRE AND F0J.D_E_L_E_T_ = ' ' "
cQuery += "WHERE "
cQuery += "F6_FILIAL = '02' AND "
cQuery += "F6_DTARREC BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "F6_CODREC IN ('100102','100129') AND "
cQuery += "F6_DOC <> ' ' AND "
cQuery += "F6_EST NOT IN ('BA','GO','MA','MG','PR','RS','SC','AC','MS',' PA','DF','AM') AND "
cQuery += "SF6.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY F6_FILIAL, F6_EST, SUBSTR(F6_DTARREC,1,6) "
cQuery += "ORDER BY F6_FILIAL,F6_EST "

//cQuery := ChangeQuery(cQuery)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

ProcRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

TCSetField(cAlias,"F0I_PER","D",8,0)
TCSetField(cAlias,"F0I_DEBDIF","N",14,2)
TCSetField(cAlias,"F0I_DEBFCP","N",14,2)
TCSetField(cAlias,"F0I_DEVDIF","N",14,2)
TCSetField(cAlias,"F0I_DIFREC","N",14,2)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	nY++
	IncProc("Atualizando Toalizador: "+(cAlias)->F0I_UF)
	DbSelectArea("F0I")
	F0I->(DbSetOrder(1))
	If F0I->(!DbSeek( (cAlias)->(F0I_FILIAL+DTOS(F0I_PER)+F0I_UF+F0I_LIVRO) ))
		RecLock("F0I",.T.)
	Else
		RecLock("F0I",.F.)
	EndIf
	For nX := 1 To Len(aCampos)
		cCampo := aCampos[nX]
		F0I->&cCampo := (cAlias)->&cCampo
	Next nX
	MsUnlock()
	(cAlias)->( DbSkip() )
End

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

MsgAlert("Foram atualizados "+cValtochar(nY)+" Toalizadores.")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ajusta    ³ Autor ³ Vitor Merguizo 		  ³ Data ³ 16/11/2014		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	³±±
±±³          ³ no SX3                                                           	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ 																		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Filial de ?                  ","Filial de ?                  ","Filial de ?                  ","mv_ch1","C",02,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SM0","S","",""})
Aadd(aPergs,{"Filial ate ?                 ","Filial ate ?                 ","Filial ate ?                 ","mv_ch2","C",02,0,0,"G",""                    ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SM0","S","",""})
Aadd(aPergs,{"Data de ?                    ","Data de ?                    ","Data de ?                    ","mv_ch3","D",08,0,0,"G",""                    ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Data ate ?                   ","Data ate ?                   ","Data ate ?                   ","mv_ch4","D",08,0,0,"G",""                    ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1(cPerg,aPergs)

Return