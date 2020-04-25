
program simpleplayer_fpGUI;

{$mode objfpc}{$H+}
  {$DEFINE UseCThreads}

uses
  {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, 
  cwstring, {$ENDIF} {$ENDIF}
  SysUtils,
  uos_flat,
  ctypes, 
  Classes,
  fpg_style_chrome_silver_flatmenu,
  fpg_stylemanager,
  fpg_button,
  fpg_widget,
  fpg_label,
  fpg_Editbtn,
  fpg_RadioButton,
  fpg_trackbar,
  fpg_CheckBox,
  fpg_Panel,
  fpg_base,
  fpg_main,
  fpg_form;

type
  TSimpleplayer = class(TfpgForm)
    procedure uos_logo(Sender: TObject);
  private
    {@VFD_HEAD_BEGIN: Simpleplayer}
    Custom1: TfpgWidget;
    Labelport: TfpgLabel;
    btnLoad: TfpgButton;
    FilenameEdit1: TfpgFileNameEdit;
    FilenameEdit2: TfpgFileNameEdit;
    Labelsnf: TfpgLabel;
    Labelmpg: TfpgLabel;
    Labelst11: TfpgLabel;
    FilenameEdit7: TfpgFileNameEdit;
    Labelst111: TfpgLabel;
    FilenameEdit8: TfpgFileNameEdit;
    Labelst11111: TfpgLabel;
    FilenameEdit31: TfpgFileNameEdit;
    Labelst: TfpgLabel;
    FilenameEdit3: TfpgFileNameEdit;
    FilenameEdit5: TfpgFileNameEdit;
    Labelst1: TfpgLabel;
    FilenameEdit6: TfpgFileNameEdit;
    Panel1: TfpgPanel;
    FilenameEdit4: TfpgFileNameEdit;
    btnStart: TfpgButton;
    btnStop: TfpgButton;
    lposition: TfpgLabel;
    Label1: TfpgLabel;
    Llength: TfpgLabel;
    btnpause: TfpgButton;
    btnresume: TfpgButton;
    CheckBox1: TfpgCheckBox;
    RadioButton1: TfpgRadioButton;
    RadioButton2: TfpgRadioButton;
    RadioButton3: TfpgRadioButton;
    Label2: TfpgLabel;
    TrackBar1: TfpgTrackBar;
    TrackBar2: TfpgTrackBar;
    TrackBar3: TfpgTrackBar;
    Label3: TfpgLabel;
    Label4: TfpgLabel;
    Label5: TfpgLabel;
    vuleft: TfpgPanel;
    vuright: TfpgPanel;
    CheckBox2: TfpgCheckBox;
    Label6: TfpgLabel;
    Label7: TfpgLabel;
    TrackBar4: TfpgTrackBar;
    TrackBar5: TfpgTrackBar;
    Button1: TfpgButton;
    chkst2b: TfpgCheckBox;
    chkstereo2mono: TfpgCheckBox;
    {@VFD_HEAD_END: Simpleplayer}
  public
    procedure AfterCreate; override;
    // constructor Create(AOwner: TComponent);
    procedure btnLoadClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnResumeClick(Sender: TObject);
    procedure btnTrackOnClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; const pos: TPoint);
    procedure btnTrackOffClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; const pos: TPoint);
     {$IF (FPC_FULLVERSION >= 20701) or DEFINED(Windows)}
          {$else}
    procedure CustomMsgReceived(var msg: TfpgMessageRec); message MSG_CUSTOM1;
      {$ENDIF}
    procedure ClosePlayer1;
    procedure LoopProcPlayer1;
    procedure ShowPosition;
    procedure ShowLevel;
    procedure changecheck(Sender: TObject);
    procedure VolumeChange(Sender: TObject; pos: integer);
    procedure ChangeStereo2Mono(Sender: TObject);
    procedure ChangePlugSetSoundTouch(Sender: TObject);
    procedure ChangePlugSetbs2b(Sender: TObject);
    procedure TrackChangePlugSetSoundTouch(Sender: TObject; pos: integer);
    procedure ResetPlugClick(Sender: TObject);
  end;

  {@VFD_NEWFORM_DECL}

  {@VFD_NEWFORM_IMPL}

