*&---------------------------------------------------------------------*
*& Include          ZR_HEADER_ITEMALV_L_F01
*&---------------------------------------------------------------------*
FORM get_dados.

  DATA: lv_header TYPE string VALUE 'Header',
        lv_itens  TYPE string VALUE 'Itens'.

  IF p_res = abap_true.

    SELECT *
     FROM ztb_c100_L
     INTO TABLE gt_header
     UP TO p_limt ROWS
     WHERE num_doc IN s_numdoc
     AND dt_doc IN s_data
     AND cod_part IN s_parc
     AND cod_mod IN s_mdoc
     AND cod_sit IN s_sit.

    IF sy-subrc <> 0.
      MESSAGE e018(zlucas) WITH lv_header.
    ENDIF.

    SELECT *
     FROM ztb_c170_l
     INTO TABLE gt_itens
     WHERE num_doc IN s_numdoc
     AND cfop IN s_cfop
     AND num_item IN s_numit
     AND cts_icms IN s_cstic.


    IF sy-subrc <> 0.
      MESSAGE e018(zlucas) WITH lv_itens.
    ENDIF.


  ELSE.

    SELECT *
     FROM ztb_c100_L
     INTO TABLE gt_header
     WHERE num_doc IN s_numdoc
     AND dt_doc IN s_data
     AND cod_part IN s_parc
     AND cod_mod IN s_mdoc
     AND cod_sit IN s_sit.

    IF sy-subrc <> 0.
      MESSAGE e018(zlucas) WITH lv_header.
    ENDIF.

    SELECT *
     FROM ztb_c170_l
     INTO TABLE gt_itens
     UP TO p_limt ROWS
     WHERE num_doc IN s_numdoc
     AND cfop IN s_cfop
     AND num_item IN s_numit
     AND cts_icms IN s_cstic.

    IF sy-subrc <> 0.
      MESSAGE e018(zlucas) WITH lv_itens.
    ENDIF.


  ENDIF.


  SORT gt_header BY num_doc.
  SORT gt_itens BY num_doc num_item.

ENDFORM.


FORM display_alv USING it_alv TYPE ANY TABLE.

  TRY.

      CALL METHOD cl_salv_table=>factory
*   EXPORTING
*     list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
*     r_container    =                           " Abstract Container for GUI Controls
*     container_name =
        IMPORTING
          r_salv_table = go_salv                        " Basis Class Simple ALV Tables
        CHANGING
          t_table      = it_alv.


    CATCH cx_salv_msg .
      MESSAGE 'Erro no display da ALV' TYPE 'E'.
  ENDTRY.
  IF go_salv IS BOUND.
    go_salv->display( ).
  ENDIF.

ENDFORM.


FORM cruza_dados.


  IF p_res = abap_true. "RELATORIO RESUMIDO.

    LOOP AT gt_header INTO gs_header.

      CLEAR gs_alv_hd.

      gs_alv_hd = CORRESPONDING #( gs_header ) .
      gs_alv_hd-vl_total = gs_header-vl_doc.

