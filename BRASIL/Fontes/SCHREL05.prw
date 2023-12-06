#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SCHREL05 ºAutor ³Jonathan Schmidt Alves º Data ³12/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao da Carta Proposta para aprovacao Salary Review.  º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ lAuto:   Chamada para impressao automatica (sem params)    º±±
±±º          ³ nMsgPr:  Tipo de mensagens de impressao                    º±±
±±º          ³          0=Sem Mensagens                                   º±±
±±º          ³          1=MsgInfo, MsgAlert, MsgStop                      º±±
±±º          ³          2=AtuAsk09 (via AskYesNo)                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SCHREL05(lAuto, nMsgPr)
Local lPrint := .T.
Local aMotAlt := {}
Local cStartPath	:= GetSrvProfString("Startpath","")
Local _z1
// Variaveis de Mensagens
Private cMsg01 := "Carregando dados para impressao..."
Private cMsg02 := ""
Private cMsg03 := ""
Private cMsg04 := ""
// Gerais
Private nLastKey := 0
Private cDesMot := ""
Private nFuncSRA := 0
Private nGereSRA := 0
Private nGereSRJ := 0
Private nAtuaSRJ := 0 // Funcao atual do funcionario
Private nNovoSRJ := 0 // Nova Funcao do funcionario
// Fontes
Private oFont08  := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
Private oFont08n := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
Private oFont10  := TFont():New("Arial",09,10,,.F.,,,,.T.,.F.)
Private oFont10n := TFont():New("Arial",09,10,,.T.,,,,.T.,.F.)
Private oFont12  := TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
Private oFont12n := TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
Private oFont12u := TFont():New("Arial",12,12,,.F.,,,,.T.,.T.)
Private oFont14  := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
Private oFont14n := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
Private oFont15  := TFont():New("Arial",15,15,,.F.,,,,.T.,.F.)
Private oFont15n := TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)
Private oFont16  := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
Private oFont16n := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
Private cLogo := "\arquivos\Salary\salary.png" // "\ADias\Logos\LogoADias01.jpg"
Default lAuto := .T. // .T.=Chamada via SCHGEN05 (Tela) .F.=Chamada via outra origem
Default nMsgPr := 0 // 0=Sem Mensagens 1=MsgInfo 2=AskYesNo

//cLogo := "\system\steck.bmp" // "steck_arg.jpg" //cStartPath + "LGRL" + SM0->M0_CODIGO + ".BMP" 						// Empresa
    
If nMsgPr == 2 // 2=AskYesNo
    _oMeter:nTotal := 12
