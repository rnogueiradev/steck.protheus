#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA020TOK �Autor  � Ricardo Posman     � Data �  15/03/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do Cadastro de Fornecedores.                     ���
�������������������������������������������������������������������������͹��
���Uso       � Estoque/Compras/Fiscal - Cliente Patola                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
//��������������������������������������������������������������������������������
//� Obriga a digitacao do CNPJ/CPF quando o Fornecedor nao pertencer ao Estado EX�
//� Obriga digitar inscricao estadual e no valid A2_INSCR funcao valida digito   �
//��������������������������������������������������������������������������������
*/

User Function MA020TOK()

	Local _cQuery 	:= ""
	Local _cAlias 	:= "QRYTEMP"
	Local lOk   	:= .T.
    Local lAuto     := .F.
    Default INCLUI  := .F.
    Default ALTERA  := .F.
    Default cMsgRet := ""
    
    //FR - 17/10/2022 - TRATATIVA QDO A CHAMADA VIER DA ROTINA AUTOM�TICA STBPO001
    If IsInCallStack("U_STBPO001")
        lAuto  := .T. 
        INCLUI := .T.      
    Endif 
    //FR - 17/10/2022 - TRATATIVA QDO A CHAMADA VIER DA ROTINA AUTOM�TICA STBPO001
  
	If IsInCallStack("U_STIMP040")
		Return(.T.)
	EndIf

	If Inclui

		// Chama Funcao para validar cadastro
		If M->A2_TIPO <> "X"
			If EMPTY(M->A2_CGC)
				MSGAlert("Aten��o! Digite o CNPJ / CPF do Fornecedor. ")
				Return (.F.)
			Endif
			If EMPTY(M->A2_INSCR) .and. !lAuto
				MSGAlert("Aten��o! Digite a Inscricao Estadual do Fornecedor ou informe se ISENTO. ")
				Return (.F.)
			Endif
		Endif
	Endif

	If INCLUI .And. lOk //Chamado 001628

		M->A2_XDTCAD	:= Date()

	EndIf

	If (INCLUI .OR. ALTERA) //Pode incluir mesmo CNPJ por�m com IE diferente - Chamado 002910

		_cQuery  := " SELECT COUNT(*) CONTADOR "
		_cQuery  += " FROM " +RetSqlName("SA2")+ " A2 "
		_cQuery  += " WHERE A2.D_E_L_E_T_=' ' AND A2_INSCR='"+M->A2_INSCR+"' AND TRIM(A2_INSCR)<>'ISENTO' "

		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())

		If (_cAlias)->(CONTADOR)>0
			MsgInfo("Aten��o, essa IE j� foi cadastrada, verifique!","Erro")
			Return (.F.)
		EndIf

		//Claudia Ferreira solicitou que fosse retirada a valida��o pois a entrada do xml � CNPJ+IE - 21/10/2015
		/*
		_cQuery  := " SELECT COUNT(*) CONTADOR "
		_cQuery  += " FROM " +RetSqlName("SA2")+ " A2 "
		_cQuery  += " WHERE A2.D_E_L_E_T_=' ' AND A2_CGC='"+M->A2_CGC+"' "

		If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())

		If (_cAlias)->(CONTADOR)>0
		MsgInfo("Aten��o, esse cnpj j� foi cadastrado, verifique!","Erro")
		Return (.F.)
		EndIf
		*/

	EndIf

	//FR - 17/10/2022 - TRATATIVA QDO A CHAMADA VIER DA ROTINA AUTOM�TICA STBPO001
    //Giovani zago Ticket 20200110000033
	 If Empty(Alltrim(M->A2_COD_MUN)) .And. M->A2_EST <> 'EX'
        If !lAuto
            MsgInfo("Codigo de Municipio N�o Cadastrado Verifique....!!!!!!")
            Return (.F.)
        Else 
            cMsgRet := "Codigo de Municipio N�o Cadastrado Verifique....!!!!!!"
            lOK     := .F.
        EndIf
    Endif 
    //FR - 17/10/2022 - TRATATIVA QDO A CHAMADA VIER DA ROTINA AUTOM�TICA STBPO001

Return(lOK)
