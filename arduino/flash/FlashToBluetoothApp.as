import BluetoothSocket;
/*
* This is the class linked to by the application, and holds all of the functionality
* associated with it. Here we will communicate with the bluetooth adapter and update
* the stage based on actions on the phone
*/
class FlashToBluetoothApp extends MovieClip {
	
	// declare the elements on the page for reference
	private var i_up:MovieClip;
	private var i_right:MovieClip;
	private var i_down:MovieClip;
	private var i_left:MovieClip;
	
	private var i_checkbox:MovieClip;
	private var checked:Boolean = false;
	
	private var i_textField:MovieClip;
	
	// used to do navigation for the page
	private var m_navDirections:Array;
	private var m_activeItem:MovieClip;
	
	
	public function FlashToBluetoothApp() {
		// initialize the Bluetooth adapter
		BluetoothSocket.init();
	}
	public function onLoad() {
		// register this class as a subscriber to
		// data over Bluetooth
		BluetoothSocket.addListener(this);
		
		// set up map of navigation directions
		m_navDirections = [ {elt: i_up, right: i_right, left: i_left, down: i_down }, 
						    {elt: i_right, up: i_up, down: i_down, left: i_left},
						    {elt: i_left, up: i_up, down: i_down, right: i_right},
							{elt: i_down, right: i_right, left: i_left, up: i_up, down: i_textField },
							{elt: i_textField, up: i_down }
						  ];
		
		// initialize labels
		i_up.m_label = "UP";
		i_right.m_label = "RIGHT";
		i_down.m_label = "DOWN";
		i_left.m_label = "LEFT";
		
		// make the up button be selected to start out
		setActiveItem(i_up);
		// start out with checkbox checked
		toggleCheckbox();
	}
	
	/*
	This method is the event handler for a key press from the
	Bluetooth device. The data is received by the BluetoothSocket
	and sent to all listeners, including this one. Here, we 
	analyze the keypress and act accordingly
	*/
	public function onBluetoothKeyDown(key:Number)
	{
		switch (key)
				{
				case Key.LEFT:
				case Key.UP:
				case Key.RIGHT:
				case Key.DOWN:
					// all navigational keypresses are handled by
					// reading the navigation table based on the currently
					// active item and the direction requested ("key")
					for (var i = 0; i < m_navDirections.length; i++)
					{
						var item:Object = m_navDirections[i];
						if (item.elt == m_activeItem) 
						{
							if (key == Key.LEFT && item.left != undefined) setActiveItem(item.left);
							else if (key == Key.UP && item.up != undefined) setActiveItem(item.up);
							else if (key == Key.RIGHT && item.right != undefined) setActiveItem(item.right);
							else if (key == Key.DOWN && item.down != undefined) setActiveItem(item.down);
							break;
						}
					}
					break;
				case Key.ENTER:
					if (m_activeItem == i_textField) // prompt for text entry
					{
						// change button label to get user to look at their phone
						// to enter text onto it
						i_textField.m_label = "Enter Text on Phone";
						
						// Tell the socket to use this prompt on the phone
						BluetoothSocket.getTextInput("Enter Text For The Toy App");
												
					}
					else // for all elements on the page besides the text entry field...
					{
						//toggle the checkbox as a toy action
						toggleCheckbox();
						
						// when you want "enter" to not prompt the user for text entry (this is the normal case
						// of a button press triggering some action within the flash application, like going
						// to a new page or checking a box as in this example), you MUST send the Bluetooth
						// adapter a noAction message so that the client will know not to wait for text entry.
						// Always have this as the default last thing you do on an enter keypress
						BluetoothSocket.noAction();
						
					}
					break;
				default:
					break;
				 }
	}
	
	/*
	Event handler for text entry... update the text field to display the data
	*/
	public function onTextEntered(txt:String) 
	{
		trace(m_activeItem.m_label + " and new txt is " + txt);
		m_activeItem.m_label = txt;
	}
	
	
	/*
	* State changing Utility functions
	*
	*/
	private function setActiveItem(item:MovieClip)
	{
		trace("current active item is " + m_activeItem + " and new item is " + item);
		if (m_activeItem != undefined)
		{
			m_activeItem.gotoAndStop("Inactive");
		}
		m_activeItem = item;
		m_activeItem.gotoAndStop("Selected");
		
	}
	
	private function toggleCheckbox() {
		if (checked)
		{
			i_checkbox.gotoAndStop("unchecked");
		}
		else
		{
			i_checkbox.gotoAndStop("checked");
		}
		checked = !checked;
	}
}
