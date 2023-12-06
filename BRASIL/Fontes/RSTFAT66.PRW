#INCLUDE "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT66 ³ Autor ³ Renato Nogueira       ³ Data ³ 25/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao do EAA					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT66()
	
	Local lContinua      := .T.
	Private cString      := "PPM"
	Private aOrd         := {}
	Private cDesc1       := "Este programa tem como objetivo imprimir informacoes do" //
	Private cDesc2       := "EAA" //
	Private cPict        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RSTFAT66" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}  //###
	Private nLastKey     := 0
	Private cPerg        := PadR ("RFAT66", Len (SX1->X1_GRUPO))
	Private titulo       := "" //
	Private nLin         := 06
	Private Cabec1       := ""
	Private Cabec2       := ""
	Private cbtxt        := "Regsitro(s) lido(s)" //
	Private cbcont       := 0
	Private CONTFL       := 01
	Private m_pag        := 01
	Private lRet         := .T.
	Private imprime      := .T.
	Private wnrel        := "RSTFAT66" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private aCombo			:= {}
	Private __aRet := {}
	Private aParamBox := {}
	Private _cAno		:= Space(4)
	
	//AjustaSX1()
	
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,Nil,.F.,aOrd,.F.,Tamanho,,.T.)
	
	//Pergunte(cPerg,.F.)
		
	aCombo := {"TODOS","abner.fernandes","adadiel.soares","altamir.constante","anderson.silva","andre.bugatti","bruna.berte","clayton.braga","denis.bueno","eduardo.campos","eirivaldo.julio","elisabete.moraes","fernanda.bereki","fabio.lessa","gabrielle.souza","gilberto.santos","gildesio.giusti","giovani.zago","janaina.paixao","juliana.queiroz","karina.callegari","kleber.braga","luciano.fernandes","luis.valente","marines.santos","marlon.repres","mauricio.aurelio","michele.florencio","pamela.ambrosio","raphael.steuer","reginaldo.silva","rita.silva","roberto.rosa","rogerio.martello","sebastiana.coelho","suely.guinati","ulisses.almeida","valmir.melo","valter.cardoso","tereza.mello","vinicius.gibrail","viviane.dias"}

	AADD(aParamBox,{1,"Informe o Ano" ,_cAno   ,'@!','.T.',,'.T.',05,.F.})
	AADD(aParamBox,{2,"Selecione o avaliador",,aCombo,50,"",.T.})
 
	If !ParamBox(aParamBox,"Tipo de Análise: ",@__aRet,,,.T.,,500)
		Return
	Endif
	
	If Empty(__aRet[1])
		MsgAlert("Informe o Ano que deseja imprimir o relatorio.","Atenção!")
		lContinua := .F.
	EndIf

	If	nLastKey == 27
		lContinua := .F.
	EndIf
	
	If	lContinua
		SetDefault(aReturn,cString)
	EndIf
	
	If	nLastKey == 27
		lContinua := .F.
	EndIf
	
	If	lContinua
		titulo       := "Relatório EAA - " + __aRet[1]
		RptStatus({|| Relatorio() },Titulo)
	EndIf
	
	PPM->(DbClearFilter())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT66 ³ Autor ³ Renato Nogueira       ³ Data ³ 25/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao do EAA					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Relatorio()
	
	DbSelectArea("PPM")
	PPM->(DbSetOrder(1))
	PPM->(DbGoTop())
	//PPM->(DbSeek(xFilial("CB7")+MV_PAR01,.T.)) // Posiciona no 1o.reg. satisfatorio
	SetRegua(RecCount()-Recno())
	
	While !PPM->(Eof())
		
		//"01-TODOS","02-VENDAS INTERNAS","03-VENDAS EXTERNAS"
		If AllTrim(__aRet[2]) <> Alltrim(PPM->PPM_04) .And. AllTrim(__aRet[2]) <> "TODOS"
			PPM->(DbSkip())
			Loop
		Endif
		
		IF Alltrim(PPM->PPM_ANO) <> Alltrim(__aRet[1])
			PPM->(DbSkip())
			Loop
		EndIF
		/*
		If CB7->CB7_DTEMIS < MV_PAR03 .or. CB7->CB7_DTEMIS > MV_PAR04 // Nao considera as ordens que nao tiver dentro do range de datas
			CB7->(DbSkip())
			Loop
		Endif
		*/

		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

		IncRegua("Imprimindo")  //
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***" //
			//		Exit
		Endif
		Imprime()
		PPM->(DbSkip())
	Enddo
	Fim()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT66 ³ Autor ³ Renato Nogueira       ³ Data ³ 25/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao do EAA					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Imprime(lRet)
	
	Local nWidth  := 0.050
	Local nHeigth := 0.75
	Local oPr
	
	Local _cTexto07  := PPM->PPM_07
	Local _cTexto08  := PPM->PPM_08

	Local _nlinhas07 := mlcount(_cTexto07,200)
	Local _nlinhas08 := mlcount(_cTexto08,200)

	Local _nCount := 0
	
	@ 006, 000 PSay "Avaliado: "+PPM->PPM_01
	@ 007, 000 Psay "Departamento: "+PPM->PPM_03
	@ 008, 000 Psay "Avaliador: "+PPM->PPM_04
	@ 009, 000 Psay "Data de admissão: "+DTOC(PPM->PPM_05)
	@ 010, 000 Psay "Data da avaliação: "+DTOC(PPM->PPM_06)
	@ 011, 000 Psay __PrtThinLine()
	
	nLin := 12
	//nLin++
	
	@ nLin, 000 PSay 'É apaixonado pelo trabalho que realiza, tem comprometimento e prazer em realizar as suas atividades. Cuida dos seus clientes, da companhia, da equipe.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_09,"PPM->PPM_09")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Atua com engajamento e antecipa-se a problemas e/ou situações visando resultados em prol da organização.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_10,"PPM->PPM_10")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Conecta com clientes e colegas. Tem facilidade para fazer negócios e é     sempre aberto a discutir novas ideias.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_11,"PPM->PPM_11")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Engajamento e foco em efetuar suas entregas com qualidade, atendendo as    expectativas daquilo que lhe é atribuido.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_12,"PPM->PPM_12")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Capacidade de entrega com rapidez, cumprimento de prazos, comprometimento  com compromissos e tarefas estabelecidos(as).'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_13,"PPM->PPM_13")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Respeita a diversidade no ambiente de trabalho e atua de forma cooperativa valorizando as diferenças de cada um.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_14,"PPM->PPM_14")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Tem bom relacionamento interpessoal, interage nos trabalhos em equipe com  facilidade.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_15,"PPM->PPM_15")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Age alinhado ao código de conduta ética, gerando credibilidade e confiança por aquele que fazem parte do seu convívio diário.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_16,"PPM->PPM_16")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Desafia outros e abraça os desafios. Está sempre em busca de melhores resultados e não busca a zona de conforto.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_17,"PPM->PPM_17")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'É comprometido com o trabalho, se esforçando para obter resultados e atingir as metas.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_18,"PPM->PPM_18")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Colabora com a segurança, evitando acidentes. Colabora para uso correto de máquinas e ferramentas de trabalho, preservando a sua integridade física e dos colegas.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_19,"PPM->PPM_19")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	/*@ nLin, 000 PSay "Informática: Protheus "
	//nLin++
	//@ nLin, 000 Psay RESPOSTA(PPM->PPM_20,"PPM->PPM_20")
	nLin++
	//@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Instrumentos de Medição (sabe utilizar e calibrar as ferramentas pertinentes às medições de produtos, suas aplicações e preservação) "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_21,"PPM->PPM_21")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Introdução ao Lean Manufactoring "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_22,"PPM->PPM_22")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Kaizen "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_23,"PPM->PPM_23")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Kanban "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_24,"PPM->PPM_24")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Leitura e Interpretação de Desenho Técnico "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_25,"PPM->PPM_25")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Manuseio de Produtos Químicos "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_26,"PPM->PPM_26")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Noções de combate à incêndio "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_27,"PPM->PPM_27")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Nossos Produtos "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_28,"PPM->PPM_28")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "NR10 - Instalações e Serviços em Eletricidade "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_29,"PPM->PPM_29")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "NR12 - Proteção de Máquinas e Equipamentos "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_30,"PPM->PPM_30")
	nLin++
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 06
	@ nLin, 000 PSay "Operação de Empilhadeira "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_31,"PPM->PPM_31")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Operação de Pontes Rolantes "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_32,"PPM->PPM_32")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Técnicas de Negociação "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_33,"PPM->PPM_33")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Técnicos na área de atuação "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_34,"PPM->PPM_34")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Relacionamento com Clientes Internos "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_35,"PPM->PPM_35")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Relacionamento com Clientes Externos "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_36,"PPM->PPM_36")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Criatividade "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_37,"PPM->PPM_37")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Disciplina (horário) "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_38,"PPM->PPM_38")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Iniciativa "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_39,"PPM->PPM_39")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Interesse em Aprendizado "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_40,"PPM->PPM_40")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Organização "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_41,"PPM->PPM_41")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Orientação para o Resultado (comprometimento) "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_42,"PPM->PPM_42")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Polivalência (capacidade da pessoa ter multiplas funções) "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_43,"PPM->PPM_43")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Relacionamento Interpessoal (habilidade de se relacionar com outras pessoas garantindo que as rotinas de trabalho sejam realizadas) "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_44,"PPM->PPM_44")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Trabalho em Equipe (tem a capacidade de ser cooperativo e consciente do seu papel no contexto organizacional) "
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_45,"PPM->PPM_45")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	nLin++
	*/
		
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Levantamento de necessidade de treinamento técnico e/ou operacional "
	nLin++
	If ! Empty(Alltrim(PPM->PPM_CURSO1))
		@ nLin, 000 Psay PPM->PPM_CURSO1
		nLin++
	EndIf

	If ! Empty(Alltrim(PPM->PPM_CURSO2))
		@ nLin, 000 Psay PPM->PPM_CURSO2
		nLin++
	EndIf

	If ! Empty(Alltrim(PPM->PPM_CURSO3))
		@ nLin, 000 Psay PPM->PPM_CURSO3
		nLin++
	EndIf

	If ! Empty(Alltrim(PPM->PPM_CURSO4))
		@ nLin, 000 Psay PPM->PPM_CURSO4
		nLin++
	EndIf

	If ! Empty(Alltrim(PPM->PPM_CURSO5))
		@ nLin, 000 Psay PPM->PPM_CURSO5
		nLin++
	EndIf

	@ nLin,000 PSay __PrtThinLine()
	nLin++

	@ nLin, 000 PSay "Comentário funcionário "
	nLin++
	For _nCount := 1 to _nlinhas07
		@ nLin, 000 PSay memoline(_cTexto07,200,_nCount)
		nLin++
	Next _nCount
	
	@ nLin,000 PSay __PrtThinLine()
	nLin++

	//@ nLin, 000 Psay PPM->PPM_07
	//nLin++

	@ nLin, 000 PSay "Comentário avaliador "
	nLin++
	
	For _nCount := 1 to _nlinhas08
		@ nLin, 000 PSay memoline(_cTexto08,200,_nCount)
		nLin++
	Next _nCount
	
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	
	//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	/*
	If nLin > 50
		//imprime o rodape
		nLin++
		@ nLin,000 PSay __PrtThinLine()
		
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 06
		//@ nLin, 000 PSay "Armazem  Endereco         Produto          Descricao                       Composicao                          Quantidade  Lote        Data Validade  Observacao"
		@ nLin, 000 PSay "Teste  "
		nLin++
		@ nLin, 000 PSay __PrtThinLine()
		nLin++
		
	Endif
	*/
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Fim()
	
	SET DEVICE TO SCREEN
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