EndIf
DbSelectArea("SRJ")
SRJ->(DbSetOrder(1)) // RJ_FILIAL + RJ_FUNCAO
DbSelectArea("SRA")
SRA->(DbSetOrder(1)) // RA_FILIAL + RA_MAT
DbSelectArea("ZS2")
ZS2->(DbSetOrder(1)) // ZS2_FILIAL + ZS2_CODSOL
If lAuto // Chamada a partir do SCHGEN05 (Tela)
    If ZS2->(DbSeek( _cFilZS2 + oGetD2:aCols[ oGetD2:nAt, nP02CodSol ] ))
        If ZS2->ZS2_STATRG = "D3" // "D3"=Alteracao Salarial Processada (Recursos Humanos)
            If SRA->(DbSeek( ZS2->ZS2_MATFIL + ZS2->ZS2_MATFUN ))
            nFuncSRA := SRA->(Recno())
                If !Empty(ZS2->ZS2_DATEFE) // Data efetivacao preenchida
                    If !Empty(ZS2->ZS2_MOTALT) // Motivo da alteracao
                    aMotAlt := FwGetSX5("41", ZS2->ZS2_MOTALT ) // Motivo alteracao
                        If Len(aMotAlt) > 0
                        cDesMot := aMotAlt[ 01, 04 ]
                            If u_GereDept( SRA->RA_DEPTO ) // Posiciono SQB conforme gerente
                                If SRA->(DbSeek( SQB->QB_FILRESP + SQB->QB_MATRESP ))
                                    nGereSRA := SRA->(Recno())
                                   
                                    //If SRJ->(DbSeek( _cFilSRJ + SRA->RA_CODFUNC))
                                    //nGereSRJ := SRJ->(Recno())
                                    
                                    //    If !Empty( ZS2->ZS2_CODFUN ) // Nova funcao do funcionario

                                        SRA->(DbGoto( nFuncSRA )) // Volto pro SRA do funcionario
                                            If SRJ->(DbSeek( _cFilSRJ + SRA->RA_CODFUNC))
                                            nAtuaSRJ := SRJ->(Recno())
                                            /*
                                                If SRJ->(DbSeek( _cFilSRJ + ZS2->ZS2_CODFUN))
                                                nNovoSRJ := SRJ->(Recno())
                                                lPrint := .T.
                                                Else // Funcao nao encontrada no cadastro (SRJ)
                                                cMsg02 := "Nova Funcao do funcionario nao encontrada no cadastro (SRJ)!"
                                                cMsg03 := "Cod Funcao: " + ZS2->ZS2_CODFUN
                                                cMsg04 := "Solicitacao: " + ZS2->ZS2_CODSOL
                                                EndIf
                                                
                                            Else // Funcao atual do funcionario nao encontrada no cadastro (SRJ)
                                            cMsg02 := "Funcao Atual do funcionario nao encontrada no cadastro (SRJ)!"
                                            cMsg03 := "Cod Funcao: " + SRA->RA_CODFUNC
                                            cMsg04 := "Solicitacao: " + ZS2->ZS2_CODSOL
                                            */
                                            EndIf
                                        /*    
                                        Else // Nao altera funcao
                                        lPrint := .T.                                        
                                        EndIf
                                        */
                                    //Else // Funcao nao encontrada no cadastro (SRJ)
                                    //cMsg02 := "Funcao do gerente nao encontrada no cadastro (SRJ)!"
                                    //cMsg03 := "Cod Funcao: " + SRA->RA_CODFUNC
                                    //cMsg04 := "Solicitacao: " + ZS2->ZS2_CODSOL
                                    //EndIf
                                    
                                Else // Gerente nao encontrado no cadastro (SRA)
                                    cMsg02 := "Gerente responsavel pelo departamento nao encontrado no cadastro (SRA)!"
                                    cMsg03 := "/Filial/Matricula Gerente: " + SQB->QB_FILRESP + "/" + SQB->QB_MATRESP
                                    cMsg04 := "Departamento: " + SRA->RA_DEPTO
                                EndIf
                            Else // Gerente nao identificado
                                cMsg02 := "Gerente responsavel pelo departamento nao foi identificado (SQB)!"
                                cMsg03 := "Fil/Func/Nome: " + SRA->RA_FILIAL + "/" + SRA->RA_MAT + " " + RTrim(SRA->RA_NOME)
                                cMsg04 := "Departamento: " + SRA->RA_DEPTO
                            EndIf
                        Else // Motivo nao identificado na tabela (SX5)
                            cMsg02 := "Codigo do Motivo da alteracao salarial nao identificado (ZS2->ZS2_MOTALT) (SX5 Tabela 41)!"
                            cMsg03 := "Codigo Motivo: " + ZS2->ZS2_MOTALT
                            cMsg04 := "Solicitacao: " + ZS2->ZS2_CODSOL
                        EndIf
                    Else // Motivo da alteracao salarial nao preenchido
                        cMsg02 := "Motivo da Alteracao salarial nao preenchido (ZS2_MOTALT)!"
                        cMsg03 := "Solicitacao: " + ZS2->ZS2_CODSOL
                    EndIf
                Else // Data Efetivacao da alteracao nao preenchida (ZS2_DATEFE)
                    cMsg02 := "Data de Efetivacao da alteracao salarial nao preenchida (ZS2_DATEFE)!"
                    cMsg03 := "Solicitacao: " + ZS2->ZS2_CODSOL
                EndIf
            Else // Funcionario nao encontrado no cadastro (SRA)
                cMsg02 := "Funcionario nao encontrado no cadastro para impressao (SRA)!"
                cMsg03 := "Filial/Matricula: " + ZS2->ZS2_MATFIL + "/" + ZS2->ZS2_MATFUN
            EndIf
        Else // Status da Solicitacao deve estar em "D3"=Alteracao Salarial Processada (Recursos Humanos)
            cMsg02 := "Solicitacao deve ter o status 'D3'=Alteracao Salarial Processada (Recursos Humanos) (ZS2)!"
            cMsg03 := "Verifique se a solicitacao ja foi aprovada e tente novamente!"
        EndIf
    Else // Solicitacao nao encontrada no cadastro (ZS2)
        cMsg02 := "Solicitacao nao encontrada para impressao (ZS2)!"
        cMsg03 := "Solicitacao: " + oGetD2:aCols[ oGetD2:nAt, nP02CodSol ]
    EndIf
