
//Bibliotecas
#Include 'Protheus.ch'
#include "topconn.ch"
 
//Variáveis Estáticas
Static cTitulo  := ""
Static cChav003 := space(6)
Static cDescPor := space(55)
Static cMsgRelac:= "Este registro contém relacionamento com os lançamentos da PAA. "
 
/*/{Protheus.doc} STPAA003
Cadastro de tabelas SX5
@author Valdemir Rabelo
@since 01/08/2019
@version 1.0
    @param cTabela, character, Código da tabela genérica
    @param cTitRot, character, Título da Rotina
    @example
    u_STPAA003("01", "Séries de NF")
/*/
User Function STPAA003()
    Local cUsuCad := SuperGetMV("FS_STPAA01",.F.,"000138")

    if !(__cUserid $ cUsuCad)
        MsgInfo("Usuário não tem permissão para entrar nesta rotina","Atenção!")
        Return
    endif

    STPAA003('Z3', 'Analise Deptos.PAA')
Return
 


Static Function STPAA003(cTabela, cTitRot)
    Private aTipoPag   := {}
    Private ni         := 0

	DbSelectArea("SX5")
	DbSetOrder(1)
	DbSeek(xFilial("SX5")+cTabela)
	While !Eof() .and. SX5->X5_TABELA == cTabela 
		If left(SX5->X5_DESCRI,1) # "*"
			Aadd(aTipoPag,{ SX5->X5_CHAVE, SX5->X5_DESCRI, SX5->X5_DESCRI , RecNo("SX5") })
		EndIf
		DbSelectArea("SX5")
		DbSkip() 
	EndDo
	If Len(aTipoPag) == 0
	   aTipoPag := {{" "," "," ",0}}
	Else
		aSort(aTipoPag,1,,{|x,y| x[1] < y[1] })
    EndIf
    cChav003 := Space(TamSX3("X5_CHAVE")[1])
    cDescPor := Space(TamSX3("X5_DESCRI")[1])
   DEFINE MSDIALOG oDlgF FROM 000,000 TO 030,060 TITLE "Cadastro de " + cTitRot OF oMainWnd
	   @ 007,009 SAY "Informe:" SIZE 30,08 OF oDlgF PIXEL COLOR CLR_BLUE
	   @ 007,030 SAY cTitRot SIZE 100,08 OF oDlgF PIXEL COLOR CLR_BLUE
	   @ 026,009 SAY "Chave  :" SIZE 30,08 OF oDlgF PIXEL COLOR CLR_BLUE
  	   @ 025,026 MSGET oChave VAR cChav003 PICTURE "@!" SIZE 20,08 OF oDlgF PIXEL COLOR CLR_HBLUE
	   @ 037,009 SAY "Desc.:"  SIZE 35,08 OF oDlgF PIXEL COLOR CLR_BLUE 
       @ 036,026 MSGET oDesc VAR cDescPor PICTURE "@!" SIZE 140,08 OF oDlgF PIXEL COLOR CLR_HBLUE
	   @ 007,177 BUTTON oInclui  PROMPT OemToAnsi("<<<    INCLUIR    >>>")  OF oDlgF SIZE 55,10 PIXEL  ACTION (Processa( {|| FS_INCLUIR(cTabela) , FS_MUDAPAG() , oChave:SetFocus() } ))
   	   @ 017,177 BUTTON oAltera  PROMPT OemToAnsi("<<<   ALTERAR   >>>")    OF oDlgF SIZE 55,10 PIXEL  ACTION (Processa( {|| FS_ALTERAR(cTabela,oLbx1:nAt,1) , FS_MUDAPAG() , oLbx1:SetFocus() } ))
	   @ 027,177 BUTTON oExclui  PROMPT OemToAnsi("<<<    EXCLUIR   >>>")   OF oDlgF SIZE 55,10 PIXEL  ACTION (Processa( {|| FS_EXCLUIR(cTabela,oLbx1:nAt,1) , FS_MUDAPAG() , oLbx1:SetFocus() } ))
   	   @ 037,177 BUTTON oSair  PROMPT OemToAnsi("<<<    S  A  I  R    >>>") OF oDlgF SIZE 55,10 PIXEL  ACTION (oDlgF:End())
	   @ 053,003 LISTBOX oLbx1 FIELDS HEADER OemToAnsi(" Chave"),OemToAnsi(" Descricao") COLSIZES 40,90 SIZE 233,170 OF oDlgF PIXEL ON CHANGE( FS_MUDAPAG() )
	   oLbx1:SetArray(aTipoPag)
   	   oLbx1:bLine := { || {aTipoPag[oLbx1:nAt,1],aTipoPag[oLbx1:nAt,2]}} //acho que essa é a parte que monta a lista
       @ 001,003 TO 051,235 LABEL "" OF oDlgF PIXEL // essa daqui é a parte do quadrado pequeno
       oChave:SetFocus()
   ACTIVATE MSDIALOG oDlgF CENTER 
