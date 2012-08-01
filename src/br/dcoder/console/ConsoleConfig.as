// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	/**
	 * Class which stores configuration details of an instance of <code>ConsoleCore</code>.
	 * All attributes are public members where you can freely modify.
	 * @see br.dcoder.console.ConsoleCore
	 */
	public class ConsoleConfig
	{
		/**
		 * AS3console version.
		 */
		public static const VERSION:String = "0.5.1";
		
		private static const DEFAULT_MAX_CHARACTERS:uint = 100000;
		private static const DEFAULT_MAX_LINE_LENGTH:uint = 1000;
		private static const DEFAULT_MAX_INPUT_HISTORY:uint = 15;
		private static const DEFAULT_PRINT_TIMER:Boolean = false;
		private static const DEFAULT_TRACE_ECHO:Boolean = true;
		private static const DEFAULT_JS_ECHO:Boolean = false;
		
		/**
		 * Max characters stored in <code>ConsoleCore</code> text area. Default value is 100000.
		 */
		public var maxCharacters:uint = DEFAULT_MAX_CHARACTERS;
		/**
		 * Max length of a text line. Note that modifying it doesn't change text previously written. Default value is 1000.
		 */
		public var maxLineLength:uint = DEFAULT_MAX_LINE_LENGTH;
		/**
		 * Max number of items stored at input story. You can access input history selection input field and pressing up/down arrows.
		 * Default value is 15.
		 */
		public var maxInputHistory:uint = DEFAULT_MAX_INPUT_HISTORY;
		/**
		 * Print the time since flash virtual machine has started in each output. Default value is false.
		 */
		public var printTimer:Boolean = DEFAULT_PRINT_TIMER;
		/**
		 * Print console output in flash trace window. Default value is true.
		 */
		public var traceEcho:Boolean = DEFAULT_TRACE_ECHO;
		/**
		 * Print console output in javascript console window. Default value is false.
		 */
		public var jsEcho:Boolean = DEFAULT_JS_ECHO;
		
		/**
		 * Create a <code>ConsoleConfig</code> instance.
		 */
		public function ConsoleConfig()
		{
			maxCharacters = DEFAULT_MAX_CHARACTERS;
			maxLineLength = DEFAULT_MAX_LINE_LENGTH;
			maxInputHistory = DEFAULT_MAX_INPUT_HISTORY;
			printTimer = DEFAULT_PRINT_TIMER;
			traceEcho = DEFAULT_TRACE_ECHO;
			jsEcho = DEFAULT_JS_ECHO;
		}
	}
}
