program consolespectrum;

///WARNING : if FPC version < 2.7.1 => Do not forget to uncoment {$DEFINE consoleapp} in define.inc !

{$mode objfpc}{$H+}
   {$DEFINE UseCThreads}
uses
{$IFDEF UNIX}
  cthreads, 
  cwstring, {$ENDIF}
  Classes,
  ctypes,
  SysUtils,
  CustApp,
  uos_flat;

type

  { TUOSConsole }

  TuosConsole = class(TCustomApplication)
  private
    procedure ConsolePlay;
  protected
    procedure doRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  res, x, y,z: integer;
  thearray : array of cfloat;
  ordir, opath, SoundFilename, PA_FileName, SF_FileName, MP_FileName: string;
  PlayerIndex1, InputIndex1, OutputIndex1 : integer;
  
  { TuosConsole }

  procedure TuosConsole.ConsolePlay;
  begin
    ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 
 {$IFDEF Windows}
     {$if defined(cpu64)}
    PA_FileName := ordir + 'lib\Windows\64bit\LibPortaudio-64.dll';
    SF_FileName := ordir + 'lib\Windows\64bit\LibSndFile-64.dll';
     {$else}
    PA_FileName := ordir + 'lib\Windows\32bit\LibPortaudio-32.dll';
    SF_FileName := ordir + 'lib\Windows\32bit\LibSndFile-32.dll';
     {$endif}
    SoundFilename := ordir + 'sound\test.ogg';
 {$ENDIF}

     {$if defined(cpu64) and defined(linux) }
    PA_FileName := ordir + 'lib/Linux/64bit/LibPortaudio-64.so';
    SF_FileName := ordir + 'lib/Linux/64bit/LibSndFile-64.so';
    SoundFilename := ordir + 'sound/test.ogg';
   {$ENDIF}
   
   {$if defined(cpu86) and defined(linux)}
    PA_FileName := ordir + 'lib/Linux/32bit/LibPortaudio-32.so';
    SF_FileName := ordir + 'lib/Linux/32bit/LibSndFile-32.so';
   SoundFilename := ordir + 'sound/test.ogg';
 {$ENDIF}
 
  {$if defined(linux) and defined(cpuarm)}
    PA_FileName := ordir + 'lib/Linux/arm_raspberrypi/libportaudio-arm.so';
    SF_FileName := ordir + ordir + 'lib/Linux/arm_raspberrypi/libsndfile-arm.so';
      SoundFilename := ordir + 'sound/test.ogg';
 {$ENDIF}
 
 {$IFDEF freebsd}
    {$if defined(cpu64)}
    PA_FileName := ordir + 'lib/FreeBSD/64bit/libportaudio-64.so';
    SF_FileName := ordir + 'lib/FreeBSD/64bit/libsndfile-64.so';
    {$else}
    PA_FileName := ordir + 'lib/FreeBSD/32bit/libportaudio-32.so';
    SF_FileName := ordir + 'lib/FreeBSD/32bit/libsndfile-32.so';
    {$endif}
    SoundFilename := ordir + 'sound/test.ogg';
 {$ENDIF}

