package  {
	
	import com.phidgets.*;
	import com.phidgets.events.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/***
	 * Class for handling two RFID readers at once (i.e. for two gloves).
	 * Reference: https://www.phidgets.com/phorum/viewtopic.php?f=10&t=4866
	 */
	public class RFIDReaderDouble {
		
		//instance of the game controller
		private var gc:GameController;
		
		//instances of the rfid reader
		private var rfid1:PhidgetRFID;
		private var rfid2:PhidgetRFID;
		
		//switch interval
		private var rfid1Interval;
		private var rfid2Interval;
		private var defaultInterval:int = 500;
		
		/**
		 * Initialises the connection to the RFID reader.
		 */
		public function RFIDReaderDouble(gc:GameController) {
			this.gc = gc;
			
			this.rfid1 = new PhidgetRFID();
			this.rfid2 = new PhidgetRFID();
			
			rfid1.addEventListener(PhidgetEvent.ATTACH, rfid2OnAttach);
			rfid1.addEventListener(PhidgetEvent.DETACH, onDetach);
			rfid1.addEventListener(PhidgetErrorEvent.ERROR, onError);
			rfid1.addEventListener(PhidgetDataEvent.TAG, onTag);
			rfid1.addEventListener(PhidgetDataEvent.TAG_LOST, onTagLoss);
			rfid1.open("localhost", 5001, 18115);
			
			rfid2.addEventListener(PhidgetEvent.ATTACH, rfid1OnAttach);
			rfid2.addEventListener(PhidgetEvent.DETACH, onDetach);
			rfid2.addEventListener(PhidgetErrorEvent.ERROR, onError);
			rfid2.addEventListener(PhidgetDataEvent.TAG, onTag);
			rfid2.addEventListener(PhidgetDataEvent.TAG_LOST, onTagLoss);
			rfid2.open("localhost", 5001, ???); //TODO needs id
			
			//there is a brief delay before we can access the readers
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			timer.start();
		}
		
		private function timerListener(e:TimerEvent):void {
			rfid1On();
		}
		
		public function rfidStop():void {
			clearInterval(rfid1Interval);
			clearInterval(rfid2Interval);
			rfid1.Antenna = false;
			rfid1.LED = false;
			rfid2.Antenna = false;
			rfid2.LED = false;
			trace("Both RFIDs have been stopped.");
		}
		
		private function rfid1On():void {
			rfid1.Antenna = true;
			rfid1.LED = true;
			trace("RFID1 is on.");
			rfid1Interval = setInterval(rfid1off, defaultInterval);
		}
		
		private function rfid1off():void {
			rfid1.Antenna = false;
			rfid1.LED = false;
			trace("RFID1 is off.");
			clearInterval(rfid1Interval);
			rfid2On();
		}
		
		private function rfid2On():void {
			rfid2.Antenna = true;
			rfid2.LED = true;
			trace("RFID2 is active.");
			rfid2Interval = setInterval(rfid2off, defaultInterval);
		}
		
		private function rfid2Off():void {
			rfid2.Antenna = false;
			rfid2.LED = false;
			trace("RFID2 is inactive.");
			clearInterval(rfid2Interval);
			rfid1On();
		}
		
		private function rfid1OnAttach(evt:PhidgetEvent):void {
			trace("rfid1OnAttach");
			trace(evt);
		
			trace("Phidgetstatus: " + rfid1.Name);	
			trace("Serialnumber: " + rfid1.serialNumber);
			trace("Version: " + rfid1.Version);
			trace("Outputs: " +  rfid1.OutputCount);
		}
		
		private function rfid2OnAttach(evt:PhidgetEvent):void {
			trace("rfid2OnAttach");
			trace(evt);
		
			trace("Phidgetstatus: " + rfid2.Name);	
			trace("Serialnumber: " + rfid2.serialNumber);
			trace("Version: " + rfid2.Version);
			trace("Outputs: " +  rfid2.OutputCount);
		}
		
		private function onDetach(evt:PhidgetEvent):void {
			trace("onDetach");
			trace(evt);
		}
		
		private function onError(evt:PhidgetErrorEvent):void {
			trace("onError");
			trace(evt);
		}
		
		private function onTag(evt:PhidgetDataEvent):void {
			trace("onTag: " + String(evt.Data));
		}
		
		private function onTagLoss(evt:PhidgetDataEvent):void {
			trace("onTagLoss: " + String(evt.Data));
		}
		
	}
	
}