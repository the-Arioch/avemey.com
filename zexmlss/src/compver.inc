{$DEFINE UNKNOWN_COMPILER}

{$IFDEF FPC} //KO: FPC
  {$UNDEF UNKNOWN_COMPILER}
  //Directive deprecated with string msg (deprecated 'Use "some else"';)
  //  works in FPC and D>=2009.
  {$DEFINE USE_DEPRECATED_STRING}
{$ENDIF}

/// ******DELPHI*********

{$IFDEF VER80} //delphi 1
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER90} //delphi 2
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER100} //delphi 3
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER120} //delphi 4
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER130} //delphi 5
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER140} //delphi 6
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER150} //delphi 7
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER160} //delphi 8
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER170} //delphi 9 (2005)
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER180} //delphi 10 (BDS2006)
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER185} //delphi 11 (2007)
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER190} // Delphi 2007 for .NET
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

/// ******Cbuilder*********

{$IFDEF VER93} //cbuilder1
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER110} //cbuilder 3
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF VER125} //cbuilder 4
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

/// ****** Delphi unicode *********

{$IFDEF VER200} // RAD Studio 2009
  {$UNDEF UNKNOWN_COMPILER}
  {$DEFINE DELPHI_UNICODE}
{$ENDIF VER200}

{$IFDEF VER210} // RAD Studio 2010
  {$UNDEF UNKNOWN_COMPILER}
  {$DEFINE DELPHI_UNICODE}
{$ENDIF VER210}

{$IFDEF VER220} // RAD Studio XE
  {$UNDEF UNKNOWN_COMPILER}
  {$DEFINE DELPHI_UNICODE}
{$ENDIF VER220}

{$IFDEF VER230} // RAD Studio XE2 
  {$UNDEF UNKNOWN_COMPILER}
  {$DEFINE DELPHI_UNICODE}
{$ENDIF VER230}

{$IFDEF UNKNOWN_COMPILER} // > XE2 
  {$DEFINE DELPHI_UNICODE}
  {$UNDEF UNKNOWN_COMPILER}
{$ENDIF}

{$IFDEF DELPHI_UNICODE}
  {$DEFINE USE_DEPRECATED_STRING}
{$ENDIF}

{ $DEFINE DELPHI_UNICODE}
