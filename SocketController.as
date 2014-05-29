package {
	import flash.debug.Debug;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.system.Security;
	
	public class SocketController {
		private var socket:Socket;
		
		public function SocketController() {
			this.socket = new Socket();
			Security.allowDomain("*");

			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(Event.CLOSE, onClose);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onResponse);
			
			socket.connect("hejp.co.uk", 80);
			
			Debug.debugMessage("Socket Started");
		}
		
		private function onConnect(e:Event) {
			socket.writeUTFBytes("GET / HTTP/1.1\n");
			socket.writeUTFBytes("Host: hejp.co.uk\n");
			socket.writeUTFBytes("\n");
		}
		
		private function onClose(e:Event) {
			socket.close();
		}
		
		private function onError(e:IOErrorEvent) {
			Debug.debugMessage("IO Error: " + e.toString());
		}
		
		private function onSecError(e:SecurityErrorEvent) {
			Debug.debugMessage("Sec Error: " + e.toString());
		}
		
		private function onResponse(e:ProgressEvent) {
			if(socket.bytesAvailable > 0) {
				Debug.debugMessage("	Socket Output: " + socket.readUTFBytes(socket.bytesAvailable));
				//GameController.getInstance().activateTag(this.processInput(socket.readUTFBytes(socket.bytesAvailable)));
			}
		}
		
		private function processInput(input:String):String {
			return "";
		}
	}
}