
{$T-}

// ���� �� ������������ ZColorStringGrid 
{$DEFINE NOZCOLORSTRINGGRID}

// Free Pascal / Lazarus
{$IFDEF FPC}
  //��� FPC ���� ���� ZColorStringGrid-�
  {$DEFINE NOZCOLORSTRINGGRID}
  //���� ����� ������������ ������ ������������� LConvEncoding.pas
  {$DEFINE USELCONVENCODING}
{$ELSE}
  {$UNDEF USELCONVENCODING}
{$ENDIF}