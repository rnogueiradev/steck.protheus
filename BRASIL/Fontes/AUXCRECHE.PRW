#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ASSMEDICA³ Autor ³ Carlos Miranda        ³ Data ³ 18.09.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Auxilio Creche                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMake ( DOS e Windows )                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para STECK                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AUXCRECHE() // STECK SP


SetPrvt("NVALO_,nIdade_,nDep")


nValo_  := 0 
nDep_   := 0 
nidade_	:= 0

                                                        	
dBSelectArea("SRB")
dBSetOrder(1)

//Pesquisa Dependente
dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)

While !Eof() .and. SRA->RA_FILIAL + SRA->RA_MAT == SRB->RB_FILIAL + SRB->RB_MAT
	

      nIdade_ := INT((DDATA_PGTO - SRB->RB_DTNASC) / 30)

      If nIdade_ <= 18 .AND. SRB->RB_AUXCRE = "1" .and. SRB->RB_GRAUPAR = "F" 
         nDep_  += 1
      Endif    


        SRB->(dbSkip())

EndDo
 
//Calculo

If nDep_ > 0 .AND. SRA->RA_SEXO = "F"

//If SRB->RB_AUXCRE = "1" .and. SRB->RB_GRAUPAR = "F" .And. nIdade_ <= 18 
//	nValo_ := Salario * 0.20
    nValo_ := FTABELA("U001",1,4,,) * FTABELA("U001",1,5,,) / 100
//Endif

        
nValo_  := nValo_ 
                                  
//  If MESANO(DDATABASE) <> MESANO(SRB->RB_DTNASC)    
  If MESANO(DDATA_PGTO) <> MESANO(SRB->RB_DTNASC)    

//	If nValo_ > 0 .and. SRB->RB_AUXCRE == "1" .and. SRB->RB_GRAUPAR = "F" .and.  nIdade_ <= 18

// 	   fGeraVerba('225',nValo_,(nDep_),,,,,,,,.T.)
//     FGERAVERBA("225",FTABELA("U001",1,4,,) * FTABELA("U001",1,5,,) / 100 * VAL(SRA->RA_DEPAUXC),VAL(SRA->RA_DEPAUXC),,,,,,,,,)             
       FGERAVERBA("225",nValo_ * nDep_,nDep_,,,,,,,,,)             
  Endif 
Endif 	

//Endif


Return(" ")
           

User Function AMAUXCRECHE() // STECK MANAUS


SetPrvt("NVALO_,nIdade_,nDep")


nValo_  := 0 
nDep_   := 0 
nidade_	:= 0

                                                        	
dBSelectArea("SRB")
dBSetOrder(1)

//Pesquisa Dependente
dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)

While !Eof() .and. SRA->RA_FILIAL + SRA->RA_MAT == SRB->RB_FILIAL + SRB->RB_MAT
	

      nIdade_ := INT((DDATA_PGTO - SRB->RB_DTNASC) / 30.43) // 30.43 eh a media de dias por mes durante um ano de 365.25 dias, considerando ano bissexto

      If nIdade_ <= 47 .AND. SRB->RB_AUXCRE = "1" .and. SRB->RB_GRAUPAR = "F" 
         nDep_  += 1
      Endif    


        SRB->(dbSkip())

EndDo
 
//Calculo

If nDep_ > 0 .AND. SRA->RA_SEXO = "F"

//If SRB->RB_AUXCRE = "1" .and. SRB->RB_GRAUPAR = "F" .And. nIdade_ <= 18 
//	nValo_ := Salario * 0.20
    nValo_ := FTABELA("U001",1,4,,) * FTABELA("U001",1,5,,) / 100
//Endif

        
nValo_  := nValo_ 
                                  
//  If MESANO(DDATABASE) <> MESANO(SRB->RB_DTNASC)
    If MESANO(DDATA_PGTO) <> MESANO(SRB->RB_DTNASC)    

//	If nValo_ > 0 .and. SRB->RB_AUXCRE == "1" .and. SRB->RB_GRAUPAR = "F" .and.  nIdade_ <= 18

// 	   fGeraVerba('225',nValo_,(nDep_),,,,,,,,.T.)
//     FGERAVERBA("225",FTABELA("U001",1,4,,) * FTABELA("U001",1,5,,) / 100 * VAL(SRA->RA_DEPAUXC),VAL(SRA->RA_DEPAUXC),,,,,,,,,)             
       FGERAVERBA("225",nValo_ * nDep_,nDep_,,,,,,,,,)             
  Endif 
Endif 	

//Endif


Return(" ")