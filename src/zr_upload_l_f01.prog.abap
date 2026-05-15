*&---------------------------------------------------------------------*
*& Include          ZR_UPLOAD_L_F01
*&---------------------------------------------------------------------*


FORM farquivo.

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = p_nmarq
    CHANGING
      data_tab                = gt_tabela
    EXCEPTIONS
      file_open_error         = 1                " File does not exist and cannot be opened
      file_read_error         = 2                " Error when reading file
      no_batch                = 3                " Front-End Function Cannot Be Executed in Backgrnd
      gui_refuse_filetransfer = 4                " Incorrect front end or error on front end
      invalid_type            = 5                " Incorrect parameter FILETYPE
      no_authority            = 6                " No Upload Authorization
      unknown_error           = 7                " Unknown error
      bad_data_format         = 8                " Cannot Interpret Data in File
      header_not_allowed      = 9                " Invalid header
      separator_not_allowed   = 10               " Invalid separator
      header_too_long         = 11               " Header information currently restricted to 1023 bytes
      unknown_dp_error        = 12               " Error when calling data provider
      access_denied           = 13               " Access to File Denied
      dp_out_of_memory        = 14               " Not Enough Memory in DataProvider
      disk_full               = 15               " Storage Medium full
      dp_timeout              = 16               " Timeout of DataProvider
      not_supported_by_gui    = 17               " GUI does not support this
      error_no_gui            = 18               " GUI not available
      OTHERS                  = 19.

  IF sy-subrc <> 0.
    MESSAGE e017(zlucas).
  ENDIF.

ENDFORM.

FORM show_alv USING IT_ST.


  CALL METHOD cl_salv_table=>factory
*    EXPORTING
*      list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
*      r_container    =                           " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table = go_salv_c        " Basis Class Simple ALV Tables
    CHANGING
      t_table      = IT_ST.

  IF go_salv_c IS BOUND.
    go_salv_c->display( ).
  ENDIF.

ENDFORM.


FORM data_alv100 USING is_string TYPE zst_c100str_l ic_status TYPE c iv_message TYPE string.

  DATA ls_st100 TYPE zst_st100_l.

  CLEAR ls_st100.

  ls_st100-status            = ic_status.
  ls_st100-message           = iv_message.
  ls_st100-usuario           = sy-uname.
  ls_st100-data              = sy-datum.
  ls_st100-hora              = sy-uzeit.

  ls_st100-reg               = is_string-campo1.
  ls_st100-ind_oper          = is_string-campo2.
  ls_st100-ind_emit          = is_string-campo3.
  ls_st100-cod_part          = is_string-campo4.
  ls_st100-cod_mod           = is_string-campo5.
  ls_st100-cod_sit           = is_string-campo6.
  ls_st100-num_doc           = is_string-campo7.
  ls_st100-dt_doc            = is_string-campo8.
  ls_st100-dt_e_s            = is_string-campo9.
  ls_st100-vl_doc            = is_string-campo10.
  ls_st100-ind_pgto          = is_string-campo11.
  ls_st100-ind_frt           = is_string-campo12.
  ls_st100-chv_nfe           = is_string-campo13.
  ls_st100-ser               = is_string-campo14.
  ls_st100-vl_desc           = is_string-campo15.
  ls_st100-vl_abat_nt        = is_string-campo16.
  ls_st100-vl_merc           = is_string-campo17.
  ls_st100-vl_frt            = is_string-campo18.
  ls_st100-vl_seg            = is_string-campo19.
  ls_st100-vl_out_da         = is_string-campo20.
  ls_st100-vl_bc_icms        = is_string-campo21.
  ls_st100-vl_icms           = is_string-campo22.
  ls_st100-vl_bc_icms_st     = is_string-campo23.
  ls_st100-vl_icms_st        = is_string-campo24.
  ls_st100-vl_ipi            = is_string-campo25.
  ls_st100-vl_pis            = is_string-campo26.
  ls_st100-vl_cofins         = is_string-campo27.
  ls_st100-vl_pis_st         = is_string-campo28.
  ls_st100-vl_cofins_st      = is_string-campo29.

  APPEND ls_st100 TO gt_st100.