/*
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i:= 0
	Local j := 0
	cPerg         := PADR(cPerg,10)
	AADD(_aRegs,{cPerg,"01","Informe o Ano ?  ","","","mv_ch1","C",04,0,0,"G"," ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(_aRegs,{_cPerg,"02","Data Final ?    ","","","mv_ch2","D",08,0,0,"G"," ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	for i := 1 to len(_aRegs)
		If !SX1->(dbSeek(cPerg+_aRegs[i,2]))
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
return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³                       ³ Data ³ 26/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINR190                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
	
	Local _aArea  := GetArea()
	Local _Nx     := 0
	Local _aRegs  := {}
	Local _cOrdem := 1
	
	cPerg := PADR(cPerg,10)  //CORRIGIDO DIA 11/06 - EUGENIO
	AAdd(_aRegs,{OemToansi("Ordem Separacao de          ?"),OemToansi("Ordem Separacao de          ?"),OemToansi("Ordem Separacao de          ?"),"mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","CB7",""})
	AAdd(_aRegs,{OemToansi("Ordem Separacao ate         ?"),OemToansi("Ordem Separacao ate         ?"),OemToansi("Ordem Separacao ate         ?"),"mv_ch2","C", 6,0,0,"G","","mv_par02","","","",REPLICATE("Z",4),"","","","","CB7",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For _Nx:=1 to Len(_aRegs)
		_cOrdem := StrZero(_Nx,2)/* Removido - 12/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		If !MsSeek(cPerg+_cOrdem)
			RecLock("SX1",.T.)
			SX1->X1_GRUPO		:= cPerg
			SX1->X1_ORDEM		:= _cOrdem
			SX1->X1_PERGUNTE	:= _aRegs[_Nx][01]
			SX1->X1_PERSPA		:= _aRegs[_Nx][02]
			SX1->X1_PERENG		:= _aRegs[_Nx][03]
			SX1->X1_VARIAVL		:= _aRegs[_Nx][04]
			SX1->X1_TIPO		:= _aRegs[_Nx][05]
			SX1->X1_TAMANHO		:= _aRegs[_Nx][06]
			SX1->X1_DECIMAL		:= _aRegs[_Nx][07]
			SX1->X1_PRESEL		:= _aRegs[_Nx][08]
			SX1->X1_GSC			:= _aRegs[_Nx][09]
			SX1->X1_VALID		:= _aRegs[_Nx][10]
			SX1->X1_VAR01		:= _aRegs[_Nx][11]
			SX1->X1_DEF01		:= _aRegs[_Nx][12]
			SX1->X1_DEFSPA1		:= _aRegs[_Nx][13]
			SX1->X1_DEFENG1		:= _aRegs[_Nx][14]
			SX1->X1_CNT01		:= _aRegs[_Nx][15]
			SX1->X1_VAR02		:= _aRegs[_Nx][16]
			SX1->X1_DEF02		:= _aRegs[_Nx][17]
			SX1->X1_DEFSPA2		:= _aRegs[_Nx][18]
			SX1->X1_DEFENG2		:= _aRegs[_Nx][19]
			SX1->X1_F3			:= _aRegs[_Nx][20]
			SX1->X1_GRPSXG		:= _aRegs[_Nx][21]
			MsUnlock()
		Endif*/
	Next
	RestArea(_aArea)
	
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT66 ³ Autor ³ Renato Nogueira       ³ Data ³ 25/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao do EAA					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RESPOSTA(_nResp,_cPerg)
	
	Local _nPerg	:= Val(SubStr(_cPerg,10,2))
	Local _cResp	:= ""
	_nResp	:= Val(_nResp)
	
	If _nPerg <= 12
		DO CASE
		CASE _nResp=1
			_cResp	:= "Meta não alcançada"
		CASE _nResp=2
			_cResp	:= "Meta parcialmente alçançada"
		CASE _nResp=3
			_cResp	:= "Meta alcançada"
		CASE _nResp=4
			_cResp	:= "Meta excedida"
		CASE _nResp=5
			_cResp	:= "Meta constantemente excedida"
		ENDCASE
	ElseIf _nPerg <= 33
		DO CASE
		CASE _nResp=1
			_cResp	:= "Meta não alcançada"
		CASE _nResp=2
			_cResp	:= "Meta parcialmente alçançada"
		CASE _nResp=3
			_cResp	:= "Meta alcançada"
		CASE _nResp=4
			_cResp	:= "Meta excedida"
		CASE _nResp=5
			_cResp	:= "Meta constantemente excedida"
		ENDCASE
	Else
		DO CASE
		CASE _nResp=1
			_cResp	:= "N/A - Não se aplica"
		CASE _nResp=2
			_cResp	:= "Não possui"
		CASE _nResp=3
			_cResp	:= "Bom"
		CASE _nResp=4
			_cResp	:= "Ótimo"
		CASE _nResp=5
			_cResp	:= "Excelente"
		ENDCASE
	EndIf
	
Return(_cResp)
