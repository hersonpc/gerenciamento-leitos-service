unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.UI.Intf, Data.DB,
  MemDS, DBAccess, Uni, UniProvider, OracleUniProvider, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, FireDAC.ConsoleUI.Wait, jsonGenerator;

type
  TDM = class(TDataModule)
    OracleConnection: TUniConnection;
    OracleUniProvider1: TOracleUniProvider;
    qryStatusLeitos: TUniQuery;
    dsStatusLeitos: TDataSource;
    qryScoresEnfermagem: TUniQuery;
    dsScoresEnfermagem: TDataSource;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qryAlertaMews: TUniQuery;
    dsAlertaMews: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure DisconectDB;
    procedure setConnectionAsIndex(Index: Integer);

    procedure consultaLeitos(pData: TDateTime);
    procedure consultaStatusLeitos(pData: TDateTime);
    procedure consultaScoreEnfermagem(pData: TDateTime);
    procedure consultaAlertaMewsRecente();

    procedure ExtrairDadosLeitos(FileName: String);
  end;

var
  DM: TDM;

const
  APP_VERSION = 'v2021.02.15-A';

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

const
  DB_HDT = 0;
  DB_CS = 1;


procedure TDM.consultaAlertaMewsRecente;
begin
  Writeln('> Consultando alerta mews recente');
  qryAlertaMews.Close;
  qryAlertaMews.Open;
end;

procedure TDM.consultaLeitos(pData: TDateTime);
begin
  consultaStatusLeitos(pData);
  consultaScoreEnfermagem(pData);
  consultaAlertaMewsRecente;
end;

procedure TDM.consultaScoreEnfermagem(pData: TDateTime);
begin
  Writeln('> Consultando scores de enfermagem');
  qryScoresEnfermagem.Close;
  qryScoresEnfermagem.ParamByName('DATA_CONSULTA').AsDateTime := pData;
  qryScoresEnfermagem.Open;
end;

procedure TDM.consultaStatusLeitos(pData: TDateTime);
begin
  Writeln('> Consultando status dos leitos');
  qryStatusLeitos.Close;
  qryStatusLeitos.ParamByName('DATA_CONSULTA').AsDateTime := pData;
  qryStatusLeitos.Open;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  setConnectionAsIndex(DB_HDT);
  if not OracleConnection.Connected then
    halt(1);
end;

procedure TDM.DisconectDB;
begin
  OracleConnection.Close;
end;

procedure TDM.ExtrairDadosLeitos(FileName: String);
var
  pData: TDateTime;
  pUnidade, pLeitoAnterior, pScoreAnterior: String;
  i: Integer;
  outputJson: TGenJson;
begin

  pData := Now;

  consultaLeitos(pData);
  Writeln('qryStatusLeitos: ' + qryStatusLeitos.RecordCount.ToString);
  Writeln('qryScoresEnfermagem: ' + qryScoresEnfermagem.RecordCount.ToString);

  outputJson :=
    TGenJson.New
      .startObject // OBJETO GLOBAL
      .pair('VERSION', APP_VERSION)
      .addSeparator
      .pair('DATA_REF', FormatDateTime('DD/MM/YYYY', pData))
      .addSeparator
      .pair('DATA_ATUALIZACAO', FormatDateTime('DD/MM/YYYY HH:NN:SS', pData))
      .addSeparator
      .openObject('UNIDADES') //BEGIN ARRAY UNIDADES...
      ;

  pUnidade := '';
  pLeitoAnterior := '';

  qryStatusLeitos.First;
  while not DM.qryStatusLeitos.Eof do
  try
    if pUnidade <> DM.qryStatusLeitos.FieldByName('DS_UNID_INT').AsString then
    begin
      if pUnidade <> '' then
        outputJson.closeArray.addSeparator;
      pUnidade := DM.qryStatusLeitos.FieldByName('DS_UNID_INT').AsString;
      pLeitoAnterior := ''; // reinicia sempre que mudar de unidade...

      outputJson.openArray(pUnidade);
    end;

    if pLeitoAnterior <> '' then
      outputJson.addSeparator;

    outputJson
      .openObject
        .pair('DS_LEITO', DM.qryStatusLeitos.FieldByName('DS_LEITO').AsString).addSeparator
        .pair('SCORE', DM.qryStatusLeitos.FieldByName('SCORE').AsString).addSeparator
        .pair('TEMPO_ULT_MOV', DM.qryStatusLeitos.FieldByName('TEMPO_ULT_MOV').AsInteger).addSeparator
        .pair('HORAS_ULT_MOV', DM.qryStatusLeitos.FieldByName('HORAS_ULT_MOV').AsInteger).addSeparator
        .pair('TEMPO_INTERNACAO', DM.qryStatusLeitos.FieldByName('TEMPO_INTERNACAO').AsInteger).addSeparator
        .pair('TP_OCUPACAO', DM.qryStatusLeitos.FieldByName('TP_OCUPACAO').AsString).addSeparator
        .pair('STATUS', DM.qryStatusLeitos.FieldByName('STATUS').AsInteger).addSeparator
        .pair('CD_ATENDIMENTO', StrToIntDef(DM.qryStatusLeitos.FieldByName('CD_ATENDIMENTO').AsString, 0)).addSeparator
        .pair('LEITURAS_SINAIS_VITAIS', StrToIntDef(DM.qryStatusLeitos.FieldByName('LEITURAS_SINAIS_VITAIS').AsString, 0));

      if ((not DM.qryStatusLeitos.FieldByName('CD_ATENDIMENTO').IsNull)
          and (DM.qryStatusLeitos.FieldByName('CD_ATENDIMENTO').AsInteger > 0)) then
      begin
        // adicionando os scores....
        qryAlertaMews.First;
        qryAlertaMews.Filtered := False;
        qryAlertaMews.Filter := Format('CD_ATENDIMENTO = %s', [qryStatusLeitos.FieldByName('CD_ATENDIMENTO').AsString]);
        qryAlertaMews.Filtered := True;
        if qryAlertaMews.RecordCount > 0 then
        try
          qryAlertaMews.First;
          outputJson
            .addSeparator
            .openArray('ALERTA');

