*&---------------------------------------------------------------------*
*& Include          ZR_UPLOAD_L_TOP
*&---------------------------------------------------------------------*

CONSTANTS: GC_SUCESS TYPE C LENGTH 1 VALUE 1,
           GC_ERRO   TYPE C LENGTH 1 VALUE 0.


DATA: go_salv_c TYPE REF TO cl_salv_table.

DATA: gt_arquivo      TYPE filetable,
      gt_tabela       TYPE TABLE OF string,
      gt_numdoc       TYPE TABLE OF ztb_c100_l,
      gt_insertc170   TYPE TABLE OF ztb_c170_l,
      gt_insertc100   TYPE TABLE OF ztb_c100_l,
      gt_st100        TYPE TABLE OF zst_st100_l,
      gt_st170        TYPE TABLE OF ZST_ST170_L.

DATA: gv_retorno  TYPE i.



SELECTION-SCREEN BEGIN OF BLOCK blk00 WITH FRAME TITLE TEXT-001.

  PARAMETERS: rdb1 RADIOBUTTON GROUP gr1 USER-COMMAND teste DEFAULT 'X',
              rdb2 RADIOBUTTON GROUP gr1,
              dltcb AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK blk00.


SELECTION-SCREEN BEGIN OF BLOCK blk01 WITH FRAME TITLE TEXT-002.

  PARAMETERS: p_nmarq TYPE string.

SELECTION-SCREEN END OF BLOCK blk01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_nmarq.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      file_filter             = 'CSV OR TXT - Text file (*.csv;*.txt)|*.csv;*.txt'
    CHANGING
      file_table              = gt_arquivo                 " Table Holding Selected Files
      rc                      = gv_retorno        " Return Code, Number of Files or -1 If Error Occurred
*     user_action             =                  " User Action (See Class Constants ACTION_OK, ACTION_CANCEL)
*     file_encoding           =
    EXCEPTIONS
      file_open_dialog_failed = 1                " "Open File" dialog failed
      cntl_error              = 2                " Control error
      error_no_gui            = 3                " No GUI available
      not_supported_by_gui    = 4                " GUI does not support this
      OTHERS                  = 5.
  IF sy-subrc <> 0.
    MESSAGE 'ERRO AO BUSCAR ARQUIVO' TYPE 'E'.
    RETURN.
  ENDIF.

  p_nmarq = VALUE #( gt_arquivo[ 1 ]-filename OPTIONAL ).
