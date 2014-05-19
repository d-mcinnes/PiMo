package flash.utils {
	public class PadZero {
		public static function convert(inputNumber:Number,numberOfDigits:int=2):String {
			var paddedString:String=inputNumber.toString();
			while (paddedString.length < numberOfDigits) {
				paddedString = "0" + paddedString;
			}
			return paddedString;
		}
	}
}