*AS SEGUINTES SERÃO DEFINIDAS NO LOOP.
* quant itens
* soma itens
* dif calculada
* stts rel
* observ

      READ TABLE gt_itens TRANSPORTING NO FIELDS
      WITH KEY num_doc = gs_header-num_doc
      BINARY SEARCH.

      IF sy-subrc = 0.
        CLEAR gv_vlit.
        LOOP AT gt_ITENS INTO gs_item WHERE num_doc = gs_header-num_doc.

          gs_alv_hd-quant += 1.
          gv_vlit += gs_item-vl_item.

        ENDLOOP.

        gs_alv_hd-soma_it = gv_vlit.
        gs_alv_hd-dif_calc = gv_vlit - gs_header-vl_doc.

        IF gs_alv_hd-dif_calc < 0. "Para a diferença sempre ser positiva.
          gs_alv_hd-dif_calc = gs_alv_hd-dif_calc * -1.
        ENDIF.

        IF gs_alv_hd-dif_calc > p_tol.

          gs_alv_hd-status_rel = gc_stts2.
          gs_alv_hd-obs = gc_obs2.

        ELSE.

          gs_alv_hd-status_rel = gc_stts1.
          gs_alv_hd-obs = gc_obs1.

        ENDIF.

      ELSE.

        gs_alv_hd-quant = 0.
        gs_alv_hd-soma_it = 0.
        gs_alv_hd-dif_calc = gs_alv_hd-vl_total.
        gs_alv_hd-status_rel = gc_stts3.
        gs_alv_hd-obs = gc_obs3.

      ENDIF.

      APPEND gs_alv_hd TO gt_alvheader.

      CLEAR gs_header.

    ENDLOOP.

    PERFORM display_alv USING gt_alvheader.




  ELSE. "RELATÓRIO COMPLETO.

    LOOP AT gt_itens INTO gs_item.

      CLEAR gs_alv_it.
      gv_index = sy-tabix.

      gs_alv_it = CORRESPONDING #( gs_item ).
      gs_alv_it-cst_icms = gs_item-cts_icms.
      gs_alv_it-quant = gs_item-qtd.
      gs_alv_it-unidade = gs_item-unid.


      gv_valtot += gs_item-vl_item.

      READ TABLE gt_header INTO gs_header
      WITH KEY num_doc = gs_item-num_doc
      BINARY SEARCH.

      IF sy-subrc = 0.

        gs_alv_it-vl_header = gs_header-vl_doc.
        gs_alv_it-dt_doc = gs_header-dt_doc.
        gs_alv_it-cod_part = gs_header-cod_part.
        gs_alv_it-cod_mod = gs_header-cod_mod.
        gs_alv_it-cod_sit = gs_header-cod_sit.

      ELSE.

        gs_alv_it-status_rel = gc_stts4.
        gs_alv_it-obs = gc_obs4.

      ENDIF.

      APPEND gs_alv_it TO gt_alvitens.

      READ TABLE gt_itens INTO gs_proximo INDEX gv_index + 1.

      IF sy-subrc <> 0 OR gs_proximo-num_doc <> gs_item-num_doc ."ve se o proximo é do mesmo doc
        gs_alv_it-soma_it = gv_valtot.
        APPEND gs_alv_it TO gt_itens_aux. "vai ter um num doc de cada item com o valor total
        CLEAR gv_valtot.

      ENDIF.


      CLEAR gs_proximo.
      CLEAR gs_item.
    ENDLOOP.

    LOOP AT gt_itens_aux ASSIGNING FIELD-SYMBOL(<fs_item_valor_total>).
      LOOP AT gt_alvitens ASSIGNING FIELD-SYMBOL(<fs_item_final>) WHERE num_doc = <fs_item_valor_total>-num_doc.
        <fs_item_final>-soma_it = <fs_item_valor_total>-soma_it.
        gv_dif =  <fs_item_valor_total>-soma_it - <fs_item_valor_total>-vl_header.
        IF gv_dif < 0.
          gv_dif = gv_dif * -1.
        ENDIF.
        <fs_item_final>-dif_calc = gv_dif.

        IF <fs_item_final>-dif_calc <= p_tol.
          <fs_item_final>-status_rel = gc_stts1.
          <fs_item_final>-obs = gc_obs1.
        ELSE.
          <fs_item_final>-status_rel = gc_stts2.
          <fs_item_final>-obs = gc_obs2.
        ENDIF.
        CLEAR gv_dif.
      ENDLOOP.
    ENDLOOP.


    PERFORM display_alv USING gt_alvitens.


  ENDIF.



ENDFORM.


