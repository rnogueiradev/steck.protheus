#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RelAfa   � Autor � R.H. - Reginaldo      � Data � 05.07.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcionarios Afastados                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function RelAfa()

Local cDesc1  := "Funcionarios Afastados "
Local cDesc2  := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := "SRA"                 // alias do arquivo principal (Base)
Local aOrd    := {"Matricula","Nome","C.Custo + Nome"} 
Local aRegs   := {}
//Local cPerg   := "GPER05    " //PROTHEUS 10 
Local cPerg   := "GPER005   " //PROTHEUS 8
//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn := {"Zebrado", 1,"Administra��o", 2, 2, 1, "",1 }	//"Zebrado"###"Administra��o"
Private NomeProg:= "GPER005   "
Private aLinha  := { },nLastKey := 0

//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
Private Titulo
Private AT_PRG   := "GPER005   "
Private wCabec0  := 1
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������

aAdd(aRegs, {cPerg,"01","Data de        "," " ," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs, {cPerg,"02","Data ate       "," " ," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs, {cPerg,"03","Filial de      "," " ," ","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs, {cPerg,"04","Filial ate     "," " ," ","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs, {cPerg,"05","C. Custo de    "," " ," ","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs, {cPerg,"06","C. Custo ate   "," " ," ","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs, {cPerg,"07","Categorias     "," " ," ","mv_ch7","C",12,0,0,"G","fCategoria","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(aRegs)


pergunte(cPerg,.F.)

cTit   := " Funcionarios Afastados "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER005   "            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem     := aReturn[8]
dDataDe    := mv_par01
dDataAte   := mv_par02
cFilDe     := mv_par03
cFilAte    := mv_par04
cCcde      := mv_par05
cCcate     := mv_par06
cCategoria := mv_par07

wCabec1  := "Fl C.C.   Matricula   Nome                            Inicio     Retorno   Motivo Afastamento            Salario"
Titulo   := " Relacao de Funcionarios Afastados de " + Dtoc(dDatade) + " a " + Dtoc(dDataAte)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| GR210Imp(@lEnd,wnRel,cString)},titulo)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER210  � Autor � R.H. - Reginaldo      � Data � 24.05.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcionarios Admitidos   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � GPR210Imp(lEnd,wnRel,cString)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GR210Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local CbTxt //Ambiente
Local CbCont
Local lAceita := .F.
Local nx := 0
Local otable
/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/

If nOrdem == 1
   cOrdem := "RA_FILIAL,RA_MAT"
ElseIf nOrdem == 2
   cOrdem := "RA_FILIAL,RA_NOME"
ElseIf nOrdem == 3
   cOrdem := "RA_FILIAL,RA_CC,RA_NOME"
Endif

cCat := "("
For nx := 1 to Len(cCategoria)
   If Substr(cCategoria,nx,1) != "*"
	   If cCat == "("
    	  cCat += "'"
	   Else
    	  cCat += "','"
	   EndIF
	   cCat += Substr(cCategoria,nx,1)
	EndIF   
Next
cCat += "')"

cQuery_ := "SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC,RA_CATFUNC,R8_DATAINI,R8_DATAFIM,RA_SALARIO,RJ_DESC,R8_TIPO " "
cQuery_ += " FROM " + RETSQLNAME("SRA") + "," + RETSQLNAME("SRJ") + "," + RETSQLNAME("SR8")
cQuery_ += " WHERE RA_FILIAL >= '" + cFilDe +"' AND RA_FILIAL <= '"+cFilAte+"'"
cQuery_ += " AND RA_CC >= '" +cCcde+ "' AND RA_CC <= '" +cCcate+ "'"
cQuery_ += " AND RA_CATFUNC IN"+cCat
cQuery_ += " AND RA_FILIAL = R8_FILIAL AND RA_MAT = R8_MAT AND R8_TIPO <> 'F' "
cQuery_ += " AND R8_DATAINI <= '"+ Dtos(dDataAte) + "' AND ( R8_DATAFIM = '        ' OR R8_DATAFIM >= '"+Dtos(dDataDe)+"')"
cQuery_ += " AND R8_TIPO <> 'F' "
cQuery_ += " AND RA_CODFUNC = RJ_FUNCAO "
cQuery_ += " AND " + RETSQLNAME("SRA") + ".D_E_L_E_T_ = ' ' " 
cQuery_ += " ORDER BY " + cOrdem
cQuery_ := CHANGEQUERY(cQuery_)

_cArqTrb := CriaTrab(nil, .f.)
IF Select("SRANEW")>0
   DbSelectArea("SRANEW")
   DbCloseArea()
ENDIF

tcQuery cQuery_ NEW ALIAS "SRANEW"

dbSelectArea("SRANEW")
dbGoTop()
//COPY TO &(_cArqTrb+OrdBagExt())
oTable := FWTemporaryTable():New(_cArqTrb+OrdBagExt()) //adicionado - 12/05/23 - "copy to" descontinuado
oTable:Create()
dbCloseArea()
dbUseArea(.T.,"TOPCONN",_cArqTrb+OrdBagExt(),"SRANEW",.T.) //alterado - 12/05/23 - dbUseArea(.T.,,_cArqTrb+OrdBagExt(),"SRANEW",.T.)

dbSelectArea("SRANEW")
dbGoTop()
nTot := 0
Set Century on
SetRegua(SRANEW->(RecCount()))
While	!EOF()
	
	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
	IncRegua()
	
	//��������������������������������������������������������������Ŀ
	//� Cancela Impres�o ao se pressionar <ALT> + <A>                �
	//����������������������������������������������������������������
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	
	If !(SRANEW->RA_FILIAL $ fValidFil()) 
		dbSkip()
		Loop
	EndIf
	
	
   If SRANEW->R8_TIPO = 'Q'
       cMotivo := 'Licenca Gestante          '
   elseIf SRANEW->R8_TIPO = 'P'
       cMotivo := 'Auxilio Doenca            '
   elseIf SRANEW->R8_TIPO = 'O'                                   
       cMotivo := 'Acidente de Trabalho      '
   elseIf SRANEW->R8_TIPO = 'R'                                   
       cMotivo := 'Servico Militar           '
   elseIf SRANEW->R8_TIPO = 'V'                                   
       cMotivo := 'Aposentadoria sem Rescisao'
   elseIf SRANEW->R8_TIPO = 'W'                                   
       cMotivo := 'Mandato Sindical          '
   elseIf SRANEW->R8_TIPO = 'X'                                   
       cMotivo := 'Licenca sem Vencimentos   '
   Else
       cMotivo := 'Outros Motivos            '       
   EndIF
       
  
    cDet :=  sranew->ra_filial  + " " + SRANEW->RA_CC+" "+sranew->ra_mat     + "  " + sranew->ra_nome + " "
    cDet +=  TRansform(STOD(SRANEW->R8_DATAINI),"@R 99/99/9999") + "  " +TRansform(STOD(SRANEW->R8_DATAFIM),"@R 99/99/9999") + "  " + cMotivo  + "" + TRansform(SRANEW->RA_SALARIO,"@E 99,999.99") 
    Impr(cDet)

    dbSkip()
    nTot ++

Enddo
Set Century off
Impr("")
Impr("Total de Funcionario " + Transform(nTot, "9999") )
Impr("","P")

//��������������������������������������������������������������Ŀ
//� Termino do relatorio                                         �
//����������������������������������������������������������������

DbSelectArea("SRANEW")
DbCloseArea()
//Ferase(_cArqTrb+OrdBagExt())
otable:DELETE()

DbSelectarea("SRA")
Set filter to
RetIndex("SRA")
DbGoTop()

Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

Static FUNCTION AjustaSx1(_aPerg)

Local _n,_aCampos,_nLimite,_x

DbSelectArea("SX1")
DbSetOrder(1)

//�����������������������������������������������������������Ŀ
//� Armazena a estrutura do arquivo de perguntas SX1 no array �
//�������������������������������������������������������������
_aCampos := DbStruct()


//������������������������������������������������������������Ŀ
//� Estabelece o limite para a grava��o do registro pelo menor �
//� valor obtido entre a compara��o da estrutura do arquivo e  �
//� a dimens�o da linha do array enviado como par�metro        �
//��������������������������������������������������������������
_nLimite := Iif(Len(_aPerg[1])<Len(_aCampos), Len(_aPerg[1]), Len(_aCampos))

FOR _n:=1 TO Len(_aPerg)
	//�������������������������������������������������������������
	//� Verifica se o registro da pergunta j� n�o est� cadastrado �
	//�������������������������������������������������������������
	IF !DbSeek(_aPerg[_n, 1] + _aPerg[_n, 2], .f.)
		//�����������������������������������������������������������Ŀ
		//� Caso n�o esteja cadastrado, cria registro novo e grava os �
		//� campos com base nos dados do array passado como par�metro �
		//�������������������������������������������������������������
		RecLock("SX1", .T.)
			FOR _x:=1 TO _nLimite
				FieldPut(FieldPos(_aCampos[_x, 1]), _aPerg[_n, _x])
			NEXT
		MsUnlock()
	ENDIF
NEXT

RETURN
