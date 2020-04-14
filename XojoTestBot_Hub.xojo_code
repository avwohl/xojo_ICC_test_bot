#tag Class
Protected Class XojoTestBot_Hub
Inherits ICC_connection.ICC_Hub
	#tag Method, Flags = &h0
		Sub Constructor(awin as XojoTestBotWindow)
		  win=awin
		  Super.Constructor
		  startup()
		  
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
		  send_line("g")
		  rem send_line("my-handle")
		  rem send_line("my-password")
		  rem may need to be TD to set buffers
		  rem send_line("set tcp_input_size 60000")
		  rem send_line("set tcp_output_size 60000")
		  send_line("set prompt 0")
		  send_line("set gin 0")
		  send_line("set pin 0")
		  send_line("set open 0")
		  send_line("set wrap 0")
		  rem guest can't set a note
		  rem send_line("set 10 Xojo test bot")
		  send_line("set style 13")
		  
		  
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
