unit formAutoSize;

interface
uses
SysUtils,Windows,Classes,Graphics, Controls,Forms,Dialogs,typinfo;

Const   //记录设计时的屏幕分辨率
 // OriWidth=1366;
 // OriHeight=768;
    OriWidth=1666;
  OriHeight=1268;
Type
  TfmForm=Class(TForm)   //实现窗体屏幕分辨率的自动调整
  Private
    fScrResolutionRateW: Double;
    fScrResolutionRateH: Double;
    fIsFitDeviceDone: Boolean;
    fPosition:Array of TRect;
    procedure FitDeviceResolution;
  Protected
    Property IsFitDeviceDone:Boolean Read fIsFitDeviceDone;
    Property ScrResolutionRateH:Double Read fScrResolutionRateH;
    Property ScrResolutionRateW:Double Read fScrResolutionRateW;
  Public
    Constructor Create(AOwner: TComponent); Override;
  End;

 
  //{
  TfdForm=Class(TfmForm)   //增加对话框窗体的修改确认
  Protected
    fIsDlgChange:Boolean;
  Public
  Constructor Create(AOwner: TComponent); Override;
  Property IsDlgChange:Boolean Read fIsDlgChange default false;
 End; // }

implementation

Constructor TfmForm.Create(AOwner: TComponent);
begin
 Inherited Create(AOwner);
  fScrResolutionRateH:=1;
  fScrResolutionRateW:=1;
  Try
    if Not fIsFitDeviceDone then
    Begin
      FitDeviceResolution;
   fIsFitDeviceDone:=True;
    End;
  Except
  fIsFitDeviceDone:=False;
  End;
end;

function PropertyExists(const AObject : TObject;const APropName : string):Boolean;
begin
   Result := Assigned(GetPropInfo(AObject.ClassInfo,APropName));
end;

procedure TfmForm.FitDeviceResolution;
Var
  i:Integer;
  LocList:TList;
  LocFontSize:Integer;
  LocFont:TFont;
  LocCmp:TComponent;
  LocFontRate:Double;
  LocRect:TRect;
  LocCtl:TControl;
begin
  LocList:=TList.Create;
  Try
    Try
      if (Screen.width<>OriWidth)OR(Screen.Height<>OriHeight) then
      begin
        Self.Scaled:=False;
        fScrResolutionRateH:=screen.height/OriHeight;
        fScrResolutionRateW:=screen.Width/OriWidth;
        Try
          if fScrResolutionRateH<fScrResolutionRateW then
            LocFontRate:=fScrResolutionRateH
          Else
            LocFontRate:=fScrResolutionRateW;
        Finally
          ReleaseDC(0, GetDc(0));
        End;

        For i:=Self.ComponentCount-1 Downto 0 Do
        Begin
          LocCmp:=Self.Components[i];
          If LocCmp Is TControl Then
            LocList.Add(LocCmp);
          If PropertyExists(LocCmp,'FONT') Then
          Begin
            LocFont:=TFont(GetPropInfo(LocCmp,'FONT'));
            LocFontSize := Round(LocFontRate*LocFont.Size);
            LocFont.Size:=LocFontSize;
          End;
        End;

        SetLength(fPosition,LocList.Count+1);
        For i:=0 to LocList.Count-1 Do
          With TControl(LocList.Items[i])Do
            fPosition[i+1]:=BoundsRect;
        fPosition[0]:=Self.BoundsRect;

        With LocRect Do
        begin
           Left:=Round(fPosition[0].Left*fScrResolutionRateW);
           Right:=Round(fPosition[0].Right*fScrResolutionRateW);
           Top:=Round(fPosition[0].Top*fScrResolutionRateH);
           Bottom:=Round(fPosition[0].Bottom*fScrResolutionRateH);
           Self.SetBounds(Left,Top,Right-Left,Bottom-Top);
        end;

        i:= LocList.Count-1;
        While (i>=0) Do
         Begin
          LocCtl:=TControl(LocList.Items[i]);
          If LocCtl.Align=alClient Then
          begin
            Dec(i);
            Continue;
          end;
          With LocRect Do
          begin
             Left:=Round(fPosition[i+1].Left*fScrResolutionRateW);
             Right:=Round(fPosition[i+1].Right*fScrResolutionRateW);
             Top:=Round(fPosition[i+1].Top*fScrResolutionRateH);
             Bottom:=Round(fPosition[i+1].Bottom*fScrResolutionRateH);
             LocCtl.SetBounds(Left,Top,Right-Left,Bottom-Top);
          end;
          Dec(i);
        End;
      End;

    Except on E:Exception Do
      Raise Exception.Create('进行屏幕分辨率自适应调整时出现错误'+E.Message);
    End;
  Finally
    LocList.Free;
  End;
end;

constructor TfdForm.Create(AOwner: TComponent);
begin
  inherited;
  fIsDlgChange:=False;
end;

end.
