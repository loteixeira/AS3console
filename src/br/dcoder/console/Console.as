// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.
// Contributed:
// - 04/20/2012, Camille Reynders, http://www.creynders.be

package br.dcoder.console
{
	import br.dcoder.console.assets.AssetFactory;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * Console class is a singleton used to access all functionalities of AS3Console.
	 * You shouldn't create it using regular constructor, instead use create static method.
	 */
	public class Console extends EventDispatcher
	{
		/**
		 * Console version.
		 */
		public static const VERSION:String = ConsoleCore.VERSION;
		
		private static var _maxCharacters : uint = ConsoleCore.DEFAULT_MAX_CHARACTERS;

		/**
		 * Max characters stored in console text area. Can be modified at runtime.
		 */
		public static function get MAX_CHARACTERS():uint{
			return _maxCharacters;
		}

		/**
		 * 
		 */
		public static function set MAX_CHARACTERS(value:uint):void{
			_maxCharacters = value;
			if( _coreInstance ){
				_coreInstance.maxCharacters = value;
			}
		}


		private static var _maxLineLength:uint = ConsoleCore.DEFAULT_MAX_LINE_LENGTH;

		/**
		 * Max line length before automatic breaking. Can be modified at runtime.
		 * Note that modifying this attribute at runtime won't change text previously written.
		 */
		public static function get MAX_LINE_LENGTH():uint{
			return _maxLineLength;
		}

		/**
		 * 
		 */
		public static function set MAX_LINE_LENGTH(value:uint):void{
			_maxLineLength = value;
			if( _coreInstance ){
				_coreInstance.maxLineLength = value;
			}
		}

		private static var _maxInputHistory:uint = ConsoleCore.DEFAULT_MAX_INPUT_HISTORY;

		/**
		 * Max input navigation history. Can be modified at runtime.
		 * You can access input history using up/down arrow keys when input text field is selected.
		 */
		public static function get MAX_INPUT_HISTORY():uint{
			return _maxInputHistory;
		}

		/**
		 * 
		 */
		public static function set MAX_INPUT_HISTORY(value:uint):void{
			_maxInputHistory = value;
			if( _coreInstance ){
				_coreInstance.maxInputHistory = value;
			}
		}

		private static var _printTimer:Boolean = ConsoleCore.DEFAULT_PRINT_TIMER;

		/**
		 * Print elapsed milliseconds since the flash virtual machine started. Can be modified at runtime.
		 */
		public static function get PRINT_TIMER():Boolean{
			return _printTimer;
		}

		/**
		 * 
		 */
		public static function set PRINT_TIMER(value:Boolean):void{
			_printTimer = value;
			if( _coreInstance ){
				_coreInstance.printTimer = value;
			}
		}

		private static var _traceEcho:Boolean = ConsoleCore.DEFAULT_TRACE_ECHO;

		/**
		 * Print output in flash trace window. Can be modified at runtime.
		 */
		public static function get TRACE_ECHO():Boolean{
			return _traceEcho;
		}

		/**
		 * @private
		 */
		public static function set TRACE_ECHO(value:Boolean):void{
			_traceEcho = value;
			if( _coreInstance ){
				_coreInstance.traceEcho = value;
			}
		}

		private static var _jsEcho:Boolean = ConsoleCore.DEFAULT_JS_ECHO;

		/**
		 * Print output in javascript console window. Can be modified at runtime.
		 */
		public static function get JS_ECHO():Boolean{
			return _jsEcho;
		}

		/**
		 * @private
		 */
		public static function set JS_ECHO(value:Boolean):void{
			_jsEcho = value;
			if( _coreInstance ){
				_coreInstance.jsEcho = value;
			}
		}
		
		
		//
		// internal data
		//
		private static var _created:Boolean;
		private static var _release:Boolean;
		private static var _instance:Console = null;
		private static var _coreInstance : ConsoleCore = null;
		
		
		//
		// static methods
		//
		/**
		 * Create console singleton instance. Should be called once.
		 * If assetFactory parameter is null, default AssetFactory is created.
		 * If release parameter is true, an empty console is created to avoid overhead.
		 * @param stage Reference to application stage object.
		 * @param assetFactory AssetFactory instance used to set component appearance.
		 * @param release Use to create release versions and remove console overhead.
		 * @return Console singleton instance.
		 */
		public static function create(stage:Stage, _release:Boolean = false):Console
		{
			if (_instance)
				throw new Error("One console instance allowed at time");
			
			Console._release = _release;
			_created = true;
			_instance = new Console(stage);
			
			return _instance;
		}
		
		/**
		 * Check if console is running release version.
		 * @return Return true if is release version.
		 */
		public static function get release():Boolean
		{
			return _release;
		}
		
		/**
		 * Check if console instance was created.
		 * @return Return true is create method was already called.
		 */
		public static function get created():Boolean
		{
			return _created;
		}
		
		/**
		 * Return console singleton instance.
		 * @return Console singleton instance.
		 */
		public static function get instance():Console
		{
			return _instance;
		}

		
		//
		// constructor
		//
		/**
		 * @private
		 */
		public function Console(stage:Stage)
		{	
			super();
			
			if (!created)
				throw new Error("This class is a singleton. Use create static method.");
			
			_coreInstance = new ConsoleCore( stage, _release, this );

		}
		
		
		/**
		 * Check if console is running release version.
		 * @return Return true if is release version.
		 */
		public function get release():Boolean
		{
			return _release;
		}
		
		//
		// public interface
		//
		/**
		 * Console position and dimension represented by a Rectangle object.
		 */
		public function get area():Rectangle
		{
			return _coreInstance.rect;
		} 
		
		public function set area(rect:Rectangle):void
		{
			_coreInstance.area = rect;
		}
		
		/**
		 * Console transparecy. If is release, the value is always zero.
		 */
		public function get alpha():Number
		{
			return _coreInstance.alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_coreInstance.alpha = value;
		}
		
		/**
		 * Console caption text. If is release, caption bar text is always "".
		 */
		public function get caption():String
		{
			return _coreInstance.caption;
		}
		
		public function set caption(text:String):void
		{
			_coreInstance.caption = text;
		}
		
		/**
		 * Set asset factory instance.
		 * @param assetFactory New asset factory instance.
		 */
		public function setAssetFactory(assetFactory:AssetFactory):void
		{
			_coreInstance.setAssetFactory( assetFactory );
		}
		
		/**
		 * Get current asset factory instance.
		 * @return Current asset factory instance.
		 */
		public function getAssetFactory():AssetFactory
		{
			return _coreInstance.getAssetFactory();
		}
		
		/**
		 * Update console gaphical interface.
		 * It's automatically called when console area has changed or a new AssetFactory instance was set.
		 */
		public function update():void
		{
			_coreInstance.update();
		}
		
		/**
		 * Show console component and throws ConsoleEvent.SHOW. If running release mode, does nothing.
		 */
		public function show():void
		{
			_coreInstance.show();
		}
		
		/**
		 * Hide console component and throws ConsoleEvent.HIDE. If running release mode, does nothing.
		 */
		public function hide():void
		{
			_coreInstance.hide();
		}
		
		/**
		 * Check if console component is visible.
		 * @return Return true if console is visible. If running release mode returns always false;
		 */
		public function isVisible():Boolean
		{
			return _coreInstance.isVisible();
		}
		
		/**
		 * Completely show console component (caption bar and text area content). 
		 */
		public function maximize():void
		{
			_coreInstance.maximize();
		}
		
		/**
		 * Minimize console component, only caption bar remains visible.
		 */
		public function minimize():void
		{
			_coreInstance.minimize();
		}
		
		/**
		 * Check if console component is maximized.
		 * @return Return true if console is maximized. If is release mode, always return false.
		 */
		public function isMaximized():Boolean
		{
			return _coreInstance.isMaximized();
		}
		
		/**
		 * Set show/hide shortcut. If this shortcut is already used by container application (Flash IDE, Web Browser, etc) or running release mode, console shortcut will never be triggered.
		 * @param shortcutKeys An array with all keys that should be pressed to trigger shortcut. Each key is a one-character string. Example: [ "m" ].
		 * @param shortcutUseAlt If true ALT key should be pressed to trigger shortcut.
		 * @param shortcutUseCtrl If true CTRL key should be pressed to trigger shortcut.
		 * @param shortcutUseShift If true SHIFT key should be pressed to trigger shortcut.
		 */
		public function shortcut(shortcutKeys:Array, shortcutUseAlt:Boolean = false, shortcutUseCtrl:Boolean = true, shortcutUseShift:Boolean = false):void
		{
			_coreInstance.shortcut( shortcutKeys, shortcutUseAlt, shortcutUseCtrl, shortcutUseShift );
		}
		
		/**
		 * Bring console to front of other display objects. This call don't change the order of the objects added to stage, making console component invisible to host application.
		 */
		public function toFront():void
		{
			_coreInstance.toFront();
		}
		
		/**
		 * Clear console text.
		 */
		public function clear():void
		{
			_coreInstance.clear();
		}
		
		/**
		 * Print information to console text area plus "\n". This method throws ConsoleEvent.OUTPUT. If running release mode, the event is thrown and
		 * TRACE_ECHO/JS_ECHO still works. 
		 * @param info Any information to be printed. If is null, "(null)" string is used.
		 */
		public function println(info:Object):void
		{
			_coreInstance.println( info );
		}

	}
}