FORM cruza_dados_casados.


  DATA: lt_itens_casados TYPE TABLE OF zst_alv170_l.

  IF p_res = abap_true. "RELATORIO RESUMIDO.

    LOOP AT gt_header INTO gs_header.

      CLEAR gs_alv_hd.

      gs_alv_hd = CORRESPONDING #( gs_header ).
      gs_alv_hd-vl_total = gs_header-vl_doc.


      READ TABLE gt_itens TRANSPORTING NO FIELDS
      WITH KEY num_doc = gs_header-num_doc
      BINARY SEARCH.

      IF sy-subrc = 0.

        CLEAR gv_vlit.
        LOOP AT gt_ITENS INTO gs_item WHERE num_doc = gs_header-num_doc.

          gs_alv_hd-quant += 1.
          gv_vlit += gs_item-vl_item.

        ENDLOOP.

        gs_alv_hd-soma_it = gv_vlit.
        gs_alv_hd-dif_calc = gv_vlit - gs_header-vl_doc.

        IF gs_alv_hd-dif_calc < 0. "Para a diferença sempre ser positiva.
          gs_alv_hd-dif_calc = gs_alv_hd-dif_calc * -1.
        ENDIF.

        IF gs_alv_hd-dif_calc <= p_tol.

          gs_alv_hd-status_rel = gc_stts1.
          gs_alv_hd-obs = gc_obs1.
          APPEND gs_alv_hd TO gt_alvheader.

        ENDIF.

      ENDIF.

      CLEAR gs_header.

    ENDLOOP.

    PERFORM display_alv USING gt_alvheader.




  ELSE. "RELATÓRIO COMPLETO.

    LOOP AT gt_itens INTO gs_item.

      CLEAR gs_alv_it.
      gv_index = sy-tabix.


      READ TABLE gt_header INTO gs_header
      WITH KEY num_doc = gs_item-num_doc
      BINARY SEARCH.

      IF sy-subrc = 0.


        gs_alv_it-num_doc = gs_item-num_doc.
        gs_alv_it-num_item = gs_item-num_item.
        gs_alv_it-descr_compl = gs_item-descr_compl.
        gs_alv_it-cfop = gs_item-cfop.
        gs_alv_it-cst_icms = gs_item-cts_icms.
        gs_alv_it-quant = gs_item-qtd.
        gs_alv_it-unidade = gs_item-unid.
        gs_alv_it-vl_item = gs_item-vl_item.

        gv_valtot += gs_item-vl_item.

        gs_alv_it-vl_header = gs_header-vl_doc.
        gs_alv_it-dt_doc = gs_header-dt_doc.
        gs_alv_it-cod_part = gs_header-cod_part.
        gs_alv_it-cod_mod = gs_header-cod_mod.
        gs_alv_it-cod_sit = gs_header-cod_sit.

        APPEND gs_alv_it TO gt_alvitens.

        READ TABLE gt_itens INTO gs_proximo INDEX gv_index + 1.

        IF sy-subrc <> 0 OR gs_proximo-num_doc <> gs_item-num_doc ."ve se o proximo é do mesmo doc
          gs_alv_it-soma_it = gv_valtot.
          APPEND gs_alv_it TO gt_itens_aux. "vai ter um num doc de cada item com o valor total
          CLEAR gv_valtot.
        ENDIF.

        CLEAR gs_proximo.
      ENDIF.

        CLEAR gs_item.


      ENDLOOP.

      LOOP AT gt_itens_aux ASSIGNING FIELD-SYMBOL(<fs_item_valor_total>).
        LOOP AT gt_alvitens ASSIGNING FIELD-SYMBOL(<fs_item_final>) WHERE num_doc = <fs_item_valor_total>-num_doc.
          <fs_item_final>-soma_it = <fs_item_valor_total>-soma_it.
          gv_dif =  <fs_item_valor_total>-soma_it - <fs_item_valor_total>-vl_header.
          IF gv_dif < 0.
            gv_dif = gv_dif * -1.
          ENDIF.
          IF gv_dif <= p_tol.
            <fs_item_final>-dif_calc = gv_dif.
            <fs_item_final>-status_rel = gc_stts1.
            <fs_item_final>-obs = gc_obs1.
            APPEND <fs_item_final> TO lt_itens_casados.
          ENDIF.

        ENDLOOP.
      ENDLOOP.


    APPEND gs_alv_it TO gt_alvitens.


    PERFORM display_alv USING lt_itens_casados.

  ENDIF.



