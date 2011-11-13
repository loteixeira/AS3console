// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;
	
	import br.dcoder.console.gui.CaptionBar;
	import br.dcoder.console.gui.InputField;
	import br.dcoder.console.gui.ResizeArea;
	import br.dcoder.console.gui.ScrollBar;
	import br.dcoder.console.gui.TextArea;
	import br.dcoder.console.util.StringUtil;

	/**
	 * Console class is a singleton used to access all functionalities of AS3Console.
	 * You shouldn't create it using regular constructor, instead use create static method.
	 */
	public class Console extends EventDispatcher
	{
		/**
		 * Console version.
		 */
		public static const VERSION:String = "0.3.4";
		
		/**
		 * Max characters stored in console text area. Can be modified at runtime.
		 */
		public static var MAX_CHARACTERS:uint = 100000;
		/**
		 * Max line length before automatic breaking. Can be modified at runtime.
		 * Note that modifying this attribute at runtime won't change text previously written.
		 */
		public static var MAX_LINE_LENGTH:uint = 1000;
		/**
		 * Max input navigation history. Can be modified at runtime.
		 * You can access input history using up/down arrow keys when input text field is selected.
		 */
		public static var MAX_INPUT_HISTORY:uint = 15;
		/**
		 * Print elapsed milliseconds since the flash virtual machine started. Can be modified at runtime.
		 */
		public static var PRINT_TIMER:Boolean = false;
		/**
		 * Print output in flash trace window. Can be modified at runtime.
		 */
		public static var TRACE_ECHO:Boolean = false;
		/**
		 * Print output in firebug window. Can be modified at runtime.
		 */
		public static var FIREBUG_ECHO:Boolean = false;
		
		
		//
		// internal data
		//
		private static const DEFAULT_ALPHA:Number = 0.75;
		
		private static var _created:Boolean;
		private static var _release:Boolean;
		private static var _instance:Console = null;
		
		private var rect:Rectangle;
		private var stage:Stage;
		private var assetFactory:AssetFactory;
		
		private var container:Sprite;
		private var captionBar:CaptionBar;
		private var content:Sprite;
		private var textArea:TextArea;
		private var inputField:InputField;
		private var hScrollBar:ScrollBar;
		private var vScrollBar:ScrollBar;
		private var resizeArea:ResizeArea;
		
		private var shortcutKeys:Array, shortcutStates:Array;
		private var shortcutUseAlt:Boolean, shortcutUseCtrl:Boolean, shortcutUseShift:Boolean;
		
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

			rect = new Rectangle(50, 50, 250, 250);
				
			if (!release)
			{
				this.stage = stage;
				assetFactory = new AssetFactory();
				container = new Sprite();
				stage.addChild(container);
			
				// caption bar
				captionBar = new CaptionBar(assetFactory);
				captionBar.text = "AS3Console " + VERSION;
				container.addChild(captionBar.getContent());
			
				captionBar.addEventListener(CaptionBar.START_DRAG_EVENT, function(event:Event):void
				{
					toFront();
					container.startDrag();
				});
			
				captionBar.addEventListener(CaptionBar.STOP_DRAG_EVENT, function(event:Event):void
				{
					container.stopDrag();
					rect.x = container.x;
					rect.y = container.y;
					inputField.getFocus();
				});

				// content
				content = new Sprite();
				content.y = assetFactory.getButtonContainerSize();
				container.addChild(content);
			
				// text area
				textArea = new TextArea(assetFactory);
				content.addChild(textArea.getContent());
			
				textArea.addEventListener(TextArea.SCROLL_EVENT, function(event:Event):void
				{
					vScrollBar.setValue(textArea.scrollV - 1);
				});
			
				// input field
				inputField = new InputField(assetFactory);
				content.addChild(inputField.getContent());
			
				inputField.addEventListener(InputField.INPUT_EVENT, function(event:Event):void
				{
					println("> " + inputField.getText());
				
					if (!handleEmbedCommands(inputField.getText().split(" ")))
						dispatchEvent(new ConsoleEvent(ConsoleEvent.INPUT, inputField.getText()));
				});
			
				// scroll bars
				hScrollBar = new ScrollBar(assetFactory, ScrollBar.HORIZONTAL, 250);
				hScrollBar.setMaxValue(0);
				content.addChild(hScrollBar.getContent());
			
				hScrollBar.addEventListener(Event.CHANGE, function(event:Event):void
				{
					textArea.scrollH = hScrollBar.getValue() + 1;
				});
			
				vScrollBar = new ScrollBar(assetFactory, ScrollBar.VERTICAL, 250);
				vScrollBar.setMaxValue(0);
				content.addChild(vScrollBar.getContent());
			
				vScrollBar.addEventListener(Event.CHANGE, function(event:Event):void
				{
					textArea.scrollV = vScrollBar.getValue() + 1;
				});
			
				// resize area
				resizeArea = new ResizeArea(assetFactory);
				content.addChild(resizeArea.getContent());
			
				resizeArea.addEventListener(ResizeArea.RESIZE_EVENT, function(event:Event):void
				{
					rect.width += resizeArea.widthOffset;
					rect.height += resizeArea.heightOffset;
					update();
				});
			
				resizeArea.addEventListener(ResizeArea.RESIZE_STOP_EVENT, function(event:Event):void
				{
					inputField.getFocus();
				});
			
				// shortcut
				shortcutKeys = [ "m" ];
				shortcutStates = [ false ];
				shortcutUseAlt = false;
				shortcutUseCtrl = true;
				shortcutUseShift = false;
			
				// stage events
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				
				// update component
				alpha = DEFAULT_ALPHA;
				update();
			}
		}
		
		//
		// public interface
		//
		/**
		 * Console position and dimension represented by a Rectangle object.
		 */
		public function get area():Rectangle
		{
			return rect;
		} 

		public function set area(rect:Rectangle):void
		{
			this.rect = rect;
			update();
		}
		
		/**
		 * Console transparecy. If is release, the value is always zero.
		 */
		public function get alpha():Number
		{
			return release ? 0 : container.alpha;
		}
		
		public function set alpha(value:Number):void
		{
			if (!release)
				container.alpha = value;
		}
		
		/**
		 * Console caption text. If is release, caption bar text is always "".
		 */
		public function get caption():String
		{
			return release ? "" : captionBar.text;
		}
		
		public function set caption(text:String):void
		{
			if (!release)
				captionBar.text = text;
		}
		
		/**
		 * Set asset factory instance.
		 * @param assetFactory New asset factory instance.
		 */
		public function setAssetFactory(assetFactory:AssetFactory):void
		{
			this.assetFactory = assetFactory;
			update();
		}
		
		/**
		 * Get current asset factory instance.
		 * @return Current asset factory instance.
		 */
		public function getAssetFactory():AssetFactory
		{
			return assetFactory;
		}
		
		/**
		 * Update console gaphical interface.
		 * It's automatically called when console area has changed or a new AssetFactory instance was set.
		 */
		public function update():void
		{
			if (!release)
			{
				// draw background
				content.graphics.clear();
				content.graphics.lineStyle(1, assetFactory.getButtonForegroundColor());
				content.graphics.beginFill(assetFactory.getBackgroundColor());
				content.graphics.drawRect(0, 0, rect.width - 1, rect.height - assetFactory.getButtonContainerSize() - 1);
				content.graphics.endFill();
			
				// container
				container.x = rect.left;
				container.y = rect.top;
			
				// caption bar
				captionBar.rect = new Rectangle(0, 0, rect.width, assetFactory.getButtonContainerSize());
				captionBar.update();
			
				// text area
				textArea.rect = new Rectangle(1, 1, rect.width - assetFactory.getButtonContainerSize() - 1, rect.height - assetFactory.getButtonContainerSize() - assetFactory.getButtonContainerSize() - inputField.getMinimumHeight() - 1);
				textArea.scrollV = textArea.maxScrollV;
				textArea.update();
			
				// input field
				inputField.rect = new Rectangle(1, rect.height - assetFactory.getButtonContainerSize() * 2 - inputField.getMinimumHeight(), rect.width - assetFactory.getButtonContainerSize(), inputField.getMinimumHeight());
				inputField.update();
			
				// horizontal scroll bar
				hScrollBar.rect = new Rectangle(0, rect.height - assetFactory.getButtonContainerSize() - assetFactory.getButtonContainerSize(), 0, 0);
				hScrollBar.setLength(rect.width - assetFactory.getButtonContainerSize() + 1);
				hScrollBar.setMaxValue(textArea.maxScrollH == 0 ? 0 : textArea.maxScrollH - 1);
				hScrollBar.update();
			
				if (hScrollBar.getValue() > hScrollBar.getMaxValue())
					hScrollBar.toMaxValue();
			
				// vertical scroll bar
				vScrollBar.rect = new Rectangle(rect.width - assetFactory.getButtonContainerSize(), 0);
				vScrollBar.setLength(rect.height - assetFactory.getButtonContainerSize() - assetFactory.getButtonContainerSize() + 1);
				vScrollBar.setMaxValue(textArea.maxScrollV == 0 ? 0 : textArea.maxScrollV - 1);
				vScrollBar.update();
			
				if (vScrollBar.getValue() > vScrollBar.getMaxValue())
					vScrollBar.toMaxValue();
			
				// resize area
				resizeArea.rect = new Rectangle(hScrollBar.rect.left + hScrollBar.getLength(), vScrollBar.rect.top + vScrollBar.getLength(), 0, 0);
				resizeArea.update();
			}
		}
		
		/**
		 * Show console component and throws ConsoleEvent.SHOW. If running release mode, does nothing.
		 */
		public function show():void
		{
			if (!release)
			{
				dispatchEvent(new ConsoleEvent(ConsoleEvent.SHOW));

				toFront();
				container.visible = true;
				inputField.getFocus();
			}
		}
		
		/**
		 * Hide console component and throws ConsoleEvent.HIDE. If running release mode, does nothing.
		 */
		public function hide():void
		{
			if (!release)
			{
				dispatchEvent(new ConsoleEvent(ConsoleEvent.HIDE));
			
				container.visible = false;
			}
		}
		
		/**
		 * Check if console component is visible.
		 * @return Return true if console is visible. If running release mode returns always false;
		 */
		public function isVisible():Boolean
		{
			return release ? false : container.visible;
		}
		
		/**
		 * Completely show console component (caption bar and text area content). 
		 */
		public function maximize():void
		{
			if (!release)
				content.visible = true;
		}
		
		/**
		 * Minimize console component, only caption bar remains visible.
		 */
		public function minimize():void
		{
			if (!release)
				content.visible = false;
		}
		
		/**
		 * Check if console component is maximized.
		 * @return Return true if console is maximized. If is release mode, always return false.
		 */
		public function isMaximized():Boolean
		{
			return release ? false : content.visible;
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
			if (!release)
			{
				this.shortcutKeys = shortcutKeys;
				this.shortcutUseAlt = shortcutUseAlt;
				this.shortcutUseCtrl = shortcutUseCtrl;
				this.shortcutUseShift = shortcutUseShift;
			
				shortcutStates = new Array();
			
				for (var i:uint = 0; i < this.shortcutKeys.length; i++)
				{
					this.shortcutKeys[i] = (this.shortcutKeys[i] as String).toLowerCase();
					shortcutStates.push(false);
				}
			}
		}
		
		/**
		 * Bring console to front of other display objects. This call don't change the order of the objects added to stage, making console component invisible to host application.
		 */
		public function toFront():void
		{
			if (!release)
				while (container.parent.getChildIndex(container) < container.parent.numChildren - 1)
					container.parent.swapChildren(container, container.parent.getChildAt(container.parent.getChildIndex(container) + 1));
		}
		
		/**
		 * Clear console text.
		 */
		public function clear():void
		{
			if (!release)
			{
				textArea.clear();
				hScrollBar.setMaxValue(0);
				hScrollBar.toMaxValue();
				vScrollBar.setMaxValue(0);
				vScrollBar.toMaxValue();
			}
		}
		
		/**
		 * Print information to console text area plus "\n". This method throws ConsoleEvent.OUTPUT. If running release mode, the event is thrown and
		 * TRACE_ECHO/FIREBUG_ECHO still works. 
		 * @param info Any information to be printed. If is null, "(null)" string is used.
		 */
		public function println(info:Object):void
		{
			// build string
			var str:String = StringUtil.check(info);

			if (PRINT_TIMER)
				str = "[" + getTimer() + "] " + str;
				
			// throw events
			if (TRACE_ECHO)
				trace(str);
				
			if (FIREBUG_ECHO)
			{
				try
				{
					ExternalInterface.call("console.log", "[AS3Console] " + str);
				}
				catch (e:Error)
				{
					str = "[Error writing on firebug: " + e + "]\n" + str;
				}
			}
				
			dispatchEvent(new ConsoleEvent(ConsoleEvent.OUTPUT, str));
			
			if (!release)
			{
				// write text
				textArea.writeln(str);

				// scroll bar
				hScrollBar.setMaxValue(textArea.maxScrollH == 0 ? 0 : textArea.maxScrollH - 1);
				vScrollBar.setMaxValue(textArea.maxScrollV == 0 ? 0 : textArea.maxScrollV - 1);
				vScrollBar.toMaxValue();
			
				// bring to front if visible
				if (isVisible())
					toFront();
			}
		}

		//
		// private methods
		//
		private function handleEmbedCommands(params:Array):Boolean {
			if (params[0] == "alpha")
			{
				if (params.length == 1)
				{
					println("Console component alpha: " + alpha);
					println("");
				}
				else
				{
					var value:Number = parseFloat(params[1]);
					
					if (isNaN(value) || value < 0 || value > 1)
					{
						println("Invalid alpha value: " + params[1]);
						println("Valid range is [0..1]");
						println("");
					}
					else
					{
						alpha = value;
					}
				}
				
				return true;
			}
			else if (params[0] == "clear")
			{
				clear();
				return true;
			}
			else if (params[0] == "hide")
			{
				hide();
				return true;
			}
			else if (params[0] == "mem")
			{
				var memUsed:String = System.totalMemory.toString();
				var result:String = "";
				var lastIndex:int = memUsed.length;
					
				for (var i:int = memUsed.length - 1; i >= 0; i--)
				{
					result = memUsed.charAt(i) + result;
						
					if (lastIndex - i == 3 && i > 0)
					{
						lastIndex = i;
						result = "." + result;
					}
				}
					
				println("Memory used: " + result + " bytes");
				println("");
				
				return true;
			}
			else if (params[0] == "version")
			{
				println("AS3Console version " + VERSION);
				println("Created by loteixeira at gmail dot com");
				println("Project page: https://github.com/loteixeira/as3console");
				println("");
				
				return true;
			}
			
			return false;
		}
		
		//
		// keyboard events
		//
		private function onKeyDown(event:KeyboardEvent):void
		{
			var i:uint;
			
			for (i = 0; i < shortcutKeys.length; i++)
			{
				if (event.charCode == (shortcutKeys[i] as String).charCodeAt(0) || event.charCode == (shortcutKeys[i] as String).toUpperCase().charCodeAt(0)) {
					shortcutStates[i] = true;
					break;
				}
			}
			
			var triggerShortcut:Boolean = true;
			
			for (i = 0; i < shortcutKeys.length; i++)
			{
				if (!shortcutStates[i])
				{
					triggerShortcut = false;
					break;
				}
			}
			
			if (shortcutUseAlt && !event.altKey)
				triggerShortcut = false;
			
			if (shortcutUseCtrl && !event.ctrlKey)
				triggerShortcut = false;
				
			if (shortcutUseShift && !event.shiftKey)
				triggerShortcut = false;
				
			if (triggerShortcut) {
				if (isVisible())
					hide();
				else
					show();
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			for (var i:uint = 0; i < shortcutKeys.length; i++)
			{
				if (event.charCode == (shortcutKeys[i] as String).charCodeAt(0) || event.charCode == (shortcutKeys[i] as String).toUpperCase().charCodeAt(0))
				{
					shortcutStates[i] = false;
					break;
				}
			}
		}
	}
}
