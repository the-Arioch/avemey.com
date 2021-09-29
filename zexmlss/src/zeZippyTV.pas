unit zeZippyTV;

// Concocted for an old project using Delphi 5 (C)1999 and
//   some old DCU-only ZipTV component
// ZipTV only can insert on-disk files (not memory streams)
//   and can not override in-zip filenames...
// See TZxFolderInsteadOfZip for a base concept

// This also can serve a base for other on-disk files based packers.

//      *** W A R N I N G ***
// ZipTV library versions i saw have a nasty bug - they IGNORE
//   all the dot-files whatever you do.
// Seems no big deal to generate OpenOffice/LibreOffice documents
//            But XLSX becomes broken!!!
// Required fix into ZipTV sources inside procedure TZxZipTV.DoSaveAndSeal

// AriochThe@gmail.com

interface
uses zeZippy, SysUtils, Classes;

type TZxZipTV = class (TZxZipGen)
  public
    // Implementations should try to create the file for writing
    //    and throw exception if they can not.
    constructor Create(const ZipFile: TFileName); override;
    procedure BeforeDestruction(); override;

  private
    procedure MakeTempStore;

  protected
    FTempPath: string;  // for lazy-init

    procedure DoAbortAndDelete();  override;
    procedure DoSaveAndSeal();  override;

    function MakeAbsPath(const RelativeName: TFileName): TFileName;
    function DoNewStream(const RelativeName: TFileName): TStream; override;


    // Returns True if the stream was flushed and clearance is given to free it.
    // Otherwise is transmitted to the sealed list
    function  DoSealStream(const Data: TStream; const RelName: TFileName): boolean;  override;
  end;

{$IFDEF VER130} // to be moved into compver.h ???
{$Define FilePathsBeforeDelphi7 }
{$EndIf}
{$IFDEF VER140} // Is this also needed in Delphi/BCB 6 ?
{$Define FilePathsBeforeDelphi7 }
{$EndIf}

implementation
uses
  ztvBase, ztvZip {ztvZipTV},
{$IfDef VER130}
  FileCtrl,  // ForceDirectories, etc
{$EndIf}
  Windows,
  zearchhelper;

const
  _FN_outTemp = 'tmpExcel.zip';
  _FN_inDir = 'in_data' + PathDelim;

{ TZxZipTV }

procedure TZxZipTV.BeforeDestruction;
begin
  inherited;

  if FTempPath > '' then
    ZEDelTree(FTempPath);
end;

constructor TZxZipTV.Create(const ZipFile: TFileName);
var fold: string;
begin
  inherited;

  fold := ExtractFileDir(Self.ZipFileName);
  if not ForceDirectories(fold) then
     raise EZxZipGen.Create(EZxFolderCreationFailed + fold);
end;

procedure TZxZipTV.DoAbortAndDelete;
begin
  if FTempPath > '' then begin
    ZEDelTree(FTempPath);
    FTempPath := '';
  end;
end;

function TZxZipTV.DoNewStream(const RelativeName: TFileName): TStream;
var fn: TFileName;
begin
  fn := MakeAbsPath(RelativeName);
  ForceDirectories(ExtractFileDir( fn ));

  Result := TFileStream.Create(fn, fmCreate
{$IfNDef FilePathsBeforeDelphi7 }
     , fmShareExclusive
{$EndIf }
  );
end;

procedure TZxZipTV.DoSaveAndSeal;
var
  Zip: ztvZip.TZip;
  zn: string;
  OK: boolean;
begin
  if '' = FTempPath then
     exit; // EMPTY ! Nothing was ever added !!!

  zn := FTempPath + PathDelim + _FN_outTemp;

  Zip := TZip.Create(nil);
  try
    Zip.ArchiveFile := zn;
    Zip.RecurseDirs := True;

//    .StoredDirNames is declared PROTECTED in TZipCommon
//    and should have been made PUBLIC in TZipTV...
//    ...but in some ZipTV versions it was forgotten.
//    then just comment that out, and rely upon TZipCommon.Create

    Zip.StoredDirNames := sdRelative;

    Zip.Switch := swAdd;
    Zip.DateAttribute := daFileDate;
    Zip.ExcludeSpec.Clear();
    Zip.FileSpec.Clear();

// The line below is intentionally left as compilation error and human warning!
  Bug in ZipTV 6.x / 7.x and probably all others
//    the required file  XLSX\'_rels\.rels' would NEVER be packed!!!
//  Nor any other dot-file.
//  Does not seem to affect OpenDocument format.

// To-Quick-Fix change one line in ZipTV sources
// Find: Procedure TztvFileScan.ScanDir(
// Find: If (String(FindData.cFilename)[1] <> '.') {And (String(FindData.cFilename) <> '..')} Then
// Replace with something like that:
//   var TempFN: string;
//   TempFN := String(FindData.cFilename);
//   If (TempFN <> '.') And (TempFN <> '..') Then

    Zip.FileSpec.Add( MakeAbsPath('*.*') );
    OK := (Zip.Compress() > 0); // flaky? that's from ZipTV demo...
    if not OK then
       raise EZxZipGen.Create(Zip.ClassName + ' failes to create ' + zn);
  finally
    Zip.Destroy;
  end;

  Win32Check(
    CopyFile( PChar(zn), PChar(Self.ZipFileName), False )
  );
end;

function TZxZipTV.DoSealStream(const Data: TStream;
  const RelName: TFileName): boolean;
begin
  Result := True; // data is saved on the go - just free it
end;

function TZxZipTV.MakeAbsPath(const RelativeName: TFileName): TFileName;
begin
  MakeTempStore;

  // zip (even a lib inside Microsoft Excel) uses standard slashes, not DOS/Win bk-slashes
  if '/' = PathDelim
     then Result := RelativeName
     else Result := StringReplace(RelativeName, '/', PathDelim, [rfReplaceAll]);

  Result := FTempPath + PathDelim + _FN_inDir + Result;
end;

procedure TZxZipTV.MakeTempStore;
var fold: string;
begin
  if '' = FTempPath then begin
     fold := ZEGetTempDir;
     if ZECreateUniqueTmpDir(fold, fold) then begin
        if fold[Length(fold)] = PathDelim then
           SetLength(fold, Length(fold) - 1);
        FTempPath := fold;
     end;
  end;

  if '' = FTempPath then
     raise EZxZipGen.Create(EZxFolderCreationFailed + '[tempporary] ' + fold);
end;

initialization
  TZxZipTV.Register();

finalization
  TZxZipTV.UnRegister;

end.
 