EndIf
If !Empty(cMsg02) // Mensagens de problemas
    If nMsgPr == 1 // 1=MsgStop
        MsgStop(cMsg01 + Chr(13) + Chr(10) + ;
            cMsg02 + Chr(13) + Chr(10) + ;
            cMsg03 + Chr(13) + Chr(10) + ;
            cMsg04,"SchRel05")
    ElseIf nMsgPr == 2 // 2=AskYesNo
        For _z1 := 1 To 4
            u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "UPDERROR")
            Sleep(600)
        Next
    EndIf
EndIf
If lPrint // Imprimir
    If nMsgPr == 2 // 2=AskYesNo
        SRA->(DbGoto( nFuncSRA )) // Posiciono SRA do funcionario
        cMsg01 := "Imprimindo dados carregados..."
        cMsg02 := "Matricula/Nome Funcionario: " + SRA->RA_MAT + " " + RTrim(SRA->RA_NOME)
        SRA->(DbGoto( nGereSRA )) // Posiciono SRA do gerente
        SRJ->(DbGoto( nGereSRJ )) // Posiciono SRJ do gerente
        cMsg03 := "Gerente: " + RTrim(SRA->RA_NOME)
        cMsg04 := "Cargo: " + SRJ->RJ_DESC
        For _z1 := 1 To 4
            u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "IMPRESSAO")
            Sleep(100)
        Next
    EndIf
    oPrint := TMSPrinter():New(OemToAnsi("SCHREL05"))
    oPrint:SetPortrait()
    oPrint:Setup()
    If nLastKey == 27
        Return
    EndIf
    RptGrap2() // RptStatus({|| RptGrap2()})
    For _z1 := 1 To 4
        u_AtuAsk09(++nCurrent, cMsg01 + " Concluido!", cMsg02, cMsg03, cMsg04, 80, "OK")
        Sleep(100)
    Next
    oPrint:Preview()
    MS_FLUSH()
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RptGrap2 ºAutor ³Jonathan Schmidt Alves º Data ³12/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao TmsPrinter.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RptGrap2()
Local nLine := 0000
Local nColu := 0200
Local _z1
oPrint:StartPage()
SRA->(DbGoto( nFuncSRA )) // Posiciono SRA do funcionario
oPrint:SayBitmap(nLine,nColu,cLogo, 2250, 3575 )	// Logo A Dias // ÉõáàéêèÇçã
nLine += 0400
nColu := 1360
oPrint:Say(nLine,nColu,"São Paulo, " + cValToChar(Day(Date())) + " de " + MesExtenso(Date()) + " de " + cValToChar(Year(Date())),oFont15)
nLine += 0300
nColu := 0220
oPrint:Say(nLine,nColu,"Att. " + RTrim(SRA->RA_NOME),oFont16n)
nLine += 0120
oPrint:Say(nLine,nColu,"Ref. " + RTrim(cDesMot),oFont16n)
nLine += 0120
oPrint:Say(nLine,nColu, { "Prezado", "Prezada", "Prezado(a)" } [ At(SRA->RA_SEXO,"MF ") ],oFont14)
nColu += 0210
oPrint:Say(nLine,nColu, RTrim(SRA->RA_NOME) + ",",oFont14n)
nColu := 0220
nLine += 0180
oPrint:Say(nLine,nColu, "É com muita satisfação que comunicamos, como reconhecimento à sua dedicacao e",oFont14)
nLine += 0060
oPrint:Say(nLine,nColu, "desenvolvimento, a sua promoção, ",oFont14)
nColu := 1012
oPrint:Say(nLine,nColu, "a partir de " + DtoC(ZS2->ZS2_DATEFE) + ",",oFont14n)
nColu := 1560
oPrint:Say(nLine,nColu, "conforme abaixo:",oFont14)
nLine += 0120
nColu := 0260
    If !Empty(ZS2->ZS2_DESFUN)
    SRJ->(DbGoto( nAtuaSRJ )) // Posiciono na Funcao Atual do funcionario
    oPrint:Say(nLine,nColu, "Alteração de cargo:",oFont14n)
    nLine += 0060
    oPrint:Say(nLine,nColu, "De:",oFont14n)
    nColu := 0440
    oPrint:Say(nLine,nColu, RTrim(SRJ->RJ_DESC),oFont14)
    SRJ->(DbGoto( nNovoSRJ )) // Posiciono na Nova Funcao do funcionario
    nLine += 0060
    nColu := 0260
    oPrint:Say(nLine,nColu, "Para:",oFont14n)
    nColu := 0440
    oPrint:Say(nLine,nColu, RTrim(ZS2->ZS2_DESFUN),oFont14)
    nLine += 0120
    EndIf
