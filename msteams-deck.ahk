#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

TeamsClick(offsetFromRightEdge, offsetFromTopEdge:=74) {
		; click somewhere within Teams window
		WinGetPos, X, Y, Width, Height, ahk_exe Teams.exe
		XClickPos := Width-offsetFromRightEdge ; offset from the right edge
		YClickPos := offsetFromTopEdge ; offset from the top edge
		MouseGetPos, XPos, YPos ; preserve mouse position
		MouseClick Left, %XClickPos%, %YClickPos% ; click on the raise hand icon
		MouseMove %XPos%, %YPos%, 0 ; restore mouse pointer position
}

TeamsActivate() {
		; activate Teams window if needed
		IfWinNotActive, ahk_exe Teams.exe
		{
			WinActivate ahk_exe Teams.exe
			Sleep, 250 ; 1/4s delay so that mouse clicks work
		}
}

; statements for Teams.exe active only when Teams is running
#IfWinExist ahk_exe Teams.exe

	;	ENTER -> mute/unmute (toggle)
	NumpadEnter::
		TeamsActivate()
		Send ^+M
	return

	;	0/Insert -> raise hand (no matter if NumLock on or off
	NumpadIns::
	Numpad0::
		TeamsActivate()
		TeamsClick(415) ; offset to hand icon
	return

	;	1/End -> participants
	Numpad1::
	NumpadEnd::
		TeamsActivate()
		TeamsClick(505) ; offset to people icon
	return

	;	2/Down -> chat
	Numpad2::
	NumpadDown::
		TeamsActivate()
		TeamsClick(456) ; offset to chat icon
	return

	;	3/PgDown -> share screen
	Numpad3::
	NumpadPgDn::
		TeamsActivate()
		TeamsClick(192) ; share screen icon
	return

	;	./Del -> push to talk (toggle mute button on key press and key release, assuming that mic is muted by default)
	NumpadDot::
	NumpadDel::
		TeamsActivate()
		Send ^+M
		KeyWait, NumpadDot
		KeyWait, NumpadDel
		Send ^+M
	return

	;	/ -> camera on/off
	NumpadDiv::
		TeamsActivate()
		Send ^+O
	return

	;	+ -> volume up
	NumpadAdd::
		SoundSet +5
	return

	;	- -> volume down
	NumpadSub::
		SoundSet -5
	return

	;	* -> volume mute/unmute
	NumpadMult::
		SoundSet +1, , mute
	return

	; 4/5/6/7/8/9/*/NumLock unused

; sort of endif
#IfWinExist
