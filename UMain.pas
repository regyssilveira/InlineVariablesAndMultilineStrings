unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMyObjectTest = class
  private

  public

  end;

  TFrmMain = class(TForm)
    BtnMultiLineStrings: TButton;
    Memo1: TMemo;
    BtnInLineVars: TButton;
    BtnEscope: TButton;
    procedure BtnMultiLineStringsClick(Sender: TObject);
    procedure BtnInLineVarsClick(Sender: TObject);
    procedure BtnEscopeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

{$region 'utils'}
function GetAnyString: string;
begin
  Result := 'any string';
end;

function GetVarType(const AVar: Variant): string;
var
  basicType  : Integer;
begin
  basicType := VarType(AVar) and VarTypeMask;
  case basicType of
    varEmpty     : Result := 'Empty';
    varNull      : Result := 'Null';
    varSmallInt  : Result := 'SmallInt';
    varInteger   : Result := 'Integer';
    varSingle    : Result := 'Single';
    varDouble    : Result := 'Double';
    varCurrency  : Result := 'Currency';
    varDate      : Result := 'Date';
    varOleStr    : Result := 'OleStr';
    varDispatch  : Result := 'Dispatch';
    varError     : Result := 'Error';
    varBoolean   : Result := 'Boolean';
    varVariant   : Result := 'Variant';
    varUnknown   : Result := 'Unknown';
    varByte      : Result := 'Byte';
    varWord      : Result := 'Word';
    varLongWord  : Result := 'LongWord';
    varInt64     : Result := 'Int64';
    varStrArg    : Result := 'StrArg';
    varString    : Result := 'String (Ansi)';
    varAny       : Result := 'Any';
    varUString   : Result := 'String (Unicode)';
    varTypeMask  : Result := 'TypeMask';
    varShortInt  : Result := 'ShortInt';
    varUInt64    : Result := 'UInt64';
    varRecord    : Result := 'Record';
    varObject    : Result := 'Object';
    varUStrArg   : Result := 'UStrArg';
    varArray     : Result := 'Array';
    varByRef     : Result := 'ByRef';
  else
    Result := 'not in the list';
  end;
end;
{$endregion}

{$region 'Variable escope'}
procedure TFrmMain.BtnEscopeClick(Sender: TObject);
var
  Var1: string;
begin
  // https://docwiki.embarcadero.com/RADStudio/Athens/en/Inline_Variable_Declaration

  Memo1.Clear;

  Var1 := 'abc';
  Memo1.Lines.Add('var1 ' + Var1);

  // var exists on the escope of the begin/end, at end, this var can't be used
  // objects needd to be free on the same escope, when create inside that using inline vars
  begin
    var Var2: string := 'inline var2 inside first begin/end';
    Memo1.Lines.Add(Var2);

    var EscopeTest := TMyObjectTest.Create; // memory leak
  end;

  // an var exists on the escope of the begin/end, at end, this var can't be used
  // objects needd to be free on the same escope, when create inside that using inline vars
  begin
    var Var2: string := 'inline var2 inside second begin/end';
    Memo1.Lines.Add(Var2);

    var EscopeTest := TMyObjectTest.Create;
    try

    finally
      EscopeTest.Free;
    end;
  end;

  //Memo1.Lines.Add(Var2); // raise a compiler error

  var Var2: string := 'inline var2 outside of the begin/end';
  Memo1.Lines.Add('var2 ' + Var2);

  // an var exists on the escope of the begin/end, at end, this var can't be used
  // same for conditional statments
  // objects needd to be free on the same escope, when create inside that using inline vars
  if True then
  begin
    var Var3: string := 'inline var3 inside the IF';
    Memo1.Lines.Add(Var3);
  end;

  // Memo1.Lines.Add(Var3); // raise a compiler error

  var Var3: string := 'inline var3 outside of the begin/end';
  Memo1.Lines.Add('var2 ' + Var3);

  var1 := 'abcd';
  Memo1.Lines.Add('var1 ' + Var1);
end;
{$endregion}

{$region 'Inline Variables'}
procedure TFrmMain.BtnInLineVarsClick(Sender: TObject);
begin
  // https://blog.idera.com/developer-tools/introducing-inline-variables-in-the-delphi-language/
  // https://docwiki.embarcadero.com/RADStudio/Athens/en/Anonymous_Methods_in_Delphi

  var Number1: Double := 1.23;
  var Number2 := 1.23;
  var Number3 := 123;
  var Number4: Double := 123;

  var String1 := GetAnyString;
  var String2: string := 'xxxxxxx';
  var String3: AnsiString := 'xxxxxxx';

  var String4 := function(Str: string): Integer
    begin
      Result := Length(Str);
    end;

  var String5 := function(Str: string): string
    begin
      Result := 'Char count: ' + Length(Str).ToString;
    end;

  Memo1.Clear;

  Memo1.Lines.add(Number1.ToString + '  ' + GetVarType(Number1));
  Memo1.Lines.add(Number2.ToString + '  ' + GetVarType(Number2));
  Memo1.Lines.add(Number3.ToString + '  ' + GetVarType(Number3));
  Memo1.Lines.add(Number4.ToString + '  ' + GetVarType(Number4));

  Memo1.Lines.add(String1 + '  ' + GetVarType(String1));
  Memo1.Lines.add(String2 + '  ' + GetVarType(String2));
  Memo1.Lines.add(String3 + '  ' + GetVarType(String3));
  Memo1.Lines.add(String4('any string').ToString + '  ' + GetVarType(String4));
  Memo1.Lines.add(string(String5('any string')) + '  ' + GetVarType(String4));
end;
{$endregion}

{$region 'Multiline strings'}
procedure TFrmMain.BtnMultiLineStringsClick(Sender: TObject);
begin
  {
    https://docwiki.embarcadero.com/RADStudio/Athens/en/String_Types_(Delphi)

    Multiline string indentation and formatting logic are used very specifically. A multiline string treats a leading white space this way:

    The closing ‘’’ needs to be in a line of its own, not at the end of the last line of the string itself.
    The indentation of the closing ‘’’ determines the base indentation of the entire string.
    Each blank space before that indentation level is removed in the final string for each of the lines.
    None of the lines can be less indented than the base indentation (the closing ‘’’). This is a compiler error, showing also as Error Insight.
    The last newline before the closing ‘’’ is omitted. If you want to have a final new line, you should add an empty line at the end.

    Note: Notice that the triple quotes (”’) can also be replaced with a large odd number of quotes, like 5 or 7. This allows embedding an actual triple quote within a multiline string. For example:
  }

  Memo1.Clear;

  var Text: string;
  Text := '''
    Text, text, text, end
    Text, text, text, end
    Text, text, text, end
    Text, text, text, end

    ''';

  Memo1.Lines.Add(Text);
  Memo1.Lines.Add(StringOfChar('-', 40));

  Text := '''''''
    Text, text, text, end
    Text, text, text, end
    Text, text, text, end
    Text, text, text, end
  ''''''';

  Memo1.Lines.Add(Text);
end;
{$endregion}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
end;

end.
