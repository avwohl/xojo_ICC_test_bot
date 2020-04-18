#tag Class
Protected Class XojoTestBot_Hub
Inherits ICC_connection.ICC_Hub
Implements AVW_util.outputer
	#tag Method, Flags = &h0
		Sub Constructor(awin as XojoTestBotWindow)
		  win=awin
		  settings=New AVW_settings_module.AVW_settings
		  // add all the known settings here
		  // if a setting in this list is missing it will throw an error in the check
		  settings.define("event_sleep_ms")
		  settings.define("ask_icc_every_seconds")
		  settings.define("chess_startup")
		  settings.define("debug_data_from_uci")
		  settings.define("debug_data_to_icc")
		  settings.define("debug_data_to_uci")
		  settings.define("debug_print")
		  settings.define("die_if_no_icc_response_seconds")
		  settings.define("tcp_input_size")
		  settings.define("tcp_output_size")
		  settings.define("icc_hostname")
		  settings.define("icc_port")
		  settings.define("password")
		  settings.define("user")
		  
		  settings.read_file(Self,"test_cfg/test_bot.cfg")
		  // report missing settings now at startup
		  // rather than much later while running
		  settings.check
		  Super.Constructor
		  startup
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub debug_print(atxt as text)
		  rem as windows closes don't throw an exception printing debug stuff
		  if win=nil then
		    return
		  end if
		  win.debug_print(atxt)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function jam(jam_code as integer, jam_text as text) As Boolean
		  // Calling the overridden superclass method.
		  dim result as boolean = Super.jam(jam_code,jam_text)
		  dim jam_str as text = Str(jam_code).ToText
		  dim space_string as string = " "
		  dim jam_out as text = jam_text + space_string.ToText + jam_str
		  debug_print(jam_out)
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NetEventDataReceived()
		  debug_print_string("DataReceived event")
		  super.NetEventDataReceived
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NetEventError(err as RuntimeException)
		  rem err doesn't seem to have any data to print
		  #pragma Unused err
		  debug_print("NetEventError a RuntimeException")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NetEventSendCompleted(userAborted as Boolean)
		  #pragma Unused userAborted
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NetEventSendProgressed(bytesSent as Integer, bytesLeft as Integer) As Boolean
		  #pragma Unused bytesSent
		  #pragma Unused bytesLeft
		  rem return false to keep going true to quit sending
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub outs(outme as string)
		  // Part of the AVW_util.outputer interface.
		  
		  debug_print(outme.totext)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub parse_failed(atext as text)
		  debug_print("parse failed error="+atext)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub print_dg(description as string, dg_name as text, a_dg as ICC_connection.ICC_datagram)
		  dim result as text
		  result=AVW_util.to_text(description)+AVW_util.to_text(" ")+dg_name
		  if a_dg.ntokens> 0 then
		    for i as integer=0 to a_dg.ntokens
		      result=result+AVW_util.to_text(" '")+a_dg.tokens(i)+AVW_util.to_text("'")
		    next i
		  end if
		  debug_print(result)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub recieve_L1(a_dg As ICC_connection.ICC_datagram)
		  Dim dg_name_text As Text = xcn_map.get_datagram_name(a_dg.nums(0))
		  print_dg("L1",dg_name_text,a_dg)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function recieve_L2(a_dg as ICC_connection.ICC_datagram) As boolean
		  
		  If Super.recieve_l2(a_dg) Then
		    Return True
		  End If
		  rem if this program enables dgs the library doesn't handle yet parse them here
		  rem still unhandled
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function recieve_text(atxt as text) As boolean
		  if not logged_in then
		    send_login
		    logged_in = true
		  end if
		  debug_print("received text outside a DG ["+atxt+"]")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub send_login()
		  send_line("level1=1")
		  send_line("level2settings="+login_L2_settings)
		  send_line(settings.get_string("user"))
		  Var password As String=settings.get_string("password")
		  // guest login doesn't need a password, no password represented as a zero len string
		  If password.length>0 Then
		    send_line(password)
		  End If
		  Var tcp_input_size As String=settings.get_string("tcp_input_size")
		  Var tcp_output_size As String=settings.get_string("tcp_output_size")
		  // may need to be TD to set these
		  If tcp_input_size.length>0 Then
		    send_line("set tcp_input_size "+tcp_input_size)
		  End If
		  If tcp_output_size.length>0 Then
		    send_line("set tcp_output_size "+tcp_output_size)
		  End If
		  
		  send_line(settings.get_string("chess_startup"))
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub shutdown()
		  // Calling the overridden superclass method.
		  Super.shutdown()
		  win.user_name.Value=AVW_util.to_text("")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub startup()
		  // Calling the overridden superclass method.
		  Super.startup()
		  
		  setup_L2 (ICC_connection.ICC_DG.DG_WHO_AM_I)
		  setup_L2 (ICC_connection.ICC_DG.DG_CHANNEL_TELL)
		  setup_L2 (ICC_connection.ICC_DG.DG_PERSONAL_TELL)
		  setup_L2 (ICC_connection.ICC_DG.DG_SHOUT)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		win As XojotestBotWindow
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="logged_in"
			Visible=false
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="login_L2_settings"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="update_next_keep_alive_ticks_time"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
