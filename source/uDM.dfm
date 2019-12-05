object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 279
  Width = 451
  object OracleConnection: TUniConnection
    Tag = -1
    AutoCommit = False
    ProviderName = 'Oracle'
    SpecificOptions.Strings = (
      'Oracle.Direct=True')
    Username = 'dbamv'
    Server = '192.168.10.1:1521:hdtprd'
    Connected = True
    LoginPrompt = False
    Left = 179
    Top = 32
    EncryptedPassword = '92FF89FFDCFFD5FFCDFFCFFFCEFFCDFF'
  end
  object OracleUniProvider1: TOracleUniProvider
    Left = 288
    Top = 32
  end
  object qryStatusLeitos: TUniQuery
    Connection = OracleConnection
    SQL.Strings = (
      'WITH'
      '    T_CENSO_RETROATIVO AS ('
      '        SELECT '
      '            multi_empresas.CD_CGC AS NR_CNPJ_OSS'
      
        '            , multi_empresas.ds_razao_social as DS_RAZAO_SOCIAL_' +
        'OSS'
      
        '            , TO_CHAR(F_CENSO_ULT_MOV_LEITO(TO_DATE(TO_CHAR(:DAT' +
        'A_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:' +
        'ss'#39'), LEITO.CD_LEITO), '#39'YYYY-MM-DD'#39') DATA_REF'
      
        '            , TO_CHAR(F_CENSO_ULT_MOV_LEITO(TO_DATE(TO_CHAR(:DAT' +
        'A_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:' +
        'ss'#39'), LEITO.CD_LEITO), '#39'HH24:MI:SS'#39') HORA_REF'
      '            , LEITO.CD_UNID_INT'
      '            , UNID_INT.DS_UNID_INT'
      '            , LEITO.CD_LEITO'
      '            , LEITO.DS_RESUMO as DS_LEITO'
      '            , '#39'N'#39' as SN_MACA'
      '            , NVL (LEITO.SN_EXTRA, '#39'N'#39') as SN_LEITO_EXTRA'
      '            , (CASE '
      
        '                    WHEN UNID_INT.SN_HOSPITAL_DIA = '#39'S'#39' THEN 7 /' +
        '*HOSPITAL/DIA*/'
      '                    ELSE'
      '                        CASE'
      
        '                            WHEN UNID_INT.CD_UNID_INT = 23 THEN ' +
        '5 /*PEDIATRICO*/'
      '                        ELSE 2 /*CLINICO*/'
      '                    END'
      '                END) AS TIPO_LEITO'
      
        '            , DECODE(NVL (DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_CO' +
        'NSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39')' +
        ' - NVL (TRUNC (MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRUNC' +
        ' (MOV_INT.HR_LIB_MOV)), :DATA_CONSULTA)), 1,'
      
        '                '#39'V'#39', DBAMV.RETORNA_SITUACAO_DO_LEITO (TO_DATE(TO' +
        '_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyy' +
        'y hh24:mi:ss'#39'), LEITO.CD_LEITO)), '#39'V'#39'),'
      
        '                '#39'F'#39', '#39'I'#39', NVL (DECODE (SIGN (TO_DATE(TO_CHAR(:DA' +
        'TA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi' +
        ':ss'#39') - NVL (TRUNC (MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - ' +
        'TRUNC (MOV_INT.HR_LIB_MOV)), :DATA_CONSULTA)), 1,'
      
        '                '#39'V'#39', DBAMV.RETORNA_SITUACAO_DO_LEITO (TO_DATE(TO' +
        '_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyy' +
        'y hh24:mi:ss'#39'), LEITO.CD_LEITO)), '#39'V'#39')'
      '            ) TP_OCUPACAO'
      '            , DECODE('
      
        '                DECODE(NVL (DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_' +
        'CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss' +
        #39') - NVL (TRUNC (MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRU' +
        'NC (MOV_INT.HR_LIB_MOV)), :DATA_CONSULTA)), 1,'
      
        '                '#39'V'#39', DBAMV.RETORNA_SITUACAO_DO_LEITO (TO_DATE(TO' +
        '_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyy' +
        'y hh24:mi:ss'#39'), LEITO.CD_LEITO)), '#39'V'#39'),'
      
        '                '#39'F'#39', '#39'I'#39', NVL (DECODE (SIGN (TO_DATE(TO_CHAR(:DA' +
        'TA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi' +
        ':ss'#39') - NVL (TRUNC (MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - ' +
        'TRUNC (MOV_INT.HR_LIB_MOV)), :DATA_CONSULTA)), 1,'
      
        '                '#39'V'#39', DBAMV.RETORNA_SITUACAO_DO_LEITO (TO_DATE(TO' +
        '_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyy' +
        'y hh24:mi:ss'#39'), LEITO.CD_LEITO)), '#39'V'#39')),'
      '                '#39'V'#39', 1, /*vago - considerar como dispon'#237'vel*/'
      ''
      '                '#39'O'#39', 2, /*ocupado - considerar como ocupado*/'
      '                '#39'R'#39', 2, /*reservado - considerar como ocupado*/'
      ''
      '                '#39'M'#39', 3, /*reforma - considerar como bloqueado*/'
      
        '                '#39'T'#39', 3, /*interdi'#231#227'o temporaria - considerar com' +
        'o bloqueado*/'
      '                3'
      '              )AS STATUS'
      '            , DECODE('
      
        '                DECODE(NVL (DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_' +
        'CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss' +
        #39') - NVL (TRUNC (MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRU' +
        'NC (MOV_INT.HR_LIB_MOV)), :DATA_CONSULTA)), 1,'
      
        '                '#39'V'#39', DBAMV.RETORNA_SITUACAO_DO_LEITO (TO_DATE(TO' +
        '_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyy' +
        'y hh24:mi:ss'#39'), LEITO.CD_LEITO)), '#39'V'#39'),'
      
        '                '#39'F'#39', '#39'I'#39', NVL (DECODE (SIGN (TO_DATE(TO_CHAR(:DA' +
        'TA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi' +
        ':ss'#39') - NVL (TRUNC (MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - ' +
        'TRUNC (MOV_INT.HR_LIB_MOV)), :DATA_CONSULTA)), 1,'
      
        '                '#39'V'#39', DBAMV.RETORNA_SITUACAO_DO_LEITO (TO_DATE(TO' +
        '_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyy' +
        'y hh24:mi:ss'#39'), LEITO.CD_LEITO)), '#39'V'#39')),'
      ''
      '                '#39'M'#39', '#39'Reforma / Manuten'#231#227'o'#39', /*reforma*/'
      
        '                '#39'T'#39', '#39'Interditado Temporariamente'#39', /*interdi'#231#227'o' +
        ' temporaria*/'
      '                '#39#39
      '              )AS DS_CAUSA_DO_BLOQUEIO'
      
        '            , DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/' +
        'mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39') - NVL (TRUN' +
        'C (MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRUNC (MOV_INT.HR' +
        '_LIB_MOV)), :DATA_CONSULTA)), 1, NULL, PACIENTE.NM_PACIENTE) NM_' +
        'PACIENTE,'
      
        '            DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm' +
        '/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39') - NVL (TRUNC ' +
        '(MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRUNC (MOV_INT.HR_L' +
        'IB_MOV)), :DATA_CONSULTA)), 1, NULL, TO_CHAR (PACIENTE.DT_NASCIM' +
        'ENTO, '#39'DD/MM/YYYY'#39')) DT_NASCIMENTO,'
      
        '            DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm' +
        '/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39') - NVL (TRUNC ' +
        '(MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRUNC (MOV_INT.HR_L' +
        'IB_MOV)), :DATA_CONSULTA)), 1, NULL, CONVENIO.NM_CONVENIO) NM_CO' +
        'NVENIO,'
      
        '            DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm' +
        '/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39') - NVL (TRUNC ' +
        '(MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRUNC (MOV_INT.HR_L' +
        'IB_MOV)), :DATA_CONSULTA)), 1, NULL, PRESTADOR.NM_PRESTADOR) NM_' +
        'PRESTADOR,'
      
        '            DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm' +
        '/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39') - NVL (TRUNC ' +
        '(MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRUNC (MOV_INT.HR_L' +
        'IB_MOV)), :DATA_CONSULTA)), 1, TO_DATE (NULL), ATENDIME.DT_ATEND' +
        'IMENTO) DT_ATENDIMENTO,'
      
        '            /*TO_CHAR(:DATA_CONSULTA, '#39'yyyy-mm-dd'#39') || '#39' 00:00:0' +
        '0'#39' DT_ATIVACAO,*/'
      
        '            TO_CHAR(LEITO.DT_ATIVACAO, '#39'yyyy-mm-dd hh24:mi:ss'#39') ' +
        'DT_ATIVACAO,'
      
        '            DECODE (SIGN (TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm' +
        '/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39') - NVL (TRUNC ' +
        '(MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRUNC (MOV_INT.HR_L' +
        'IB_MOV)), :DATA_CONSULTA)), 1, NULL, ATENDIME.CD_ATENDIMENTO) CD' +
        '_ATENDIMENTO,'
      '            CONVENIO.CD_CONVENIO CD_CONVENIO,'
      
        '            DECODE (NVL (DECODE (SIGN(TO_DATE(TO_CHAR(:DATA_CONS' +
        'ULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39') -' +
        ' NVL (TRUNC (MOV_INT.DT_LIB_MOV) + (MOV_INT.HR_LIB_MOV - TRUNC (' +
        'MOV_INT.HR_LIB_MOV)), :DATA_CONSULTA)), 1, '#39'V'#39', MOV_INT.TP_MOV),' +
        ' '#39'V'#39'), '#39'V'#39', '#39#39', SUB_PLANO.DS_SUB_PLANO) DS_SUB_PLANO'
      '        FROM DBAMV.LEITO,'
      '             DBAMV.UNID_INT,'
      '            ('
      '                SELECT '
      '                    MAX(CD_MOV_INT) CD_MOV_INT'
      
        '                    , TO_CHAR(MAX(DT_MOV_INT), '#39'yyyy-mm-dd'#39') DT_' +
        'ULT_MOV_INT'
      
        '                    , TO_CHAR (MAX(HR_MOV_INT), '#39'hh24:mi:ss'#39') HR' +
        '_ULT_MOV_INT'
      '                    , CD_LEITO'
      '                FROM DBAMV.MOV_INT'
      
        '                WHERE TO_DATE(TO_CHAR (MOV_INT.DT_MOV_INT, '#39'DD/M' +
        'M/YYYY'#39') || '#39' '#39' || TO_CHAR (MOV_INT.HR_MOV_INT, '#39'HH24:MI'#39'), '#39'DD/' +
        'MM/YYYY HH24:MI'#39') <= TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy' +
        ' hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39')'
      '                GROUP BY CD_LEITO'
      '            ) ULT_MOV,'
      '             DBAMV.MOV_INT,'
      '             DBAMV.ATENDIME,'
      '             DBAMV.PACIENTE,'
      '             DBAMV.CONVENIO,'
      '             DBAMV.PRESTADOR,'
      '             DBAMV.SUB_PLANO,'
      '             DBAMV.SETOR,'
      '             multi_empresas'
      '        WHERE LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT'
      '          AND LEITO.CD_LEITO = ULT_MOV.CD_LEITO (+)'
      '          AND ULT_MOV.CD_MOV_INT = MOV_INT.CD_MOV_INT (+)'
      
        '          AND MOV_INT.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO (' +
        '+)'
      '          AND UNID_INT.CD_SETOR = SETOR.CD_SETOR'
      '          AND ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE (+)'
      '          AND ATENDIME.CD_CONVENIO = CONVENIO.CD_CONVENIO (+)'
      '          AND ATENDIME.CD_PRESTADOR = PRESTADOR.CD_PRESTADOR (+)'
      '          AND (TRUNC (LEITO.DT_DESATIVACAO) IS NULL'
      
        '               OR TRUNC (LEITO.DT_DESATIVACAO) > TRUNC (TO_DATE(' +
        'TO_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/y' +
        'yyy hh24:mi:ss'#39')))'
      
        '          AND TRUNC (LEITO.DT_ATIVACAO) <= TRUNC (TO_DATE(TO_CHA' +
        'R(:DATA_CONSULTA, '#39'dd/mm/yyyy hh24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh' +
        '24:mi:ss'#39'))'
      '          AND ATENDIME.CD_SUB_PLANO = SUB_PLANO.CD_SUB_PLANO (+)'
      '          AND ATENDIME.CD_CONVENIO = SUB_PLANO.CD_CONVENIO (+)'
      '          AND ATENDIME.CD_CON_PLA = SUB_PLANO.CD_CON_PLA (+)'
      '          AND ATENDIME.CD_MULTI_EMPRESA (+) = 1'
      '          AND multi_empresas.CD_MULTI_EMPRESA (+) = 1'
      '          AND (MOV_INT.DT_LIB_MOV IS NULL'
      
        '               OR TO_DATE (TO_CHAR (MOV_INT.DT_LIB_MOV, '#39'DD/MM/Y' +
        'YYY'#39') || '#39' '#39' || TO_CHAR (MOV_INT.HR_LIB_MOV, '#39'HH24:MI'#39'), '#39'DD/MM/' +
        'YYYY HH24:MI'#39') <> TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh' +
        '24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39')'
      
        '               OR (TO_DATE (TO_CHAR (MOV_INT.DT_LIB_MOV, '#39'DD/MM/' +
        'YYYY'#39') || '#39' '#39' || TO_CHAR (MOV_INT.HR_LIB_MOV, '#39'HH24:MI'#39'), '#39'DD/MM' +
        '/YYYY HH24:MI'#39') = TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy hh' +
        '24'#39') || '#39':00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39')))'
      '          AND nvl (setor.cd_multi_empresa, 1) = 1'
      '        ORDER BY 2 ASC,'
      '                 1 ASC,'
      '                 4,'
      '                 12'
      '    ),'
      #9'T_CENSO_HOSP_ULT_HORA AS ('
      
        '        SELECT "NR_CNPJ_OSS","DS_RAZAO_SOCIAL_OSS","DATA_REF","H' +
        'ORA_REF","CD_UNID_INT","DS_UNID_INT","CD_LEITO","DS_LEITO","SN_M' +
        'ACA","SN_LEITO_EXTRA","TIPO_LEITO","TP_OCUPACAO","STATUS","DS_CA' +
        'USA_DO_BLOQUEIO","NM_PACIENTE","DT_NASCIMENTO","NM_CONVENIO","NM' +
        '_PRESTADOR","DT_ATENDIMENTO","DT_ATIVACAO","CD_ATENDIMENTO","CD_' +
        'CONVENIO","DS_SUB_PLANO"'
      #9#9'FROM T_CENSO_RETROATIVO'
      '    ),'
      '    CENSO_HOSPITALAR_AGORA AS ('
      '        SELECT * FROM T_CENSO_HOSP_ULT_HORA '
      '    ),'
      '    CENSO_HOSPITALAR_AGORA_C_TEMPO AS ('
      '        SELECT '
      '            CASE '
      '                WHEN CD_ATENDIMENTO IS NOT NULL THEN'
      
        '                    /* FN_IDADE(DT_ATENDIMENTO, '#39'd'#39', :DATA_CONSU' +
        'LTA)  */'
      '                    TRUNC(:DATA_CONSULTA - DT_ATENDIMENTO, 0)'
      '                ELSE'
      '                    NULL'
      '            END TEMPO_INTERNACAO'
      '            , CASE '
      '                WHEN CD_ATENDIMENTO IS NOT NULL THEN'
      
        '                    TRUNC(:DATA_CONSULTA - TO_DATE(DATA_REF, '#39'YY' +
        'YY-MM-DD'#39'), 0)'
      '                ELSE'
      '                    NULL'
      '            END TEMPO_ULT_MOV'
      '            , CASE'
      '                WHEN CD_ATENDIMENTO IS NOT NULL THEN'
      
        '                    round(24 * ( :DATA_CONSULTA - TO_DATE(DATA_R' +
        'EF||'#39' '#39'||HORA_REF, '#39'YYYY-MM-DD HH24:MI:SS'#39') ),0)'
      '                ELSE'
      '                    NULL'
      '            END HORAS_ULT_MOV'
      '            , CENSO_HOSPITALAR_AGORA.*'
      '        FROM CENSO_HOSPITALAR_AGORA '
      '    ),'
      '    /* SELECT * FROM CENSO_HOSPITALAR_AGORA_C_TEMPO */'
      '    ANALISE_LEITOS AS ('
      '        SELECT '
      '            CASE'
      '                WHEN TEMPO_INTERNACAO IS NULL THEN '#39'VAGO'#39
      '                WHEN TEMPO_INTERNACAO <= 12 THEN '#39'0 ~ 12 DIAS'#39
      '                WHEN TEMPO_INTERNACAO <= 24 THEN '#39'13 ~ 24 DIAS'#39
      '                ELSE '#39'> 24 DIAS'#39
      '            END SCORE'
      '            , DECODE(CD_UNID_INT '
      '                    , 13, '#39'HOSPITAL DIA'#39' '
      '                    , 24, '#39'EMERGENCIA'#39
      '                    , 11, '#39'UTI'#39
      '                    , 12, '#39'UTI'#39
      '                    , 17, '#39'INTERNACAO ADULTO'#39
      '                    , 20, '#39'INTERNACAO ADULTO'#39
      '                    , 21, '#39'INTERNACAO ADULTO'#39
      '                    , 22, '#39'INTERNACAO ADULTO'#39
      '                    , 25, '#39'INTERNACAO ADULTO'#39
      '                    , 23, '#39'INTERNACAO PEDIATRICA'#39
      '                    , CD_UNID_INT) CLASSE_INTERNACAO'
      '            , TRIM(SUBSTR(DS_LEITO, 5, 10)) LEITO_DESC'
      
        '            , CASE WHEN (TEMPO_INTERNACAO >= 12) THEN '#39'S'#39' ELSE '#39 +
        'N'#39' END EM_ALERTA'
      '            , CENSO_HOSPITALAR_AGORA_C_TEMPO.*'
      '        FROM CENSO_HOSPITALAR_AGORA_C_TEMPO'
      '    )'
      '    SELECT '
      '        CASE WHEN TEMPO_INTERNACAO IS NULL THEN NULL'
      '            WHEN TEMPO_INTERNACAO = 0 THEN NULL'
      #9#9#9'ELSE ('
      #9#9#9#9'SELECT '
      #9#9#9#9#9'COUNT(COLETA_SINAL_VITAL.CD_COLETA_SINAL_VITAL) '
      #9#9#9#9'FROM COLETA_SINAL_VITAL '
      #9#9#9#9'WHERE '
      
        #9#9#9#9#9'COLETA_SINAL_VITAL.CD_ATENDIMENTO = ANALISE_LEITOS.CD_ATEND' +
        'IMENTO'
      #9#9#9#9#9'AND COLETA_SINAL_VITAL.DATA_COLETA BETWEEN '
      
        #9#9#9#9#9#9'TO_DATE(TO_CHAR(:DATA_CONSULTA - interval '#39'1'#39' day, '#39'dd/mm/' +
        'yyyy'#39') || '#39' 00:00:00'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39')'
      
        #9#9#9#9#9#9'AND TO_DATE(TO_CHAR(:DATA_CONSULTA - interval '#39'1'#39' day, '#39'dd' +
        '/mm/yyyy'#39') || '#39' 23:59:59'#39', '#39'dd/mm/yyyy hh24:mi:ss'#39')'
      #9#9#9') '
      '        END LEITURAS_SINAIS_VITAIS'
      '        , ANALISE_LEITOS."SCORE"'
      '        ,ANALISE_LEITOS."CLASSE_INTERNACAO"'
      '        ,ANALISE_LEITOS."LEITO_DESC"'
      '        ,ANALISE_LEITOS."EM_ALERTA"'
      '        ,ANALISE_LEITOS."TEMPO_ULT_MOV"'
      '        ,ANALISE_LEITOS."HORAS_ULT_MOV"'
      '        ,ANALISE_LEITOS."TEMPO_INTERNACAO"'
      '        ,ANALISE_LEITOS."NR_CNPJ_OSS"'
      '        ,ANALISE_LEITOS."DS_RAZAO_SOCIAL_OSS"'
      '        ,ANALISE_LEITOS."DATA_REF"'
      '        ,ANALISE_LEITOS."HORA_REF"'
      '        ,ANALISE_LEITOS."CD_UNID_INT"'
      '--        ,ANALISE_LEITOS."DS_UNID_INT"'
      
        '        , CASE WHEN ANALISE_LEITOS.CD_LEITO = 341 THEN '#39'BIOSEGUR' +
        'ANCA NIVEL IV'#39' ELSE ANALISE_LEITOS.DS_UNID_INT END AS DS_UNID_IN' +
        'T'
      '        ,ANALISE_LEITOS."CD_LEITO"'
      '        ,ANALISE_LEITOS."DS_LEITO"'
      '        ,ANALISE_LEITOS."SN_MACA"'
      '        ,ANALISE_LEITOS."SN_LEITO_EXTRA"'
      '        ,ANALISE_LEITOS."TIPO_LEITO"'
      '        ,ANALISE_LEITOS."TP_OCUPACAO"'
      '        ,ANALISE_LEITOS."STATUS"'
      '        ,ANALISE_LEITOS."DS_CAUSA_DO_BLOQUEIO"'
      '        ,ANALISE_LEITOS."NM_PACIENTE"'
      '        ,ANALISE_LEITOS."DT_NASCIMENTO"'
      '        ,ANALISE_LEITOS."NM_CONVENIO"'
      '        ,ANALISE_LEITOS."NM_PRESTADOR"'
      '        ,ANALISE_LEITOS."DT_ATENDIMENTO"'
      '        ,ANALISE_LEITOS."DT_ATIVACAO"'
      '        ,ANALISE_LEITOS."CD_ATENDIMENTO"'
      '        ,ANALISE_LEITOS."CD_CONVENIO"'
      '        ,ANALISE_LEITOS."DS_SUB_PLANO"'
      '    FROM ANALISE_LEITOS'
      'ORDER BY DS_UNID_INT, DS_LEITO')
    FetchRows = 300
    ReadOnly = True
    Left = 115
    Top = 136
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'DATA_CONSULTA'
        Value = 43607.7381944444d
      end>
  end
  object dsStatusLeitos: TDataSource
    DataSet = qryStatusLeitos
    Left = 112
    Top = 200
  end
  object qryScoresEnfermagem: TUniQuery
    Connection = OracleConnection
    SQL.Strings = (
      '  WITH'
      '    LEITOS_ATIVOS AS ('
      '        SELECT '
      '            PAGU_FORMULA.CD_FORMULA'
      '            , PAGU_FORMULA.DS_FORMULA'
      '            , UNID_INT.DS_UNID_INT'
      '            , LEITO.CD_LEITO'
      '            , LEITO.DS_RESUMO'
      '            , DECODE(LEITO.TP_OCUPACAO,'
      '                '#39'V'#39', '#39'VAGO'#39','
      '                '
      '                '#39'O'#39', '#39'OCUPADO'#39','
      '                '#39'R'#39', '#39'OCUPADO'#39','
      '                '
      '                '#39'M'#39', '#39'BLOQUEADO'#39','
      '                '#39'T'#39', '#39'BLOQUEADO'#39','
      '                LEITO.TP_OCUPACAO'
      '            ) STATUS_OCUPACAO'
      '        FROM LEITO'
      
        '        INNER JOIN UNID_INT ON UNID_INT.CD_UNID_INT = LEITO.CD_U' +
        'NID_INT'
      
        '        INNER JOIN PAGU_FORMULA ON 1 = 1 AND PAGU_FORMULA.CD_FOR' +
        'MULA IN'
      
        '          (SELECT CD_FORMULA FROM PAGU_FORMULA WHERE TP_FORMULA ' +
        '= '#39'E'#39' AND DS_FORMULA IN ('#39'PEWS'#39', '#39'FUGULIN'#39', '#39'FUGULIN PEDI'#193'TRICO'#39 +
        ', '#39'FUGULIN UTI ADULTO'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'MEWS'#39'))'
      '        WHERE'
      '            DT_DESATIVACAO IS NULL'
      
        '        ORDER BY PAGU_FORMULA.DS_FORMULA, UNID_INT.DS_UNID_INT, ' +
        'LEITO.DS_RESUMO'
      '    ),'
      '    AVALIACOES_ELEGIVEIS_HOJE AS ('
      '        SELECT '
      '            PAGU_AVALIACAO.*'
      '            , ATENDIME.DT_ALTA'
      '        FROM PAGU_AVALIACAO'
      
        '        INNER JOIN ATENDIME ON ATENDIME.CD_ATENDIMENTO = PAGU_AV' +
        'ALIACAO.CD_ATENDIMENTO'
      
        '        INNER JOIN PW_DOCUMENTO_CLINICO ON  PW_DOCUMENTO_CLINICO' +
        '.CD_DOCUMENTO_CLINICO = PAGU_AVALIACAO.CD_DOCUMENTO_CLINICO '
      
        '                                            AND PW_DOCUMENTO_CLI' +
        'NICO.TP_STATUS <> '#39'CANCELADO'#39
      '        WHERE '
      
        '            TRUNC(PAGU_AVALIACAO.DH_AVALIACAO) = TRUNC(TO_DATE(T' +
        'O_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy'#39'), '#39'dd/mm/yyyy'#39'))'
      
        '            AND ( (ATENDIME.DT_ALTA IS NULL) OR (TRUNC(ATENDIME.' +
        'DT_ALTA) < TRUNC(TO_DATE(TO_CHAR(:DATA_CONSULTA, '#39'dd/mm/yyyy'#39'), ' +
        #39'dd/mm/yyyy'#39')) ))'
      '            AND PAGU_AVALIACAO.CD_FORMULA IN'
      
        '              (SELECT CD_FORMULA FROM PAGU_FORMULA WHERE DS_FORM' +
        'ULA IN ('#39'PEWS'#39', '#39'FUGULIN'#39', '#39'FUGULIN PEDI'#193'TRICO'#39', '#39'FUGULIN UTI AD' +
        'ULTO'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'MEWS'#39'))'
      '            /*'
      '              19'#9'PEWS'
      '              15'#9'FUGULIN'
      '              16'#9'BRADEN'
      '              17'#9'MORSE'
      '              18'#9'MEWS'
      '              26  FUGULIN PEDI'#193'TRICO'
      '              27  FUGULIN UTI ADULTO'
      '            */'
      '    ),'
      '    AVALIACOES AS ('
      '        SELECT'
      '            UNID_INT.DS_UNID_INT'
      '            , LEITO.CD_LEITO'
      '            , LEITO.DS_RESUMO'
      '            , PAGU_FORMULA.CD_FORMULA'
      '            , PAGU_FORMULA.DS_FORMULA'
      '            , PAGU_FORMULA.TP_FORMULA'
      '            , AV.CD_ATENDIMENTO'
      '            , ATENDIME.DT_ALTA'
      '            , AV.CD_AVALIACAO'
      
        '            , TO_CHAR(AV.DH_AVALIACAO, '#39'dd/mm/yyyy hh24:mi:ss'#39') ' +
        'DH_AVALIACAO'
      '            , AV.VL_RESULTADO'
      '            , AV.NM_USUARIO'
      '            , PAGU_FORMULA_INTERPRETACAO.DS_INTERPRETACAO'
      '        FROM AVALIACOES_ELEGIVEIS_HOJE AV'
      
        '        INNER JOIN PAGU_FORMULA ON PAGU_FORMULA.CD_FORMULA = AV.' +
        'CD_FORMULA'
      '        LEFT JOIN PAGU_FORMULA_INTERPRETACAO ON '
      
        '            PAGU_FORMULA_INTERPRETACAO.CD_FORMULA = AV.CD_FORMUL' +
        'A '
      
        '            AND AV.VL_RESULTADO BETWEEN PAGU_FORMULA_INTERPRETAC' +
        'AO.VL_INICIAL AND PAGU_FORMULA_INTERPRETACAO.VL_FINAL'
      
        '        INNER JOIN ATENDIME ON ATENDIME.CD_ATENDIMENTO = AV.CD_A' +
        'TENDIMENTO'
      '        INNER JOIN LEITO ON LEITO.CD_LEITO = ATENDIME.CD_LEITO'
      
        '        INNER JOIN UNID_INT ON UNID_INT.CD_UNID_INT = LEITO.CD_U' +
        'NID_INT'
      '    )'
      '    SELECT '
      '        LEITOS_ATIVOS.CD_FORMULA'
      '        , LEITOS_ATIVOS.DS_FORMULA'
      
        '        , CASE WHEN LEITOS_ATIVOS.CD_LEITO = 341 THEN '#39'BIOSEGURA' +
        'NCA NIVEL IV'#39' ELSE LEITOS_ATIVOS.DS_UNID_INT END AS DS_UNID_INT'
      '        , LEITOS_ATIVOS.CD_LEITO'
      '        , LEITOS_ATIVOS.DS_RESUMO'
      '        , LEITOS_ATIVOS.STATUS_OCUPACAO'
      ''
      '        , AVALIACOES.CD_ATENDIMENTO'
      '        , AVALIACOES.DH_AVALIACAO'
      '        , AVALIACOES.VL_RESULTADO'
      '        , AVALIACOES.NM_USUARIO'
      '        , AVALIACOES.DS_INTERPRETACAO'
      '    FROM LEITOS_ATIVOS'
      
        '    LEFT JOIN AVALIACOES ON AVALIACOES.CD_FORMULA = LEITOS_ATIVO' +
        'S.CD_FORMULA AND AVALIACOES.CD_LEITO = LEITOS_ATIVOS.CD_LEITO'
      '    WHERE'
      
        '         ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'ALA A'#39') AND (LEITOS_' +
        'ATIVOS.DS_FORMULA IN ('#39'FUGULIN'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'MEWS'#39')) )'
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'ALA A - ADULTO'#39') AND' +
        ' (LEITOS_ATIVOS.DS_FORMULA IN ('#39'FUGULIN'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'ME' +
        'WS'#39')) )'
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'ALA A - PEDIATRIA'#39') ' +
        'AND (LEITOS_ATIVOS.DS_FORMULA IN ('#39'FUGULIN PEDI'#193'TRICO'#39', '#39'BRADEN'#39 +
        ', '#39'MORSE'#39')) )'
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'ALA B'#39') AND (LEITOS_' +
        'ATIVOS.DS_FORMULA IN ('#39'FUGULIN'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'MEWS'#39')) )'
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'ALA C'#39') AND (LEITOS_' +
        'ATIVOS.DS_FORMULA IN ('#39'FUGULIN'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'MEWS'#39')) )'
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'ALA D'#39') AND (LEITOS_' +
        'ATIVOS.DS_FORMULA IN ('#39'FUGULIN'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'MEWS'#39')) )'
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'ALA E'#39') AND (LEITOS_' +
        'ATIVOS.DS_FORMULA IN ('#39'FUGULIN'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'MEWS'#39')) )'
      ''
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'EMERGENCIA - OBSERVA' +
        'CAO'#39') AND (LEITOS_ATIVOS.DS_FORMULA IN ('#39'FUGULIN'#39', '#39'BRADEN'#39', '#39'MO' +
        'RSE'#39', '#39'MEWS'#39')) )'
      ''
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'UTI ADULTO'#39') AND (LE' +
        'ITOS_ATIVOS.DS_FORMULA IN ('#39'FUGULIN UTI ADULTO'#39', '#39'BRADEN'#39', '#39'MORS' +
        'E'#39')) )'
      
        '      OR ( (LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'UTI PEDIATRICA'#39') AND' +
        ' (LEITOS_ATIVOS.DS_FORMULA IN ('#39'FUGULIN PEDI'#193'TRICO'#39', '#39'BRADEN'#39', '#39 +
        'MORSE'#39')) )'
      ''
      
        '      OR ( ( LEITOS_ATIVOS.DS_UNID_INT LIKE '#39'ENFERMARIA'#39' ) AND (' +
        'LEITOS_ATIVOS.DS_FORMULA IN ('#39'FUGULIN'#39', '#39'BRADEN'#39', '#39'MORSE'#39', '#39'MEWS' +
        #39')) ) /* CEAP-SOL */'
      ''
      '    ORDER BY LEITOS_ATIVOS.CD_LEITO, LEITOS_ATIVOS.DS_FORMULA')
    FetchRows = 300
    ReadOnly = True
    Left = 235
    Top = 136
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'DATA_CONSULTA'
        Value = 43572d
      end>
  end
  object dsScoresEnfermagem: TDataSource
    DataSet = qryScoresEnfermagem
    Left = 232
    Top = 200
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 56
    Top = 48
  end
  object qryAlertaMews: TUniQuery
    Connection = OracleConnection
    SQL.Strings = (
      'SELECT * FROM VDIC_ALETRA_MEWS_RISCO_RECENTE'
      'WHERE DT_ALTA IS NULL')
    FetchRows = 300
    ReadOnly = True
    Left = 355
    Top = 136
  end
  object dsAlertaMews: TDataSource
    DataSet = qryAlertaMews
    Left = 352
    Top = 200
  end
end