var
  PlayerIndex1: integer;
  ordir, opath: string;
  OutputIndex1, InputIndex1, DSPIndex1, DSPIndex2, PluginIndex1, PluginIndex2, PluginIndex3: integer;
  plugsoundtouch : boolean = false;
  plugbs2b : boolean = false;
  
  procedure TSimpleplayer.btnTrackOnClick(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; const pos: TPoint);
  begin
    TrackBar1.Tag := 1;
   end;
   
   procedure TSimpleplayer.ChangePlugSetBs2b(Sender: TObject);
   begin
   uos_SetPluginBs2b(PlayerIndex1, PluginIndex1, -1, -1, -1, chkst2b.Checked);   
  end;
  
  procedure TSimpleplayer.Changestereo2mono(Sender: TObject);
  begin
    uos_InputSetDSP(PlayerIndex1, InputIndex1, DSPIndex2, chkstereo2mono.Checked); 
  end;

  procedure TSimpleplayer.ChangePlugSetSoundTouch(Sender: TObject);
  var
    tempo, rate: cfloat;
  begin
         if (trim(Pchar(filenameedit5.FileName)) <> '') and fileexists(filenameedit5.FileName) then
  begin
    if 2 - (2 * (TrackBar4.Position / 100)) < 0.3 then
      tempo := 0.3
    else
      tempo := 2 - (2 * (TrackBar4.Position / 100));
    if 2 - (2 * (TrackBar5.Position / 100)) < 0.3 then
      rate := 0.3
    else
      rate := 2 - (2 * (TrackBar5.Position / 100));

    label6.Text := 'Tempo: ' + floattostrf(tempo, ffFixed, 15, 1);
    label7.Text := 'Pitch: ' + floattostrf(rate, ffFixed, 15, 1);

    uos_SetPluginSoundTouch(PlayerIndex1, PluginIndex2, tempo, rate, checkbox2.Checked);
    end;
    
  end;

  procedure TSimpleplayer.ResetPlugClick(Sender: TObject);
  begin
       TrackBar4.Position := 50;
    TrackBar5.Position := 50;
  
      uos_SetPluginSoundTouch(PlayerIndex1, PluginIndex2, 1, 1, checkbox2.Checked);
   
  end;

  procedure TSimpleplayer.TrackChangePlugSetSoundTouch(Sender: TObject; pos: integer);
  begin
       if (trim(Pchar(filenameedit5.FileName)) <> '') and fileexists(filenameedit5.FileName) then
      ChangePlugSetSoundTouch(Sender);
  end;

  procedure TSimpleplayer.btnTrackoffClick(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; const pos: TPoint);
  begin
    uos_InputSeek(PlayerIndex1, InputIndex1, TrackBar1.position);
    TrackBar1.Tag := 0;
  end;

  procedure TSimpleplayer.btnResumeClick(Sender: TObject);
  begin
    uos_RePlay(PlayerIndex1);
    btnStart.Enabled := False;
    btnStop.Enabled := True;
    btnPause.Enabled := True;
    btnresume.Enabled := False;
  end;

  procedure TSimpleplayer.btnPauseClick(Sender: TObject);
  begin
    uos_Pause(PlayerIndex1);
    btnStart.Enabled := False;
    btnStop.Enabled := True;
    btnPause.Enabled := False;
    btnresume.Enabled := True;
    vuLeft.Visible := False;
    vuRight.Visible := False;
    vuright.Height := 0;
    vuleft.Height := 0;
    vuright.UpdateWindowPosition;
    vuLeft.UpdateWindowPosition;
  end;

  procedure TSimpleplayer.changecheck(Sender: TObject);
  begin
      uos_InputSetDSP(PlayerIndex1, InputIndex1, DSPIndex1, checkbox1.Checked);
    
  end;

  procedure TSimpleplayer.VolumeChange(Sender: TObject; pos: integer);
  begin
  
  {
      uos_InputSetDSPVolume(PlayerIndex1, InputIndex1,
        (100 - TrackBar2.position) / 100,
        (100 - TrackBar3.position) / 100, True);
   }
     
    uos_OutputSetDSPVolume(PlayerIndex1, OutputIndex1,
        (100 - TrackBar2.position) / 100,
        (100 - TrackBar3.position) / 100, True);      
  end;

 procedure TSimpleplayer.ShowLevel;
  begin
    vuLeft.Visible := True;
    vuRight.Visible := True;
    if round(uos_InputGetLevelLeft(PlayerIndex1, InputIndex1) * 74) >= 0 then
      vuLeft.Height := round(uos_InputGetLevelLeft(PlayerIndex1, InputIndex1) * 74);
    if round(uos_InputGetLevelRight(PlayerIndex1, InputIndex1) * 74) >= 0 then
      vuRight.Height := round(uos_InputGetLevelRight(PlayerIndex1, InputIndex1) * 74);
    vuLeft.top := 96 - vuLeft.Height;
    vuRight.top := 96 - vuRight.Height;
    vuright.UpdateWindowPosition;
    vuLeft.UpdateWindowPosition;
   // writeln('BPM ' + floattostr(uos_InputGetBPM(PlayerIndex1, InputIndex1)));
  end;

  procedure TSimpleplayer.btnCloseClick(Sender: TObject);
  begin
    if (btnstart.Enabled = False) then
    begin
      uos_stop(PlayerIndex1);
      sleep(100);
    end;
     uos_free();
   end;

  procedure TSimpleplayer.btnLoadClick(Sender: TObject);
var
loadok : boolean = false;
  begin
  ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 
    // Load the libraries
