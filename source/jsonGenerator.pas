unit jsonGenerator;

interface

type
  TGenJson = class
  private
    FJSON: String;
    level: Integer;
    procedure Clear;
    procedure enterLevel;
    procedure backLevel;
    procedure add(text: String);
    procedure SetJSON(const Value: String);
    procedure removeLastSeparatorIfExists();
  public
    constructor Create;
    class function New: TGenJson;
    function addSeparator: TGenJson;
    function addLinebreak: TGenJson;
    function startObject: TGenJson;
    function openObject: TGenJson; overload;
    function openObject(nodeName: String): TGenJson; overload;
    function openArray: TGenJson; overload;
    function openArray(tagName: String): TGenJson; overload;
    function pair(key, value: String): TGenJson; overload;
    function pair(key: String; value: Integer): TGenJson; overload;
    function closeObject: TGenJson;
    function closeArray: TGenJson;
  published
    property JSON: String read FJSON write SetJSON;
  end;

implementation

uses
  System.SysUtils, System.StrUtils;

{ TGenJson }

procedure TGenJson.add(text: String);
begin
  FJSON := FJSON + text;
end;

function TGenJson.addLinebreak: TGenJson;
begin
//  add(#13#10);
  Result := Self;
end;

function TGenJson.addSeparator: TGenJson;
begin
  add(',');
  Result := Self;
end;

procedure TGenJson.backLevel;
begin
  level := level -1;
end;

procedure TGenJson.Clear;
begin
  FJSON := '';
  level := 0;
end;

function TGenJson.closeArray: TGenJson;
begin
  removeLastSeparatorIfExists;
  add(']');
  Result := Self;
end;

function TGenJson.closeObject: TGenJson;
begin
  removeLastSeparatorIfExists;
  add('}');
  Result := Self;
end;

constructor TGenJson.Create;
begin
  Clear;
end;

procedure TGenJson.enterLevel;
begin
  level := level +1;
end;

class function TGenJson.New: TGenJson;
begin
  Result := Self.Create;
end;

function TGenJson.openArray(tagName: String): TGenJson;
begin
  enterLevel;

  add(Format('"%s": [', [tagName]));
  Result := Self;
end;

function TGenJson.openArray: TGenJson;
begin
  add('[');
  Result := Self;
end;

function TGenJson.openObject(nodeName: String): TGenJson;
begin
  add(Format('"%s": {', [nodeName]));
  Result := Self;
end;

function TGenJson.pair(key: String; value: Integer): TGenJson;
begin
  add(Format('"%s": %d', [key, value]));
  Result := Self;
end;

procedure TGenJson.removeLastSeparatorIfExists;
begin
  if AnsiRightStr(FJSON, 1) = ',' then
    FJSON := Copy(FJSON, 1, Length(FJSON)-1);
end;

function TGenJson.openObject: TGenJson;
begin
  add('{');
  Result := Self;
end;

function TGenJson.pair(key, value: String): TGenJson;
begin
  add(Format('"%s": "%s"', [key, value]));
//  Result := Self.addSeparator;
  Result := Self;
end;

procedure TGenJson.SetJSON(const Value: String);
begin
  FJSON := Value;
end;

function TGenJson.startObject: TGenJson;
begin
  FJSON := '';
  add('{');
  Result := Self;
end;

end.
