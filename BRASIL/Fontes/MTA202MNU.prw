#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA202MNU ºAutor  ³Renato Nogueira     º Data ³  23/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para adicionar itens no menu do MTA202MNU  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function MTA202MNU()
	Local cFS_LIBSTAT	:= SuperGetMV("FS_LIBSTAT",,"")

	aRotina	 := {}

	If __cUserId $ cFS_LIBSTAT
        /*                 
        aAdd(aRotina, { OemToAnsi("Pesuqisa")  		  		, 'AxPesqui' 	, 0, 1,0,.F.})   //pesq   
        aAdd(aRotina, { OemToAnsi("Visulaizar")		  		, 'a202Proc' 	, 0, 2,0,nil})   //visu				
        aAdd(aRotina, { OemToAnsi("Incluir")   		  		, 'a202Proc' 	, 0, 3,0,nil})   //inclui
        aAdd(aRotina, { OemToAnsi("Alterar")   		  		, 'a202Proc' 	, 0, 4,0,nil})   //altera
        aAdd(aRotina, { OemToAnsi("Excluir")   		  		, 'a202Proc' 	, 0, 5,0,nil})   //exclui
        aAdd(aRotina, { OemToAnsi("Compara")   		  		, 'a202CEst' 	, 0, 6,0,nil})   //compara
        aAdd(aRotina, { OemToAnsi("Substituir")		   		, 'a202Subs' 	, 0, 6,0,nil})   //substitui
        aAdd(aRotina, { OemToAnsi("Aprovar/Rejeitar") 		, 'a202Proc' 	, 0, 4,0,nil})   //"Aprovar/Rejeitar"
        aAdd(aRotina, { OemToAnsi("Criar Estrutura")  		, 'a202Proc' 	, 0, 5,0,nil})   //"Criar Estrutura"
        aAdd(aRotina, { OemToAnsi("Legenda")		   		, 'a202Lege' 	, 0, 2,0,.F.})   //Legenda
        aAdd(aRotina, { OemToAnsi("Deleta Componente")		, 'u_A202spdl' 	, 0, 2,0,.F.})   //Legenda
        aAdd(aRotina, { OemToAnsi("Liberar S D Unicom ")	, 'u_A202LbSd' 	, 0, 2,0,.F.}) 
        aAdd(aRotina, { OemToAnsi("Libera status")			, 'u_stesta02' 	, 0, 3,0,.F.}) 
        aAdd(aRotina, { OemToAnsi("Importa Pre-estrutura"), 'U_IMPQCPRO',0,4,0,.F.}) 
        */

		//Emerson Holanda 02/10/23 - Criação dos menus em MVC, pois a nova rotina de pre-estrutura PCPA135 utiliza MVC
		ADD OPTION aRotina TITLE "Visualizar" ACTION 'PCPA135MNU(2)' OPERATION OP_VISUALIZAR ACCESS 0 //"Visualizar"
		ADD OPTION aRotina TITLE "Incluir" ACTION 'PCPA135MNU(3)' OPERATION OP_INCLUIR    ACCESS 0 //"Incluir"
		ADD OPTION aRotina TITLE "Alterar" ACTION 'PCPA135MNU(4)' OPERATION OP_VISUALIZAR ACCESS 0 //"Alterar" - OP_ALTERAR -> OP_VISUALIZAR (Nao realiza lock da FwMBrowse)
		ADD OPTION aRotina TITLE "Excluir" ACTION 'PCPA135MNU(5)' OPERATION OP_VISUALIZAR ACCESS 0 //"Excluir" - OP_ALTERAR -> OP_VISUALIZAR (Nao realiza lock da FwMBrowse)
		ADD OPTION aRotina TITLE "Legenda" ACTION 'P135Legend()'  OPERATION OP_VISUALIZAR ACCESS 0 //"Legenda"
		ADD OPTION aRotina TITLE "Comparar" ACTION 'A135CEst()'    OPERATION OP_VISUALIZAR ACCESS 0 //"Comparar"
		ADD OPTION aRotina TITLE "Pré-Estrutura Similar" ACTION 'A135Copia()'   OPERATION OP_INCLUIR    ACCESS 0 //"Pré-Estrutura Similar"
		If SuperGetMV("MV_APRESTR",.F.,.F.)
			ADD OPTION aRotina TITLE "Enc.Aprovação" ACTION "P135Aprova('E')" OPERATION OP_VISUALIZAR ACCESS 0 //"Enc.Aprovação"
			ADD OPTION aRotina TITLE "Log. Aprovação" ACTION "P135LogApr()"    OPERATION OP_VISUALIZAR ACCESS 0 //"Log. Aprovação"
		Else
			ADD OPTION aRotina TITLE "Aprovar" ACTION "P135Aprova('A')" OPERATION OP_VISUALIZAR ACCESS 0 //"Aprovar"
			ADD OPTION aRotina TITLE "Rejeitar" ACTION "P135Aprova('R')" OPERATION OP_VISUALIZAR ACCESS 0 //"Rejeitar"
		EndIf
		ADD OPTION aRotina TITLE "Criar Estrutura" ACTION 'P135CriaEs()'    OPERATION OP_VISUALIZAR ACCESS 0 //"Criar Estrutura" - OP_ALTERAR -> OP_VISUALIZAR (Nao realiza lock da FwMBrowse)
		ADD OPTION aRotina TITLE "Substituir" ACTION 'P135Subst()' 	  OPERATION OP_VISUALIZAR ACCESS 0 //"Substituir" - OP_ALTERAR -> OP_VISUALIZAR (Nao realiza lock da FwMBrowse)
		//Rotinas Customizadas
		ADD OPTION aRotina TITLE "Deleta Componente" ACTION 'u_A202spdl()'    OPERATION OP_VISUALIZAR ACCESS 0
		ADD OPTION aRotina TITLE "Liberar S D Unicom " ACTION 'u_A202LbSd()' 	  OPERATION OP_VISUALIZAR ACCESS 0
		ADD OPTION aRotina TITLE "Libera status" ACTION 'u_stesta02()'    OPERATION OP_VISUALIZAR ACCESS 0
		ADD OPTION aRotina TITLE "Importa Pre-estrutura" ACTION 'U_IMPQCPRO()' 	  OPERATION OP_VISUALIZAR ACCESS 0
	EndIf

Return()
