unit zeUnzi;

interface
uses SysUtils, Classes;

type
  iuzFile = interface;
  iuzFolder = interface;

  iuzElement = interface
     function IsFile: boolean;
     function IsFolder: boolean;
     function IsRoot: boolean; // only if folder

     function Name: TFileName;
     function PathName: TFileName;

     function Parent: iuzFolder;
     function Root: iuzFolder;
  end;

  iuzFile = interface(iuzElement)
     function Size: integer;
     function Data: TStream;
  end;

  iuzFolder = interface(iuzElement)
     function FoldersCount: integer;
     function Folder(const No: integer): iuzFolder;

     function FilesCount: integer;
     function Files(const No: integer): iuzFile;

     function ElementsCount: integer;
     function Element(const No: integer): iuzElement;

     function ByName(const ElemName: TFileName): iuzElement;
     function ByPath(const ElemName: TFileName): iuzElement;
     function FileByName(const ElemName: TFileName): iuzFile;
     function FileByPath(const ElemName: TFileName): iuzFile;
  end;

implementation

end.
