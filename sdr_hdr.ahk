#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn

; VARIABLES

global whitePoint := 220
global blackPoint := 0
global gammaCurve := 2.2

lutFile := EnvGet("TEMP") "\lut.cal"

; FUNCTIONS

LoadCalibrationCurve() {
  createLutFile()
  Run("bin\dispwin.exe " lutFile, , "Hide")
}

ResetCalibrationCurve() {
  FileExist(lutFile) && FileDelete(lutFile)
  Run("bin\dispwin.exe -c", , "Hide")
}

createLutFile() {
  calCurve := "
(
CAL    

DESCRIPTOR "w=" whitePoint " b=" blackPoint " g=" gammaCurve ""
ORIGINATOR "vcgt"
CREATED "Thu Jun 01 01:41:55 2023"
DEVICE_CLASS "DISPLAY"
COLOR_REP "RGB"

NUMBER_OF_FIELDS 4
BEGIN_DATA_FORMAT
RGB_I RGB_R RGB_G RGB_B
END_DATA_FORMAT

NUMBER_OF_SETS 1024
BEGIN_DATA
0.00000000000000	0.00000000000000	0.00000000000000	0.00000000000000
)"


  Loop 1023
{
  b := (A_Index / 1023)
  c := PQ_EOTF(b)
  d := SRGB_INV_EOTF(c, whitePoint, blackPoint)
  e := blackPoint + (whitePoint - blackPoint) * (d ** gammaCurve)
  f := PQ_INV_EOTF(Max(0, e))
  x := f + Min(1, (c / whitePoint)) * (b - f)

  calCurve := calCurve "`n" b "	" x "	" x "	" x
}

calCurve := calCurve "`n" "END_DATA"

FileExist(lutFile) && FileDelete(lutFile)
FileAppend(calCurve, lutFile)
Return
}

m1 := (2610 / 4096) / 4
m2 := (2523 / 4096) * 128
c1 := (3424 / 4096)
c2 := (2413 / 4096) * 32
c3 := (2392 / 4096) * 32

PQ_EOTF(V) {
  x := 10000 * (Max(V ** (1 / m2) - c1, 0) / (c2 - c3 * V ** (1 / m2))) ** (1 / m1)
  return x
}

PQ_INV_EOTF(L) {
  x := ((c1 + c2 * (L / 10000) ** m1) / (1 + c3 * (L / 10000) ** m1)) ** m2
  return x
}

SRGB_INV_EOTF(L, whitePoint, blackPoint) {
  X1 := "0.0404482362771082"
  X2 := "0.00313066844250063"

  x := (L - blackPoint) / (whitePoint - blackPoint)

  If (x > 1) {
  x := 1
} Else If (x < 0) {
  x := 0
} Else If (x <= X2) {
  x := x * 12.92
} Else {
  x := 1.055 * (x ** (1 / 2.4)) - 0.055
}

return x
}

;---------------------------------- HOTKEYS -----------------------------------

!Esc::
{
  ResetCalibrationCurve()
  global whitePoint := 80
  ; global blackLuminance := 0
  ; global gammaCurve := 2.2
  LoadCalibrationCurve()
}
!+1::
{
  ResetCalibrationCurve()
  global whitePoint := 120
  ; global blackLuminance := 0
  ; global gammaCurve := 2.2
  LoadCalibrationCurve()
}
!+2::
{
  ResetCalibrationCurve()
  global whitePoint := 220
  ; global blackLuminance := 0
  ; global gammaCurve := 2.2
  LoadCalibrationCurve()
}
!Delete::
{
  ResetCalibrationCurve()
  global whitePoint := 480
  ; global blackLuminance := 0
  ; global gammaCurve := 2.2
  LoadCalibrationCurve()
}
!+Delete:: ; Alt Shift
{
  ResetCalibrationCurve()
}


#Requires AutoHotkey v2.0
#SingleInstance Force

#include Lib\json.ahk

var := FileRead("hdr_games.json")

; Set up an array of target processes
TargetProcesses := JSON.parse(var)
;TargetProcesses := ["Cyberpunk2077.exe", "b1.exe"]

; Loop to monitor the processes
Loop {
    ; Iterate through the list of target processes
    for Each, Process in TargetProcesses {
        ; Check if the process is running
        if (PID := ProcessExist(Process)) {
            ResetCalibrationCurve()

            ; Wait for the process to close
            ProcessWaitClose(PID)
            LoadCalibrationCurve()
        }
    }
    Sleep(5000)
}