Return

Static Function FS_MUDAPAG()      
	cChav003:=aTipoPag[oLbx1:nAt,1]
        cDescPor:=aTipoPag[oLbx1:nAt,2]
	oChave:Refresh()
	oDesc:Refresh()
Return()


Static Function FS_INCLUIR(cTabela)
    Local nj := 0
    DbSelectArea("SX5")
    DbSetOrder(1)
    If !DbSeek(xFilial("SX5")+cTabela+cChav003)
    /* Removido\Ajustado - Não executa mais RecLock na X5. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
        RecLock("SX5",.t.)
        SX5->X5_FILIAL := xfilial()
        SX5->X5_TABELA := cTabela
        SX5->X5_CHAVE  := cChav003 
        SX5->X5_DESCRI := cDescPor
        SX5->X5_DESCSPA:= cDescPor
        SX5->X5_DESCENG:= cDescPor
        MsUnLock()*/
        aTipoPag := {}
        DbSelectArea("SX5")
        DbSetOrder(1)
        DbSeek(xFilial("SX5")+cTabela)
        While !Eof() .and. SX5->X5_TABELA == cTabela
            If left(SX5->X5_DESCRI,1) # "*"
                Aadd(aTipoPag,{ SX5->X5_CHAVE, SX5->X5_DESCRI, SX5->X5_DESCRI , RecNo("SX5") })
            EndIf
            DbSelectArea("SX5")
            DbSkip()
        EndDo
        aSort(aTipoPag,1,,{|x,y| x[1] < y[1] })
        oLbx1:SetArray(aTipoPag)
        oLbx1:bLine := { || {aTipoPag[oLbx1:nAt,1],aTipoPag[oLbx1:nAt,2]}}
        oLbx1:Refresh()
    Else
        MsgAlert("Chave Invalida...","Atencao")
    EndIf
Return()


Static Function FS_ALTERAR(cTabela,ni)
    Local lExiste := .F.
    Local lVld    := .F.
    
    DbSelectArea("SX5")
    DbSetOrder(1)
    lExiste := DbSeek(xFilial("SX5")+cTabela+cChav003)

    If lExiste
        // Chama Validação para verificar se ja existe relacionamento
        Vld := VLdRelac(SX5->X5_DESCRI)
       if !Vld
            /* Removido\Ajustado - Não executa mais RecLock na X6. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
            RecLock("SX5",.f.)
            SX5->X5_DESCRI := cDescPor
            SX5->X5_DESCSPA:= cDescPor
            SX5->X5_DESCENG:= cDescPor
            MsUnLock()*/
            aTipoPag := {}
            DbSelectArea("SX5")
            DbSetOrder(1)
            DbSeek(xFilial("SX5")+cTabela)
            While !Eof() .and. SX5->X5_TABELA == cTabela
                If left(SX5->X5_DESCRI,1) # "*"
                    Aadd(aTipoPag,{ SX5->X5_CHAVE, SX5->X5_DESCRI, SX5->X5_DESCRI , RecNo("SX5") })
                EndIf                                               
                DbSelectArea("SX5")
                DbSkip()
            EndDo
            aSort(aTipoPag,1,,{|x,y| x[1] < y[1] })
            oLbx1:SetArray(aTipoPag)
            oLbx1:bLine := { || {aTipoPag[oLbx1:nAt,1],aTipoPag[oLbx1:nAt,2]}}
            oLbx1:Refresh()
        else
            MSGINFO( cMsgRelac + CRLF + "<font color='red'><b>Alteração não permitida</b></font>", "Atenção" )
        endif
    Else
        MsgAlert("Chave Invalida...","Atencao")
    EndIf