// function uos_loadlib(PortAudioFileName, SndFileFileName, Mpg123FileName, Mp4ffFileName, FaadFileName, opusfileFileName : PChar) : LongInt;

 if uos_LoadLib(Pchar(FilenameEdit1.FileName), Pchar(FilenameEdit2.FileName),
 Pchar(FilenameEdit3.FileName), Pchar(FilenameEdit7.FileName), Pchar(FilenameEdit8.FileName),
  Pchar(FilenameEdit31.FileName)) = 0 then
     begin
      hide;
      loadok := true;
      Height := 208; 
      panel1.height := height;
      panel1.width := width;
      panel1.left := 0;
      panel1.top := 0;
      panel1.visible := true;
      btnStart.Enabled := True;
      btnLoad.Enabled := False;
      FilenameEdit1.ReadOnly := True;
      FilenameEdit2.ReadOnly := True;
      FilenameEdit3.ReadOnly := True;
      FilenameEdit5.ReadOnly := True;
      FilenameEdit6.ReadOnly := True;
      FilenameEdit7.ReadOnly := True;
      FilenameEdit8.ReadOnly := True;
      FilenameEdit31.ReadOnly := True;
      UpdateWindowPosition;
       btnLoad.Text :=
        'PortAudio, SndFile, Mpg123, AAC, Opus libraries are loaded...'
       end else btnLoad.Text :=
        'One or more libraries did not load, check filenames...';
        
        if loadok = true then
        begin
           if ((trim(Pchar(filenameedit5.FileName)) <> '') and fileexists(filenameedit5.FileName))
       then if (uos_LoadPlugin('soundtouch', Pchar(FilenameEdit5.FileName)) = 0)  then
       begin
      plugsoundtouch := true;
          btnLoad.Text :=
        'PortAudio, SndFile, Mpg123, AAC, Opus and Plugin are loaded...';
        end
         else
         begin
         TrackBar4.enabled := false;
       TrackBar5.enabled := false;
       CheckBox2.enabled := false;
       Button1.enabled := false;
       label6.enabled := false;
       label7.enabled := false;
           end;    
          
      if ((trim(Pchar(filenameedit6.FileName)) <> '') and fileexists(filenameedit6.FileName)) 
      then if (uos_LoadPlugin('bs2b', Pchar(FilenameEdit6.FileName)) = 0)
      then plugbs2b := true else chkst2b.enabled := false; 
      
                
      WindowPosition := wpScreenCenter;
      WindowTitle := 'Simple Player.    uos Version ' + inttostr(uos_getversion());
      
       fpgapplication.ProcessMessages;
      sleep(100);
      Show;
    end;
  end;

  procedure TSimpleplayer.ClosePlayer1;
  begin
    radiobutton1.Enabled := True;
    radiobutton2.Enabled := True;
    radiobutton3.Enabled := True;
    vuLeft.Visible := False;
    vuRight.Visible := False;
    vuright.Height := 0;
    vuleft.Height := 0;
    vuright.UpdateWindowPosition;
    vuLeft.UpdateWindowPosition;
    btnStart.Enabled := True;
    btnPause.Enabled := False;
    btnresume.Enabled := False;
    trackbar1.Position := 0;
    lposition.Text := '00:00:00.000';
    fpgapplication.processmessages;
    btnStop.Enabled := False;
  end;

  procedure TSimpleplayer.btnStopClick(Sender: TObject);
  begin
     uos_Stop(PlayerIndex1);
  end;

  ///// example how to do custom dsp
  
  function DSPReverseBefore(var Data: TuosF_Data;var fft: TuosF_FFT): TDArFloat;
  begin
   
    if (Data.position > Data.OutFrames div Data.channels) then
     uos_InputSeek(PlayerIndex1, InputIndex1, Data.position - (Data.OutFrames div Data.channels))
   end;

  function DSPReverseAfter(var Data: TuosF_Data; var fft: TuosF_FFT): TDArFloat;
  var
    x: integer = 0;
    arfl: TDArFloat;

  begin
   if (Data.position > Data.OutFrames div Data.channels) then
   begin
     SetLength(arfl, Data.outframes);
 
        while x < Data.outframes -1  do
          begin
      arfl[x] := Data.Buffer[Data.outframes - x - 1] ;
      arfl[x+1] := Data.Buffer[Data.outframes - x ]  ;
      x := x +2;
          end;
    Result := arfl;
    end else Result := Data.Buffer;
  end;
  
  /// WARNING: This is only to show a DSP effect, it is not the best reverb it exists ;-)
{
  function DSPReverb(Data: TuosF_Data; fft: TuosF_FFT): TDArFloat;
  var
    x: integer = 0;
    arfl: TDArFloat;
  begin
    SetLength(arfl, length(Data.Buffer));
         while x < length(Data.Buffer)   do
          begin
      if x > 10000 then
      begin
        arfl[x] := Data.Buffer[x] + (Data.Buffer[x-10000] / 2);
        arfl[x+1] := Data.Buffer[x+1] + (Data.Buffer[x+1-10000] / 2);
      end else 
     begin
        arfl[x] := Data.Buffer[x] ;
        arfl[x+1] := Data.Buffer[x+1];
      end;
       x := x + 2;
          end;
       Result := arfl;
  end;
}
  
  function DSPStereo2Mono(var Data: TuosF_Data; var fft: TuosF_FFT): TDArFloat;
  var
    x: integer = 0;
    ps: PDArShort;     //////// if input is Int16 format
    pl: PDArLong;      //////// if input is Int32 format
    pf: PDArFloat;     //////// if input is Float32 format
    
    samplef : cFloat;
    samplei : integer;
  begin
   if (Data.channels = 2) then  
  begin
  
   case Data.SampleFormat of
    2:
    begin
      ps := @Data.Buffer;
     while x < Data.OutFrames  do
          begin
        samplei := round((ps^[x] + ps^[x+1])/2);
        ps^[x] := samplei ;
        ps^[x+1] := samplei ;
        x := x + 2;
        end;
     end;
     
    1:
    begin
      pl := @Data.Buffer;
     while x < Data.OutFrames  do
          begin
        samplei := round((pl^[x] + pl^[x+1])/2);   
        pl^[x] := samplei ;
        pl^[x+1] := samplei ;
        x := x + 2;
        end;
     end;
     
    0:
    begin
      pf := @Data.Buffer;
     while x < Data.OutFrames  do
          begin
        samplef := (pf^[x] + pf^[x+1])/2;   
        pf^[x] := samplef ;
        pf^[x+1] := samplef ;
        x := x + 2;
        end;
     end;
        
  
  end;
  Result := Data.Buffer; 
  end 
  else Result := Data.Buffer; 
  end;

  procedure TSimpleplayer.btnStartClick(Sender: TObject);
  var
    samformat: shortint;
    temptime: ttime;
    ho, mi, se, ms: word;
  begin
  
    if radiobutton1.Checked = True then
      samformat := 0;
    if radiobutton2.Checked = True then
      samformat := 1;
    if radiobutton3.Checked = True then
      samformat := 2;

    radiobutton1.Enabled := False;
    radiobutton2.Enabled := False;
    radiobutton3.Enabled := False;
   
   InputIndex1 := -1;
    PlayerIndex1 := 0;
    // PlayerIndex : from 0 to what your computer can do ! (depends of ram, cpu, ...)
    // If PlayerIndex exists already, it will be overwritten...
    
   {$IF (FPC_FULLVERSION >= 20701) or DEFINED(Windows)}
   if uos_CreatePlayer(PlayerIndex1) then
     {$else}
   if uos_CreatePlayer(PlayerIndex1,self) then
    {$endif}
    //// Create the player.
    //// PlayerIndex : from 0 to what your computer can do !
    //// If PlayerIndex exists already, it will be overwriten...
     
     InputIndex1 := uos_AddFromFile(PlayerIndex1, pchar(filenameEdit4.filename), -1, 
     samformat, -1);
    //// add input from audio file with custom parameters
    ////////// FileName : filename of audio file
    //////////// PlayerIndex : Index of a existing Player
    ////////// OutputIndex : OutputIndex of existing Output // -1 : all output, -2: no output, other integer : existing output)
    ////////// SampleFormat : -1 default : Int16 : (0: Float32, 1:Int32, 2:Int16) SampleFormat of Input can be <= SampleFormat float of Output
    //////////// FramesCount : default : -1 (65536 div channels)
    //  result : -1 nothing created, otherwise Input Index in array

    if InputIndex1 > -1 then begin

      // OutputIndex1 := uos_AddIntoDevOut(PlayerIndex1) ;
    //// add a Output into device with default parameters
   
   {$if defined(cpuarm)} // needs lower latency
       OutputIndex1 := uos_AddIntoDevOut(PlayerIndex1, -1, 0.3, uos_InputGetSampleRate(PlayerIndex1, InputIndex1),
     uos_InputGetChannels(PlayerIndex1, InputIndex1), samformat, -1, -1);
       {$else}
       OutputIndex1 := uos_AddIntoDevOut(PlayerIndex1, -1, -1, uos_InputGetSampleRate(PlayerIndex1, InputIndex1),
     uos_InputGetChannels(PlayerIndex1, InputIndex1), samformat, -1, -1);
       {$endif}
   
       //// add a Output into device with custom parameters
    //////////// PlayerIndex : Index of a existing Player
    //////////// Device ( -1 is default Output device )
    //////////// Latency  ( -1 is latency suggested ) )
    //////////// SampleRate : delault : -1 (44100)   /// here default samplerate of input
    //////////// Channels : delault : -1 (2:stereo) (0: no channels, 1:mono, 2:stereo, ...)
    //////////// SampleFormat : -1 default : Int16 : (0: Float32, 1:Int32, 2:Int16)
    //////////// FramesCount : default : -1 (65536)
    //  result : -1 nothing created, otherwise Output Index in array

     uos_InputSetLevelEnable(PlayerIndex1, InputIndex1, 2) ;
     ///// set calculation of level/volume (usefull for showvolume procedure)
                       ///////// set level calculation (default is 0)
                          // 0 => no calcul
                          // 1 => calcul before all DSP procedures.
                          // 2 => calcul after all DSP procedures.
                          // 3 => calcul before and after all DSP procedures.

      uos_InputSetPositionEnable(PlayerIndex1, InputIndex1, 1) ;
     ///// set calculation of position (usefull for positions procedure)
                       ///////// set position calculation (default is 0)
                          // 0 => no calcul
                          // 1 => calcul position.

      uos_LoopProcIn(PlayerIndex1, InputIndex1, @LoopProcPlayer1);
    ///// Assign the procedure of object to execute inside the loop
    //////////// PlayerIndex : Index of a existing Player
    //////////// InputIndex1 : Index of a existing Input
    //////////// LoopProcPlayer1 : procedure of object to execute inside the loop

 
   uos_OutputAddDSPVolume(PlayerIndex1, OutputIndex1, 1, 1);
    ///// DSP Volume changer
    ////////// PlayerIndex1 : Index of a existing Player
    ////////// OutputIndex1 : Index of a existing output
    ////////// VolLeft : Left volume
    ////////// VolRight : Right volume
 
     uos_OutputSetDSPVolume(PlayerIndex1, OutputIndex1,
      (100 - TrackBar2.position) / 100,
      (100 - TrackBar3.position) / 100, True);
    /// Set volume
    ////////// PlayerIndex1 : Index of a existing Player
    ////////// OutputIndex1 : InputIndex of a existing Output
    ////////// VolLeft : Left volume
    ////////// VolRight : Right volume
    ////////// Enable : Enabled
  
  DSPIndex1 := uos_InputAddDSP(PlayerIndex1, InputIndex1, @DSPReverseBefore,
    @DSPReverseAfter, nil, nil);
      ///// add a custom DSP procedure for input
    ////////// PlayerIndex1 : Index of a existing Player
    ////////// InputIndex1: InputIndex of existing input
    ////////// BeforeFunc : function to do before the buffer is filled
    ////////// AfterFunc : function to do after the buffer is filled
    ////////// EndedFunc : function to do at end of thread
    ////////// LoopProc : external procedure to do after the buffer is filled
   
   //// set the parameters of custom DSP
   uos_InputSetDSP(PlayerIndex1, InputIndex1, DSPIndex1, checkbox1.Checked);
     
   // This is a other custom DSP...stereo to mono  to show how to do a DSP ;-)  
 DSPIndex2 := uos_InputAddDSP(PlayerIndex1, InputIndex1, nil, @DSPStereo2Mono, nil, nil);
 uos_InputSetDSP(PlayerIndex1, InputIndex1, DSPIndex2, chkstereo2mono.checked); 
   
   ///// add bs2b plugin with samplerate_of_input1 / default channels (2 = stereo)
  if plugbs2b = true then
  begin
  PlugInIndex1 := uos_AddPlugin(PlayerIndex1, 'bs2b',
  uos_InputGetSampleRate(PlayerIndex1, InputIndex1) , -1);
  uos_SetPluginbs2b(PlayerIndex1, PluginIndex1, -1 , -1, -1, chkst2b.checked);
  end; 
  
   if plugsoundtouch = true then
  begin
  {
 PluginIndex3 := uos_AddPlugin(PlayerIndex1, 'getbpm', 
  uos_InputGetSampleRate(PlayerIndex1, InputIndex1) , -1);
  uos_SetPluginGetBPM(PlayerIndex1, PluginIndex3, 20, true, checkbox2.Checked);
  }
   /// add SoundTouch plugin with samplerate of input1 / default channels (2 = stereo)
  /// SoundTouch plugin should be the last added.
   PlugInIndex2 := uos_AddPlugin(PlayerIndex1, 'soundtouch', 
   uos_InputGetSampleRate(PlayerIndex1, InputIndex1) , -1);
   ChangePlugSetSoundTouch(self); //// custom procedure to Change plugin settings

   end;    
         
   trackbar1.Max := uos_InputLength(PlayerIndex1, InputIndex1);
   
   ////// Length of Input in samples

   temptime := uos_InputLengthTime(PlayerIndex1, InputIndex1);
    ////// Length of input in time

    DecodeTime(temptime, ho, mi, se, ms);
    
    llength.Text := format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);

    /////// procedure to execute when stream is terminated
    uos_EndProc(PlayerIndex1, @ClosePlayer1);
    ///// Assign the procedure of object to execute at end
    //////////// PlayerIndex : Index of a existing Player
    //////////// ClosePlayer1 : procedure of object to execute inside the general loop

    TrackBar1.position := 0;
    trackbar1.Enabled := True;
    CheckBox1.Enabled := True;
    
    btnStop.Enabled := True;
    btnpause.Enabled := True;
    btnresume.Enabled := False;
       
    uos_Play(PlayerIndex1);  /////// everything is ready, here we are, lets play it...
  
    end;
    
  end;

  procedure TSimpleplayer.ShowPosition;
  var
    temptime: ttime;
    ho, mi, se, ms: word;
  begin
    if (TrackBar1.Tag = 0) then
    begin
      if uos_InputPosition(PlayerIndex1, InputIndex1) > 0 then
      begin
        TrackBar1.Position := uos_InputPosition(PlayerIndex1, InputIndex1);
        temptime := uos_InputPositionTime(PlayerIndex1, InputIndex1);
        ////// Length of input in time
        DecodeTime(temptime, ho, mi, se, ms);
        lposition.Text := format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);
      end;
    end;
  end;

   {$IF (FPC_FULLVERSION >= 20701) or DEFINED(Windows)}
      {$else}
  procedure TSimpleplayer.CustomMsgReceived(var msg: TfpgMessageRec);
  begin
    ShowLevel;
    ShowPosition ;
    end;

      {$ENDIF}

