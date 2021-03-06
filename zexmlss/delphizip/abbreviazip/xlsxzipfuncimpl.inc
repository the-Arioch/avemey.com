{
implementation: function for XLSX zip (delphi)
using TurboPower Abbrevia http://sourceforge.net/projects/tpabbrevia/
}

//��������� �������������� �������� � ������� Office Open XML (OOXML)
//INPUT
//  var XMLSS: TZEXMLSS                   - ���������
//      PathName: string                  - ���� � ���������� ��� ���������� (������ ������������ ������������ ����������)
//  const SheetsNumbers:array of integer  - ������ ������� ������� � ������ ������������������
//  const SheetsNames: array of string    - ������ �������� �������
//                                          (���������� ��������� � ���� �������� ������ ���������)
//      TextConverter: TAnsiToCPConverter - ���������
//      CodePageName: string              - ��� ���������
//      BOM: ansistring                   - Byte Order Mark
//RETURN
//      integer
function SaveXmlssToXLSX(var XMLSS: TZEXMLSS; FileName: string; const SheetsNumbers:array of integer;
                         const SheetsNames: array of string; TextConverter: TAnsiToCPConverter; CodePageName: string; BOM: ansistring = ''): integer; overload;
var
  tmpdir: string;
  b: boolean;
  _isCreated: boolean;

begin
  _isCreated := false;
  try
    _isCreated := ZECreateUniqueTmpDir(ZEGetTempDir(), tmpdir);
    result := SaveXmlssToXLSXPath(XMLSS, tmpdir, SheetsNumbers, SheetsNames, TextConverter, CodePageName, BOM);
    b := ZEZipPackAb(FileName, tmpdir);
    if (not b) then
      result := -1;
  finally
    if (_isCreated) then
      ZEDelTree(tmpdir);
  end;
end; //SaveXmlssToODFS

//������ xlsx
//INPUT
//  var XMLSS: TZEXMLSS - ���������
//  FileName: string    - ��� �����
//RETURN
//      integer - ����� ������ (0 - �� OK)
function ReadXLSX(var XMLSS: TZEXMLSS; FileName: string): integer;
var
  tmpdir: string;
  b: boolean;
  _isCreated: boolean;

begin
  result := 0;
  _isCreated := false;
  try
    _isCreated := ZECreateUniqueTmpDir(ZEGetTempDir(), tmpdir);
    b := ZEZipUnpackAb(FileName, tmpdir);
    if (b) then
      result := ReadXLSXPath(XMLSS, tmpdir)
    else
      result := -1;
  finally
    if (_isCreated) then
      ZEDelTree(tmpdir);
  end;
end; //ReadODFS
