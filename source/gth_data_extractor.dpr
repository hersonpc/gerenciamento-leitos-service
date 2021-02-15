program gth_data_extractor;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uDM in 'uDM.pas' {DM: TDataModule},
  jsonGenerator in 'jsonGenerator.pas';

begin
  try
    Writeln('Gerenciamento Tático Hospitalar - Monitor de Leitos Hospitalares '+APP_VERSION);
    Writeln('By Herson Melo <hersonpc@gmail.com>');
    Writeln('==============================================================================');
    Writeln('');
    Writeln('Qdte parametros: ' + ParamCount.ToString);
    Writeln('  #0: ' + ParamStr(0));
    Writeln('  #1: ' + ParamStr(1));
    Writeln('  #2: ' + ParamStr(2));

    if(ParamStr(1) = '') then
      raise Exception.Create('Parametro "arquivo de saida" não informado!');

    DM := TDM.Create(nil);
    DM.setConnectionAsIndex(0);
    DM.ExtrairDadosLeitos(ParamStr(1));

    if (ParamStr(2) <> '') then
    begin
      DM.setConnectionAsIndex(1);
      DM.ExtrairDadosLeitos(ParamStr(2));
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Writeln('fim.');
end.