procedure TSimpleplayer.LoopProcPlayer1;
begin
 ShowPosition;
 ShowLevel ;
end;

  procedure TSimpleplayer.AfterCreate;
  begin
    {%region 'Auto-generated GUI code' -fold}


    {@VFD_BODY_BEGIN: Simpleplayer}
  Name := 'Simpleplayer';
  SetPosition(593, 132, 513, 364);
  WindowTitle := 'Simple player ';
  IconName := '';
  BackGroundColor := $80000001;
  Sizeable := False;
  Hint := '';
  WindowPosition := wpScreenCenter;
  Ondestroy := @btnCloseClick;

  Custom1 := TfpgWidget.Create(self);
  with Custom1 do
  begin
    Name := 'Custom1';
    SetPosition(10, 16, 115, 307);
    OnPaint := @uos_logo;
  end;

  Labelport := TfpgLabel.Create(self);
  with Labelport do
  begin
    Name := 'Labelport';
    SetPosition(136, -4, 320, 15);
    Alignment := taCenter;
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Folder + filename of PortAudio Library';
    Hint := '';
  end;

  btnLoad := TfpgButton.Create(self);
  with btnLoad do
  begin
    Name := 'btnLoad';
    SetPosition(8, 334, 488, 24);
    Text := 'Load that libraries';
    FontDesc := '#Label1';
    ImageName := '';
    ParentShowHint := False;
    TabOrder := 0;
    Hint := '';
    onclick := @btnLoadClick;
  end;

  FilenameEdit1 := TfpgFileNameEdit.Create(self);
  with FilenameEdit1 do
  begin
    Name := 'FilenameEdit1';
    SetPosition(136, 12, 356, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 3;
  end;

  FilenameEdit2 := TfpgFileNameEdit.Create(self);
  with FilenameEdit2 do
  begin
    Name := 'FilenameEdit2';
    SetPosition(136, 52, 356, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 4;
  end;

  Labelsnf := TfpgLabel.Create(self);
  with Labelsnf do
  begin
    Name := 'Labelsnf';
    SetPosition(140, 36, 316, 15);
    Alignment := taCenter;
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Folder + filename of SndFile Library';
    Hint := '';
  end;

  Labelmpg := TfpgLabel.Create(self);
  with Labelmpg do
  begin
    Name := 'Labelmpg';
    SetPosition(136, 76, 316, 15);
    Alignment := taCenter;
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Folder + filename of Mpg123 Library';
    Hint := '';
  end;

  Labelst11 := TfpgLabel.Create(self);
  with Labelst11 do
  begin
    Name := 'Labelst11';
    SetPosition(136, 116, 316, 15);
    Alignment := taCenter;
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Folder + filename of mp4ff Library';
  end;

  FilenameEdit7 := TfpgFileNameEdit.Create(self);
  with FilenameEdit7 do
  begin
    Name := 'FilenameEdit7';
    SetPosition(136, 132, 356, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 44;
  end;

  Labelst111 := TfpgLabel.Create(self);
  with Labelst111 do
  begin
    Name := 'Labelst111';
    SetPosition(138, 156, 316, 15);
    Alignment := taCenter;
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Folder + filename of Faad Library';
  end;

  FilenameEdit8 := TfpgFileNameEdit.Create(self);
  with FilenameEdit8 do
  begin
    Name := 'FilenameEdit8';
    SetPosition(136, 172, 356, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 46;
  end;

  Labelst11111 := TfpgLabel.Create(self);
  with Labelst11111 do
  begin
    Name := 'Labelst11111';
    SetPosition(176, 196, 292, 15);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Folder + filename of OpusFile Library';
  end;

  FilenameEdit31 := TfpgFileNameEdit.Create(self);
  with FilenameEdit31 do
  begin
    Name := 'FilenameEdit31';
    SetPosition(136, 213, 356, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 49;
  end;

  Labelst := TfpgLabel.Create(self);
  with Labelst do
  begin
    Name := 'Labelst';
    SetPosition(152, 240, 316, 15);
    Alignment := taCenter;
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Folder + filename of SoundTouch plugin Library';
    Hint := '';
  end;

  FilenameEdit3 := TfpgFileNameEdit.Create(self);
  with FilenameEdit3 do
  begin
    Name := 'FilenameEdit3';
    SetPosition(136, 92, 356, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 12;
  end;

  FilenameEdit5 := TfpgFileNameEdit.Create(self);
  with FilenameEdit5 do
  begin
    Name := 'FilenameEdit5';
    SetPosition(136, 256, 356, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 12;
  end;

  Labelst1 := TfpgLabel.Create(self);
  with Labelst1 do
  begin
    Name := 'Labelst1';
    SetPosition(142, 284, 316, 15);
    Alignment := taCenter;
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Folder + filename of bs2b plugin Library';
  end;

  FilenameEdit6 := TfpgFileNameEdit.Create(self);
  with FilenameEdit6 do
  begin
    Name := 'FilenameEdit6';
    SetPosition(136, 300, 356, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 40;
  end;

  Panel1 := TfpgPanel.Create(self);
  with Panel1 do
  begin
    Name := 'Panel1';
    SetPosition(4, 396, 512, 208);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := '';
    Visible := False;
    Hint := '';
  end;

  FilenameEdit4 := TfpgFileNameEdit.Create(Panel1);
  with FilenameEdit4 do
  begin
    Name := 'FilenameEdit4';
    SetPosition(140, 12, 360, 24);
    ExtraHint := '';
    FileName := '';
    Filter := '';
    InitialDir := '';
    TabOrder := 5;
  end;

  btnStart := TfpgButton.Create(Panel1);
  with btnStart do
  begin
    Name := 'btnStart';
    SetPosition(152, 176, 66, 23);
    Text := 'Play';
    Enabled := False;
    FontDesc := '#Label1';
    ImageName := '';
    ParentShowHint := False;
    TabOrder := 6;
    Hint := '';
    onclick := @btnstartClick;
  end;

  btnStop := TfpgButton.Create(Panel1);
  with btnStop do
  begin
    Name := 'btnStop';
    SetPosition(380, 176, 66, 23);
    Text := 'Stop';
    Enabled := False;
    FontDesc := '#Label1';
    ImageName := '';
    ParentShowHint := False;
    TabOrder := 7;
    Hint := '';
    onclick := @btnStopClick;
  end;

  lposition := TfpgLabel.Create(Panel1);
  with lposition do
  begin
    Name := 'lposition';
    SetPosition(232, 69, 84, 19);
    Alignment := taCenter;
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label2';
    ParentShowHint := False;
    Text := '00:00:00.000';
    Hint := '';
  end;

  Label1 := TfpgLabel.Create(Panel1);
  with Label1 do
  begin
    Name := 'Label1';
    SetPosition(316, 69, 12, 15);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := '/';
    Hint := '';
  end;

  Llength := TfpgLabel.Create(Panel1);
  with Llength do
  begin
    Name := 'Llength';
    SetPosition(324, 69, 80, 15);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label2';
    ParentShowHint := False;
    Text := '00:00:00.000';
    Hint := '';
  end;

  btnpause := TfpgButton.Create(Panel1);
  with btnpause do
  begin
    Name := 'btnpause';
    SetPosition(228, 176, 66, 23);
    Text := 'Pause';
    Enabled := False;
    FontDesc := '#Label1';
    ImageName := '';
    ParentShowHint := False;
    TabOrder := 15;
    Hint := '';
    onclick := @btnPauseClick;
  end;

  btnresume := TfpgButton.Create(Panel1);
  with btnresume do
  begin
    Name := 'btnresume';
    SetPosition(304, 176, 66, 23);
    Text := 'Resume';
    Enabled := False;
    FontDesc := '#Label1';
    ImageName := '';
    ParentShowHint := False;
    TabOrder := 16;
    Hint := '';
    onclick := @btnResumeClick;
  end;

  CheckBox1 := TfpgCheckBox.Create(Panel1);
  with CheckBox1 do
  begin
    Name := 'CheckBox1';
    SetPosition(144, 148, 104, 19);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    TabOrder := 17;
    Text := 'Play Reverse';
    Hint := '';
    onchange := @changecheck;
  end;

  RadioButton1 := TfpgRadioButton.Create(Panel1);
  with RadioButton1 do
  begin
    Name := 'RadioButton1';
    SetPosition(24, 140, 96, 19);
    BackgroundColor := TfpgColor($68A7D3A8);
    Checked := True;
    FontDesc := '#Label1';
    GroupIndex := 0;
    ParentShowHint := False;
    TabOrder := 18;
    Text := 'Float 32 bit';
    Hint := '';
  end;

  RadioButton2 := TfpgRadioButton.Create(Panel1);
  with RadioButton2 do
  begin
    Name := 'RadioButton2';
    SetPosition(24, 156, 100, 19);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    GroupIndex := 0;
    ParentShowHint := False;
    TabOrder := 19;
    Text := 'Int 32 bit';
    Hint := '';
  end;

  RadioButton3 := TfpgRadioButton.Create(Panel1);
  with RadioButton3 do
  begin
    Name := 'RadioButton3';
    SetPosition(24, 174, 100, 19);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    GroupIndex := 0;
    ParentShowHint := False;
    TabOrder := 20;
    Text := 'Int 16 bit';
    Hint := '';
  end;

  Label2 := TfpgLabel.Create(Panel1);
  with Label2 do
  begin
    Name := 'Label2';
    SetPosition(24, 124, 104, 15);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label2';
    ParentShowHint := False;
    Text := 'Sample format';
    Hint := '';
  end;

  TrackBar1 := TfpgTrackBar.Create(Panel1);
  with TrackBar1 do
  begin
    Name := 'TrackBar1';
    SetPosition(140, 40, 356, 30);
    BackgroundColor := TfpgColor($68A7D3A8);
    ParentShowHint := False;
    TabOrder := 22;
    Hint := '';
    TrackBar1.OnMouseDown := @btntrackonClick;
    TrackBar1.OnMouseUp := @btntrackoffClick;
  end;

  TrackBar2 := TfpgTrackBar.Create(Panel1);
  with TrackBar2 do
  begin
    Name := 'TrackBar2';
    SetPosition(20, 20, 32, 78);
    BackgroundColor := TfpgColor($68A7D3A8);
    Orientation := orVertical;
    ParentShowHint := False;
    TabOrder := 23;
    Hint := '';
    OnChange := @volumechange;
  end;

  TrackBar3 := TfpgTrackBar.Create(Panel1);
  with TrackBar3 do
  begin
    Name := 'TrackBar3';
    SetPosition(88, 20, 28, 78);
    BackgroundColor := TfpgColor($68A7D3A8);
    Orientation := orVertical;
    ParentShowHint := False;
    TabOrder := 24;
    Hint := '';
    OnChange := @volumechange;
  end;

  Label3 := TfpgLabel.Create(Panel1);
  with Label3 do
  begin
    Name := 'Label3';
    SetPosition(28, 4, 84, 15);
    Alignment := taCenter;
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label2';
    ParentShowHint := False;
    Text := 'Volume';
    Hint := '';
  end;

  Label4 := TfpgLabel.Create(Panel1);
  with Label4 do
  begin
    Name := 'Label4';
    SetPosition(20, 100, 40, 15);
    Alignment := taCenter;
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Left';
    Hint := '';
  end;

  Label5 := TfpgLabel.Create(Panel1);
  with Label5 do
  begin
    Name := 'Label5';
    SetPosition(84, 100, 36, 19);
    Alignment := taCenter;
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Right';
    Hint := '';
  end;

  vuleft := TfpgPanel.Create(Panel1);
  with vuleft do
  begin
    Name := 'vuleft';
    SetPosition(56, 24, 8, 74);
    BackgroundColor := TfpgColor($00D51D);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Style := bsFlat;
    Text := '';
    Hint := '';
  end;

  vuright := TfpgPanel.Create(Panel1);
  with vuright do
  begin
    Name := 'vuright';
    SetPosition(76, 24, 8, 74);
    BackgroundColor := TfpgColor($1DD523);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Style := bsFlat;
    Text := '';
    Hint := '';
  end;

  CheckBox2 := TfpgCheckBox.Create(Panel1);
  with CheckBox2 do
  begin
    Name := 'CheckBox2';
    SetPosition(292, 92, 184, 19);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    TabOrder := 32;
    Text := 'Enable SoundTouch PlugIn';
    Hint := 'Change Tempo with same tuning or change Tuning with same tempo';
    OnChange := @ChangePlugSetSoundTouch;
  end;

  Label6 := TfpgLabel.Create(Panel1);
  with Label6 do
  begin
    Name := 'Label6';
    SetPosition(284, 112, 80, 19);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Tempo: 1.0';
    Hint := '';
  end;

  Label7 := TfpgLabel.Create(Panel1);
  with Label7 do
  begin
    Name := 'Label7';
    SetPosition(396, 112, 68, 15);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    Text := 'Pitch: 1.0';
    Hint := '';
  end;

  TrackBar4 := TfpgTrackBar.Create(Panel1);
  with TrackBar4 do
  begin
    Name := 'TrackBar4';
    SetPosition(360, 112, 28, 54);
    BackgroundColor := TfpgColor($68A7D3A8);
    Orientation := orVertical;
    ParentShowHint := False;
    Position := 50;
    TabOrder := 35;
    Hint := '';
    OnChange := @TrackChangePlugSetSoundTouch;
  end;

  TrackBar5 := TfpgTrackBar.Create(Panel1);
  with TrackBar5 do
  begin
    Name := 'TrackBar5';
    SetPosition(456, 112, 28, 54);
    BackgroundColor := TfpgColor($68A7D3A8);
    Orientation := orVertical;
    ParentShowHint := False;
    Position := 50;
    TabOrder := 36;
    Hint := '';
    OnChange := @TrackChangePlugSetSoundTouch;
  end;

  Button1 := TfpgButton.Create(Panel1);
  with Button1 do
  begin
    Name := 'Button1';
    SetPosition(288, 140, 60, 23);
    Text := 'Reset';
    FontDesc := '#Label1';
    ImageName := '';
    ParentShowHint := False;
    TabOrder := 37;
    Hint := '';
    OnClick := @ResetPlugClick;
  end;

  chkst2b := TfpgCheckBox.Create(Panel1);
  with chkst2b do
  begin
    Name := 'chkst2b';
    SetPosition(144, 120, 136, 19);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    TabOrder := 38;
    Text := 'Stereo to BinAural';
    Hint := 'Stereo to BinAural (for headphones)';
    OnChange := @ChangePlugSetBs2b;
  end;

  chkstereo2mono := TfpgCheckBox.Create(Panel1);
  with chkstereo2mono do
  begin
    Name := 'chkstereo2mono';
    SetPosition(144, 88, 120, 19);
    BackgroundColor := TfpgColor($68A7D3A8);
    FontDesc := '#Label1';
    ParentShowHint := False;
    TabOrder := 42;
    Text := 'Stereo to Mono';
    Hint := 'Convert Stereo to Mono';
    OnChange := @Changestereo2mono;
  end;

  {@VFD_BODY_END: Simpleplayer}
    {%endregion}

    //////////////////////

    ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
    RadioButton1.Checked := True;
    height := 364;
             {$IFDEF Windows}
     {$if defined(cpu64)}
    FilenameEdit1.FileName := ordir + 'lib\Windows\64bit\LibPortaudio-64.dll';
    FilenameEdit2.FileName := ordir + 'lib\Windows\64bit\LibSndFile-64.dll';
    FilenameEdit3.FileName := ordir + 'lib\Windows\64bit\LibMpg123-64.dll';
    FilenameEdit5.FileName := ordir + 'lib\Windows\64bit\plugin\LibSoundTouch-64.dll';
{$else}
    FilenameEdit1.FileName := ordir + 'lib\Windows\32bit\LibPortaudio-32.dll';
    FilenameEdit2.FileName := ordir + 'lib\Windows\32bit\LibSndFile-32.dll';
    FilenameEdit3.FileName := ordir + 'lib\Windows\32bit\LibMpg123-32.dll';
    FilenameEdit7.FileName := ordir + 'lib\Windows\32bit\LibMp4ff-32.dll';
    FilenameEdit8.FileName := ordir + 'lib\Windows\32bit\LibFaad2-32.dll';
   
    FilenameEdit31.FileName := ordir + 'lib\Windows\32bit\LibOpusFile-32.dll';
    
    FilenameEdit5.FileName := ordir + 'lib\Windows\32bit\plugin\libSoundTouch-32.dll';
   
   // problem with windows10 when closing application
   // FilenameEdit6.FileName := ordir + 'lib\Windows\32bit\plugin\LibBs2b-32.dll';
    
  {$endif}
    FilenameEdit4.FileName := ordir + 'sound\test.ogg';
 {$ENDIF}

  {$IFDEF Darwin}
   {$IFDEF CPU32}
    opath := ordir;
    opath := copy(opath, 1, Pos('/uos', opath) - 1);
    FilenameEdit1.FileName := opath + '/lib/Mac/32bit/LibPortaudio-32.dylib';
    FilenameEdit2.FileName := opath + '/lib/Mac/32bit/LibSndFile-32.dylib';
    FilenameEdit3.FileName := opath + '/lib/Mac/32bit/LibMpg123-32.dylib';
    FilenameEdit5.FileName := opath + '/lib/Mac/32bit/plugin/libSoundTouch-32.dylib';
    FilenameEdit4.FileName := opath + 'sound/test.ogg';
    {$ENDIF}
    {$IFDEF CPU64}
    opath := ordir;
    opath := copy(opath, 1, Pos('/uos', opath) - 1);
    FilenameEdit1.FileName := opath + '/lib/Mac/64bit/LibPortaudio-64.dylib';
    FilenameEdit2.FileName := opath + '/lib/Mac/64bit/LibSndFile-64.dylib';
    FilenameEdit3.FileName := opath + '/lib/Mac/64bit/LibMpg123-64.dylib';
    FilenameEdit4.FileName := opath + 'sound/test.ogg';
    {$ENDIF}
   {$ENDIF}

     {$if defined(cpu64) and defined(linux) }
    FilenameEdit1.FileName := ordir + 'lib/Linux/64bit/LibPortaudio-64.so';
    FilenameEdit2.FileName := ordir + 'lib/Linux/64bit/LibSndFile-64.so';
    FilenameEdit3.FileName := ordir + 'lib/Linux/64bit/LibMpg123-64.so';
    FilenameEdit7.FileName := ordir + 'lib/Linux/64bit/LibMp4ff-64.so';
    FilenameEdit8.FileName := ordir + 'lib/Linux/64bit/LibFaad2-64.so';
    
    FilenameEdit31.FileName := ordir + 'lib/Linux/64bit/LibOpusFile-64.so';
    
    FilenameEdit5.FileName := ordir + 'lib/Linux/64bit/plugin/LibSoundTouch-64.so';
    FilenameEdit6.FileName := ordir + 'lib/Linux/64bit/plugin/libbs2b-64.so';
    FilenameEdit4.FileName := ordir + 'sound/test.ogg'; 
 {$ENDIF}

    {$if defined(cpu32) and defined(linux) and not defined(cpuarm)}
    FilenameEdit1.FileName := ordir + 'lib/Linux/32bit/LibPortaudio-32.so';
    FilenameEdit2.FileName := ordir + 'lib/Linux/32bit/LibSndFile-32.so';
    FilenameEdit3.FileName := ordir + 'lib/Linux/32bit/LibMpg123-32.so';
    FilenameEdit7.FileName := ordir + 'lib/Linux/32bit/LibMp4ff-32.so';
    FilenameEdit8.FileName := ordir + 'lib/Linux/32bit/LibFaad2-32.so';
    
    FilenameEdit5.FileName := ordir + 'lib/Linux/32bit/plugin/LibSoundTouch-32.so';
    FilenameEdit6.FileName := ordir + 'lib/Linux/32bit/plugin/libbs2b-32.so';
     FilenameEdit4.FileName := ordir + 'sound/test.ogg';
   {$ENDIF}
   
    {$if defined(linux) and defined(cpuarm)}
    FilenameEdit1.FileName := ordir + 'lib/Linux/arm_raspberrypi/libportaudio-arm.so';
    FilenameEdit2.FileName := ordir + 'lib/Linux/arm_raspberrypi/libsndfile-arm.so';
    FilenameEdit3.FileName := ordir + 'lib/Linux/arm_raspberrypi/libmpg123-arm.so';
    FilenameEdit3.FileName := ordir + 'lib/Linux/arm_raspberrypi/plugin/soundtouch-arm.so';
    FilenameEdit4.FileName := ordir + 'sound/test.ogg';
   {$ENDIF}

  {$IFDEF freebsd}
    {$if defined(cpu64)}
    FilenameEdit1.FileName := ordir + 'lib/FreeBSD/64bit/libportaudio-64.so';
     FilenameEdit2.FileName := ordir + 'lib/FreeBSD/64bit/libsndfile-64.so';
    FilenameEdit3.FileName := ordir + 'lib/FreeBSD/64bit/libmpg123-64.so';
   FilenameEdit5.FileName := ordir + 'lib/FreeBSD/64bit/plugin/libsoundtouch-64.so';
    FilenameEdit7.FileName := ordir + 'lib/FreeBSD/64bit/libmp4ff-64.so';
    FilenameEdit8.FileName := ordir + 'lib/FreeBSD/64bit/libfaad2-64.so';
    
    // To play opus file you should copy uos/examples/lib/FreeBSD/64bit/libopus.so and paste into /usr/local/lib.    
    FilenameEdit31.FileName := ordir + 'lib/FreeBSD/64bit/libopusfile-64.so';
    
    FilenameEdit6.FileName := ordir + 'lib/FreeBSD/64bit/plugin/libbs2b-64.so';
    {$else}
    FilenameEdit1.FileName := ordir + 'lib/FreeBSD/32bit/libportaudio-32.so';
    FilenameEdit2.FileName := ordir + 'lib/FreeBSD/32bit/libsndfile-32.so';
    FilenameEdit3.FileName := ordir + 'lib/FreeBSD/32bit/libmpg123-32.so';
    FilenameEdit5.FileName := '';
{$endif}
    FilenameEdit4.FileName := ordir + 'sound/test.ogg';
{$ENDIF}
    FilenameEdit4.Initialdir := ordir + 'sound';
    FilenameEdit1.Initialdir := ordir + 'lib';
    FilenameEdit2.Initialdir := ordir + 'lib';
    FilenameEdit3.Initialdir := ordir + 'lib';
    FilenameEdit5.Initialdir := ordir + 'lib';
    vuLeft.Visible := False;
    vuRight.Visible := False;
    vuLeft.Height := 0;
    vuRight.Height := 0;
    vuright.UpdatewindowPosition;
    vuLeft.UpdatewindowPosition;

  end;

  procedure TSimpleplayer.uos_logo(Sender: TObject);
   begin
     with Custom1 do
    begin
      Canvas.GradientFill(GetClientRect, clgreen, clBlack, gdVertical);
      Canvas.TextColor := clWhite;
      Canvas.DrawText(60, 20, 'uos');
    end;
  end;

  procedure MainProc;
  var
    frm: TSimpleplayer;
  begin
     fpgApplication.Initialize;
     if fpgStyleManager.SetStyle('Chrome silver flat menu') then
          fpgStyle := fpgStyleManager.Style;
    fpgApplication.CreateForm(TSimpleplayer, frm);
    try
     frm.Show;
     fpgApplication.Run;
    finally
      uos_free;
      frm.Free;
    end;
  end;

begin
  MainProc;
end.
