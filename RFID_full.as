import com.phidgets.*;
import com.phidgets.events.*;

var rfid:PhidgetRFID = new PhidgetRFID();

rfid.addEventListener(PhidgetEvent.DETACH,	onDetach);
rfid.addEventListener(PhidgetEvent.ATTACH,	onAttach);
rfid.addEventListener(PhidgetErrorEvent.ERROR, onError);
rfid.addEventListener(PhidgetDataEvent.TAG, onTag);
rfid.addEventListener(PhidgetDataEvent.TAG_LOST, onTagLoss);

antennaChk.addEventListener(MouseEvent.CLICK,updateOutputs);
ledChk.addEventListener(MouseEvent.CLICK,updateOutputs);
output0Chk.addEventListener(MouseEvent.CLICK,updateOutputs);
output1Chk.addEventListener(MouseEvent.CLICK,updateOutputs);

rfid.open("localhost", 5001);

function onError(evt:PhidgetErrorEvent):void {
	trace(evt);
}
function onAttach(evt:PhidgetEvent):void{
	trace(evt);

	Phidgetstatus.text = rfid.Name;	
	Serialnumber.text = rfid.serialNumber;
	Version.text = rfid.Version;
	Outputs.text = rfid.OutputCount;
	rfid.Antenna = true;
	antennaChk.selected = true;
	rfid.LED = true;
	ledChk.selected = true;

	rfid.setOutputState(0,output0Chk.selected);
	rfid.setOutputState(1,output1Chk.selected);
	
	//How to write a tag:
	//rfid.write(new PhidgetRFIDTag("Help me!!", PhidgetRFID.PHIDGET_RFID_PROTOCOL_PHIDGETS));
}
function onDetach(evt:PhidgetEvent):void{
	trace(evt);
	Phidgetstatus.text = "";
	Serialnumber.text = "";
	Version.text = "";
	Outputs.text = "";
}
function onTag(evt:PhidgetDataEvent):void{
	trace(evt);
	Tagoutput.text = evt.Data;
}
function onTagLoss(evt:PhidgetDataEvent):void{
	trace(evt);
	Tagoutput.text = "";
}
function updateOutputs(e:MouseEvent):void 
{
	var cb:CheckBox = CheckBox(e.target);
	if(e.target.name == "antennaChk")
	{
		rfid.Antenna = antennaChk.selected;
	}
	if(e.target.name == "ledChk")
	{
		rfid.LED = ledChk.selected;
	}
	if(e.target.name == "output0Chk")
	{
		rfid.setOutputState(0,output0Chk.selected);
	}			
	if(e.target.name == "output1Chk")
	{
		rfid.setOutputState(1,output1Chk.selected);
	}
}
