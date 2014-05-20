/*
* The Bluetooth Adapter component. Receives from and sends to remote
* device. Data is passed to the app by registering is a listener to this
* class, which will fire an onBluetoothKeyDown event, unless the user was
* prompted for text entry, in which case it will fire a onTextEntered event
*/
class BluetoothSocket
{
	private static var s_sock:XMLSocket;
	private static var s_listeners:Array;
	// correspond to variables in navigation.py
	// NOTE: IF THE VALS ARE CHANGED HERE, THEY MUST ALSO
	// BE CHANGED THERE!
	private static var s_endMarker:String = "@"
	private static var s_noAction:String = "noAction"
	private static var s_delim:String = "#"
	private static var s_prefixText:String = "text"
	private static var s_prefixNav:String = "nav"
	private static var s_cancel:String = "cancel"
	
	public function BluetoothSocket() {}
	
	static function init() 
	{
		s_listeners = new Array();
		Key.addListener(BluetoothSocket);
		
		
		s_sock = new XMLSocket();
		s_sock.onConnect = function(success) {
			if (success) {
				trace("sock Connected");
			} else {
				trace("sock NOT connected");
			}
		}
		s_sock.onClose = function() {
			trace("sock Closed");
		}
		s_sock.onData = function (msg) {
			var t_msgArr = msg.split(s_delim);
			var msgType = t_msgArr[0];
			var msgData = t_msgArr[1];
			
			trace("sock recieved type: " + msgType + " ,data: " + msgData );
			// navigational operation
			if (msgType == s_prefixNav)
			{
				msgData = int(msgData);
				fireKeyDown(msgData);
			}
			// text submitted
			else if (msgType == s_prefixText)
			{
				fireTextReceived(msgData);
			}
			else if (msgType == s_cancel)
			{
				fireCancel();
			}
		}
		s_sock.connect("localhost", 5331);
	}
	
	static function addListener(listener:Object)
	{
		s_listeners[s_listeners.length] = listener;
		//trace("adding socket listener: " + listener + ", array is now " + s_listeners);
	}
	
	static function removeListener(listener:Object)
	{
		var t_listener;
		for (var i = 0; i < s_listeners.length; i++) 
			{
				t_listener = s_listeners[i];
				if (listener == t_listener) {
					s_listeners.splice(i,1);
					trace("removing socket listener, array now is " + s_listeners);
					break;
				}
				
			}
	}
	
	static function close()
	{
		s_sock.close();
	}
	
	static function onKeyDown()
	{
		fireKeyDown(Key.getCode());
	}
	
	static function fireKeyDown(keyCode:Number)
	{
		trace("fireKeyDown: keyCode = " + keyCode);
		var listener:Object;
		for (var i = 0; i < s_listeners.length; i++) 
		{
			listener = s_listeners[i];
			listener.onBluetoothKeyDown(keyCode);
		}
	}
	
	static function fireTextReceived(txt:String)
	{
		trace("fireTextReceived: keyCode = " + txt);
		var listener:Object;
		for (var i = 0; i < s_listeners.length; i++) 
		{
			listener = s_listeners[i];
			listener.onTextEntered(txt);
		}
	}
	
	static function fireCancel()
	{
		//trace("fireTextCancel: keyCode = " + txt);
		var listener:Object;
		for (var i = 0; i < s_listeners.length; i++) 
		{
			listener = s_listeners[i];
			listener.fireCancel();
		}
	}

	// ask user to enter text on the remote device
	static function getTextInput(prompt:String)
	{
		s_sock.send(prompt + s_endMarker);
	}
	
	// tell remote device to stop listening for further action
	// after a key was pressed... basically an ack with no further request
	static function noAction()
	{
		s_sock.send(s_noAction + s_endMarker);
	}

}