ENDFORM.

FORM data_alv170 USING is_string TYPE zst_c100str_l ic_status TYPE c iv_message TYPE string.

  DATA ls_st170 TYPE ZST_ST170_L.

  CLEAR ls_st170.


  ls_st170-status            = ic_status.
  ls_st170-message           = iv_message.
  ls_st170-usuario           = sy-uname.
  ls_st170-data              = sy-datum.
  ls_st170-hora              = sy-uzeit.

  ls_st170-reg               = is_string-campo1.
  ls_st170-num_item          = is_string-campo2.
  ls_st170-cod_item          = is_string-campo3.
  ls_st170-vl_item           = is_string-campo4.
  ls_st170-cfop              = is_string-campo5.
  ls_st170-cst_pis           = is_string-campo6.
  ls_st170-cst_cofins        = is_string-campo7.
  ls_st170-num_doc           = is_string-campo8.
  ls_st170-descr_compl       = is_string-campo9.
  ls_st170-qtd               = is_string-campo10.
  ls_st170-unid              = is_string-campo11.
  ls_st170-vl_desc           = is_string-campo12.
  ls_st170-ind_mov           = is_string-campo13.
  ls_st170-cts_icms          = is_string-campo14.
  ls_st170-cod_nat           = is_string-campo15.
  ls_st170-vl_bc_icms        = is_string-campo16.
  ls_st170-aliq_icms         = is_string-campo17.
  ls_st170-vl_icms           = is_string-campo18.
  ls_st170-vl_bc_icms_st     = is_string-campo19.
  ls_st170-aliq_st           = is_string-campo20.
  ls_st170-vl_icms_st        = is_string-campo21.
  ls_st170-ind_apur          = is_string-campo22.
  ls_st170-cst_ipi           = is_string-campo23.
  ls_st170-cod_enq           = is_string-campo24.
  ls_st170-vl_bc_ipi         = is_string-campo25.
  ls_st170-aliq_ipi          = is_string-campo26.
  ls_st170-vl_ipi            = is_string-campo27.
  ls_st170-vl_bc_pis         = is_string-campo28.
  ls_st170-aliq_pis          = is_string-campo29.
  ls_st170-quant_bc_pis      = is_string-campo30.
  ls_st170-aliq_pis_quant    = is_string-campo31.
  ls_st170-vl_pis            = is_string-campo32.
  ls_st170-vl_bc_cofins      = is_string-campo33.
  ls_st170-aliq_cofins       = is_string-campo34.
  ls_st170-quant_bc_cofins   = is_string-campo35.
  ls_st170-aliq_cofins_quant = is_string-campo36.
  ls_st170-vl_cofins         = is_string-campo37.
  ls_st170-cod_cta           = is_string-campo38.


  APPEND ls_st170 TO gt_st170.

ENDFORM.

FORM c100 USING is_string TYPE zst_c100str_l.

  CONSTANTS: lc_emit1 TYPE c LENGTH 1 VALUE '0',
             lc_emit2 TYPE c LENGTH 1 VALUE '1',
             lc_oper1 TYPE c LENGTH 1 VALUE '0',
             lc_oper2 TYPE c LENGTH 1 VALUE '1',
