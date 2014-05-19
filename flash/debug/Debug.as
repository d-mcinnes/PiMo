package flash.debug {
	import flash.utils.getTimer;
	
	public class Debug {
		/** Takes a string and prints a debug message. **/
		public static function debugMessage(text:String):void {
			if(GameController.DEBUG_MODE_ON == true) {
				var location:String = new Error().getStackTrace().match( /(?<=\/|\\)\w+?.as:\d+?(?=])/g )[1].replace( ":" , ", line " );
				var x:int = getTimer() / 1000;
				var seconds:int = x % 60;
				x /= 60;
				var minutes:int = x % 60;
				x /= 60;
				var hours:int = x % 24;
				
				trace("[" + Debug.padChar(hours.toString(), 2, '0', true) + 
					  ":" + Debug.padChar(minutes.toString(), 2, '0', true) + 
					  ":" + Debug.padChar(seconds.toString(), 2, '0', true) + 
					  "]" + Debug.padChar(("[" + location + "] "), 40, ' ', false) + text);
			}
		}
		
		/** Takes an input number and (optional) number of digits pads up to the nummber
		 ** of digits with 0. **/
		public static function padChar(input:String, numberOfDigits:int, char:String, prefix:Boolean):String {
			var paddedString:String=input.toString();
			while (paddedString.length < numberOfDigits) {
				if(prefix == true) {
					paddedString = char + paddedString;
				} else {
					paddedString = paddedString + char;
				}
			}
			return paddedString;
		}
	}
}
