package br.dcoder.console {

	/**
	 * @author lteixeira
	 */
	public class ConsoleConfig {
		/**
		 * AS3console version.
		 */
		public static const VERSION:String = "0.5.0";
		
		private static const DEFAULT_MAX_CHARACTERS:uint = 100000;
		private static const DEFAULT_MAX_LINE_LENGTH:uint = 1000;
		private static const DEFAULT_MAX_INPUT_HISTORY:uint = 15;
		private static const DEFAULT_PRINT_TIMER:Boolean = false;
		private static const DEFAULT_TRACE_ECHO:Boolean = false;
		private static const DEFAULT_JS_ECHO:Boolean = false;
		
		private var _maxCharacters:uint = DEFAULT_MAX_CHARACTERS;
		private var _maxLineLength:uint = DEFAULT_MAX_LINE_LENGTH;
		private var _maxInputHistory:uint = DEFAULT_MAX_INPUT_HISTORY;
		private var _printTimer:Boolean = DEFAULT_PRINT_TIMER;
		private var _traceEcho:Boolean = DEFAULT_TRACE_ECHO;
		private var _jsEcho:Boolean = DEFAULT_JS_ECHO;
		
		public function ConsoleConfig()
		{
			_maxCharacters = DEFAULT_MAX_CHARACTERS;
			_maxLineLength = DEFAULT_MAX_LINE_LENGTH;
			_maxInputHistory = DEFAULT_MAX_INPUT_HISTORY;
			_printTimer = DEFAULT_PRINT_TIMER;
			_traceEcho = DEFAULT_TRACE_ECHO;
			_jsEcho = DEFAULT_JS_ECHO;
		}
		
		public function get maxCharacters():uint
		{
			return _maxCharacters;
		}
		
		public function set maxCharacters(_maxCharacters:uint):void
		{
			this._maxCharacters = _maxCharacters;
		}
		
		public function get maxLineLength():uint
		{
			return _maxLineLength;
		}
		
		public function set maxLineLength(_maxLineLength:uint):void
		{
			this._maxLineLength = _maxLineLength;
		}
		
		public function get maxInputHistory():uint
		{
			return _maxInputHistory;
		}
		
		public function set maxInputHistory(_maxInputHistory:uint):void
		{
			this._maxInputHistory = _maxInputHistory;
		}
		
		public function get printTimer():Boolean
		{
			return _printTimer;
		}
		
		public function set printTimer(_printTimer:Boolean):void
		{
			this._printTimer = _printTimer;
		}
		
		public function get traceEcho():Boolean
		{
			return _traceEcho;
		}
		
		public function set traceEcho(_traceEcho:Boolean):void
		{
			this._traceEcho = _traceEcho;
		}
		
		public function get jsEcho():Boolean
		{
			return _jsEcho;
		}
		
		public function set jsEcho(_jsEcho:Boolean):void
		{
			this._jsEcho = _jsEcho;
		}
	}
}
