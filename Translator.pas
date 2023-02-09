unit Translator;

{$mode objfpc}{$H+}

//Author: domasz
//Version: 0.1 (2023-02-09)
//Licence: MIT

interface

uses
  Classes, SysUtils, Forms, Controls, TypInfo, Dialogs, CRC;

  procedure TranslateForm(Lang: String; Form: TForm);
  procedure SaveOriginalTranslations(Filename: String);
  function _(Str: String): String;
  procedure SetTranlationDir(Dir: String);

var Translations: TStringList;
    OrgText: TStringList;
    GlobalLang: String;
    TransDir: String;

implementation

function DoHash(Str: String): String;
var H: Cardinal;
begin
  H := CRC32(0,nil,0);
  H := CRC32(H, @Str[1], Length(Str));
  Result := IntToHex(H , 8);
end;

function _(Str: String): String;
var Hash: String;
begin
  Hash := DoHash(Str);
  Result := Translations.Values[Hash];
  if Result = '' then Result := Str;
end;

procedure SetTranlationDir(Dir: String);
begin
  TransDir := Dir;
end;

procedure SaveOriginalTranslations(Filename: String);
var List: TStringList;
    i: Integer;
    Str: String;
begin
  List := TStringList.Create;

  for i:=0 to OrgText.Count-1 do begin
    Str := OrgText.ValueFromIndex[i];

    if (Str = '') or (Str = '-') then continue;

    List.Add(DoHash(Str) + '=' + Str);
  end;

  try
    List.SaveToFile(Filename);
  finally
  end;

  List.Free;
end;

procedure TranslateForm(Lang: String; Form: TForm);
procedure TrComponent(C: TComponent);
var Org: String;
    Hash: String;
begin
  if IsPublishedProp(C, 'Caption') then begin
    Org := GetPropValue(C, 'Caption', True);

    Hash := IntToStr(C.GetHashCode);

    if OrgText.IndexOfName(Hash) < 0 then begin
      OrgText.Add(Hash + '=' + Org);

      SetPropValue(C, 'Caption', _(Org) );
    end
    else begin
      SetPropValue(C, 'Caption', _( OrgText.Values[Hash]) );
    end;
  end;
end;

procedure Tr(C: TComponent);
var i: Integer;
    CC: TComponent;
begin
    for i:=0 to C.ComponentCount-1 do begin
      CC := C.Components[i] as TComponent;
      TrComponent(CC);

      if CC.ComponentCount > 0 then Tr(CC);
    end;
end;

var FName: String;
begin
  GlobalLang := Lang;

  FName := TransDir + DirectorySeparator + Lang + '.txt';

  if FileExists(FName) then
  try
    Translations.LoadFromFile(FName);
  finally
  end;

  Tr(Form);
end;

initialization
TransDir := 'lang';
Translations := TStringList.Create;
OrgText := TStringList.Create;

finalization
Translations.Free;
OrgText.Free;

end.
