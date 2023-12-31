#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �   DEPEN  � Autor �                       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Listagem de Dependentes                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para                                            ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
���            �        �      �                                          ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function Depen()

// Declaracao de variaveis private
SetPrvt("cString,aOrd,cDesc1,cDesc2,cDesc3,nLastKey,cPerg,nomeprog,Titulo,cNomRel")
SetPrvt("wCabec1,wCabec2,Tamanho,m_pag,li,ContFl,aReturn,nOrdem,lEnd,cCancel")
SetPrvt("aSavRA_,aSavRB_,cInic_,cFim_,cSit_,cDepIR_,cDepSF_,cFilMat_,nTot_,nTotIR_")
SetPrvt("nTotSF_,nTotg_,nTotIRg_,nTotSFg_,nTotF_")

//Inicializacao das Variaveis
cString   := 'SRB' //-- Alias do arquivo principal (Base).
aOrd      := {'Matricula','C.Custo','Nome'} //-- Ordem
cDesc1    := 'Emiss�o de Relatorio de Dependentes.'
cDesc2    := 'Ser� impresso de acordo com os parametros solicitados pelo'
cDesc3    := 'usuario.'
nLastKey  := 0
cPerg     := 'DEP001'
nomeprog  := 'DEPEND'
Titulo    := 'RELATORIO DE DEPENDENTES'
cNomRel   := 'Relatorio de Dependentes'
wCabec1   := " Matr     Nome do Funcionario "
wCabec2   := "Seq. Nome do Dependente             Parent. Sexo Dt.Nasc.  Dep.IR    Dep.S.Fam"
Tamanho   := 'P'
m_pag     := 0
li        := 0
ContFl    := 1
aReturn   := { 'Zebrado', 1,'Administra��o', 2, 2, 1, '',1 }
nOrdem    := 0
lEnd      := .F.
cCancel   := "***** CANCELADO PELO OPERADOR *****"

//��������������������������������������������������������������Ŀ
//� Define Variaveis Basicas Programa                            �
//����������������������������������������������������������������
aSavRA_   := {}
aSavRB_   := {}
cInic_    := ''
cFim_     := ''
cSit_     := ''
cDepIR_   := ''
cDepSF_   := ''
cFilMat_  := ''
nTot_     := 0
nTotIR_   := 0
nTotSF_   := 0
nTotF_	  := 0
nTotg_    := 0
nTotIRg_  := 0
nTotSFg_  := 0

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
VerPerg()
Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//�mv_par01 - Filial de                                          �
//�mv_par02 - Filial Ate                                         �
//�mv_par03 - Centro de Custo de                                 �
//�mv_par04 - Centro de Custo Ate                                �
//�mv_par05 - Matricula de                                       �
//�mv_par06 - Matricula Ate                                      �
//�mv_Par07 - Nome de Funcionario de                             �
//�mv_Par08 - Nome de Funcionario ate                            �
//�mv_par09 - Situa�ao na folha                                  �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
WnRel := 'DEPEND' //-- Nome Default do relatorio em Disco.
WnRel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return Nil
Endif

//Ordem
nOrdem := aReturn[8]

//Salva Ambiente
aSavRB_ := SRB->(GetArea())
SRB->(dbSetOrder(1))

aSavRA_ := SRA->(GetArea())
SRA->(dbSetOrder(nOrdem))

// Chamada da Funcao
RptStatus({|lEnd| fRB_Imp(@lEnd)},"Aguarde...","Imprimindo Registros...",.T.)  //-- Chamada do Relatorio.

// Chama o Spool de Impressao para impressoes em Disco                        �
If aReturn[5]==1
   Set Print to
   dbCommitAll()
   OurSpool(wnrel)
EndIf

// Libera o relatorio para Spool da Rede 
MS_FLUSH()

//Retorna Ambiente
SRA->(RestArea(aSavRA_))
SRB->(RestArea(aSavRB_))

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Funcao   � fRB_Imp  � Autor �                       � Data � 28.10.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Impressao                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fRB_Imp()

// Carregando Variaveis
FilialDe  := mv_par01
FilialAte := mv_par02
CcDe      := mv_par03
CcAte     := mv_par04
MatDe     := mv_par05
MatAte    := mv_par06
NomDe     := mv_par17
NomAte    := mv_par18
cSit_     := mv_par09