SRA->(DbGoto( nFuncSRA )) // Posiciono SRA do funcionario
nColu := 0260
oPrint:Say(nLine,nColu, "Alteração Salarial:",oFont14n)
nLine += 0060
nColu := 0260
oPrint:Say(nLine,nColu, "De:",oFont14n)
nColu := 0440
oPrint:Say(nLine,nColu, "R$ " + TransForm(ZS2->ZS2_SALARIO,"@E 999,999,999.99"),oFont14)
nColu := 0850
oPrint:Say(nLine,nColu, Extenso( ZS2->ZS2_SALARIO ),oFont14)
nLine += 0060
nColu := 0260
oPrint:Say(nLine,nColu, "Para:",oFont14n)
nColu := 0440
oPrint:Say(nLine,nColu, "R$ " + TransForm(ZS2->ZS2_SALATU,"@E 999,999,999.99"),oFont14)
nColu := 0850
oPrint:Say(nLine,nColu, Extenso( ZS2->ZS2_SALATU ),oFont14)
nLine += 0220
nColu := 0220
oPrint:Say(nLine,nColu, "Nessa nova posição, todos os seus benefícios anteriores serão mantidos.",oFont14)
nLine += 0060
oPrint:Say(nLine,nColu, "Aproveitamos para desejar sucesso, e contamos com sua reconhecida dedicação e",oFont14)
nLine += 0060
oPrint:Say(nLine,nColu, "empenho de sempre.",oFont14)
nLine += 0220
oPrint:Say(nLine,nColu, "Atenciosamente,",oFont14)
nLine += 0400
nColu := 0220
oPrint:Line(nLine, nColu, nLine, nColu + 0800)
SRA->(DbGoto( nGereSRA )) // Posiciono SRA do gerente
SRJ->(DbGoto( nGereSRJ )) // Posiciono SRJ do gerente
nColu := 0250
nLine += 0020
oPrint:Say(nLine,nColu, RTrim(SRA->RA_NOME),oFont14)
nLine += 0060
oPrint:Say(nLine,nColu, RTrim(SRJ->RJ_DESC),oFont14)
nLine -= 0080
nColu := 1280
oPrint:Line(nLine, nColu, nLine, nColu + 0800)
nColu := 1320
nLine += 0020
SRA->(DbGoto( nFuncSRA )) // Posiciono SRA do funcionario
oPrint:Say(nLine,nColu, RTrim(SRA->RA_NOME),oFont14)
    For _z1 := 1 To 4
    u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "IMPRESSAO")
    Sleep(100)
    Next
oPrint:EndPage()
Return