ENDFORM.

FORM cruza_dados_div.


  DATA: lt_itens_div TYPE TABLE OF zst_alv170_l.

  IF p_res = abap_true. "RELATORIO RESUMIDO.

    LOOP AT gt_header INTO gs_header.

      CLEAR gs_alv_hd.

      gs_alv_hd = CORRESPONDING #( gs_header ).
      gs_alv_hd-vl_total = gs_header-vl_doc.


      READ TABLE gt_itens TRANSPORTING NO FIELDS
      WITH KEY num_doc = gs_header-num_doc
      BINARY SEARCH.

      IF sy-subrc = 0.

        CLEAR gv_vlit.
        LOOP AT gt_ITENS INTO gs_item WHERE num_doc = gs_header-num_doc.

          gs_alv_hd-quant += 1.
          gv_vlit += gs_item-vl_item.

        ENDLOOP.

        gs_alv_hd-soma_it = gv_vlit.
        gs_alv_hd-dif_calc = gv_vlit - gs_header-vl_doc.

        IF gs_alv_hd-dif_calc < 0. "Para a diferença sempre ser positiva.
          gs_alv_hd-dif_calc = gs_alv_hd-dif_calc * -1.
        ENDIF.

        IF gs_alv_hd-dif_calc > p_tol.

          gs_alv_hd-status_rel = gc_stts2.
          gs_alv_hd-obs = gc_obs2.
          APPEND gs_alv_hd TO gt_alvheader.

        ENDIF.

      ENDIF.

      CLEAR gs_header.

    ENDLOOP.

    PERFORM display_alv USING gt_alvheader.




  ELSE. "RELATÓRIO COMPLETO.

    LOOP AT gt_itens INTO gs_item.

      CLEAR gs_alv_it.
      gv_index = sy-tabix.

      gs_alv_it-num_doc = gs_item-num_doc.
      gs_alv_it-num_item = gs_item-num_item.
      gs_alv_it-descr_compl = gs_item-descr_compl.
      gs_alv_it-cfop = gs_item-cfop.
      gs_alv_it-cst_icms = gs_item-cts_icms.
      gs_alv_it-quant = gs_item-qtd.
      gs_alv_it-unidade = gs_item-unid.
      gs_alv_it-vl_item = gs_item-vl_item.


      gv_valtot += gs_item-vl_item.

      READ TABLE gt_header INTO gs_header
      WITH KEY num_doc = gs_item-num_doc
      BINARY SEARCH.

      IF sy-subrc = 0.

        gs_alv_it-vl_header = gs_header-vl_doc.
        gs_alv_it-dt_doc = gs_header-dt_doc.
        gs_alv_it-cod_part = gs_header-cod_part.
        gs_alv_it-cod_mod = gs_header-cod_mod.
        gs_alv_it-cod_sit = gs_header-cod_sit.

      APPEND gs_alv_it TO gt_alvitens.

      READ TABLE gt_itens INTO gs_proximo INDEX gv_index + 1.

      IF sy-subrc <> 0 OR gs_proximo-num_doc <> gs_item-num_doc ."ve se o proximo é do mesmo doc
        gs_alv_it-soma_it = gv_valtot.
        APPEND gs_alv_it TO gt_itens_aux. "vai ter um num doc de cada item com o valor total
        CLEAR gv_valtot.
      ENDIF.

      CLEAR gs_proximo.

      ELSE.
        CLEAR gv_valtot.
      ENDIF.

      CLEAR gs_item.
    ENDLOOP.

    LOOP AT gt_itens_aux ASSIGNING FIELD-SYMBOL(<fs_item_valor_total>).
      LOOP AT gt_alvitens ASSIGNING FIELD-SYMBOL(<fs_item_final>) WHERE num_doc = <fs_item_valor_total>-num_doc.
        <fs_item_final>-soma_it = <fs_item_valor_total>-soma_it.
        gv_dif =  <fs_item_valor_total>-soma_it - <fs_item_valor_total>-vl_header.
        IF gv_dif < 0.
          gv_dif = gv_dif * -1.
        ENDIF.
        IF gv_dif > p_tol.
          <fs_item_final>-dif_calc = gv_dif.
          <fs_item_final>-status_rel = gc_stts2.
          <fs_item_final>-obs = gc_obs2.
          APPEND <fs_item_final> TO lt_itens_div.
        ENDIF.
        CLEAR gv_dif.
      ENDLOOP.
    ENDLOOP.

    PERFORM display_alv USING lt_itens_div.

  ENDIF.



