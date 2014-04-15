﻿package  {
	
	import com.phidgets.*;
	import com.phidgets.events.*;
	
	/***
	 * Class for demonstrating the basics of RFID reader...stuff.
	 */
	public class RFIDReader {
		
		//instance of the rfid reader
		private var rfid:PhidgetRFID;
		
		/**
		 * Initialises the connection to the RFID reader.
		 */
		public function RFIDReader() {
			this.rfid = new PhidgetRFID();
			
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