{$IFDEF Darwin}
  {$IFDEF CPU32}
    opath := ordir;
    opath := copy(opath, 1, Pos('/UOS', opath) - 1);
    PA_FileName := opath + '/lib/Mac/32bit/LibPortaudio-32.dylib';
    SF_FileName := opath + '/lib/Mac/32bit/LibSndFile-32.dylib';
    SoundFilename := ordir + '/sound/test.ogg';
    {$ENDIF}
  
   {$IFDEF CPU64}
    opath := ordir;
    opath := copy(opath, 1, Pos('/UOS', opath) - 1);
    PA_FileName := opath + '/lib/Mac/64bit/LibPortaudio-64.dylib';
    SF_FileName := opath + '/lib/Mac/64bit/LibSndFile-64.dylib';
    SoundFilename := ordir + '/sound/test.ogg';
    {$ENDIF}  
 {$ENDIF}
 
 
    // Load the libraries
   // function uos_loadlib(PortAudioFileName, SndFileFileName, Mpg123FileName, Mp4ffFileName, FaadFileName,  opusfilefilename: PChar) : LongInt;

   res := uos_LoadLib(Pchar(PA_FileName), Pchar(SF_FileName), nil, nil, nil, nil) ;
     
    writeln;
    if res = 0 then
     writeln('Libraries are loaded.')
     else
    writeln('Libraries did not load.');

   if res = 0 then begin
    writeln();
  //  writeln('Libraries version: '+ uos_GetInfoLibraries());

    //// Create the player.
    //// PlayerIndex : from 0 to what your computer can do !
    //// If PlayerIndex exists already, it will be overwriten...
    
  PlayerIndex1 := 0;
  
   if uos_CreatePlayer(PlayerIndex1) then
  
  begin
  
    //// add a Input from audio-file with default parameters
    //////////// PlayerIndex : Index of a existing Player
    ////////// FileName : filename of audio file
    //  result : -1 nothing created, otherwise Input Index in array

    InputIndex1 := uos_AddFromFile(PlayerIndex1,(pchar(SoundFilename)));
    
      if InputIndex1 > -1 then
  
    //// add a Output into device with default parameters
    //////////// PlayerIndex : Index of a existing Player
    //  result : -1 nothing created, otherwise Output Index in array
    
   
   OutputIndex1 := uos_AddIntoDevOut(PlayerIndex1, -1, 0.3, -1, -1, -1, -1, -1) ;
    
       
     if OutputIndex1 > -1 then 
    begin

    // Spectrum : create  bandpass filters with alsobuf set to false, how many you want:
     uos_InputAddFilter(PlayerIndex1, InputIndex1, 10000,20000, 1, 3, false, nil);
     uos_InputAddFilter(PlayerIndex1, InputIndex1, 6000,10000, 1, 3, false, nil);
     uos_InputAddFilter(PlayerIndex1, InputIndex1, 4000,6000, 1, 3, false, nil);
     uos_InputAddFilter(PlayerIndex1, InputIndex1, 2500,4000, 1, 3, false, nil);
     uos_InputAddFilter(PlayerIndex1, InputIndex1, 1000,2500, 1, 3, false, nil);
     uos_InputAddFilter(PlayerIndex1, InputIndex1, 700,1000, 1, 3, false, nil);
     uos_InputAddFilter(PlayerIndex1, InputIndex1, 500,700, 1, 3, false, nil);
     uos_InputAddFilter(PlayerIndex1, InputIndex1, 300,500, 1, 3, false, nil);

    /////// everything is ready, here we are, lets play it...
    uos_Play(PlayerIndex1);

    writeln();

// you may, of course, use a player-loop procedure insteed.
   while uos_getstatus(PlayerIndex1) > 0 do
 begin
 sleep(200);
 writeln();
  writeln('GetLevelArray() left|right by band:'); 
// list of left|right levels separed by $ character of each virtual filter:

// writeln(uos_InputFiltersGetLevelString(PlayerIndex1,InputIndex1));
  
 // you may also use uos_InputFiltersGetLevelArray and get a array of float:
 thearray := uos_InputFiltersGetLevelArray(PlayerIndex1,InputIndex1);
 x := 0;
 while x < length(thearray) -1 do
 begin
 writeln('Band' + inttostr(x div 2) + ' = ' + floattostr(thearray[x]) + '|' + floattostr(thearray[x+1]));
  x := x +2;
 end;

 end;
end;
end;

end;
end;

  procedure TuosConsole.doRun;
  begin
    ConsolePlay;
 //   writeln('Press a key to exit...');
 //   readln;
   writeln('');
   writeln('Ciao...');
     uos_free(); // Do not forget this !
    Terminate;   
  end;

constructor TuosConsole.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

var
  Application: TUOSConsole;
begin
  Application := TUOSConsole.Create(nil);
  Application.Title := 'Console Player';
  Application.Run;
  Application.Free;
end.
