#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_STGPE013()

Relatorio Salary Review     

@type function
@author Everson Santana
@since 22/02/2021
@version Protheus 12 - SigaGpe

@history ,Ticket 20200826006370 ,

/*/

User Function STGPE013()
	/*
	Declaracao de variaveis
	*/
    Private _oReport := Nil
    Private _oSecCab := Nil
    Private _cPerg 	 := PadR ("STGPE013", Len (SX1->X1_GRUPO))
    Private _cTipo	 := ""
    Private _cTitulo := ""
    Private _oBreak

    Private _cGpe013	:= GetMV( 'ST_GPE013', , "001036#000975" )

    If !(__cuserid $ _cGpe013)
        MsgInfo("Usuario sem acesso")
        Return()
    EndIf

    ValidPerg()

	/*
	Definicoes/preparacao para impressao
	*/
    ReportDef()
    _oReport:PrintDialog()

Return
/*
Definição da estrutura do relatório.
*/
Static Function ReportDef()

    _cTitulo := "Relatorio Salary Review"

    _oReport := TReport():New("STGPE013"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

    Pergunte("STGPE013",.F.)

    _oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

    TRCell():New( _oSecCab, "ZS2_CODSOL"	,,RetTitle("ZS2_CODSOL")	,PesqPict('ZS2',"ZS2_CODSOL")	,TamSX3("ZS2_CODSOL")[1]	,.F.,)//01
    TRCell():New( _oSecCab, "ZS2_DATEMI"	,,RetTitle("ZS2_DATEMI")	,PesqPict('ZS2',"ZS2_DATEMI")	,TamSX3("ZS2_DATEMI")[1]	,.F.,)//02
    TRCell():New( _oSecCab, "ZS2_MATFIL"	,,RetTitle("ZS2_MATFIL") 	,PesqPict('ZS2',"ZS2_MATFIL")	,TamSX3("ZS2_MATFIL")[1]	,.F.,)//03
    TRCell():New( _oSecCab, "ZS2_MATFUN"    ,,RetTitle("ZS2_MATFUN") 	,PesqPict('ZS2',"ZS2_MATFUN")	,TamSX3("ZS2_MATFUN")[1]	,.F.,)//04
    TRCell():New( _oSecCab, "RA_NOME"       ,,RetTitle("RA_NOME") 	    ,PesqPict('SRA',"RA_NOME")	    ,TamSX3("RA_NOME")[1]	    ,.F.,)//04
    TRCell():New( _oSecCab, "RA_DEPTO"      ,,RetTitle("RA_DEPTO") 	    ,PesqPict('SRA',"RA_DEPTO")	    ,TamSX3("RA_DEPTO")[1]	    ,.F.,)//04
    TRCell():New( _oSecCab, "QB_DESCRIC"    ,,RetTitle("QB_DESCRIC") 	,PesqPict('SQB',"QB_DESCRIC")	,TamSX3("QB_DESCRIC")[1]	,.F.,)//04
    TRCell():New( _oSecCab, "ZS2_SALARI"    ,,RetTitle("ZS2_SALARI") 	,PesqPict('ZS2',"ZS2_SALARI")	,TamSX3("ZS2_SALARI")[1]	,.F.,)//05
    TRCell():New( _oSecCab, "ZS2_SALPER"    ,,RetTitle("ZS2_SALPER")    ,PesqPict('ZS2',"ZS2_SALPER")	,TamSX3("ZS2_SALPER")[1]	,.F.,)//06
    TRCell():New( _oSecCab, "ZS2_SALALT"	,,RetTitle("ZS2_SALALT")    ,PesqPict('ZS2',"ZS2_SALALT")	,TamSX3("ZS2_SALALT")[1]    ,.F.,)//07
    TRCell():New( _oSecCab, "ZS2_SALATU"	,,RetTitle("ZS2_SALATU")    ,PesqPict('ZS2',"ZS2_SALATU")	,TamSX3("ZS2_SALATU")[1]    ,.F.,)//07
    TRCell():New( _oSecCab, "ZS2_MOTALT"	,,RetTitle("ZS2_MOTALT")    ,PesqPict('ZS2',"ZS2_MOTALT")	,TamSX3("ZS2_MOTALT")[1]    ,.F.,)//08
    TRCell():New( _oSecCab, "ZS2_DATDES"	,,RetTitle("ZS2_DATDES")    ,PesqPict('ZS2',"ZS2_DATDES")	,TamSX3("ZS2_DATDES")[1]    ,.F.,)//09
    TRCell():New( _oSecCab, "ZS2_DATEFE"	,,RetTitle("ZS2_DATEFE")    ,PesqPict('ZS2',"ZS2_DATEFE")	,TamSX3("ZS2_DATEFE")[1]    ,.F.,)//10
    TRCell():New( _oSecCab, "ZS2_OBSGES"	,,RetTitle("ZS2_OBSGES")    ,PesqPict('ZS2',"ZS2_OBSGES")	,TamSX3("ZS2_OBSGES")[1]    ,.F.,)//11
    TRCell():New( _oSecCab, "ZS2_OBSREC"	,,RetTitle("ZS2_OBSREC")    ,PesqPict('ZS2',"ZS2_OBSREC")	,TamSX3("ZS2_OBSREC")[1]    ,.F.,)//12
    TRCell():New( _oSecCab, "ZS2_OBSPRE"	,,RetTitle("ZS2_OBSPRE")    ,PesqPict('ZS2',"ZS2_OBSPRE")	,TamSX3("ZS2_OBSPRE")[1]    ,.F.,)//13
    TRCell():New( _oSecCab, "ZS2_STATRG"	,,RetTitle("ZS2_STATRG")    ,PesqPict('ZS2',"ZS2_STATRG")	,TamSX3("ZS2_STATRG")[1]    ,.F.,)//14
    TRCell():New( _oSecCab, "ZS2_DESCST"	,,"Desc Status"             ,"@!"	                        ,30                         ,.F.,)//14
    TRCell():New( _oSecCab, "ZS2_FUNCAO"	,,"Cod. Função Antiga"      ,PesqPict('ZS2',"ZS2_FUNCAO")	,TamSX3("ZS2_FUNCAO")[1]    ,.F.,)//16
    TRCell():New( _oSecCab, "RJ_DESC"	    ,,"Desc. Função Antiga"     ,PesqPict('ZS2',"RJ_DESC")	    ,TamSX3("RJ_DESC")[1]       ,.F.,)//16
    TRCell():New( _oSecCab, "ZS2_DESFUN"	,,"Desc. Função Nova"       ,PesqPict('ZS2',"ZS2_DESFUN")	,TamSX3("ZS2_DESFUN")[1]    ,.F.,)//15

Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

    Local _oSecCab      := _oReport:Section(1)
    Local _cQuery1      := ""
    Local aStats        := {} // Status

    // Gestor    {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
    aAdd(aStats, {    "A1", "-> Incluir Solicitacao (Gestor)"                                             ,  "", "Cinza Padrao",     "A2", {      "",            "",             "" } })
    aAdd(aStats, {    "A2", "Solicitacao incluida (Gestor)"                                               ,  "", "Verde Claro",      "A2", {    "A3",            "",             "" } })
    aAdd(aStats, {    "A3", "-> Enviar Solicitacao para Analise (Gestor -> Recursos Humanos)"             ,  "", "Verde Escuro", /*"B1"*/"B3", {    "A6",            "",             "" } })
    aAdd(aStats, {    "A4", "Solicitacao Reprovada (Recursos Humanos/Presidencia)"                        ,  "", "Vermelho	Claro",   "A4", {    "A5",            "",             "" } })
    aAdd(aStats, {    "A5", "-> Reavaliar Solicitacao Reprovada (Gestor)"                                 ,  "", "Vermelho Claro",   "A2", {    "A4",            "",             "" } })
    aAdd(aStats, {    "A6", "-> Abandonar Solicitacao (Gestor)"                                           ,  "", "Roxo	Claro",       "A9", {    "A2",            "",             "" } })
    aAdd(aStats, {    "A7", "-> Retornar Solicitacao (Recursos Humanos -> Gestor)"                        ,  "", "Laranja Claro",    "A2", {    "B1",            "",             "" } })
    aAdd(aStats, {    "A8", "-> Retornar Solicitacao Abandonada (Gestor)"                                 ,  "", "Laranja Claro",    "A2", {    "A9",            "",             "" } })
    aAdd(aStats, {    "A9", "Solicitacao Abandonada (Gestor)"                                             ,  "", "Roxo Claro",       "A9", {    "A8",            "",             "" } })
    // RecsHuman {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
    aAdd(aStats, {    "B1", "Solicitacao Aguardando Analise (Recursos Humanos)"                           ,  "", "Amarelo Claro", /*"B1"*/ "B3", {    "A7",          "B2",             "" } })
    aAdd(aStats, {    "B2", "-> Analisar Solicitacao (Recursos Humanos)"                                  ,  "", "Amarelo Escuro",   "B3", {      "",          "B1",             "" } })
    aAdd(aStats, {    "B3", "Solicitacao em Analise (Recursos Humanos)"                                   ,  "", "Azul Esverd Claro","B3", {      "",          "B6",             "" } })
    aAdd(aStats, {    "B4", "Solicitacao Reprovada (Presidencia)"                                         ,  "", "Vermelho Escuro",  "B4", {      "",          "B5",             "" } })
    aAdd(aStats, {    "B5", "-> Reprovar Solicitacao (Recursos Humanos/Presidencia -> Gestor)"            ,  "", "Vermelho Claro",   "A4", {      "",          "B9",             "" } })
    aAdd(aStats, {    "B6", "-> Aprovar Solicitacao (Recursos Humanos -> Presidencia)"                    ,  "", "Azul Claro", /*"C1"*/ "C3", {      "",          "B8",             "" } })
    aAdd(aStats, {    "B7", "-> Retornar Solicitacao (Presidencia -> Recursos Humanos)"                   ,  "", "Laranja Claro",    "B3", {      "",          "C1",             "" } })
    aAdd(aStats, {    "B8", "-> Reprovar Solicitacao (Recursos Humanos -> Gestor)"                        ,  "", "Vermelho	Claro",   "A4", {      "",          "B3",             "" } })
    aAdd(aStats, {    "B9", "-> Reanalisar Solicitacao (Recursos Humanos)"                                ,  "", "Laranja Claro",    "B3", {      "",          "B4",             "" } })
    // Presidenc {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
    aAdd(aStats, {    "C1", "Solicitacao Aguardando Analise (Presidencia)"                                ,  "", "Azul Claro", /*"C1"*/"C3", {      "",          "B7",           "C2" } })
    aAdd(aStats, {    "C2", "-> Analisar Solicitacao (Presidencia)"                                       ,  "", "Azul Mais Escuro", "C3", {      "",            "",           "C1" } })
    aAdd(aStats, {    "C3", "Solicitacao em Analise (Presidencia)"                                        ,  "", "Cinza Amarelado",  "C3", {      "",            "",           "C5" } })
    aAdd(aStats, {    "C4", "-> Reprovar Solicitacao (Presidencia)"                                       ,  "", "Cinza Averm Claro","B4", {      "",            "",           "C3" } })
    aAdd(aStats, {    "C5", "-> Aprovar Solicitacao (Presidencia -> Recursos Humanos)"                    ,  "", "Cinza Esver Claro","D1", {      "",            "",           "C4" } })
    aAdd(aStats, {    "C9", "-> Reanalisar Solicitacao (Presidencia)"                                     ,  "", "Laranja Claro",    "C3", {      "",            "",           "D1" } })
    // RecsHuman {  Status, Descricao Status                                                              ,    Cores, Descricao Cor,      Grvs, {  Gestor, Recur Humanos,    Presidencia } }
    aAdd(aStats, {    "D1", "Solicitacao Aprovada (Presidencia)"                                          ,  "", "Verde Claro",      "D1", {      "",          "D2",           "C9" } })
    aAdd(aStats, {    "D2", "-> Processar Alteracao Salarial (Recursos Humanos)"                          ,  "", "Roxo Claro",       "D3", {      "",          "D1",             "" } })
    aAdd(aStats, {    "D3", "Alteracao Salarial Processada (Recursos Humanos)"                            ,  "", "Azul Claro",       "D3", {      "",            "",             "" } })


    _cQuery1 := " "
    _cQuery1 += " SELECT ZS2_FILIAL, "
    _cQuery1 += "       ZS2_CODSOL, "
    _cQuery1 += "       ZS2_DATEMI, "
    _cQuery1 += "       ZS2_MATFIL, "
    _cQuery1 += "       ZS2_MATFUN, "
    _cQuery1 += "       SRA.RA_NOME, "
    _cQuery1 += "       SRA.RA_DEPTO, "
    _cQuery1 += "       SQB.QB_DESCRIC, "
    _cQuery1 += "       ZS2_SALARI, "
    _cQuery1 += "       ZS2_SALPER, "
    _cQuery1 += "       ZS2_SALALT, "
    _cQuery1 += "       ZS2_SALATU, "
    _cQuery1 += "       ZS2_MOTALT, "
    _cQuery1 += "       ZS2_DATDES, "
    _cQuery1 += "       ZS2_DATEFE, "
    _cQuery1 += "       utl_raw.cast_to_varchar2(dbms_lob.substr(ZS2_OBSGES)) ZS2_OBSGES, "
    _cQuery1 += "       utl_raw.cast_to_varchar2(dbms_lob.substr(ZS2_OBSREC)) ZS2_OBSREC, "
    _cQuery1 += "       utl_raw.cast_to_varchar2(dbms_lob.substr(ZS2_OBSPRE)) ZS2_OBSPRE, "
    _cQuery1 += "       ZS2_STATRG, "
    _cQuery1 += "       ZS2_FUNCAO, "
    _cQuery1 += "       SRJ.RJ_DESC, "
    _cQuery1 += "       ZS2_DESFUN "
    _cQuery1 += "       FROM "+RetSqlName("ZS2")+" ZS2 "
    _cQuery1 += " LEFT JOIN "+RetSqlName("SRA")+" SRA"
    _cQuery1 += "    ON SRA.RA_FILIAL = ZS2.ZS2_MATFIL "
    _cQuery1 += "        AND SRA.RA_MAT = ZS2.ZS2_MATFUN "
    _cQuery1 += "        AND SRA.D_E_L_E_T_ = ' ' "
    _cQuery1 += " LEFT JOIN "+RetSqlName("SQB")+" SQB "
    _cQuery1 += "    ON SQB.QB_FILIAL = ' ' "
    _cQuery1 += "        AND SQB.QB_DEPTO = SRA.RA_DEPTO "
    _cQuery1 += "        AND SQB.D_E_L_E_T_ = ' ' "
    _cQuery1 += " LEFT JOIN "+RetSqlName("SRJ")+" SRJ "
    _cQuery1 += "    ON SRJ.RJ_FILIAL = ' ' "
    _cQuery1 += "        AND SRJ.RJ_FUNCAO = ZS2.ZS2_FUNCAO "
    _cQuery1 += "        AND SRJ.D_E_L_E_T_ = ' ' "
    _cQuery1 += " WHERE ZS2_MATFIL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
    _cQuery1 += "   AND ZS2_MATFUN BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
    _cQuery1 += "   AND RA_DEPTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

    If MV_PAR07 <> 2 //So efetivados
        _cQuery1 += "   AND SubStr(ZS2_DATEFE,1,4) = '"+MV_PAR08+"' "
        _cQuery1 += "   AND SubStr(ZS2_DATEFE,5,2) = '"+MV_PAR09+"' "
    else
        _cQuery1 += "   AND SubStr(ZS2_DATEMI,1,4) = '"+MV_PAR08+"' "
        _cQuery1 += "   AND SubStr(ZS2_DATEMI,5,2) = '"+MV_PAR09+"' "
    EndIf
    _cQuery1 += "   AND ZS2.D_E_L_E_T_ = ' ' "

    If Select("QRG") > 0
        Dbselectarea("QRG")
        QRG->(DbClosearea())
    EndIf

    TcQuery _cQuery1 New Alias "QRG"

    dbSelectArea("QRG")
    QRG->(dbGoTop())

    While !QRG->(Eof())
        _oSecCab:Init()

        _oSecCab:Cell("ZS2_CODSOL"):SetValue(QRG->ZS2_CODSOL)
        _oSecCab:Cell("ZS2_DATEMI"):SetValue(Stod(QRG->ZS2_DATEMI))
        _oSecCab:Cell("ZS2_MATFIL"):SetValue(QRG->ZS2_MATFIL)
        _oSecCab:Cell("ZS2_MATFUN"):SetValue(QRG->ZS2_MATFUN)
        _oSecCab:Cell("RA_NOME"):SetValue(QRG->RA_NOME)
        _oSecCab:Cell("RA_DEPTO"):SetValue(QRG->RA_DEPTO)
        _oSecCab:Cell("QB_DESCRIC"):SetValue(QRG->QB_DESCRIC)
        _oSecCab:Cell("ZS2_SALARI"):SetValue(QRG->ZS2_SALARI)
        _oSecCab:Cell("ZS2_SALPER"):SetValue(QRG->ZS2_SALPER)
        _oSecCab:Cell("ZS2_SALALT"):SetValue(QRG->ZS2_SALALT)
        _oSecCab:Cell("ZS2_SALATU"):SetValue(QRG->ZS2_SALATU)
        _oSecCab:Cell("ZS2_MOTALT"):SetValue(QRG->ZS2_MOTALT)
        _oSecCab:Cell("ZS2_DATDES"):SetValue(Stod(QRG->ZS2_DATDES))
        _oSecCab:Cell("ZS2_DATEFE"):SetValue(Stod(QRG->ZS2_DATEFE))
        _oSecCab:Cell("ZS2_OBSGES"):SetValue(QRG->ZS2_OBSGES)
        _oSecCab:Cell("ZS2_OBSREC"):SetValue(QRG->ZS2_OBSREC)
        _oSecCab:Cell("ZS2_OBSPRE"):SetValue(QRG->ZS2_OBSPRE)
        _oSecCab:Cell("ZS2_STATRG"):SetValue(QRG->ZS2_STATRG)

        nPosS := 0
        xRet := ""
        If (nPosS := ASCan(aStats, {|x|, x[01] == QRG->ZS2_STATRG })) > 0 // Localizando Status
            xRet := aStats[nPosS,02] // Nome do Status
        EndIf
        _oSecCab:Cell("ZS2_DESCST"):SetValue(xRet)
        _oSecCab:Cell("ZS2_FUNCAO"):SetValue(QRG->ZS2_FUNCAO)
        _oSecCab:Cell("RJ_DESC"):SetValue(QRG->RJ_DESC)
        _oSecCab:Cell("ZS2_DESFUN"):SetValue(QRG->ZS2_DESFUN)

        _oSecCab:PrintLine()

        QRG->(DbSkip())

    EndDo

    _oSecCab:Finish()

    _oReport:ThinLine()

Return Nil
/*
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
    Local _sAlias := GetArea()
    Local _aRegs  := {}
    Local i := 0
    Local j := 0
    _cPerg         := PADR(_cPerg,10)
    AADD(_aRegs,{_cPerg,"01","Da Filial? "	,"Da Filial? "	,"Da Filial?  "	,"mv_ch1","C",02,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AADD(_aRegs,{_cPerg,"02","Ate Filial? "	,"Ate Filial? "	,"Ate Filial  "	,"mv_ch2","C",02,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AADD(_aRegs,{_cPerg,"03","Da Matricula? "	,"Da Matricula? "	,"Da Matricula? "	,"mv_ch3","C",06,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AADD(_aRegs,{_cPerg,"04","Ate Matricula? "	,"Ate Matricula? "	,"Ate Matricula? "	,"mv_ch4","C",06,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AADD(_aRegs,{_cPerg,"05","Do Departamento? "	,"Do Departamento? "	,"Do Departamento? "	,"mv_ch5","C",09,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AADD(_aRegs,{_cPerg,"06","Ate Departamento? "	,"Ate Departamento? "	,"Ate Departamento? "	,"mv_ch6","C",09,0,0,"G","          ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AADD(_aRegs,{_cPerg,"07","Imprimir? "	,"Imprimir? ","Imprimir? "	,"mv_ch7","N",01,0,0,"G","          ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AADD(_aRegs,{_cPerg,"08","Ano ? "	,"Ano? "	,"Ano? "	,"mv_ch8","C",04,0,0,"G","          ","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AADD(_aRegs,{_cPerg,"09","Mes ? "	,"Mes? "	,"Mes? "	,"mv_ch9","C",02,0,0,"G","          ","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})

    dbSelectArea("SX1")
    SX1->(dbSetOrder(1))
    for i := 1 to len(_aRegs)
        If !SX1->(dbSeek(_cPerg+_aRegs[i,2]))
            RecLock("SX1",.T.)
            for j := 1 to FCount()
                If j <= Len(_aRegs[i])
                    FieldPut(j,_aRegs[i,j])
                Else
                    Exit
                EndIf
            next
            MsUnlock()
        EndIf
    next
    RestArea(_sAlias)
Return