Return

Static Function FS_EXCLUIR(cTabela,ni)
    Local aAux := {}
    Local nj   := 0
    Local lExiste := .F.
    Local lVld    := .F.

    DbSelectArea("SX5")
    DbSetOrder(1)
    lExiste := DbSeek(xFilial("SX5")+cTabela+cChav003)
    If lExiste 
        // Chama Validação para verificar se ja existe relacionamento
        Vld := VLdRelac(SX5->X5_DESCRI)
        if !Vld
            If MsgYesNo("Deseja Realmente EXCLUIR a Tabela: <b>"+aTipoPag[ni,1]+" - "+aTipoPag[ni,2]+"</b>","Atencao")
                For nj := 1 to len(aTipoPag)
                    If ni # nj
                            aAdd(aAux,{ aTipoPag[nj,1] , aTipoPag[nj,2] , aTipoPag[nj,3] , aTipoPag[nj,4] } )
                        Else
                        DbSelectArea("SX5")
                        DbGoto(aTipoPag[ni,4])
                        RecLock("SX5",.f.,.t.)
                        DbDelete()
                        MsUnLock()
                        EndIf
                Next
                aTipoPag := aClone(aAux)
                    If Len(aTipoPag) == 0
                    aTipoPag := {{" "," "," ",0}}
                    EndIf
                    aSort(aTipoPag,1,,{|x,y| x[1] < y[1] })
                oLbx1:SetArray(aTipoPag)
                    oLbx1:bLine := { || {aTipoPag[oLbx1:nAt,1],aTipoPag[oLbx1:nAt,2]}}
                oLbx1:Refresh()
            EndIf
        Else 
           MSGINFO( cMsgRelac + CRLF + "<font color='red'><b>Exclusão não permitida</b></font>", "Atenção" )
        Endif 
    EndIf   

Return


User Function VLDSX5PA(pDEPTO)
       Local lRET := .F.
       Local aArea := GetArea()

       dbSelectArea("SX5")
       dbSetOrder(1)
       dbSeek(xFilial("SX5")+'Z3')
       While !Eof() .and. (ALLTRIM(SX5->X5_TABELA)=='Z3') .and. (!lRET)
         lRET := (ALLTRIM(pDEPTO) $ ALLTRIM(SX5->X5_DESCRI))
         dbSkip()
       EndDo

       IF !lRET 
            MSGRUN('Departamento não encontrado','Informação', {|| sleep(3000)})
       ENDIF 

       RestArea( aArea )

Return lRET


Static Function VLdRelac(pDESCRI)
   Local lRET   := .F.
   Local cQry   := ""
   Local aAreaR := GetArea()

   cQry += "SELECT COUNT(*) REG " + CRLF 
   cQry += "FROM " + RETSQLNAME("Z46") + " Z46 " + CRLF 
   cQry += "WHERE Z46.D_E_L_E_T_ = ' ' " + CRLF 
   cQry += " AND Z46_DEPTO LIKE '" +alltrim(pDESCRI)+ "%' " + CRLF 

   IF SELECT("TZ46") > 0
      TZ46->( dbCloseArea() )
   ENDIF 

   TcQuery cQry New Alias "TZ46"

   if !Eof() 
      lRET := (TZ46->REG > 0)
   endif

    IF SELECT("TZ46") > 0
        TZ46->( dbCloseArea() )
    ENDIF 

    RestArea( aAreaR )

Return lRET
