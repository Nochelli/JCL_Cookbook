//* DISP(NEW)     -> cria dataset novo
//* DISP(CATLG)   -> cataloga se terminar OK
//* DISP(DELETE)  -> remove/remove se ocorrer erro
//* DISP(OLD)     -> dataset já existente
//* SPACE         -> espaco alocado
//* DCB           -> caracteristicas do arquivo
//* SYSUT1        -> arquivo de entrada
//* SYSUT2        -> arquivo de saida

//*IEFBR14 = Criar um DS.
//XXXXXX   JOB (JEFF),'CREATE DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEFBR14         
//DD1      DD DSN=XXXXXX.XXXXXX.XXXXXX,DISP=(NEW,CATLG,DELETE),       
//            SPACE=(CYL,(1,1)),UNIT=SYSDA,
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)

//*IEFBR14 = deletar um DS.
//XXXXXX   JOB (JEFF),'DELETE DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEFBR14
//DD1      DD DSN=XXXXXX.XXXXXX.XXXXXX,DISP=(OLD,DELETE)


//*IEBGENER = copiar um DS.
//XXXXXX   JOB (JEFF),'COPIA DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBGENER                       
//SYSPRINT DD SYSOUT=*                                          
//SYSIN    DD DUMMY                                              
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=OLD         
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),  
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),     
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)


//*IDCAMS = Deletar um GDG Base
//XXXXXX   JOB (JEFF),'DELETAR GDG',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS                                          
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE XX.XXXXXX.XXXXXX GDG FORCE                            
/*

//*IDCAMS = Criar um GDG Base
//XXXXXX JOB (JEFF),'CRIAR GDG',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE GDG (NAME(XX.XXXXXX.XXXXXX)
              LIMIT(10)
              NOEMPTY
              SCRATCH)
/*

//*DFSERA10 = Copiar DS até certa linha especifica.
//XXXXXX   JOB (JEFF),'COPIA',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=DFSERA10,TIME=100               
//SYSPRINT DD DUMMY                                               
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=OLD          
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),     
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),     
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)              
//SYSIN    DD *                                                   
  CONTROL  CNTL  STOPAFT=XXXX //*informar até qual linha copiar.            
/*


