*&---------------------------------------------------------------------*
*& Include          ZR_HEADER_ITEMALV_TOP
*&---------------------------------------------------------------------*
TABLES: ztb_c100_l, ztb_c170_l.

CONSTANTS: gc_stts1 TYPE STRING VALUE 'CASADO',
           gc_stts2 TYPE STRING VALUE 'DIVERGENTE',
           gc_stts3 TYPE STRING VALUE 'HEADER_SEM_ITEM',
           gc_stts4 TYPE STRING VALUE 'ITEM_SEM_HEADER',

           gc_obs1 TYPE STRING VALUE 'Header e item correspondem, valores estão dentro da tolerância informada.',
           gc_obs2 TYPE STRING VALUE 'Header e item correspondem, porém a diferença ultrapassa a tolerância informada.',
           gc_obs3 TYPE STRING VALUE 'Não foi encontrado nenhum item correspondente',
           gc_obs4 TYPE STRING VALUE 'Não foi encontrado header correspondente.'.



DATA: go_salv TYPE REF TO cl_salv_table.

DATA: gt_header TYPE TABLE OF ztb_c100_l,
      gt_itens TYPE TABLE OF ztb_c170_l,
      gt_alvheader TYPE TABLE OF zst_alv100_l,
      gt_alvitens TYPE TABLE OF zst_alv170_l,
      gt_itens_aux TYPE TABLE OF zst_alv170_l.

DATA: gs_header  TYPE ztb_c100_l,
      gs_item    TYPE ztb_c170_l,
      gs_alv_hd  TYPE zst_alv100_l,
      gs_alv_it  TYPE zst_alv170_l,
      gs_proximo TYPE ztb_c170_l.


DATA: gv_qitem   TYPE i,
      gv_index TYPE sy-tabix,
      gv_valhd   TYPE ztb_c100_l-vl_doc,
      gv_valtot  TYPE zst_alv100_l-dif_calc,
      gv_smitem  TYPE ztb_c170_l-qtd,
      gv_dif     TYPE zst_alv170_l-dif_calc,
      gv_stts    TYPE string,
      gv_obs     TYPE string,
      gv_vlit    TYPE ztb_c170_l-vl_item.


SELECTION-SCREEN BEGIN OF BLOCK B0 WITH FRAME TITLE TEXT-004.

 PARAMETERS:  p_res RADIOBUTTON GROUP G1 DEFAULT 'X',
              p_compl RADIOBUTTON GROUP G1.

SELECTION-SCREEN END OF BLOCK B0.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.


  PARAMETERS: p_todos RADIOBUTTON GROUP G2 DEFAULT 'X',
              p_casad RADIOBUTTON GROUP G2,
              p_div RADIOBUTTON GROUP G2,
              p_semrel RADIOBUTTON GROUP G2.


 PARAMETERS: p_tol TYPE p DECIMALS 2 DEFAULT '500.00',
             p_limt TYPE i DEFAULT 32000.


SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002. "FILTROS C100


  SELECT-OPTIONS: s_numdoc FOR ztb_c100_l-num_doc,
                  s_data   FOR ztb_c100_l-dt_doc,
                  s_parc FOR ztb_c100_l-cod_part,
                  s_mdoc FOR ztb_c100_l-cod_mod,
                  s_sit FOR ztb_c100_l-cod_sit.

SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003. "FILTROS C170

  SELECT-OPTIONS: s_cfop FOR ztb_c170_l-cfop,
                  s_numit FOR ztb_c170_l-num_item,
                  s_cstic FOR ztb_c170_l-cts_icms.

SELECTION-SCREEN END OF BLOCK B3.
