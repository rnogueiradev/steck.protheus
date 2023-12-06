#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
 



User  Function STXMLPROCES(cOrigem)
	Local lRet
	Local nCount := 0
	Local nTotal := 0
	Local lProc  := .F.
	Local lOk    := .F.
	Local oModelGW4
	Local nCountDC := 0
	Local lDCUsoCons := .F.
	Local cCredPC
	Local aAreaGW1 := GW1->( GetArea() )
	Local cLogOption   := SuperGetMV('MV_GFEEDIL',,'1')
	Local cFilTemp := cFilAnt
	Local nCountZerosNF := 0
	Local lNrDf := .F.
	Local aFormat       := {7, 8, 9, 6, 0} //Sequência do tamanho para as tentativas de posicionamento no Documento de Carga.	
	Local cNumeroNF     := ""  	// Numero da Nota Fiscal do arquivo
	Local nI		    := 0
	Local nFormat       := 0		
	Local cNRDF
	Local aArray    := {}
	local nCont
	Local lMsgErr := .F.
	Local cCont:= 0 
	Local cContDel := 0	
	Local cNum := ""
	Local cSer := ""
	Local cEmi := ""
	Private GFELog115 := GFELog():New("EDI_Conemb_Processamento", "EDI Conemb - Processamento", cLogOption)
	Private lRetMsg 	:= .F.
	Private lRetRedes 	:= .F.
	Default cOrigem := "1"

	
	DbSelectArea('GXG')
	GXG->( dbSetOrder(01) )
	GXG->( dBGoTop() )
	// Aqui ocorre o instanciamento do modelo de dados (Model)
	oModel    := FWLoadModel( "GFEA065" )
	oModelGW4 := oModel:getModel("GFEA065_GW4")
		
	While !GXG->( Eof() )
		If  GXG->GXG_EDISIT == '4'
			GXG->( dbSkip() )
			Loop
		EndIf

		lProc := .T.
		lDCUsoCons := .F.
		nTotal++

		If GXG->GXG_ACAO != "E"
			// Verifica se o conhecimento já está cadastrado
			dbSelectArea("GW3")
			dbSetOrder(1)
			If dbSeek(PadR(GXG->GXG_FILDOC, TamSX3("GW3_FILIAL")[1]) + ;
					  PadR(GXG->GXG_CDESP,  TamSX3("GW3_CDESP")[1])  + ;
					  PadR(GXG->GXG_EMISDF, TamSX3("GW3_EMISDF")[1]) + ;
					  PadR(GXG->GXG_SERDF,  TamSX3("GW3_SERDF")[1])  + ;
					  PadR(GXG->GXG_NRDF,   TamSX3("GW3_NRDF")[1])   + ;
					  DTOS(GXG->GXG_DTEMIS))
				RecLock("GXG",.F.)
				If GXG->GXG_ORIGEM != "2" .Or. ( Empty(GXG->GXG_ORINR) .And. Empty(GXG->GXG_ORISER))
		        	GXG->GXG_EDIMSG := "- " + "Conhecimento já cadastrado."
		            GXG->GXG_EDISIT := '3'
				Else
		
		        	GXG->GXG_EDIMSG := "- " + "Não é possível importar documento de frete substituto " +;
										  "pois o documento de frete substituído ainda existe na base. " +;
										  "Filial Docto: " + AllTrim(GXG->GXG_FILDOC) +;
										  " Especie Docto: " + AllTrim(GXG->GXG_CDESP) +;
										  " Emis Docto: " + AllTrim(GXG->GXG_EMISDF) +;
										  " Serie Docto: " + AllTrim(GXG->GXG_SERDF) +;
										  " Nr Docto: X." + AllTrim(GXG->GXG_NRDF)
		            GXG->GXG_EDISIT := '3'
				EndIf
				MsUnLock("GXG")
		    	dbSelectArea('GXG')
		    	GXG->( dbSkip() )
				Loop
			EndIf
		Endif
		// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
		If GXG->GXG_ACAO == "E"	
			dbSelectArea("GVT")
			aGVTStruct := GVT->( dbStruct() )
	
	
		 	//Número do Documento de Frete
		 	cNRDF := GXG->GXG_NRDF
	
			If AScan(aGVTStruct, {|x| x[1] == "GVT_FORMNM"}) != 0
	
				dbSelectArea("GVT")
				GVT->( dbSetOrder(1) )
				If GVT->( dbSeek(xFilial("GVT") + GXG->GXG_CDESP) )
					
					If GVT->GVT_ZEROS == "2"
						cNRDF := GFEZapZero(AllTrim(GXG->GXG_NRDF))
					ElseIf GVT->GVT_ZEROS == "3"
						cNRDF := PadL(AllTrim(GFEZapZero(GXG->GXG_NRDF)), IIf(GVT->GVT_QTALG == 0, TamSX3("GW3_NRDF")[1], GVT->GVT_QTALG), "0")
					EndIf
					
					If Len(AllTrim(cNRDF)) > GVT->GVT_QTALG .And. GVT->GVT_QTALG != 0
						dbSelectArea('GXG')
			    		GXG->( dbSkip() )
						Loop
					EndIf
	
					If GVT->GVT_FORMNM == "1" .And. !GFEVldFor1(AllTrim(cNRDF), "IsDigit")						
						dbSelectArea('GXG')
			    		GXG->( dbSkip() )
						Loop
					ElseIf GVT->GVT_FORMNM == "2" .And. !GFEVldFor1(AllTrim(cNRDF), "LetterOrNum")
			    		dbSelectArea('GXG')
			    		GXG->( dbSkip() )
						Loop
					EndIf
				else	
					cEsp := GXG->GXG_CDESP
			    	dbSelectArea('GXG')
			    	GXG->( dbSkip() )
					Loop
							 
				EndIf

				dbSelectArea("GW3")
				dbSetOrder(1)
				If dbSeek(PadR(GXG->GXG_FILDOC, TamSX3("GW3_FILIAL")[1]) + ;
						  PadR(GXG->GXG_CDESP,  TamSX3("GW3_CDESP")[1])  + ;
						  PadR(GXG->GXG_EMISDF, TamSX3("GW3_EMISDF")[1]) + ;
						  PadR(GXG->GXG_SERDF,  TamSX3("GW3_SERDF")[1])  + ;
						  PadR(cNRDF,           TamSX3("GW3_NRDF")[1])   + ;
						  DTOS(GXG->GXG_DTEMIS))
				
				Else
					
					RecLock("GXG",.F.)
			  		GXG->GXG_EDIMSG :=  "Não foi encontrado o Documento de Frete para ser excluído."
			        GXG->GXG_EDISIT := '3'
					MsUnLock("GXG")
					GXG->( dbSkip() )
					Loop
				EndIf

			EndIf
	
			// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão		
		 
			oModel:SetOperation( 5 )
		Else 
			oModel:SetOperation( 3 )
		EndIf

		// Antes de atribuirmos os valores dos campos temos que ativar o modelo
		DbSelectArea('GXH')
		GXH->( dbSetOrder(1) )
		GXH->( dbSeek(GXG->GXG_FILIAL + GXG->GXG_NRIMP) )		
		cFilAnt := GXH->GXH_FILDC
		oModel:Activate()

		If GXG->GXG_ACAO != "E"

			// Carrega os dados do documento de frete no model
			oModel:SetValue("GFEA065_GW3",'GW3_FILIAL' ,GXG->GXG_FILDOC )
			oModel:SetValue("GFEA065_GW3",'GW3_CDESP'  ,ALLTRIM(GXG->GXG_CDESP ) )
			oModel:SetValue("GFEA065_GW3",'GW3_EMISDF' ,ALLTRIM(GXG->GXG_EMISDF) )
			oModel:SetValue("GFEA065_GW3",'GW3_SERDF'  ,ALLTRIM(GXG->GXG_SERDF) )
			oModel:SetValue("GFEA065_GW3",'GW3_NRDF'   ,ALLTRIM(GXG->GXG_NRDF)  )
			oModel:SetValue("GFEA065_GW3",'GW3_DTEMIS' ,GXG->GXG_DTEMIS )
			oModel:SetValue("GFEA065_GW3",'GW3_DTENT ' ,GXG->GXG_DTENT  )			
			oModel:SetValue("GFEA065_GW3",'GW3_CDREM'  ,ALLTRIM(GXG->GXG_CDREM ) )
			oModel:SetValue("GFEA065_GW3",'GW3_CDDEST' ,ALLTRIM(GXG->GXG_CDDEST) )
			oModel:SetValue("GFEA065_GW3",'GW3_TPDF'   ,ALLTRIM(GXG->GXG_TPDF) )
			oModel:SetValue("GFEA065_GW3",'GW3_PESOR'  ,GXG->GXG_PESOR  )
			oModel:SetValue("GFEA065_GW3",'GW3_FRPESO' ,GXG->GXG_FRPESO )
			oModel:SetValue("GFEA065_GW3",'GW3_FRVAL'  ,GXG->GXG_FRVAL  )
			oModel:SetValue("GFEA065_GW3",'GW3_TAXAS'  ,GXG->GXG_TAXAS  )
			oModel:SetValue("GFEA065_GW3",'GW3_PEDAG'  ,GXG->GXG_PEDAG  )
			oModel:SetValue("GFEA065_GW3",'GW3_VLDF'   ,GXG->GXG_VLDF   )
			oModel:SetValue("GFEA065_GW3",'GW3_CFOP'   ,GXG->GXG_CFOP)
			oModel:SetValue("GFEA065_GW3",'GW3_ORIGEM' ,cOrigem)
			If GXGTIDCBI()
				oModel:SetValue("GFEA065_GW3",'GW3_QTDCS'  ,GXG->GXG_QTDCS)
				oModel:SetValue("GFEA065_GW3",'GW3_VOLUM'  ,GXG->GXG_VOLUM)
				oModel:SetValue("GFEA065_GW3",'GW3_VLCARG' ,GXG->GXG_VLCARG)
				oModel:SetValue("GFEA065_GW3",'GW3_QTVOL'  ,GXG->GXG_QTVOL)
			EndIf
			
			If GXG->GXG_TPDF != '3' .And. Abs(GXG->GXG_BASIMP - GXG->GXG_VLDF) > GXG->GXG_PEDAG .And. GXG->GXG_TRBIMP == "1"
				oModel:LoadValue("GFEA065_GW3",'GW3_TRBIMP',"5")
			Else
				oModel:LoadValue("GFEA065_GW3",'GW3_TRBIMP',GXG->GXG_TRBIMP )
			EndIf

			oModel:LoadValue("GFEA065_GW3",'GW3_PCIMP' ,GXG->GXG_PCIMP  )
			oModel:LoadValue("GFEA065_GW3",'GW3_BASIMP',GXG->GXG_BASIMP )
			oModel:LoadValue("GFEA065_GW3",'GW3_VLIMP' ,GXG->GXG_VLIMP )

			oModel:LoadValue("GFEA065_GW3",'GW3_IMPRET',GXG->GXG_IMPRET )
			oModel:LoadValue("GFEA065_GW3",'GW3_PCRET',GXG->GXG_PCRET )

			oModel:SetValue("GFEA065_GW3",'GW3_ORINR' ,ALLTRIM(GXG->GXG_ORINR ) )
			oModel:SetValue("GFEA065_GW3",'GW3_ORISER',ALLTRIM(GXG->GXG_ORISER) )
			oModel:SetValue("GFEA065_GW3",'GW3_CTE'   ,AllTrim(GXG->GXG_CTE) )
			
			If Empty(GXG->GXG_CTE)
				oModel:SetValue("GFEA065_GW3",'GW3_TPCTE'   , " ")
			Elseif !Empty(GXG->GXG_CTE) .and. (GXG->GXG_TPCTE)<> '0'
				oModel:SetValue("GFEA065_GW3",'GW3_TPCTE'   ,AllTrim(GXG->GXG_TPCTE) )
			Else 
				oModel:SetValue("GFEA065_GW3",'GW3_TPCTE'   , "0")
			EndIf

			nCountDC := 0
		 

			DbSelectArea('GXH')
			GXH->( dbSetOrder(1) )
			GXH->( dbSeek(GXG->GXG_FILIAL + GXG->GXG_NRIMP) )
			While !GXH->(Eof()) .AND. ;
			       GXH->GXH_FILIAL == GXG->GXG_FILIAL .AND. ;
				   GXH->GXH_NRIMP  == GXG->GXG_NRIMP

				nCountDC++

				 
				If nCountDC > 1
					oModelGW4:addLine()
				EndIf

				If !lDCUsoCons
					dbSelectArea("GW1")
					GW1->( dbSetOrder(1) )
					If GW1->( dbSeek(GXH->GXH_FILDC + GXH->GXH_TPDC + GXH->GXH_EMISDC + GXH->GXH_SERDC + GXH->GXH_NRDC) ) .And. GW1->GW1_USO == "2"
					 
						lDCUsoCons := .T.
					EndIf
				EndIf

		 
				// Valida se o documento de carga existe
				//Considera documentos com ou sem zeros a esquerda 
				nCountZerosNF := 0
				lNrDf := .F.
				dbSelectArea("GW1")
				dbSetOrder(1)
				While nCountZerosNF <= 6
					cNumeroNF := Replicate("0",nCountZerosNF) + GXH->GXH_NRDC
					If dbSeek(GXH->GXH_FILDC + GXH->GXH_TPDC + GXH->GXH_EMISDC + GXH->GXH_SERDC + AllTrim(cNumeroNF ))
						lNrDf := .T.	
						Exit
					EndIf
					nCountZerosNF++
				EndDo
				
	 

				// Carrega os dados do documento de carga relacionado ao documetno de frete
				oModelGW4:SetValue('GW4_FILIAL', GXH->GXH_FILDC)			
				oModelGW4:SetValue('GW4_EMISDF', GXG->GXG_EMISDF)
				oModelGW4:SetValue('GW4_CDESP ', GXG->GXG_CDESP )
				oModelGW4:SetValue('GW4_SERDF' , GXG->GXG_SERDF )
				oModelGW4:SetValue('GW4_NRDF'  , GXG->GXG_NRDF  )
				oModelGW4:SetValue('GW4_DTEMIS', GXG->GXG_DTEMIS)
				oModelGW4:SetValue('GW4_EMISDC', GXH->GXH_EMISDC)
				oModelGW4:SetValue('GW4_SERDC' , GXH->GXH_SERDC )
				oModelGW4:SetValue('GW4_NRDC'  , Alltrim(cNumeroNF ))
				oModelGW4:SetValue('GW4_TPDC'  , GXH->GXH_TPDC  )

				DbSelectArea('GXH')
				GXH->( dbSkip() )

		    EndDo

 

	 

			// Crédito ICMS
	 
			If SuperGetMv("MV_GFECRIC", .F., "1", GXG->GXG_FILDOC) == "2"	// Sem direito a crédito
				IF (!Empty(GXG->GXG_BASIMP))
				  
				    oModel:LoadValue("GFEA065_GW3", "GW3_TRBIMP", "6")	// Só muda para a tributação para Outros, se não tiver base de imposto.
				Endif
			EndIf

			If !lDCUsoCons .And. oModel:GetValue("GFEA065_GW3", "GW3_TRBIMP") $ "1;3;4;5;7"
				oModel:LoadValue("GFEA065_GW3", "GW3_CRDICM", "1")
			 
			Else
				oModel:LoadValue("GFEA065_GW3", "GW3_CRDICM", "2")
			 
			EndIf

			 



			// Crédito PIS/COFINS
 
			cCredPC := GetNewPar("MV_GFEPC", "1", cFilAnt)
			If Empty(cCredPC)
				cCredPC := "1"
			EndIf
			 

			If cCredPC == "1" .And. !lDCUsoCons .And. (!Posicione("GU3", 1, xFilial("GU3") + oModel:GetValue("GFEA065_GW3", "GW3_CDREM"), "GU3->GU3_EMFIL") == "1" .Or. ;
		 	   !Posicione("GU3", 1, xFilial("GU3") + oModel:GetValue("GFEA065_GW3", "GW3_CDDEST"), "GU3->GU3_EMFIL") == "1")
				oModel:LoadValue("GFEA065_GW3", "GW3_CRDPC", "1")
			Else
				oModel:LoadValue("GFEA065_GW3", "GW3_CRDPC", "2")
			EndIf

		EndIf

		lRet := oModel:VldData()

		If (lRet) // Validou o modelo para exclusão

			If GXG->GXG_ACAO == "E"
			
				dbSelectArea('GXH')
				GXH->( dbSetOrder(1) )
				GXH->( dbSeek(GXG->GXG_FILIAL + GXG->GXG_NRIMP) )

				cCont:= 0 
				cContDel := 0
				// Valida se existem diferenças de documentos
				// do registro intermediário para o documento de frete eliminado
				While !Eof() .And. GXG->GXG_FILIAL + GXG->GXG_NRIMP == GXH->GXH_FILIAL + GXH->GXH_NRIMP	
					cCont:= cCont +1
					GW4->( dbSetOrder(1) )
					If GW4->( dbSeek(GXG->GXG_FILDOC;
						+PadR(GXG->GXG_EMISDF, TamSx3("GW4_EMISDF")[1]);
						+PadR(GXG->GXG_CDESP, TamSx3("GW4_CDESP")[1]);
						+PadR(GXG->GXG_SERDF,TamSx3("GW4_SERDF")[1]);
						+PadR(cNRDF,TamSx3("GW4_NRDF")[1]);
						+DTOS(GXG->GXG_DTEMIS);
						+PadR(GXH->GXH_EMISDC, TamSx3("GW4_EMISDC")[1]);
						+PadR(GXH->GXH_SERDC,TamSx3("GW4_SERDC")[1]);
						+PadR(GXH->GXH_NRDC,TamSx3("GW4_NRDC")[1]);
						+PadR(GXH->GXH_TPDC,TamSx3("GW4_TPDC")[1])) )
						
						cContDel := cContDel + 1								
					else 
						cNum := GXH->GXH_NRDC
						cSer := GXH->GXH_SERDC
						cEmi := GXH->GXH_EMISDC	
						Exit														
					EndIf
					DbSelectArea('GXH')
					GXH->( dbSkip() )
				EndDo     
			    
			    If  cContDel == cCont .And. cCont > 0                                                                     
				    dbSelectArea('GW3')
					GW3->( dbSetOrder(1) )
					If GW3->( dbSeek(GXG->GXG_FILDOC;
						+PadR(GXG->GXG_CDESP,TamSx3("GW3_CDESP")[1]);
						+PadR(GXG->GXG_EMISDF, TamSx3("GW3_EMISDF")[1]);
						+PadR(GXG->GXG_SERDF,TamSx3("GW3_SERDF")[1]);
						+PadR(cNRDF,TamSx3("GW3_NRDF")[1]);
						+DTOS(GXG->GXG_DTEMIS)) )
						lOk := .T.
					    oModel:CommitData()				
					EndIf
				Else 
				    lMsgErr := .T.
				EndIf	
			 			
			ElseIf GXG->GXG_ACAO $ "IC"
				oModel:CommitData()
				lOk := .T.
			EndIf
			//Validou os registros intermediários
			If lOk
				nCount++
				RecLock("GXG",.F.)
		       	GXG->GXG_EDIMSG := ""
		        GXG->GXG_EDISIT := '4'		       
		       	If lRetMsg
		       		GXG->GXG_EDIMSG := "Documento de Carga possui ocorrência!"
		       	EndIf
				MsUnLock("GXG")
			Else
				RecLock("GXG",.F.)
				If lMsgErr
			  		// STR0006 //"Não foi encontrado o Documento de Frete para ser excluído."
			        GXG->GXG_EDISIT := '3'	         
		        	GXG->GXG_EDIMSG := "Não foi encontrado o Documento de Frete para ser excluído." + "   Erro no Documento de Carga -  Série: " + cSer +" Número: "+cNum+" Emissor: "+ cEmi 
		        EndIf    
				MsUnLock("GXG")
			EndIf
		Else
		
			//  A estrutura do vetor aErro com erro é:
			//  [1] Id do formulário de origem
			//  [2] Id do campo de origem
			//  [3] Id do formulário de erro
			//  [4] Id do campo de erro
			//  [5] Id do erro
			//  [6] mensagem do erro
			//  [7] mensagem da solução
			//  [8] Valor atribuido
			//  [9] Valor anterior
			aErro := oModel:GetErrorMessage()

			RecLock("GXG",.F.)
				 
	           	GXG->GXG_EDIMSG := "Ocorreu um erro no campo: " + aErro[4] + ". Motivo: " + aErro[6] + CRLF //"Ocorreu um erro no campo: "###". Motivo: "
	           	GXG->GXG_EDISIT := '3'
	           	If lRetRedes
		       		GXG->GXG_EDIMSG := "** Erro na inclusão do registro."+ CRLF +"O Documento de Carga " + cNum+" já está vinculado em outro Documento de Frete ("+GXG->GXG_NRDF+") do tipo redespacho para este emissor." 
		       	EndIf
			MsUnLock("GXG")
		EndIf
		oModel:DeActivate()

 

	    dbSelectArea('GXG')
	    GXG->( dbSkip() )
	EndDo

	RestArea(aAreaGW1)

 
	cFilAnt := cFilTemp
	 

Return