*            constantes para erros
             lc_suc   TYPE string VALUE 'SUCESSO',
             lc_campovazio   TYPE string VALUE 'CAMPO CHAVE VAZIO OU INVÁLIDO',
             lc_erriemit   TYPE string VALUE 'IND EMIT INVÁLIDO',
             lc_erroper   TYPE string VALUE 'IND OPER INVÁLIDO',
             lc_errpgto   TYPE string VALUE 'IND PAGTO INVÁLIDO',
             lc_datainv   TYPE string VALUE  'DATA INVÁLIDA',
             lc_errfrt   TYPE string VALUE 'IND FRETE INVÁLIDO'.

  DATA: lt_indfrt TYPE TABLE OF ztb_c100_l-ind_frt,
        lt_tpag   TYPE TABLE OF ztb_c100_l-ind_pgto.

  DATA: ls_novalinha TYPE ztb_c100_l.


  DATA: lv_datamin  TYPE ztb_c100_l-dt_doc,
        lv_datamax  TYPE ztb_c100_l-dt_doc,
        lv_datacrt  TYPE string.

  lv_datamin = '19900101'.
  lv_datamax = '20261212'.

  APPEND '0' TO lt_tpag.
  APPEND '1' TO lt_tpag.
  APPEND '2' TO lt_tpag.
  APPEND '9' TO lt_tpag.

  APPEND '0' TO lt_indfrt.
  APPEND '1' TO lt_indfrt.
  APPEND '2' TO lt_indfrt.
  APPEND '3' TO lt_indfrt.
  APPEND '4' TO lt_indfrt.
  APPEND '5' TO lt_indfrt.
  APPEND '6' TO lt_indfrt.
  APPEND '7' TO lt_indfrt.
  APPEND '8' TO lt_indfrt.
  APPEND '9' TO lt_indfrt.
  APPEND '10' TO lt_indfrt.

  CLEAR ls_novalinha.


  TRY.

      ls_novalinha-reg               = is_string-campo1.
      ls_novalinha-ind_oper          = is_string-campo2.
      ls_novalinha-ind_emit          = is_string-campo3.
      ls_novalinha-cod_part          = is_string-campo4.
      ls_novalinha-cod_mod           = is_string-campo5.
      ls_novalinha-cod_sit           = is_string-campo6.
      ls_novalinha-num_doc           = is_string-campo7.
      ls_novalinha-dt_doc            = is_string-campo8.
      ls_novalinha-dt_e_s            = is_string-campo9.
      ls_novalinha-vl_doc            = is_string-campo10.
      ls_novalinha-ind_pgto          = is_string-campo11.
      ls_novalinha-ind_frt           = is_string-campo12.
      ls_novalinha-chv_nfe           = is_string-campo13.
      ls_novalinha-ser               = is_string-campo14.
      ls_novalinha-vl_desc           = is_string-campo15.
      ls_novalinha-vl_abat_nt        = is_string-campo16.
      ls_novalinha-vl_merc           = is_string-campo17.
      ls_novalinha-vl_frt            = is_string-campo18.
      ls_novalinha-vl_seg            = is_string-campo19.
      ls_novalinha-vl_out_da         = is_string-campo20.
      ls_novalinha-vl_bc_icms        = is_string-campo21.
      ls_novalinha-vl_icms           = is_string-campo22.
      ls_novalinha-vl_bc_icms_st     = is_string-campo23.
      ls_novalinha-vl_icms_st        = is_string-campo24.
      ls_novalinha-vl_ipi            = is_string-campo25.
      ls_novalinha-vl_pis            = is_string-campo26.
      ls_novalinha-vl_cofins         = is_string-campo27.
      ls_novalinha-vl_pis_st         = is_string-campo28.
      ls_novalinha-vl_cofins_st      = is_string-campo29.


      CLEAR lv_datacrt.

      DATA(lv_ano) = is_string-campo8+4(4).
      DATA(lv_mes) = is_string-campo8+2(2).
      DATA(lv_dia) = is_string-campo8(2).

      CONCATENATE lv_ano lv_mes lv_dia INTO lv_datacrt.

      ls_novalinha-dt_doc = lv_datacrt.

      CLEAR lv_datacrt.

      lv_ano = is_string-campo9+4(4).
      lv_mes = is_string-campo9+2(2).
      lv_dia = is_string-campo9(2).

      CONCATENATE lv_ano lv_mes lv_dia  INTO lv_datacrt.

      ls_novalinha-dt_e_s = lv_datacrt.


      IF ls_novalinha-reg IS INITIAL OR ls_novalinha-reg <> 'C100'.
         PERFORM data_alv100 USING is_string gc_erro lc_campovazio.
      ELSEIF ls_novalinha-num_doc IS INITIAL.
         PERFORM data_alv100 USING is_string gc_erro lc_campovazio.

      ELSEIF ( ls_novalinha-dt_doc NOT BETWEEN lv_datamin AND lv_datamax ) OR ( ls_novalinha-dt_e_s NOT BETWEEN lv_datamin AND lv_datamax ).
         PERFORM data_alv100 USING is_string gc_erro lc_datainv.

      ELSEIF ls_novalinha-ind_emit <> lc_emit1 AND ls_novalinha-ind_emit <> lc_emit2.
        PERFORM data_alv100 USING is_string gc_erro lc_campovazio.

      ELSEIF ls_novalinha-ind_oper <> lc_oper1 AND ls_novalinha-ind_oper <> lc_oper2.
        PERFORM data_alv100 USING is_string gc_erro lc_erroper.

      ELSEIF NOT line_exists( lt_indfrt[ TABLE_LINE = ls_novalinha-ind_frt ] ).
         PERFORM data_alv100 USING is_string gc_erro lc_errfrt.

      ELSEIF NOT line_exists( lt_tpag[ TABLE_LINE = ls_novalinha-ind_pgto ] ).
        PERFORM data_alv100 USING is_string gc_erro lc_errpgto.
      ELSE.

       APPEND ls_novalinha TO gt_INSERTC100.
       PERFORM data_alv100 USING is_string gc_sucess lc_suc.
      ENDIF.

    CATCH cx_root INTO DATA(LO_ERRO).

      DATA(lv_cx_msg) = lo_erro->get_text(  ).
      PERFORM data_alv100 USING is_string gc_erro lv_cx_msg.

  ENDTRY.

