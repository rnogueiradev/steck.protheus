#include "rwmake.ch"
#DEFINE CRLF chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCADSZD  ºAutor  ³Renato Nogueira     º Data ³  22/07/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastrar amarração cliente x produto do EDI			      º±±
±±º          ³ 						                 			          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCADSZD()

	Local aRotAdic		:= {}

	Dbselectarea("SZD")
	
	aadd(aRotAdic,{ "Imp. CSV","U_IMPSZD", 0 , 10 })

	_cTitulo := "Cadastro de produto x cliente EDI"
                                                                              
    AxCadastro("SZD",_cTitulo,,"U_STALTSZD()",aRotAdic,,,,)

	//AxCadastro("SZD",_cTitulo,,"U_STALTSZD()")

Return .t.

User Function STALTSZD()

	Local _cMsg			:= ""
	Local _lAlterado	:= .F.

	_cMsg	+= "Usuário: "+cUserName+CRLF
	_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CRLF
	_cMsg	+= "Campo               | Anterior                               | Novo                                   "+CRLF

	If !(AllTrim(M->ZD_CLIENTE)==AllTrim(SZD->ZD_CLIENTE))
		_cMsg	+= "Alterado de: "+AllTrim(SZD->ZD_CLIENTE)+" para: "+AllTrim(M->ZD_CLIENTE)+" em "+DTOC(Date())+" "+Time()+" por "+cUserName+CRLF
		_lAlterado	:= .T.
	EndIf
	If !(AllTrim(M->ZD_CODCLI)==AllTrim(SZD->ZD_CODCLI))
		_cMsg	+= "Alterado de: "+AllTrim(SZD->ZD_CODCLI)+" para: "+AllTrim(M->ZD_CODCLI)+" em "+DTOC(Date())+" "+Time()+" por "+cUserName+CRLF
		_lAlterado	:= .T.
	EndIf
	If !(AllTrim(M->ZD_CODSTE)==AllTrim(SZD->ZD_CODSTE))
		_cMsg	+= "Alterado de: "+AllTrim(SZD->ZD_CODSTE)+" para: "+AllTrim(M->ZD_CODSTE)+" em "+DTOC(Date())+" "+Time()+" por "+cUserName+CRLF
		_lAlterado	:= .T.
	EndIf
	If !(AllTrim(M->ZD_BLOQ)==AllTrim(SZD->ZD_BLOQ))
		_cMsg	+= "Alterado de: "+AllTrim(SZD->ZD_BLOQ)+" para: "+AllTrim(M->ZD_BLOQ)+" em "+DTOC(Date())+" "+Time()+" por "+cUserName+CRLF
		_lAlterado	:= .T.
	EndIf
	
	If _lAlterado
		M->ZD_XLOG	:= AllTrim(SZD->ZD_XLOG)+_cMsg
	EndIf

Return(.T.)


