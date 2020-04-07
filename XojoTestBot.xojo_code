#tag Class
Protected Class XojoTestBot
Inherits Application
	#tag Event
		Sub Open()
		  dg_map=new ICC_DG_debug
		  xcn_map=new ICC_XCN_debug
		  
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		Shared dg_map As ICC_DG_debug
	#tag EndProperty

	#tag Property, Flags = &h0
		settings As AVW_settings
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared xcn_map As ICC_XCN_debug
	#tag EndProperty


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