ENDFORM.

FORM c170 USING is_string TYPE zst_c100str_l.


  CONSTANTS:  lc_c1 TYPE C LENGTH 1 VALUE '0',
              lc_c2 TYPE C LENGTH 1 VALUE '1',
              lc_s TYPE string VALUE 'SUCESSO',
              lc_errchv TYPE string VALUE 'CAMPO CHAVE VAZIO',
              lc_errindmov TYPE string VALUE 'ÍNDICE MOV INVÁLIDO',
              lc_semheader TYPE string VALUE 'NÃO HÁ HEADER CORRESPONDENTE',
              lc_errindapur TYPE string VALUE 'ÍNDICE APUR INVÁLIDO'.

  DATA: ls_novalinha170 TYPE ztb_c170_l.

  CLEAR ls_novalinha170.

  TRY.

  ls_novalinha170-reg               = is_string-campo1.
  ls_novalinha170-num_item          = is_string-campo2.
  ls_novalinha170-cod_item          = is_string-campo3.
  ls_novalinha170-vl_item           = is_string-campo4.
  ls_novalinha170-cfop              = is_string-campo5.
  ls_novalinha170-cst_pis           = is_string-campo6.
  ls_novalinha170-cst_cofins        = is_string-campo7.
  ls_novalinha170-num_doc           = is_string-campo8.
  ls_novalinha170-descr_compl       = is_string-campo9.
  ls_novalinha170-qtd               = is_string-campo10.
  ls_novalinha170-unid              = is_string-campo11.
  ls_novalinha170-vl_desc           = is_string-campo12.
  ls_novalinha170-ind_mov           = is_string-campo13.
  ls_novalinha170-cts_icms          = is_string-campo14.
  ls_novalinha170-cod_nat           = is_string-campo15.
  ls_novalinha170-vl_bc_icms        = is_string-campo16.
  ls_novalinha170-aliq_icms         = is_string-campo17.
  ls_novalinha170-vl_icms           = is_string-campo18.
  ls_novalinha170-vl_bc_icms_st     = is_string-campo19.
  ls_novalinha170-aliq_st           = is_string-campo20.
  ls_novalinha170-vl_icms_st        = is_string-campo21.
  ls_novalinha170-ind_apur          = is_string-campo22.
  ls_novalinha170-cst_ipi           = is_string-campo23.
  ls_novalinha170-cod_enq           = is_string-campo24.
  ls_novalinha170-vl_bc_ipi         = is_string-campo25.
  ls_novalinha170-aliq_ipi          = is_string-campo26.
  ls_novalinha170-vl_ipi            = is_string-campo27.
  ls_novalinha170-vl_bc_pis         = is_string-campo28.
  ls_novalinha170-aliq_pis          = is_string-campo29.
  ls_novalinha170-quant_bc_pis      = is_string-campo30.
  ls_novalinha170-aliq_pis_quant    = is_string-campo31.
  ls_novalinha170-vl_pis            = is_string-campo32.
  ls_novalinha170-vl_bc_cofins      = is_string-campo33.
  ls_novalinha170-aliq_cofins       = is_string-campo34.
  ls_novalinha170-quant_bc_cofins   = is_string-campo35.
  ls_novalinha170-aliq_cofins_quant = is_string-campo36.
  ls_novalinha170-vl_cofins         = is_string-campo37.
  ls_novalinha170-cod_cta           = is_string-campo38.



  IF ( ls_novalinha170-reg IS INITIAL OR ls_novalinha170-reg <> 'C170' ) OR ( ls_novalinha170-num_item IS INITIAL ) OR ( ls_novalinha170-cod_item IS INITIAL )
      OR ( ls_novalinha170-cfop IS INITIAL ) OR ( ls_novalinha170-cst_cofins IS INITIAL ) OR ( ls_novalinha170-CST_PIS IS INITIAL ).

    PERFORM data_alv170 USING is_string gc_erro lc_errchv.

  ELSEIF ls_novalinha170-ind_mov <> lc_c1 AND ls_novalinha170-ind_mov <> lc_c2.

    PERFORM data_alv170 USING is_string gc_erro lc_errindmov.

  ELSEIF ls_novalinha170-ind_apur <> lc_c1 AND ls_novalinha170-ind_apur <> lc_c2.

    PERFORM data_alv170 USING is_string gc_erro lc_errindapur.

  ELSE.

    APPEND ls_novalinha170 TO Gt_INSERTC170.
    PERFORM data_alv170 USING is_string gc_sucess lc_s.

  ENDIF.

  CATCH cx_root INTO DATA(LO_ERRO).

      DATA(lv_cx_msg) = lo_erro->get_text(  ).
      PERFORM data_alv170 USING is_string gc_erro lv_cx_msg.

  ENDTRY.