/*====================================================================================\
|Programa  | IMPSZD          | Autor | ANTONIO CORDEIRO          | Data | 15/11/2023  |
|=====================================================================================|
|Descrição | ROTINA PARA IMPORTAR CSV PARA A SZD                                      |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function IMPSZD()

Processa({|| ValCsv() },"","Valida CSV..")

Return()

// Valida CSV. 

Static Function ValCsv() 

	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local aProc   := {}
	Local lErro    :=.F.
	Local cErro    :=""
	Local nx     :=0
	Local lContinua:=.T.
    Private q      :=""
    Private z      :=""
    Private aErro  := {}
    Private cArquivo:=""
	Private nP       :=0
    Private cAltera:=""

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)


	If !File(cArquivo)
		MsgStop("O arquivo " +cArquivo+ " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return()
	EndIf

    nP:=AT(',',cArquivo)
    cVarFile := cFileChgx:=1

    nP:=AT('.',cArquivo)

    _cArquivo:=substr(cArquivo,1,nP-1)+"_log"+Substr(cArquivo,nP,len(cArquivo)+4)
    _cArqProc:=substr(cArquivo,1,nP-1)+"_proc"+Substr(cArquivo,nP,len(cArquivo)+4)

    z := fcreate(alltrim(_cArquivo))

	oFT   := fT():New()
	oFT:ft_fUse( cArquivo )

	_nX := 0

	FT_FUSE(cArquivo)
	ProcRegua(FT_FLASTREC()) 
	FT_FGOTOP()  

	While !( oFT:ft_fEof() )
		IncProc(' Validando Registros ...')
		_nX++
		cLinha := oFT:ft_fReadLn()

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
            For nx:=1 to len(aCampos)
                q+=ALLTRIM(aCampos[nx])+'";'
            next 
            q+='Log Erro'+'";'
            q+=chr(13)+chr(10)
            fwrite(z,q,len(q))
		Else
		   cErro:=""
		   aDados:={}
		   AADD(aDados,Separa(cLinha,";",.T.))
		   nx:=len(aDados)
           
	       aDados[nx,1] := PADL(AllTrim(aDados[nx,1]),TAMSX3("ZD_CLIENTE")[1],"0")
	       aDados[nx,2] := AllTrim(aDados[nx,2])
           aDados[nx,3] := PADR(AllTrim(aDados[nx,3]),TAMSX3("ZD_CODSTE")[1],' ')
	       aDados[nx,4] := AllTrim(aDados[nx,4])

           //Valida Cliente 
		   SA1->(DBSETORDER(1))
		   IF !SA1->(DBSEEK(XFILIAL('SA1')+aDados[nx,1]+IIF(!Empty(aDados[nx,2]),aDados[nx,2],"")))
			   cErro+='Cliente : '+aDados[nx,1]+'/'+aDados[nx,2]+' não localizado/ '
		   ENDIF

           //Valida Produto 
		   SB1->(DBSETORDER(1))
		   IF !SB1->(DBSEEK(XFILIAL('SB1')+aDados[nx,3]))
			   cErro+='Produto: '+aDados[nx,3]+' não localizado/ '
		   ENDIF

 		   if !Empty(cErro)
			   lErro:=.T.
               GravaLog(aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4],cErro)
		   else 
              //Valida se o registro ja existe e exibe alteração 
			  cAltera:=""
              SZD->(DBSETORDER(2))
			  IF SZD->(DBSEEK(XFILIAL('SZD')+aDados[nx,1]+aDados[nx,3]+IIF(!Empty(aDados[nx,2]),aDados[nx,2],'')))
                 cAltera:='Registro ja Existe Alteração' 
              ELSE
                 cAltera:='Registro Novo Inclusão ' 
			  ENDIF
              aadd(aProc,{aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4]})
              GravaLog(aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4],cAltera)
            ENDIF   
		EndIf

		oFT:ft_fSkip()
	End While

    fclose(z)
    incproc("Abrindo os dados em Excel.....")

    If !ApOleClient( 'MsExcel' )
       MsgAlert( 'MsExcel não instalado')
	   Return
    else
	   oExcel1 := MsExcel():New()
	   oExcel1:WorkBooks:Open(alltrim(_cArquivo))
	   oExcel1:SetVisible(.T.)
    EndIf

    oFT:ft_fUse()

    if lErro
	   If Msgyesno('Houve erro na análise do CSV  - Continua ?...')
          lContinua:=.T.
	   ELSE 
	      lContinua:=.F.
	   ENDIF 
    ELSE 
	   If Msgyesno('CSV OK - Continua ?...')
          lContinua:=.T.
       ELSE 
	      lContinua:=.F.
	   ENDIF 
    ENDIF	   

 	IF lContinua    
	   oFT:ft_fUse()
       aSort(aProc, , , {|x,y| x[1]+x[2] < y[1]+y[2] } ) 
	   IF LEN(aProc)>0
	      ImpSZD(aProc)
	   ELSE 
          FWAlertSuccess('Sem dados para processar!! ')
	   ENDIF

	   FT_FUSE()
    ENDIF 

	FWAlertSuccess('Processo Finalizado!!! ')

Return()



Static Function ImpSZD(aDados)

Processa({|| RunProc(aDados) },"","Atualizando Regisros")

Return()


Static Function RunProc(aDados1)

Local cFilAtu:=""
Local lRet   :=.F.
Local nx:=0



cFilAtu:=cFilAnt

ProcRegua(len(aDados1))

For nx:=1 to len(aDados1)

  IncProc('Processando Registros!!')
  
  //cFilAnt:=aDados1[nx,1]
  DbSelectArea("SZD")
  SZD->(DbSetOrder(2))
  IF SZD->(DBSEEK(XFILIAL('SZD')+aDados1[nx,1]+aDados1[nx,3]+IIF(!Empty(aDados1[nx,2]),aDados1[nx,2],'')))
     SZD->(RECLOCK('SZD',.F.))
     SZD->ZD_CODCLI:=aDados1[nx,4]
     SZD->(MSUNLOCK('SZD'))
  ELSE 
     SZD->(RECLOCK('SZD',.T.))
     
     SZD->ZD_CLIENTE :=aDados1[nx,1]
     SZD->ZD_LOJA    :=aDados1[nx,2]
     SZD->ZD_CODSTE  :=aDados1[nx,3]
     SZD->ZD_CODCLI  :=aDados1[nx,4]
	 
	 SZD->(MSUNLOCK('SZD'))
  ENDIF
Next 

Return(lRet)



Static Function GravaLog(cCli,cLoja,cCodSteck,cCodCli,cErro1)

q := CHR(160)+cCli+';';fwrite(z,q,len(q))
q := CHR(160)+cLoja+';';fwrite(z,q,len(q))
q := CHR(160)+cCodSteck+';';fwrite(z,q,len(q))
q := CHR(160)+cCodCli+';';fwrite(z,q,len(q))
q := CHR(160)+cErro1+';';fwrite(z,q,len(q))  
q := chr(13)+chr(10);fwrite(z,q,len(q))
q:=''

Return()




