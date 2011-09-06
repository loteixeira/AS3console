// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: http://code.google.com/p/as3console/
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;

	public class Console extends EventDispatcher
	{
		/**
		 * Console version.
		 */
		public static const VERSION:String = "0.2.2";
		
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
		private static const FONT_SIZE:uint = 12;
		private static const CAPTION_TEXT:String = "AS3Console";
		private static const CAPTION_BAR_HEIGHT:uint = 20;
		private static const MARKER_FIELD_WIDTH:uint = 12;
		private static const DEFAULT_ALPHA:Number = 0.75;
		
		private static var release:Boolean;
		private static var instance:Console = null;
		
		private var stage:Stage;
		private var assetFactory:AssetFactory;
		private var rect:Rectangle;		
		private var container:Sprite;
		private var captionBar:Sprite;
		private var captionTextField:TextField;
		private var minimizeButton:Button;
		private var content:Sprite;
		private var textArea:TextField;
		private var markerField:TextField;
		private var inputField:TextField;
		private var hScrollBar:ScrollBar;
		private var vScrollBar:ScrollBar;
		private var resizeArea:Sprite;
		
		private var resizeOffset:Point;
		private var resizing:Boolean;
		
		private var shortcutKeys:Array, shortcutStates:Array;
		private var shortcutUseAlt:Boolean, shortcutUseCtrl:Boolean, shortcutUseShift:Boolean;
		
		private var inputHistory:Array;
		private var historyIndex:int;
		
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
		public static function create(stage:Stage, assetFactory:AssetFactory = null, release:Boolean = false):Console
		{
			Console.release = release;
			
			if (release)
				instance = new DummyConsole(stage);
			else
				instance = new Console(stage, !assetFactory ? new AssetFactory() : assetFactory);
			
			return instance;
		}
		
		/**
		 * Check if console is running release version.
		 * @return Return true if is release version.
		 */
		public static function isRelease():Boolean
		{
			return release;
		}
		
		/**
		 * Return console singleton instance.
		 * @return Console singleton instance.
		 */
		public static function getInstance():Console
		{
			return instance;
		}
		
		private static function getString(info:Object):String {
			if (info == null)
				return "(null)";
			else if (info is String)
				return info as String;
			
			return info.toString();
		}
		
		//
		// constructor
		//
		/**
		 * @private
		 */
		public function Console(stage:Stage, assetFactory:AssetFactory)
		{
			super();
			
			if (release)
				return;
				
			this.stage = stage;
			this.assetFactory = assetFactory;
			
			var tFormat:TextFormat;
			
			rect = new Rectangle(50, 50, 250, 250);
			container = new Sprite();
			stage.addChild(container);
			
			// caption bar
			captionBar = new Sprite();
			captionBar.addEventListener(MouseEvent.MOUSE_UP, onCaptionBarMouseUp);
			captionBar.addEventListener(MouseEvent.MOUSE_DOWN, onCaptionBarMouseDown);
			captionBar.buttonMode = true;
			container.addChild(captionBar);
			
			captionTextField = new TextField();
			captionTextField.text = CAPTION_TEXT + " " + VERSION;
			captionTextField.height = CAPTION_BAR_HEIGHT;
			captionTextField.mouseEnabled = false;
			captionTextField.selectable = false;
			captionTextField.y = 2;
			captionBar.addChild(captionTextField);
			
			tFormat = new TextFormat();
			tFormat.align = TextFormatAlign.CENTER;
			tFormat.bold = true;
			tFormat.color = assetFactory.getButtonForegroundColor();
			tFormat.font = "_typewriter";
			tFormat.size = 14;
			captionTextField.setTextFormat(tFormat);
			captionTextField.defaultTextFormat = tFormat;
			
			minimizeButton = new Button(Button.ARROW_ICON, assetFactory);
			minimizeButton.draw(CAPTION_BAR_HEIGHT - CAPTION_BAR_HEIGHT * 0.3, CAPTION_BAR_HEIGHT - CAPTION_BAR_HEIGHT * 0.3);
			minimizeButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void
			{
				if (isMaximized())
				{
					minimize();
				}
				else
				{
					maximize();
					focusInputField();
				}
			});
			captionBar.addChild(minimizeButton);
			
			// content
			content = new Sprite();
			content.y = CAPTION_BAR_HEIGHT;
			container.addChild(content);
			
			// text area
			textArea = new TextField();
			textArea.multiline = true;
			textArea.addEventListener(MouseEvent.MOUSE_WHEEL, onTextAreaMouseWheel);
			content.addChild(textArea);
			
			tFormat = new TextFormat();
			tFormat.color = assetFactory.getButtonForegroundColor();
			tFormat.font = "_typewriter";
			tFormat.size = FONT_SIZE;
			textArea.defaultTextFormat = tFormat;
			
			// marker field
			markerField = new TextField();
			markerField.background = true;
			markerField.backgroundColor = assetFactory.getButtonBackgroundColor();
			markerField.selectable = false;
			markerField.text = ">";
			content.addChild(markerField);
			
			tFormat = new TextFormat();
			tFormat.color = assetFactory.getButtonForegroundColor();
			tFormat.font = "_typewriter";
			tFormat.size = FONT_SIZE;
			markerField.setTextFormat(tFormat);
			
			// input field
			inputField = new TextField();
			inputField.background = true;
			inputField.backgroundColor = assetFactory.getButtonBackgroundColor();
			inputField.type = TextFieldType.INPUT;
			inputField.addEventListener(KeyboardEvent.KEY_DOWN, onInputFieldKeyDown);
			content.addChild(inputField);
			
			tFormat = new TextFormat();
			tFormat.color = assetFactory.getButtonForegroundColor();
			tFormat.font = "_typewriter";
			tFormat.size = FONT_SIZE;
			inputField.defaultTextFormat = tFormat;
			
			// scroll bars
			hScrollBar = new ScrollBar(assetFactory, ScrollBar.HORIZONTAL, 250);
			hScrollBar.addEventListener(Event.CHANGE, scrollBarChange);
			hScrollBar.setMaxValue(0);
			content.addChild(hScrollBar);
			
			vScrollBar = new ScrollBar(assetFactory, ScrollBar.VERTICAL, 250);
			vScrollBar.addEventListener(Event.CHANGE, scrollBarChange);
			vScrollBar.setMaxValue(0);
			content.addChild(vScrollBar);
			
			// resize area
			resizeArea = new Sprite();
			resizeArea.buttonMode = true;
			resizeArea.addEventListener(MouseEvent.MOUSE_DOWN, onResizeAreaMouseDown);
			content.addChild(resizeArea);

			resizeOffset = new Point();
			resizing = false;
			
			// shortcut
			shortcutKeys = [ "m" ];
			shortcutStates = [ false ];
			shortcutUseAlt = false;
			shortcutUseCtrl = true;
			shortcutUseShift = false;
			
			// input history
			inputHistory = new Array();
			historyIndex = -1; 
			
			// stage events
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			
			// update component
			alpha = DEFAULT_ALPHA;
			update();
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
		 * Console transparecy.
		 */
		public function get alpha():Number
		{
			return container.alpha;
		}
		
		public function set alpha(value:Number):void
		{
			container.alpha = value;
		}
		
		/**
		 * Console caption text.
		 */
		public function get caption():String
		{
			return captionTextField.text;
		}
		
		public function set caption(text:String):void
		{
			captionTextField.text = getString(text);
		}
		
		/**
		 * Update console gaphical interface.
		 * It's automatically called when console area has changed.
		 */
		public function update():void
		{
			container.x = rect.left;
			container.y = rect.top;

			inputField.width = rect.width - assetFactory.getButtonContainerSize() - MARKER_FIELD_WIDTH;
			inputField.height = 20;			
			inputField.x = MARKER_FIELD_WIDTH + 1;
			inputField.y = rect.height - CAPTION_BAR_HEIGHT - assetFactory.getButtonContainerSize() - inputField.height;
			
			markerField.x = 1;
			markerField.y = inputField.y;
			markerField.width = MARKER_FIELD_WIDTH;
			markerField.height = 20;
			
			captionTextField.width = rect.width;
			minimizeButton.x = rect.width - CAPTION_BAR_HEIGHT + CAPTION_BAR_HEIGHT * 0.15;
			minimizeButton.y = CAPTION_BAR_HEIGHT * 0.15;
			
			textArea.x = textArea.y = 1;
			textArea.width = rect.width - assetFactory.getButtonContainerSize() - 1;
			textArea.height = rect.height - CAPTION_BAR_HEIGHT - assetFactory.getButtonContainerSize() - inputField.height - 1;
			
			hScrollBar.x = 0;
			hScrollBar.y = rect.height - CAPTION_BAR_HEIGHT - assetFactory.getButtonContainerSize();
			hScrollBar.setLength(rect.width - assetFactory.getButtonContainerSize() + 1);
			hScrollBar.setMaxValue(textArea.maxScrollH == 0 ? 0 : textArea.maxScrollH - 1);
			hScrollBar.draw();
			
			if (hScrollBar.getValue() > hScrollBar.getMaxValue())
				hScrollBar.toMaxValue();
			
			vScrollBar.x = rect.width - assetFactory.getButtonContainerSize();
			vScrollBar.y = 0;
			vScrollBar.setLength(rect.height - CAPTION_BAR_HEIGHT - assetFactory.getButtonContainerSize() + 1);
			vScrollBar.setMaxValue(textArea.maxScrollV == 0 ? 0 : textArea.maxScrollV - 1);
			vScrollBar.draw();
			
			if (vScrollBar.getValue() > vScrollBar.getMaxValue())
				vScrollBar.toMaxValue();
			
			resizeArea.x = hScrollBar.x + hScrollBar.getLength();
			resizeArea.y = vScrollBar.y + vScrollBar.getLength();
			drawResizeArea();
			
			drawBackground();
			textArea.scrollV = textArea.maxScrollV;
		}
		
		/**
		 * Show console component.
		 */
		public function show():void
		{
			dispatchEvent(new ConsoleEvent(ConsoleEvent.SHOW));
			
			toFront();
			container.visible = true;
			focusInputField();
		}
		
		/**
		 * Hide console component.
		 */
		public function hide():void
		{
			dispatchEvent(new ConsoleEvent(ConsoleEvent.HIDE));
			
			container.visible = false;
		}
		
		/**
		 * Check if console component is visible.
		 * @return Return true if console is visible.
		 */
		public function isVisible():Boolean
		{
			return container.visible;
		}
		
		/**
		 * Completely show console component (caption bar and text area content). 
		 */
		public function maximize():void
		{
			content.visible = true;
		}
		
		/**
		 * Minimize console component, only caption bar remains visible.
		 */
		public function minimize():void
		{
			content.visible = false;
		}
		
		/**
		 * Check if console component is maximized.
		 * @return Return true if console is maximized.
		 */
		public function isMaximized():Boolean
		{
			return content.visible;
		}
		
		/**
		 * Set show/hide shortcut. If this shortcut is already used by container application (Flash IDE, Web Browser, etc) console shortcut will never be triggered.
		 * @param shortcutKeys An array with all keys that should be pressed to trigger shortcut. Each key is a one-character string. Example: [ "m" ].
		 * @param shortcutUseAlt If true ALT key should be pressed to trigger shortcut.
		 * @param shortcutUseCtrl If true CTRL key should be pressed to trigger shortcut.
		 * @param shortcutUseShift If true SHIFT key should be pressed to trigger shortcut.
		 */
		public function shortcut(shortcutKeys:Array, shortcutUseAlt:Boolean = false, shortcutUseCtrl:Boolean = true, shortcutUseShift:Boolean = false):void
		{
			this.shortcutKeys = shortcutKeys;
			this.shortcutUseAlt = shortcutUseAlt;
			this.shortcutUseCtrl = shortcutUseCtrl;
			this.shortcutUseShift = shortcutUseShift;
			
			shortcutStates = new Array();
			
			for (var i:uint = 0; i < this.shortcutKeys.length; i++)
			{
				this.shortcutKeys[i] = this.shortcutKeys[i].toLowerCase();
				shortcutStates.push(false);
			}
		}
		
		/**
		 * Bring console to front of other display objects. This call don't change the order of the objects added to stage, making console component invisible to host application.
		 */
		public function toFront():void
		{
			while (container.parent.getChildIndex(container) < container.parent.numChildren - 1)
				container.parent.swapChildren(container, container.parent.getChildAt(container.parent.getChildIndex(container) + 1));
		}
		
		/**
		 * Clear console text.
		 */
		public function clear():void
		{
			textArea.text = "";
			hScrollBar.setMaxValue(0);
			hScrollBar.toMaxValue();
			vScrollBar.setMaxValue(0);
			vScrollBar.toMaxValue();
		}
		
		/**
		 * Print information to console text area plus "\n".
		 * @param info Any information to be printed. If is null, "(null)" string is used.
		 */
		public function println(info:Object):void
		{
			// build string
			var str:String = getString(info);

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
			
			// write text
			while (str.length > MAX_LINE_LENGTH)
			{
				var tmp:String = str.substr(0, MAX_LINE_LENGTH);
				textArea.appendText(tmp + "\n");
				str = str.substr(MAX_LINE_LENGTH);
			}

			textArea.appendText(str);
			textArea.appendText("\n");
			
			if (textArea.length > MAX_CHARACTERS)
				textArea.replaceText(0, textArea.length - MAX_CHARACTERS, "");
						
			// scroll bar
			hScrollBar.setMaxValue(textArea.maxScrollH == 0 ? 0 : textArea.maxScrollH - 1);
			vScrollBar.setMaxValue(textArea.maxScrollV == 0 ? 0 : textArea.maxScrollV - 1);
			vScrollBar.toMaxValue();
			
			// bring to front if visible
			if (isVisible())
				toFront();
		}

		//
		// private methods
		//
		private function drawResizeArea():void
		{
			resizeArea.graphics.clear();
			resizeArea.graphics.beginFill(assetFactory.getBackgroundColor());
			resizeArea.graphics.drawRect(0, 0, assetFactory.getButtonContainerSize() - 2, assetFactory.getButtonContainerSize() - 2);
			resizeArea.graphics.endFill();

			resizeArea.graphics.lineStyle(1, assetFactory.getButtonForegroundColor());			
			resizeArea.graphics.beginFill(assetFactory.getButtonBackgroundColor());
			resizeArea.graphics.moveTo(assetFactory.getButtonContainerSize() - 4, 3);
			resizeArea.graphics.lineTo(assetFactory.getButtonContainerSize() - 4, assetFactory.getButtonContainerSize() - 4);
			resizeArea.graphics.lineTo(3, assetFactory.getButtonContainerSize() - 4);
			resizeArea.graphics.endFill();
		}
		
		private function drawBackground():void
		{
			captionBar.graphics.clear();
			captionBar.graphics.lineStyle(1, assetFactory.getButtonForegroundColor());
			captionBar.graphics.beginFill(assetFactory.getButtonBackgroundColor());
			captionBar.graphics.drawRect(0, 0, rect.width - 1, CAPTION_BAR_HEIGHT);
			captionBar.graphics.endFill();
			
			content.graphics.clear();
			
			content.graphics.lineStyle(1, assetFactory.getButtonForegroundColor());
			content.graphics.beginFill(assetFactory.getBackgroundColor());
			content.graphics.drawRect(0, 0, rect.width - 1, rect.height - CAPTION_BAR_HEIGHT - 1);
			content.graphics.endFill();
		}
		
		private function focusInputField():void {
			stage.focus = inputField;
			inputField.setSelection(inputField.text.length, inputField.text.length);
		}
		
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
				println("Project page: http://code.google.com/p/as3console/");
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
				if (event.charCode == shortcutKeys[i].charCodeAt(0) || event.charCode == shortcutKeys[i].toUpperCase().charCodeAt(0)) {
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
				if (event.charCode == shortcutKeys[i].charCodeAt(0) || event.charCode == shortcutKeys[i].toUpperCase().charCodeAt(0))
				{
					shortcutStates[i] = false;
					break;
				}
			}
		}
		
		private function onInputFieldKeyDown(event:KeyboardEvent):void
		{
			// enter key pressed
			if (event.charCode == 13)
			{
				println("> " + inputField.text);
				
				if (!handleEmbedCommands(inputField.text.split(" ")))
					dispatchEvent(new ConsoleEvent(ConsoleEvent.INPUT, inputField.text));

				// input history
				inputHistory.splice(0, 0, inputField.text);
					
				while (inputHistory.length > MAX_INPUT_HISTORY)
					inputHistory.pop();
				
				inputField.text = "";
				historyIndex = -1;
			// up key pressed
			} else if (event.keyCode == 38) {
				if (historyIndex < inputHistory.length - 1)
					historyIndex++;
					
				inputField.text = inputHistory[historyIndex];
			// down key pressed
			} else if (event.keyCode == 40) {
				if (historyIndex >= 0)
					historyIndex--;
				
				if (historyIndex == -1)
					inputField.text = "";
				else
					inputField.text = inputHistory[historyIndex];
			}
		}
		
		//
		// mouse events
		//
		private function onCaptionBarMouseUp(event:MouseEvent):void
		{
			container.stopDrag();
			rect.x = container.x;
			rect.y = container.y;
			focusInputField();
		}
		
		private function onCaptionBarMouseDown(event:MouseEvent):void
		{
			toFront();
			container.startDrag();
		}

		private function onTextAreaMouseWheel(event:MouseEvent):void
		{
			vScrollBar.setValue(textArea.scrollV - 1);
		}
		
		private function stageMouseMove(event:MouseEvent):void
		{
			hScrollBar.onStageMouseMove(event);
			vScrollBar.onStageMouseMove(event);
			
			if (resizing)
			{
				rect.width += event.stageX - resizeOffset.x;
				rect.height += event.stageY - resizeOffset.y;
				resizeOffset.x = event.stageX;
				resizeOffset.y = event.stageY;
				update();
			}
		}
		
		private function stageMouseUp(event:MouseEvent):void
		{
			hScrollBar.onStageMouseUp(event);
			vScrollBar.onStageMouseUp(event);
			
			if (resizing)
			{
				resizing = false;
				focusInputField();
			}
		}
		
		private function onResizeAreaMouseDown(event:MouseEvent):void
		{
			resizeOffset.x = event.stageX;
			resizeOffset.y = event.stageY;
			resizing = true;
		}
		
		//
		// scroll bar events
		//
		private function scrollBarChange(event:Event):void
		{
			if (event.target == hScrollBar)
				textArea.scrollH = hScrollBar.getValue() + 1;
			else if (event.target == vScrollBar)
				textArea.scrollV = vScrollBar.getValue() + 1;
		}
	}

}