ENDFORM.


FORM campos_arquivo.


  DATA: ls_string TYPE zst_c100str_l.

  IF rdb2 = abap_true.

   SELECT *
   FROM ztb_c100_l
   INTO TABLE gt_numdoc.

   SORT gt_numdoc BY num_doc.
  ENDIF.

  LOOP AT gt_tabela ASSIGNING FIELD-SYMBOL(<fs_linha>).

    CLEAR ls_string.

    IF sy-tabix = 1.
      CONTINUE.
    ENDIF.

    SPLIT <fs_linha> AT ';' INTO TABLE DATA(lt_campos).

    IF lt_campos IS NOT INITIAL.

      ls_string-campo1  = VALUE #( lt_campos[ 1  ] OPTIONAL ).
      ls_string-campo2  = VALUE #( lt_campos[ 2  ] OPTIONAL ).
      ls_string-campo3  = VALUE #( lt_campos[ 3  ] OPTIONAL ).
      ls_string-campo4  = VALUE #( lt_campos[ 4  ] OPTIONAL ).
      ls_string-campo5  = VALUE #( lt_campos[ 5  ] OPTIONAL ).
      ls_string-campo6  = VALUE #( lt_campos[ 6  ] OPTIONAL ).
      ls_string-campo7  = VALUE #( lt_campos[ 7  ] OPTIONAL ).
      ls_string-campo8  = VALUE #( lt_campos[ 8  ] OPTIONAL ).
      ls_string-campo9  = VALUE #( lt_campos[ 9  ] OPTIONAL ).
      ls_string-campo10 = VALUE #( lt_campos[ 10 ] OPTIONAL ).
      ls_string-campo11 = VALUE #( lt_campos[ 11 ] OPTIONAL ).
      ls_string-campo12 = VALUE #( lt_campos[ 12 ] OPTIONAL ).
      ls_string-campo13 = VALUE #( lt_campos[ 13 ] OPTIONAL ).
      ls_string-campo14 = VALUE #( lt_campos[ 14 ] OPTIONAL ).
      ls_string-campo15 = VALUE #( lt_campos[ 15 ] OPTIONAL ).
      ls_string-campo16 = VALUE #( lt_campos[ 16 ] OPTIONAL ).
      ls_string-campo17 = VALUE #( lt_campos[ 17 ] OPTIONAL ).
      ls_string-campo18 = VALUE #( lt_campos[ 18 ] OPTIONAL ).
      ls_string-campo19 = VALUE #( lt_campos[ 19 ] OPTIONAL ).
      ls_string-campo20 = VALUE #( lt_campos[ 20 ] OPTIONAL ).
      ls_string-campo21 = VALUE #( lt_campos[ 21 ] OPTIONAL ).
      ls_string-campo22 = VALUE #( lt_campos[ 22 ] OPTIONAL ).
      ls_string-campo23 = VALUE #( lt_campos[ 23 ] OPTIONAL ).
      ls_string-campo24 = VALUE #( lt_campos[ 24 ] OPTIONAL ).
      ls_string-campo25 = VALUE #( lt_campos[ 25 ] OPTIONAL ).
      ls_string-campo26 = VALUE #( lt_campos[ 26 ] OPTIONAL ).
      ls_string-campo27 = VALUE #( lt_campos[ 27 ] OPTIONAL ).
      ls_string-campo28 = VALUE #( lt_campos[ 28 ] OPTIONAL ).
      ls_string-campo29 = VALUE #( lt_campos[ 29 ] OPTIONAL ).
      ls_string-campo30 = VALUE #( lt_campos[ 30 ] OPTIONAL ).
      ls_string-campo31 = VALUE #( lt_campos[ 31 ] OPTIONAL ).
      ls_string-campo32 = VALUE #( lt_campos[ 32 ] OPTIONAL ).
      ls_string-campo33 = VALUE #( lt_campos[ 33 ] OPTIONAL ).
      ls_string-campo34 = VALUE #( lt_campos[ 34 ] OPTIONAL ).
      ls_string-campo35 = VALUE #( lt_campos[ 35 ] OPTIONAL ).
      ls_string-campo36 = VALUE #( lt_campos[ 36 ] OPTIONAL ).
      ls_string-campo37 = VALUE #( lt_campos[ 37 ] OPTIONAL ).
      ls_string-campo38 = VALUE #( lt_campos[ 38 ] OPTIONAL ).
      ls_string-campo39 = VALUE #( lt_campos[ 39 ] OPTIONAL ).
      ls_string-campo40 = VALUE #( lt_campos[ 40 ] OPTIONAL ).

      IF rdb1 = abap_true.
        PERFORM c100 USING ls_string.
      ELSE.
        PERFORM c170 USING ls_string.
      ENDIF.
    ENDIF.

  ENDLOOP.

ENDFORM.


FORM insert.

  IF rdb1 = abap_true.

    IF dltcb = 'X'.
      DELETE FROM ztb_c100_l.
      IF sy-subrc = 0.
        COMMIT WORK.
      ENDIF.
    ENDIF.

    INSERT ztb_c100_l FROM TABLE gt_insertc100.
    IF sy-subrc <> 0.
      MESSAGE e015(zlucas).
    ELSE.
      MESSAGE s016(zlucas).
    ENDIF.

    PERFORM show_alv USING gt_st100.

  ELSE.

    IF dltcb = 'X'.
      DELETE FROM ztb_c170_l.
      IF sy-subrc = 0.
        COMMIT WORK.
      ENDIF.
    ENDIF.


    MODIFY ztb_c170_l FROM TABLE gt_insertc170.
    IF sy-subrc <> 0.
      MESSAGE e015(zlucas).
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
      MESSAGE s016(zlucas).
    ENDIF.

    PERFORM show_alv USING gt_st170.

  ENDIF.

ENDFORM.

FORM execute.

  PERFORM farquivo.

  PERFORM campos_arquivo.

  PERFORM insert.

ENDFORM.