// Selecionando o Primeiro Registro e montando Filtro.
If nOrdem == 1
	SRA->(dbSeek(FilialDe + MatDe,.T.))
        cInic_ := 'SRA->RA_FILIAL + SRA->RA_MAT'
        cFim_  := FilialAte + MatAte
ElseIf nOrdem == 2
	SRA->(dbSeek(FilialDe + CcDe + MatDe,.T.))
        cInic_  := 'SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT'
        cFim_   := FilialAte + CcAte + MatAte
ElseIf nOrdem == 3
	SRA->(dbSeek(FilialDe + NomDe + MatDe,.T.))
        cInic_ := 'SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT'
        cFim_  := FilialAte + NomAte + MatAte
End

//Carrega Regua
SetRegua(SRA->(RecCount()))

While SRA->(!EOF()) .And. &cInic_ <= cFim_ .And. !lEnd
	
    // Movimenta Regua Processamento
	IncRegua()  //-- Move a regua.

  	//Abortado Pelo Operador
	If lAbortPrint
		lEnd := .T.
	Endif

	If lEnd
		cDet := cCancel
		Impr(cDet,'C')
		Loop
	EndIF			

        //-- Despreza registros conforme situacao.
    If ! SRA->RA_SITFOLH $ cSit_
		SRA->(dbSkip())
		Loop
	Endif

    cFilMat_ := SRA->RA_FILIAL + SRA->RA_MAT

    If SRB->(dbSeek(cFilMat_),Found())
    	
		GravFun()
		nTotF_ += 1
                
		While SRB->(!Eof()) .And. SRB->RB_FILIAL + SRB->RB_MAT == cFilMat_

			GravDep()
			nTot_ += 1

			If SRB->RB_TIPIR $ "123"
				nTotIR_ += 1
			End

			If SRB->RB_TIPSF $ "12"
				nTotSF_ += 1
			End

			SRB->(dbSkip())
    	End
	Else

		SRA->(dbSkip())
		Loop           
		
	End

	ImpTot()

	// Zera Variaveis
	nTot_     := 0
	nTotIR_   := 0
	nTotSF_   := 0

	SRA->(dbSkip())

End

ImpTotg()

cDet := " "
Impr(cDet,"F")

Return

// Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Funcao   � GravFun  � Autor �                       � Data � 28.10.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Impressao                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GravFun

cDet := SRA->RA_MAT + " - " + SRA->RA_NOME

Impr(cDet,"C")

Return

// Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Funcao   � GravDep  � Autor �                       � Data � 28.10.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Impressao                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GravDep

// Dependente de IR
If SRB->RB_TIPIR == '1'
        cDepIR_ := 'S/Limite   '
ElseIf SRB->RB_TIPIR == '2'
        cDepIR_ := 'Ate 21 Anos'
ElseIf SRB->RB_TIPIR == '3'
        cDepIR_ := 'Ate 24 Anos'
ElseIf SRB->RB_TIPIR == '4'
        cDepIR_ := 'Nao Depend.'
End

// Dependente de Sal.Familia
If SRB->RB_TIPSF == '1'
        cDepSF_ := 'S/Limite   '
ElseIf SRB->RB_TIPSF == '2'
        cDepSF_ := 'Ate 14 Anos'
ElseIf SRB->RB_TIPSF == '3'
        cDepSF_ := 'Nao Depend.'
End

// Grau de Parentensco
If SRB->RB_GRAUPAR == 'C'
        cPar_ := 'Conjuge '
ElseIf SRB->RB_GRAUPAR == 'F'
        cPar_ := 'Filho(a)'
ElseIf SRB->RB_GRAUPAR == 'O'
        cPar_ := 'Outros  '
ElseIf SRB->RB_GRAUPAR == 'E'
        cPar_ := 'Enteado '
ElseIf SRB->RB_GRAUPAR == 'P'
        cPar_ := 'Pai/Mae '

End

cDet :=  SRB->RB_COD + " "
cDet += SubStr(SRB->RB_NOME + Space(30),1,33)
cDet += cPar_ + " "
cDet += SRB->RB_SEXO + "  "
cDet += dToc(SRB->RB_DTNASC) + " "
cDet += cDepIR_ + " "
cDet += cDepSF_

Impr(cDet,"C")

Return

// Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Funcao   �  ImpTot  � Autor �                       � Data � 28.10.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Impressao                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function ImpTot
                      
nTotg_     += nTot_
nTotIRg_   += nTotIR_
nTotSFg_   += nTotSF_

cDet := "Totais...                           "
cDet += Transform(nTot_,'@E 99,999') + "               "
cDet += Transform(nTotIR_,'@E 99,999') + "    "
cDet += Transform(nTotSF_,'@E 99,999')

Impr(cDet,"C")

cDet := " "
Impr(cDet,"C")

Return

// Fim da Rotina


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Funcao   �  ImpTotg � Autor �                       � Data � 28.10.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Impressao                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function ImpTotg()
                         
cDet := " "
Impr(cDet,"C")
                      
cDet := "Totais Gerais "
Impr(cDet,"C")

cDet := "Funcionarios " + Transform(nTotF_,'@E 99,999') 
cDet += "  Dependentes " + Transform(nTotg_,'@E 99,999')
cDet += "  Dep. IR " + Transform(nTotIRg_,'@E 99,999')
cDet += "  Dep. Sal.Fam. " + Transform(nTotSFg_,'@E 99,999')

Impr(cDet,"C")

Return

// Fim da Rotina
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ValidPerg    � Autor � Fernando Joly     � Data � 15.06.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas, Incluindo-as caso n�o existam       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function VerPerg()

aRegs     := {}

cPerg := Left(cPerg,6)

//X1_GRUPO,X1_ORDEM,X1_PERGUNT,X1_PERSPA,X1_PERENG,X1_VARIAVL,X1_TIPO,X1_TAMANHO,X1_DECIMAL,X1_PRESEL,X1_GSC,X1_VALID,X1_VAR01,X1_DEF01,X1_DEFSPA1,X1_DEFENG1,X1_CNT01,X1_VAR02,X1_DEF02,X1_DEFSPA2,X1_DEFENG2,X1_CNT02,X1_VAR03,X1_DEF03,X1_DEFSPA3,X1_DEFENG3,X1_CNT03,X1_VAR04,X1_DEF04,X1_DEFSPA4,X1_DEFENG4,X1_CNT04,X1_VAR05,X1_DEF05,X1_DEFSPA5,X1_DEFENG5,X1_CNT05,X1_F3,X1_PYME,X1_GRPSXG,X1_HELP  
aAdd(aRegs,{cPerg,"01","Da Filial          ?","Da Filial          ?","Da Filial          ?","mv_ch1","C",02,0,0,"G","naovazio","mv_par01","","","","01","","","","","","","","","","","","","","","","","","","","","SM0","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Filial       ?","Ate a Filial       ?","Ate a Filial       ?","mv_ch2","C",02,0,0,"G","naovazio","mv_par02","","","","99","","","","","","","","","","","","","","","","","","","","","SM0","","",""})
aAdd(aRegs,{cPerg,"03","Do Centro Custo    ?","Do Centro de Custo ?","Do Centro de Custo ?","mv_ch3","C",09,0,0,"G","naovazio","mv_par03","","","","000000001","","","","","","","","","","","","","","","","","","","","","SI3","","",""})
aAdd(aRegs,{cPerg,"04","At� Centro de Custo?","At� Centro de Custo?","At� Centro de Custo?","mv_ch4","C",09,0,0,"G","naovazio","mv_par04","","","","999999999","","","","","","","","","","","","","","","","","","","","","SI3","","",""})
aAdd(aRegs,{cPerg,"05","Da Matricula       ?","Da Matricula       ?","Da Matricula       ?","mv_ch5","C",06,0,0,"G","naovazio","mv_par05","","","","000001","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{cPerg,"06","Ate Matricula      ?","Ate Matricula      ?","Ate Matricula      ?","mv_ch6","C",06,0,0,"G","naovazio","mv_par06","","","","999999","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{cPerg,"07","Nome De            ?","Nome De            ?","Nome De            ?","mv_ch7","C",30,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{cPerg,"08","Nome Ate           ?","Nome Ate           ?","Nome Ate           ?","mv_ch8","C",30,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{cPerg,"09","Situacao           ?","Situacao           ?","Situacao           ?","mv_ch9","C",09,0,0,"G","fSituacao","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg ,.F.)

Return

// Fim da Rotina

// Fim do Programa