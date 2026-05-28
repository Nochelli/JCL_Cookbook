# JCL_Cookbook
![Mainframe](https://img.shields.io/badge/IBM-z%2FOS-blue)
![JCL](https://img.shields.io/badge/JCL-Batch%20Processing-green)


## Utilitários z/OS IBM 

Reuni neste repositório os principais **utilitários IBM** utilizados no ambiente z/OS, com base em estudos e experiências práticas no dia a dia com Mainframe.

O objetivo é servir como material de referência para consultas rápidas, estudo de **JCL (Job Control Language)** e entendimento dos utilitários mais comuns em ambientes batch corporativos.

_Basicamentes são JOBS para manipulação de datasets, incluindo o gerenciamento de GDGs._


**Fluxo de um job**
- JOB       → define o job batch e inicia a execução
- EXEC      → chama o programa/utilitário
- DD        → define datasets (entrada/saída)
- SYSIN     → comandos do utilitário (controla o processamento)
- SYSPRINT  → logs e saída do processamento

**DCB (Data Control Block)**
- RECFM=FB   → Fixed Block
- LRECL      → tamanho do registro
- BLKSIZE    → tamanho do bloco


- SPACE         -> espaco alocado
- DCB           -> caracteristicas do arquivo
- SYSUT1        -> arquivo de entrada
- SYSUT2        -> arquivo de saida


## DISP 

**- DISP(NEW)**     -> cria dataset novo
**- DISP(CATLG)**   -> cataloga se terminar OK
**- DISP(DELETE)**  -> remove se ocorrer erro
**- DISP(OLD)**     -> dataset já existente

`DISP=(NEW,CATLG,DELETE)` == Cria dataset novo, cataloga se OK, apaga se falhar
`DISP=(NEW,DELETE,DELETE)` == Dataset temporário (não fica no catálogo)
`DISP=(NEW,CATLG,KEEP)` == Cria e mantém mesmo se o job falhar
`DISP=SHR` == Leitura compartilhada (vários jobs podem acessar)
`DISP=OLD` == Acesso exclusivo ao dataset (bloqueia outros jobs)
`DISP=(MOD,CATLG,KEEP)` == Adiciona dados no final do dataset
`DISP=(MOD,DELETE,DELETE)` == Append, mas apaga o dataset se ocorrer erro
`DISP=(OLD,UNCATLG,KEEP)` == Remove do catálogo, mas mantém o dataset físico

1º valor = status do dataset
2º valor = ação normal
3º valor = ação em erro
_Exemplo: DISP=(NEW,CATLG,DELETE) == cria → salva → apaga se der erro_