ENDFORM.


FORM cruza_dados_semrel.


  IF p_res = abap_true.

    LOOP AT gt_header INTO gs_header.


      CLEAR gs_alv_hd.



      READ TABLE gt_itens TRANSPORTING NO FIELDS
      WITH KEY num_doc = gs_header-num_doc
      BINARY SEARCH.

      IF sy-subrc <> 0.

        gs_alv_hd = CORRESPONDING #( gs_header ) .
        gs_alv_hd-vl_total = gs_header-vl_doc.


        gs_alv_hd-quant = 0.
        gs_alv_hd-soma_it = 0.
        gs_alv_hd-dif_calc = gs_alv_hd-vl_total.
        gs_alv_hd-status_rel = gc_stts3.
        gs_alv_hd-obs = gc_obs3.

        APPEND gs_alv_hd TO gt_alvheader.

      ENDIF.

      CLEAR gs_header.

    ENDLOOP.

    PERFORM display_alv USING gt_alvheader.



  ELSE.


    LOOP AT gt_itens INTO gs_item.

      gv_index = sy-tabix.

      READ TABLE gt_header TRANSPORTING NO FIELDS
      WITH KEY num_doc = gs_item-num_doc
      BINARY SEARCH.

      IF sy-subrc <> 0.

        CLEAR gs_alv_it.

        gs_alv_it = CORRESPONDING #( gs_item ).
        gs_alv_it-cst_icms = gs_item-cts_icms.
        gs_alv_it-quant = gs_item-qtd.
        gs_alv_it-unidade = gs_item-unid.


        gs_alv_it-status_rel = gc_stts4.
        gs_alv_it-obs = gc_obs4.

        gv_valtot += gs_item-vl_item.

        APPEND gs_alv_it TO gt_alvitens.

        READ TABLE gt_itens INTO gs_proximo INDEX gv_index + 1.

        IF sy-subrc <> 0 OR gs_proximo-num_doc <> gs_item-num_doc ."ve se o proximo é do mesmo doc

          gs_alv_it-soma_it = gv_valtot.
          APPEND gs_alv_it TO gt_itens_aux.
          CLEAR gv_valtot.

        ENDIF.

        CLEAR gs_proximo.
      ENDIF.
      CLEAR gs_item.
    ENDLOOP.

    LOOP AT gt_itens_aux ASSIGNING FIELD-SYMBOL(<fs_item_valor_total>).
      LOOP AT gt_alvitens ASSIGNING FIELD-SYMBOL(<fs_item_final>) WHERE num_doc = <fs_item_valor_total>-num_doc.
        <fs_item_final>-soma_it = <fs_item_valor_total>-soma_it.
        gv_dif =  <fs_item_valor_total>-soma_it - <fs_item_valor_total>-vl_header.
        IF gv_dif < 0.
          gv_dif = gv_dif * -1.
        ENDIF.
        <fs_item_final>-dif_calc = gv_dif.
        CLEAR gv_dif.
      ENDLOOP.
    ENDLOOP.

    PERFORM display_alv USING gt_alvitens.

  ENDIF.
*
ENDFORM.


FORM execute.

  PERFORM get_dados.
  IF p_semrel = abap_true.
    PERFORM cruza_dados_semrel.
  ELSEIF p_div = abap_true.
    PERFORM cruza_dados_div.
  ELSEIF p_casad = abap_true.
    PERFORM cruza_dados_casados.
  ELSE.
    PERFORM cruza_dados.
  ENDIF.

ENDFORM.
