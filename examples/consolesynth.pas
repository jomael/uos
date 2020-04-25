program consolesynth;

///WARNING : if FPC version < 2.7.1 => Do not forget to uncoment {$DEFINE consoleapp} in define.inc !

{$mode objfpc}{$H+}
   {$DEFINE UseCThreads}
uses
{$IFDEF UNIX}
  cthreads, 
 {$ENDIF}
  Classes,
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
  res: integer;
  ordir, opath, PA_FileName: string;
  PlayerIndex1, inindex1 : integer;
  
  { TuosConsole }

  procedure TuosConsole.ConsolePlay;
  begin
    ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 
 {$IFDEF Windows}
     {$if defined(cpu64)}
    PA_FileName := ordir + 'lib\Windows\64bit\LibPortaudio-64.dll';
     {$else}
    PA_FileName := ordir + 'lib\Windows\32bit\LibPortaudio-32.dll';
     {$endif}
 {$ENDIF}

  {$if defined(cpu64) and  defined(linux) }
    PA_FileName := ordir + 'lib/Linux/64bit/LibPortaudio-64.so';
  {$ENDIF}
   
  {$if defined(cpu86) and defined(linux)}
    PA_FileName := ordir + 'lib/Linux/32bit/LibPortaudio-32.so';
  {$ENDIF}
 
  {$if defined(linux) and defined(cpuarm)}
    PA_FileName := ordir + 'lib/Linux/arm_raspberrypi/libportaudio-arm.so';
  {$ENDIF}

 {$IFDEF freebsd}
    {$if defined(cpu64)}
    PA_FileName := ordir + 'lib/FreeBSD/64bit/libportaudio-64.so';
    {$else}
    PA_FileName := ordir + 'lib/FreeBSD/32bit/libportaudio-32.so';
    {$endif}
  {$ENDIF}

 {$IFDEF Darwin}
  {$IFDEF CPU32}
    opath := ordir;
    opath := copy(opath, 1, Pos('/UOS', opath) - 1);
    PA_FileName := opath + '/lib/Mac/32bit/LibPortaudio-32.dylib';
    {$ENDIF}
  
   {$IFDEF CPU64}
    opath := ordir;
    opath := copy(opath, 1, Pos('/UOS', opath) - 1);
    PA_FileName := opath + '/lib/Mac/64bit/LibPortaudio-64.dylib';
    {$ENDIF}  
 {$ENDIF}
  
    // Load the libraries (here only portaudio is needed)
    // function uos_loadlib(PortAudioFileName, SndFileFileName, Mpg123FileName, Mp4ffFileName, FaadFileName, opusfilefilename:: PChar) : LongInt;

   res := uos_LoadLib(Pchar(PA_FileName), nil, nil, nil, nil, nil) ;

    writeln('Result of loading (if 0 => ok ) : ' + IntToStr(res));
    
    writeln((uos_getinfolibraries()));

   if res = 0 then begin

    //// Create the player.
    //// PlayerIndex : from 0 to what your computer can do !
    //// If PlayerIndex exists already, it will be overwriten...
  
   PlayerIndex1 := 0;
   inindex1 := -1;
   
   if uos_CreatePlayer(PlayerIndex1) then

    inindex1 := uos_AddFromSynth(PlayerIndex1,420,-1,-1, 0, -1, 0, -1, -1 );  
      
   // Add a input from Synthesizer with custom parameters
  // Frequency : default : -1 (440 htz)
  // VolumeL : default : -1 (= 1) (from 0 to 1) => volume left
  // VolumeR : default : -1 (= 1) (from 0 to 1) => volume right
  // Duration : default :  -1 (= 1000)  => duration in msec (0 = endless)
  // OutputIndex : Output index of used output// -1: all output, -2: no output, other cint32 refer to a existing OutputIndex  (if multi-output then OutName = name of each output separeted by ';')
  // SampleFormat : default : -1 (0: Float32) (0: Float32, 1:Int32, 2:Int16)
  // SampleRate : delault : -1 (44100)
  // FramesCount : -1 default : 1024
  //  result :  Input Index in array  -1 = error
  // example : InputIndex1 := AddFromSynth(0,880,-1,-1,-1,-1,-1,-1);
   
 if inindex1 > -1 then
 
 
    {$if defined(cpuarm)} // needs lower latency
        if uos_AddIntoDevOut(PlayerIndex1,-1,0.3,-1,-1, 0,-1,-1) > - 1 then
       {$else}
        if uos_AddIntoDevOut(PlayerIndex1,-1,-1,-1,-1, 0,-1, -1) > - 1 then
       
       {$endif}
    //// add a Output into device with custom parameters
    //////////// PlayerIndex : Index of a existing Player
    //  result : -1 nothing created, otherwise Output Index in array

  begin 
 /////// everything is ready, here we are, lets play it...
    
    uos_Play(PlayerIndex1);

      sleep(150) ;
    
   uos_InputSetSynth(PlayerIndex1,inindex1, 880, -1,-1, -1,true);
       ////////// Frequency : in Hertz (-1 = do not change)
     ////////// VolumeL :  from 0 to 1 (-1 = do not change)
     ////////// VolumeR :  from 0 to 1 (-1 = do not change)
     // Duration : duration in msec (-1 = do not change)
     //////////// Enabled : true or false ;
     //{
    sleep(175) ;
     uos_InputSetSynth(PlayerIndex1,inindex1, 610, 0.2,1, -1, true);
      sleep(300) ;
     uos_InputSetSynth(PlayerIndex1,inindex1, la1, 1,0.2, -1,true);
    sleep(150) ;
    uos_InputSetSynth(PlayerIndex1,inindex1, 440, 0.2,1, -1 ,true);
     sleep(300) ; 
     uos_InputSetSynth(PlayerIndex1,inindex1, 320,1,0.2, -1,true);
     sleep(150) ; 
     uos_InputSetSynth(PlayerIndex1,inindex1, 660, 0.2,1, -1, true);
     sleep(300) ; 
     uos_InputSetSynth(PlayerIndex1,inindex1, la3, 1,0.2, -1, true);
     //}
    {      
     uos_InputSetSynth(PlayerIndex1,inindex1, 884, 1, 1, -1, true);
          sleep(2000); 
       uos_InputSetSynth(PlayerIndex1,inindex1, 889,1,1, -1,true);
     sleep(2000) ; 
     uos_InputSetSynth(PlayerIndex1,inindex1, 884, 1,1, -1, true);
     sleep(2000) ; 
     uos_InputSetSynth(PlayerIndex1,inindex1, 889, 1,1, 1, true);
    // } 
    
        sleep(1500);
      uos_stop(PlayerIndex1);
  
   end;
   end;

 end;

  procedure TuosConsole.doRun;
  begin
    ConsolePlay;
    uos_free;
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
  Application.Title := 'Console Synthesizer';
  Application.Run;
  Application.Free;
end.   
