#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; preload images for matching
chatIcon := LoadPicture("chat.png")
handIcon := LoadPicture("hand.png")
handRaisedIcon := LoadPicture("hand-raised.png")
participantsIcon := LoadPicture("participants.png")
chatIconHi := LoadPicture("chat-hires.png")
handIconHi := LoadPicture("hand-hires.png")
handRaisedIconHi := LoadPicture("hand-raised-hires.png")
participantsIconHi := LoadPicture("participants-hires.png")

CoordMode Pixel, Window  ; Interprets the coordinates below as relative to the screen rather than the active window.

TeamsMouseClick(FoundX, FoundY) {
		MouseGetPos, XPos, YPos ; preserve mouse position
		MouseClick Left, %FoundX%, %FoundY% ; click on the raise hand icon
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
		WinGetPos, X, Y, Width, Height, ahk_exe Teams.exe
		ImageSearch, FoundX, FoundY, 0, 0, %Width%, %Height%, *64 HBITMAP:*%handIcon%
		if (ErrorLevel = 0) {
			TeamsMouseClick(FoundX, FoundY)
			return
		}
		ImageSearch, FoundX, FoundY, 0, 0, %Width%, %Height%, *64 HBITMAP:*%handRaisedIcon%
		if (ErrorLevel = 0) {
			TeamsMouseClick(FoundX, FoundY)
			return
		}
		ImageSearch, FoundX, FoundY, 0, 0, %Width%, %Height%, *64 HBITMAP:*%handIconHi%
		if (ErrorLevel = 0) {
			TeamsMouseClick(FoundX, FoundY)
			return
		}
		ImageSearch, FoundX, FoundY, 0, 0, %Width%, %Height%, *64 HBITMAP:*%handRaisedIconHi%
		if (ErrorLevel = 0) {
			TeamsMouseClick(FoundX, FoundY)
			return
		}
	return

	;	1/End -> participants
	Numpad1::
	NumpadEnd::
		TeamsActivate()
		WinGetPos, X, Y, Width, Height, ahk_exe Teams.exe
		ImageSearch, FoundX, FoundY, 0, 0, %Width%, %Height%, *64 HBITMAP:*%participantsIcon%
		if (ErrorLevel = 0) {
			TeamsMouseClick(FoundX, FoundY)
			return
		}
		ImageSearch, FoundX, FoundY, 0, 0, %Width%, %Height%, *64 HBITMAP:*%participantsIconHi%
		if (ErrorLevel = 0) {
			TeamsMouseClick(FoundX, FoundY)
			return
		}
	return

	;	2/Down -> chat
	Numpad2::
	NumpadDown::
		TeamsActivate()
		WinGetPos, X, Y, Width, Height, ahk_exe Teams.exe
		ImageSearch, FoundX, FoundY, 0, 0, %Width%, %Height%, *64 HBITMAP:*%chatIcon%
		if (ErrorLevel = 0) {
			TeamsMouseClick(FoundX, FoundY)
			return
		}
		ImageSearch, FoundX, FoundY, 0, 0, %Width%, %Height%, *64 HBITMAP:*%chatIconHi%
		if (ErrorLevel = 0) {
			TeamsMouseClick(FoundX, FoundY)
			return
		}
	return

	;	3/PgDown -> share screen
	Numpad3::
	NumpadPgDn::
		TeamsActivate()
		Send ^+E
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
		SoundSet +10
	return

	;	- -> volume down
	NumpadSub::
		SoundSet -10
	return

	;	* -> volume mute/unmute
	NumpadMult::
		SoundSet +1, , mute
	return

	; 4/5/6/7/8/9/*/NumLock unused

; sort of endif
#IfWinExist