//          if qryAlertaMews.RecordCount > 1 then
//          begin
//            outputJson.pair('ANALISE', '#' + qryAlertaMews.RecordCount.ToString + ' leituras de MEWS com gravidade' ).addSeparator;
//          end;

          while not qryAlertaMews.Eof do
          try
            outputJson
              .openObject
              .pair('HORARIO', qryAlertaMews.FieldByName('HORA_AVALIACAO').AsString).addSeparator
              .pair('SCORE', qryAlertaMews.FieldByName('VL_RESULTADO').AsInteger).addSeparator
              .closeObject
              .addSeparator;
          finally
            qryAlertaMews.Next;
          end;


          outputJson
            .closeArray;
        finally
          DM.qryAlertaMews.Filtered := False;
          DM.qryAlertaMews.Filter := '';
        end;
      end;

      // adicionando os scores....
      DM.qryScoresEnfermagem.First;
      DM.qryScoresEnfermagem.Filtered := False;
      DM.qryScoresEnfermagem.Filter := Format('CD_LEITO LIKE "%s"', [DM.qryStatusLeitos.FieldByName('CD_LEITO').AsString]);
      DM.qryScoresEnfermagem.Filtered := True;

      if DM.qryScoresEnfermagem.RecordCount > 0 then
      try
        outputJson
          .addSeparator
          .openObject('SCORES');
        pScoreAnterior := '';
        while (
              (not DM.qryScoresEnfermagem.Eof)
              and (DM.qryScoresEnfermagem.FieldByName('CD_LEITO').AsString = DM.qryStatusLeitos.FieldByName('CD_LEITO').AsString)
          ) do
        try
          if pScoreAnterior <> DM.qryScoresEnfermagem.FieldByName('DS_FORMULA').AsString then
          begin
            if pScoreAnterior <> '' then
              outputJson.addLinebreak.closeArray.addSeparator.addLinebreak;
            outputJson.addLinebreak.openArray(DM.qryScoresEnfermagem.FieldByName('DS_FORMULA').AsString).addLinebreak;
          end
          else
            outputJson.addSeparator.addLinebreak;
          pScoreAnterior := DM.qryScoresEnfermagem.FieldByName('DS_FORMULA').AsString;

          if DM.qryScoresEnfermagem.FieldByName('DH_AVALIACAO').AsString <> '' then
          begin
            outputJson
              .openObject
              .pair('LEITURA', DM.qryScoresEnfermagem.FieldByName('DH_AVALIACAO').AsString).addSeparator
              .pair('RESULTADO', DM.qryScoresEnfermagem.FieldByName('VL_RESULTADO').AsString).addSeparator
              .pair('INTERPRETACAO', DM.qryScoresEnfermagem.FieldByName('DS_INTERPRETACAO').AsString)
              .closeObject;
          end;
        finally
          DM.qryScoresEnfermagem.Next;
        end;
      finally
        outputJson
          .closeArray // ultimo score...
          .closeObject // fechar o array de scores...
          ;
      end;

      outputJson
        .closeObject // fechar o objeto LEITO...
        .addLinebreak.addLinebreak;

    pLeitoAnterior := DM.qryStatusLeitos.FieldByName('DS_LEITO').AsString;
  finally
    DM.qryStatusLeitos.Next;
  end;
  DM.qryStatusLeitos.First;
  outputJson
    .closeArray // ULTIMA UNIDADE...
    .closeObject // END OBJETO UNIDADES..
    .closeObject; // OBJETO GLOBAL

  if FileName <> '' then
    with TStringList.Create do
    try
      Text := outputJson.JSON;
      SaveToFile(FileName);
      Writeln('Arquivo salvo em: ' + FileName);
    finally
      Free;
    end;
end;

procedure TDM.setConnectionAsIndex(Index: Integer);
begin
  if OracleConnection.Tag <> Index then
  begin
    Writeln('Conectando...');
    OracleConnection.Disconnect;
    OracleConnection.Tag := Index;

    if Index = DB_HDT then
    begin
      OracleConnection.Server := '192.168.10.1:1521:hdtprd';
      OracleConnection.Username := 'dbamv';
      OracleConnection.Password := 'mv#*2012';
    end
    else if Index = DB_CS then
    begin
      OracleConnection.Server := '192.168.10.1:1521:csprd';
      OracleConnection.Username := 'dbamv';
      OracleConnection.Password := 'ceapsol2018';
    end;

    OracleConnection.Connected := True;
  end;
end;

end.
