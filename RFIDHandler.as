package  {
	
	import com.phidgets.*;
	import com.phidgets.events.*;
	import flash.events.MouseEvent;
	
	public class RFIDHandler {
		
		private var rfid:PhidgetRFID;
		
		//TODO move this stuff into GameController later
		public function RFIDHandler() {
			var rfid:PhidgetRFID = new PhidgetRFID();
			
			rfid.addEventListener(PhidgetEvent.DETACH,	onDetach);
			rfid.addEventListener(PhidgetEvent.ATTACH,	onAttach);
			rfid.addEventListener(PhidgetErrorEvent.ERROR, onError);
			rfid.addEventListener(PhidgetDataEvent.TAG, onTag);
			rfid.addEventListener(PhidgetDataEvent.TAG_LOST, onTagLoss);
			
			rfid.open("localhost", 5001);
		}
		
		function onError(evt:PhidgetErrorEvent):void {
			trace(evt);
		}
		
		function onAttach(evt:PhidgetEvent):void{
			trace(evt);
			rfid.Antenna = true;
			rfid.LED = true;
			//Phidgetstatus.text = rfid.Type + " Attached";
		}
		
		function onDetach(evt:PhidgetEvent):void{
			trace(evt);
			//Phidgetstatus.text = rfid.Type + " Detached";
		}
		
		function onTag(evt:PhidgetDataEvent):void{
			trace(evt);
			//Tagoutput.text = evt.Data;
		}
		function onTagLoss(evt:PhidgetDataEvent):void{
			trace(evt);
			//Tagoutput.text = "";
		}
		
	}
	
}
