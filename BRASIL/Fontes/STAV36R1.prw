#INCLUDE "TOTVS.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE IMP_SPOOL 2

USER FUNCTION STAV36R1()

    Local nX:=0
    Local nY:=0
    Local nL:=050
   // Local i

    Local nLLength 		:= 110
    Local nLineLength1 	:= 152
    Local nTabSize 		:= 3
    Local lWrap 		:= .T.
    Local nCurrentLine	:= 0
    Local _cAval1	:= ""
    Local _cAval2	:= ""
  //  Local _aRet 		:= {}
    Local _aParamBox 	:= {}
    Local _GestorDe       := Space(6)
    Local _GestorAte       := Space(6)

    AADD(_aParamBox,{1,"Do Gestor ",_GestorDe ,"",".T.","USR",".T.",6, .F.})
    AADD(_aParamBox,{1,"Ate Gestor ",_GestorAte ,"",".T.","USR",".T.",6, .F.})
    AADD(_aParamBox,{1,"Ano",Space(4),"","","","",0,.F.})


    ParamBox(_aParamBox, "Informe os parâmetros")

    //+----------------------------------------------------------------+
    //|DEFINICAO DE FONTES                                             |
    //+----------------------------------------------------------------+
    PRIVATE oFont07n    :=TFont():new("Arial",,-07,.F.,,,,,,.F.,.F.)
    PRIVATE oFont07b    :=TFont():new("Arial",,-07,.T.,,,,,,.F.,.F.)
    PRIVATE oFont08n    :=TFont():new("Arial",,-08,.F.,,,,,,.F.,.F.)
    PRIVATE oFont08b    :=TFont():new("Arial",,-08,.T.,,,,,,.F.,.F.)
    PRIVATE oFont09n    :=TFont():new("Arial",,-09,.F.,,,,,,.F.,.F.)
    PRIVATE oFont09b    :=TFont():new("Arial",,-09,.T.,,,,,,.F.,.F.)
    PRIVATE oFont10n    :=TFont():new("Arial",,-10,.F.,,,,,,.F.,.F.)
    PRIVATE oFont10b    :=TFont():new("Arial",,-10,.T.,,,,,,.F.,.F.)
    PRIVATE oFont12n    :=TFont():new("Arial",,-12,.F.,,,,,,.F.,.F.)
    PRIVATE oFont12b    :=TFont():new("Times New Roman",,-12,.T.,,,,,,.F.,.F.)
    PRIVATE oFont14n    :=TFont():new("Arial",,-14,.F.,,,,,,.F.,.F.)
    PRIVATE oFont14b    :=TFont():new("Arial",,-14,.T.,,,,,,.F.,.F.)
    PRIVATE oFont16n    :=TFont():new("Arial",,-16,.F.,,,,,,.F.,.F.)
    PRIVATE oFont16b    :=TFont():new("Arial",,-16,.T.,,,,,,.F.,.F.)
    PRIVATE oFont18n    :=TFont():new("Arial",,-18,.F.,,,,,,.F.,.F.)
    PRIVATE oFont18b    :=TFont():new("Arial",,-18,.T.,,,,,,.F.,.F.)
    PRIVATE oFont20n    :=TFont():new("Arial",,-20,.F.,,,,,,.F.,.F.)
    PRIVATE oFont20b    :=TFont():new("Arial",,-20,.T.,,,,,,.F.,.F.)

    //+---------------------------------------------------------------------------
    //| Monta query de selecao dos Dados
    //+---------------------------------------------------------------------------

    If SELECT("AV360")>0
        AV360->(DBCLOSEAREA())
    ENDIF

    cQuery:=""

    cQuery+= " SELECT * FROM Z32010 Z32 "
    cQuery+= " LEFT JOIN Z34010 Z34 "
    cQuery+= "  ON Z34.Z34_XEMPFU = Z32.Z32_XEMP "
    cQuery+= "  AND Z34.Z34_XFILFU = Z32.Z32_XFILIA "
    cQuery+= "  AND Z34.Z34_MAT = Z32.Z32_MAT "
    cQuery+= "  AND Z34.Z34_ANO = '"+MV_PAR03+"' "
    cQuery+= " AND Z34.D_E_L_E_T_ = ' ' "
    cQuery+= " WHERE Z32.D_E_L_E_T_ = ' ' "
    cQuery+= " AND Z32_SUPUSR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' OR Z32_USER BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
    cQuery+= " AND Z32_SUPUSR <>' '
    cQuery+= " AND Z32.D_E_L_E_T_ = ' ' "

    cQuery+= " ORDER BY Z32_SUPUSR,Z34_XEMPFU,Z34_XFILFU,Z34_USER,Z34_XEMP,Z34_XFILIA,Z34_USRAVA "

    //cQuery := ChangeQuery(cQuery)

    tcquery cquery new alias "AV360"

    // ----------------------------------------------
    // Inicializa objeto de impressao
    // ----------------------------------------------

    oPrt:=FWMsPrinter():New("AV360R1"+Alltrim(StrTran(time(),":","")),IMP_PDF)

    // ----------------------------------------------
    // Define para salvar o PDF
    // ----------------------------------------------

    oPrt:SetViewPDF(.t.)

    //+---------------------------------------------
    //|Configuracao de Impressao
    //+---------------------------------------------
    oPrt:SetResolution(78) //O Mesmo tamanho estipulado para a Danfe
    oPrt:SetPortrait()
    oPrt:SetPaperSize(DMPAPER_A4)
    oPrt:SetMargin(60,60,60,60)

    // ----------------------------------------------
    // Configuracao de resolucao de Pagina
    // ----------------------------------------------
    nY:=oPrt:nVertRes() 	//Resolucao vertical
    nX:=oprt:nHorzRes()-200	//Resulucao Horizontal

    oPrt:StartPage()    //Inicia uma nova Pagina

    DBSELECTAREA("AV360")
    DBGOTOP()

    If Eof()
        MsgInfo("Avaliação Não Respondida")
        Return
    EndIf

    oPrt:Say(010, 620, "Resultado FEEDBACK 360 "+Alltrim(MV_PAR03)+" Gestor: "+Alltrim(AV360->Z32_SUPNO), oFont20n)

    oPrt:Line (030,020,030,nX+200)
    //bOX DO TOPO DE ASSINATURA
    // oPrt:Box(050,020,170,nX+200)	//Nome do Avaliado
    oPrt:Say(100,020,"Nome", oFont12n)
    oPrt:Say(100,1820,"Ano", oFont12n)

    oPrt:Box(120,020,200,nX+200)	//Nome do Avaliado
    oPrt:Say(170,030,AV360->Z34_NOMFUN, oFont16n)
    oPrt:Say(170,1830,AV360->Z34_ANO, oFont16n)

    nL := 250

    _cAval1 := AV360->Z34_MATAVA
    _cAval2  := AV360->Z34_NOMFUN

    While !EOF()

        If AV360->Z34_TIPOOB = "3"

            If nL > 2775
                oPrt:StartPage()
                oPrt:Say(010, 620, "Resultado FEEDBACK 360 "+Alltrim(Z33->Z33_ANO)+" Gestor: "+Alltrim(AV360->Z32_SUPNO), oFont20n)
                oPrt:Line (030,020,030,nX+200)
                nL := 100
            EndIf

            nLines1 := 0
            nCurrentLine1 := 0

            //Z34_FILIAL+Z34_MAT+Z34_XEMPFU+Z34_XFILFU+Z34_QUESTA
            nLines1 := MLCOUNT(POSICIONE("SQO", 1, xFilial("SQO")+AV360->Z34_QUESTA, "QO_QUEST"), nLineLength1, nTabSize, lWrap)

            //nLines1 := MLCOUNT(AV360->Z34_RESTP3, nLineLength, nTabSize, lWrap)

            FOR nCurrentLine := 1 TO nLines1

                xText1 := MEMOLINE(POSICIONE("SQO", 1, xFilial("SQO")+AV360->Z34_QUESTA, "QO_QUEST"), nLineLength1, nCurrentLine, nTabSize, lWrap)

                oPrt:Say(nL,020,xText1, oFont12n)

            Next

            nL += 50

            xText1	:= ""
            nLines1 := 0
            nCurrentLine1 := 0

            //Z34_FILIAL+Z34_MAT+Z34_XEMPFU+Z34_XFILFU+Z34_QUESTA
            nLines1 := MLCOUNT(POSICIONE("Z34", 2, xFilial("Z34")+AV360->(Z34_MAT+Z34_XEMPFU+Z34_XFILFU+Z34_MATAVA+Z34_QUESTA+Z34_ANO), "Z34_RESTP3"), nLLength, nTabSize, lWrap)

            //nLines1 := MLCOUNT(AV360->Z34_RESTP3, nLineLength, nTabSize, lWrap)

            FOR nCurrentLine := 1 TO nLines1

                xText1 := MEMOLINE(POSICIONE("Z34", 2,xFilial("Z34")+AV360->(Z34_MAT+Z34_XEMPFU+Z34_XFILFU+Z34_MATAVA+Z34_QUESTA+Z34_ANO), "Z34_RESTP3"), nLLength, nCurrentLine, nTabSize, lWrap)

                oPrt:Box(nL-30,020,nL+30,nX+200)	//Nome do Avaliado
                oPrt:Say(nL+10,030,xText1, oFont16n)

                nL += 50

            Next

        EndIf

        nL += 50

        If SELECT("TRC")>0
            TRC->(DBCLOSEAREA())
        ENDIF

        cQuery2:=""
        cQuery2+= " SELECT * FROM ( "
        cQuery2+= " SELECT RA_FILIAL,RA_XEMP,RA_MAT,RA_NOME FROM SRA010 WHERE D_E_L_E_T_ = ' ' "
        cQuery2+= " UNION "
        cQuery2+= " SELECT RA_FILIAL,RA_XEMP,RA_MAT,RA_NOME FROM SRA030 WHERE D_E_L_E_T_ = ' ' "
        cQuery2+= " UNION "
        cQuery2+= " SELECT RA_FILIAL,RA_XEMP,RA_MAT,RA_NOME FROM SRA070 WHERE D_E_L_E_T_ = ' ' ) XXX "
        cQuery2+= " WHERE XXX.RA_FILIAL = '"+AV360->Z34_XFILIA+"' AND XXX.RA_XEMP = '"+AV360->Z34_XEMP+"' AND RA_MAT = '"+AV360->Z34_MATAVA+"' "

        tcquery cquery2 new alias "TRC"

        DBSELECTAREA("AV360")
        DbSkip()

        If _cAval1 <> AV360->Z34_MATAVA

            If SELECT("TRB")>0
                TRB->(DBCLOSEAREA())
            ENDIF

            cQuery1:=""
            cQuery1+= " SELECT * FROM ( "
            cQuery1+= "	SELECT RA_FILIAL,RA_XEMP,RA_MAT,RA_DEPTO,QB_DESCRIC  FROM SRA010 RA  LEFT JOIN SQB010 QB ON QB.QB_DEPTO = RA.RA_DEPTO  AND QB.D_E_L_E_T_ = ' ' WHERE  RA.D_E_L_E_T_ = ' ' "
            cQuery1+= " UNION "
            cQuery1+= " SELECT RA_FILIAL,RA_XEMP,RA_MAT,RA_DEPTO,QB_DESCRIC  FROM SRA030 RA  LEFT JOIN SQB010 QB ON QB.QB_DEPTO = RA.RA_DEPTO  AND QB.D_E_L_E_T_ = ' ' WHERE  RA.D_E_L_E_T_ = ' ' )XXX "
            cQuery1+= " WHERE XXX.RA_MAT = '"+TRC->RA_MAT+"' AND XXX.RA_XEMP = '"+TRC->RA_XEMP+"' AND XXX.RA_FILIAL = '"+TRC->RA_FILIAL+"' "

            tcquery cquery1 new alias "TRB"

            oPrt:Say(nL+10,030,"Avaliador: "+Alltrim(TRC->RA_NOME)+" ( "+Alltrim(TRB->QB_DESCRIC)+" )", oFont16n)

            nL += 50

            oPrt:Line (nL,020,nL,nX+200)

            nL += 100

            If !Empty(AV360->Z34_NOMFUN)

                If _cAval2 <> AV360->Z34_NOMFUN

                    oPrt:StartPage()
                    _cAval2 := AV360->Z34_NOMFUN

                    oPrt:Say(010, 620, "Resultado FEEDBACK 360 "+Alltrim(Z33->Z33_ANO)+" Gestor: "+Alltrim(AV360->Z32_SUPNO), oFont20n)
                    oPrt:Line (030,020,030,nX+200)
                    nL := 100

                EndIf

                If nL > 2775
                    oPrt:StartPage()

                    oPrt:Say(010, 620, "Resultado FEEDBACK 360 "+Alltrim(Z33->Z33_ANO)+" Gestor: "+Alltrim(AV360->Z32_SUPNO), oFont20n)
                    oPrt:Line (030,020,030,nX+200)

                    nL := 100

                EndIf

                //bOX DO TOPO DE ASSINATURA
                oPrt:Say(nL,020,"Nome", oFont12n)
                oPrt:Say(nL,1820,"Ano", oFont12n)
                nL += 50

                oPrt:Box(nL-30,020,nL+30,nX+200)	//Nome do Avaliado
                oPrt:Say(nL+5,030,AV360->Z34_NOMFUN, oFont16n)
                oPrt:Say(nL+5,1830,AV360->Z34_ANO, oFont16n)

                //oPrt:Box(nL-30,1820,nL+30,nX+200)	//Nome do Avaliado
                nL += 100
                //oPrt:Line (nL,020,nL,nX+200)
                //nL += 75

            EndIf

            DBSELECTAREA("AV360")

            _cAval1 := AV360->Z34_MATAVA

        EndIf

    End

    oPrt:EndPage()

    oPrt:Print()

RETURN
