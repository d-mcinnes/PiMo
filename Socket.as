package {
	import flash.debug.Debug;
	import flash.net.Socket;
	import flash.events.*;
	
	public class Socket {
		private var socket:Socket;
		
		public function Socket() {
			this.socket = new Socket();
			Security.allowDomain("*");

			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(Event.CLOSE, onClose);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onResponse);
			
			socket.connect("hejp.co.uk", 80);
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
				Debug.debugMessage(socket.readUTFBytes(socket.bytesAvailable));
			}
		}
	}
}