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
		
		/**
		 * Initialises the connection to the RFID reader.
		 */
		public function RFIDReaderDouble(gc:GameController) {
			this.gc = gc;
			
			this.rfid1 = new PhidgetRFID();
			this.rfid2 = new PhidgetRFID();
			
			rfid1.addEventListener(PhidgetEvent.ATTACH, onRFID1Attach);
			rfid1.open("localhost", 5001, 18115);
			
			rfid2.addEventListener(PhidgetEvent.ATTACH, onRFID2Attach);
			rfid2.open("localhost", 5001, ???); //TODO needs id
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			timer.start();
		}
		
		private function timerListener(e:TimerEvent):void {
			rfid1On();
		}
		
		private function rfid1On():void {
			rfid1.Antenna = true;
			rfid1.LED = true;
			trace("RFID1 is on.");
			rfid1Interval = setInterval(rfid1off, 500);
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
			rfid2Interval = setInterval(rfid2off, 500);
		}
		
		private function rfid2Off():void {
			rfid2.Antenna = false;
			rfid2.LED = false;
			trace("RFID2 is inactive.");
			clearInterval(rfid2Interval);
			rfid1On();
		}
		
		//TODO event listeners for each tag.
		
	}
}
		
/*
			
			rfid.addEventListener(PhidgetEvent.DETACH, onDetach);
			rfid.addEventListener(PhidgetEvent.ATTACH, onAttach);
			rfid.addEventListener(PhidgetErrorEvent.ERROR, onError);
			rfid.addEventListener(PhidgetDataEvent.TAG, onTag);
			rfid.addEventListener(PhidgetDataEvent.TAG_LOST, onTagLoss);
			
			rfid.open("localhost", 5001);
			
			/*
			 * It takes time to connect to the device, so trying to access the device 
			 * at this point in the code (immediately or too soon after opening the 
			 * device) will result in the following error:
			 * Error: Value is Unknown (State not yet received from device).
			 */
			 
			 //You also need to close the device when you're done with it.
		}
		
		function onError(evt:PhidgetErrorEvent):void {
			trace("onError");
			trace(evt);
		}
		
		function onAttach(evt:PhidgetEvent):void {
			trace("onAttach");
			trace(evt);
		
			trace("Phidgetstatus: " + rfid.Name);	
			trace("Serialnumber: " + rfid.serialNumber);
			trace("Version: " + rfid.Version);
			trace("Outputs: " +  rfid.OutputCount);
			
			rfid.LED = true;
			rfid.Antenna = true;
			
			//How to write a tag:
			//rfid.write(new PhidgetRFIDTag("Help me!!", PhidgetRFID.PHIDGET_RFID_PROTOCOL_PHIDGETS));
		}
		
		function onDetach(evt:PhidgetEvent):void {
			trace("onDetach");
			trace(evt);
			
			rfid.LED = false;
			rfid.Antenna = false;
		}
		
		function onTag(evt:PhidgetDataEvent):void {
			trace("onTag: " + String(evt.Data));
			
			//funsies
			if (rfid.LED == false) {
				rfid.LED = true;
			} else {
				rfid.LED = false;
			}
		}
		
		function onTagLoss(evt:PhidgetDataEvent):void {
			trace("onTagLoss: " + String(evt.Data));
		}
		
	}
	
}