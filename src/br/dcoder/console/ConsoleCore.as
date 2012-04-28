// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.
// Contributed:
// - 04/20/2012, Camille Reynders, http://www.creynders.be

package br.dcoder.console
{
	import br.dcoder.console.assets.AssetFactory;
	import br.dcoder.console.assets.DefaultAssetFactory;
	import br.dcoder.console.gui.CaptionBar;
	import br.dcoder.console.gui.InputField;
	import br.dcoder.console.gui.ResizeArea;
	import br.dcoder.console.gui.ScrollBar;
	import br.dcoder.console.gui.TextArea;
	import br.dcoder.console.plugin.ConsolePlugin;
	import br.dcoder.console.util.StringUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;

	/**
	 * AS3console component main class, where you can write/read data, throw/listen events, etc.
	 * You can use AS3console through Console class, where a single instance may be accessed from any point of the code,
	 * or creating a instance of the ConsoleCore class. Whether you instantiate this class, you must keep a reference to the object.
	 * However, cpln won't work (the alias is tied to Console static instance).
	 * Using instances of this class instead of Console single instance allows you to manage several different consoles.
	 * @see Console
	 */
	public class ConsoleCore
	{
		private static const DEFAULT_ALPHA:Number = 0.75;
		
		private var _config:ConsoleConfig;

		private var parent:DisplayObjectContainer;
		private var assetFactory:AssetFactory;
		private var eventDispatcher:IEventDispatcher;
		private var rect:Rectangle;
		private var plugins:Array;
		
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
		// constructor
		//
		/**
		 * Create an instance of AS3console component. If parent is non-null the instance will have a graphical interface,
		 * otherwise it runs in release mode.
		 * If assetFactory is null, a DefaultAssetFactory is used.<br>
		 * Note: parent object <b>MUST</b> be part of the display list in such way that parent.stage attribute is valid.
		 * @param parent DisplayObjectContainer to add console component. If this value is null, console runs in release mode.
		 * @param assetFactory Use to specify a non-default instance of AssetFactory.
		 * @param eventDispatcher An object to dispatch ConsoleCore events.
		 * @see br.dcoder.console.assets.AssetFactory
		 * @see br.dcoder.console.assets.DefaultAssetFactory
		 */
		public function ConsoleCore(parent:DisplayObjectContainer = null, assetFactory:AssetFactory = null, eventDispatcher:IEventDispatcher = null)
		{
			this.parent = parent;
			this.assetFactory = assetFactory;
			this.eventDispatcher = eventDispatcher || new EventDispatcher();
			
			_config = new ConsoleConfig();
			rect = new Rectangle(50, 50, 250, 250);
			plugins = [];
			
			init();
		}
		
		//
		// getters and setters
		//
		/**
		 * Check if console is running release mode.
		 */
		public function get release():Boolean
		{
			return parent == null;
		}
		
		/**
		 * ConsoleConfig instance related to this ConsoleCore object.
		 */
		public function get config():ConsoleConfig
		{
			return _config;
		}
		
		/**
		 * Gets/sets whether ConsoleCore object is resizable (default value is true).
		 * Setting this attribute to false, the console resize area won't be visible.
		 * If running release mode, this attribute is ignored.
		 */
		public function get resizable():Boolean
		{
			return release ? false : resizeArea.visible;
		}
		
		public function set resizable(_resizable:Boolean):void
		{
			if (!release)
				resizeArea.visible = _resizable;
		}
		
		/**
		 * Gets/sets whether ConsoleCore object is draggable (default value is true).
		 * You can drag the component clicking on the caption bar.
		 * If running release mode, this attribute is ignored.
		 */
		public function get draggable():Boolean
		{
			return release ? false : captionBar.draggable;
		}
		
		public function set draggable(_draggable:Boolean):void
		{
			if (!release)
				captionBar.draggable = _draggable;
		}
		
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
		 * Console transparecy. If running release mode, the value is always zero.
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
		 * Console caption text. If running release mode, caption bar text is always "" (empty string).
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
		
		//
		// public interface
		//
		/**
		 * Set asset factory instance.
		 * @param assetFactory New asset factory instance.
		 * @see br.dcoder.console.assets.DefaultAssetFactory
		 * @see br.dcoder.console.assets.HerculesAssetFactory
		 */
		public function setAssetFactory(assetFactory:AssetFactory):void
		{
			this.assetFactory = assetFactory;
			
			captionBar.setAssetFactory(assetFactory);
			textArea.setAssetFactory(assetFactory);
			inputField.setAssetFactory(assetFactory);
			hScrollBar.setAssetFactory(assetFactory);
			vScrollBar.setAssetFactory(assetFactory);
			resizeArea.setAssetFactory(assetFactory);
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
		 * Get IEventDispatcher object related to this instance.
		 * @return An object to dispatch the ConsoleCore events.
		 */
		public function getEventDispatcher():IEventDispatcher
		{
			return eventDispatcher;
		}
		
		/**
		 * Update console gaphical interface.
		 * It's automatically called when console area has changed or a new AssetFactory instance was set.
		 * If running release mode does nothing.
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
				captionBar.rect.x = 0;
				captionBar.rect.y = 0;
				captionBar.rect.width = rect.width;
				captionBar.rect.height = assetFactory.getButtonContainerSize();
				captionBar.update();
				
				// text area
				textArea.rect.x = 1;
				textArea.rect.y = 1;
				textArea.rect.width = rect.width - assetFactory.getButtonContainerSize() - 1;
				textArea.rect.height = rect.height - assetFactory.getButtonContainerSize() - assetFactory.getButtonContainerSize() - inputField.getMinimumHeight() - 1;
				textArea.scrollV = textArea.maxScrollV;
				textArea.update();
				
				// input field
				inputField.rect.x = 1;
				inputField.rect.y = rect.height - assetFactory.getButtonContainerSize() * 2 - inputField.getMinimumHeight();
				inputField.rect.width = rect.width - assetFactory.getButtonContainerSize();
				inputField.rect.height = inputField.getMinimumHeight();
				inputField.update();
				
				// horizontal scroll bar
				hScrollBar.rect.x = 0;
				hScrollBar.rect.y = rect.height - assetFactory.getButtonContainerSize() - assetFactory.getButtonContainerSize();
				hScrollBar.rect.width = 0; // value ignored
				hScrollBar.rect.height = 0; // value ignored
				hScrollBar.setLength(rect.width - assetFactory.getButtonContainerSize() + 1);
				hScrollBar.setMaxValue(textArea.maxScrollH == 0 ? 0 : textArea.maxScrollH - 1);
				hScrollBar.update();
				
				if (hScrollBar.getValue() > hScrollBar.getMaxValue())
					hScrollBar.toMaxValue();
				
				// vertical scroll bar
				vScrollBar.rect.x = rect.width - assetFactory.getButtonContainerSize();
				vScrollBar.rect.y = 0;
				vScrollBar.rect.width = 0; // value ignored
				vScrollBar.rect.height = 0; // value ignored 
				vScrollBar.setLength(rect.height - assetFactory.getButtonContainerSize() - assetFactory.getButtonContainerSize() + 1);
				vScrollBar.setMaxValue(textArea.maxScrollV == 0 ? 0 : textArea.maxScrollV - 1);
				vScrollBar.update();
				
				if (vScrollBar.getValue() > vScrollBar.getMaxValue())
					vScrollBar.toMaxValue();
				
				// resize area
				resizeArea.rect.x = hScrollBar.rect.left + hScrollBar.getLength();
				resizeArea.rect.y = vScrollBar.rect.top + vScrollBar.getLength();
				resizeArea.rect.width = 0; // value ignored
				resizeArea.rect.height = 0; // value ignored
				resizeArea.update();
			}
		}
		
		/**
		 * Show console component and throws ConsoleEvent.SHOW. If running release mode, does nothing.
		 * @see ConsoleEvent
		 */
		public function show():void
		{
			if (!release)
			{
				eventDispatcher.dispatchEvent(new ConsoleEvent(ConsoleEvent.SHOW));
				
				toFront();
				container.visible = true;
				inputField.getFocus();
			}
		}
		
		/**
		 * Hide console component and throws ConsoleEvent.HIDE. If running release mode, does nothing.
		 * @see ConsoleEvent
		 */
		public function hide():void
		{
			if (!release)
			{
				eventDispatcher.dispatchEvent(new ConsoleEvent(ConsoleEvent.HIDE));
				
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
		 * If running release mode, does nothing. 
		 */
		public function maximize():void
		{
			if (!release)
				content.visible = true;
		}
		
		/**
		 * Minimize console component, only caption bar remains visible.
		 * If running release mode, does nothing.
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
			{
				while (container.parent.getChildIndex(container) < container.parent.numChildren - 1)
				{
					container.parent.swapChildren(container, container.parent.getChildAt(container.parent.getChildIndex(container) + 1));
				}
			}
		}
		
		/**
		 * Clear console text. If running release mode, does nothing.
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
		 * traceEcho/jsEcho still works. 
		 * @param info Any information to be printed. If is null, "(null)" string is used.
		 * @see ConsoleConfig
		 * @see ConsoleEvent
		 */
		public function println(info:Object):void
		{
			// build string
			var str:String = StringUtil.check(info);
			
			if (config.printTimer)
				str = "[" + getTimer() + "] " + str;
			
			// throw events
			if (config.traceEcho)
				trace(str);
			
			if (config.jsEcho && ExternalInterface.available)
				ExternalInterface.call("console.log", "[AS3Console" + ConsoleConfig.VERSION + "] " + str);
			
			eventDispatcher.dispatchEvent(new ConsoleEvent(ConsoleEvent.OUTPUT, false, false, str));
			
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
				{
					toFront();
				}
			}
		}
		
		/**
		 * Install a plugin.
		 * @param plugin ConsolePlugin child class instance
		 */
		public function installPlugin(plugin:ConsolePlugin):void
		{
			plugins.push(plugin);
			plugin.install(this);
		}
		
		/**
		 * Get an array with all installed plugins.
		 * @return Plugins array
		 * @see br.dcoder.console.plugin.ConsolePlugin
		 * @see br.dcoder.console.plugin.ConsolePlugin#name
		 */
		public function getPlugins():Array
		{
			return plugins;
		}
		
		//
		// private methods
		//
		private function init():void
		{
			if (!release)
			{
				if (!assetFactory)
					assetFactory = new DefaultAssetFactory();
				
				container = new Sprite();
				parent.addChild(container);
				
				// caption bar
				captionBar = new CaptionBar(config, assetFactory);
				captionBar.text = "AS3console" + ConsoleConfig.VERSION;
				container.addChild(captionBar.getContent());
				
				captionBar.addEventListener(CaptionBar.START_DRAG_EVENT, startDrag);
				captionBar.addEventListener(CaptionBar.STOP_DRAG_EVENT, stopDrag);
				
				// content
				content = new Sprite();
				content.y = assetFactory.getButtonContainerSize();
				container.addChild(content);
				
				// text area
				textArea = new TextArea(config, assetFactory);
				content.addChild(textArea.getContent());
				
				textArea.addEventListener(TextArea.SCROLL_EVENT, textScroll);
				
				// input field
				inputField = new InputField(config, assetFactory);
				content.addChild(inputField.getContent());
				
				inputField.addEventListener(InputField.INPUT_EVENT, input);
				
				// scroll bars
				hScrollBar = new ScrollBar(config, assetFactory, ScrollBar.HORIZONTAL, 250);
				hScrollBar.setMaxValue(0);
				content.addChild(hScrollBar.getContent());
				
				hScrollBar.addEventListener(Event.CHANGE, hScrollBarChange);
				
				vScrollBar = new ScrollBar(config, assetFactory, ScrollBar.VERTICAL, 250);
				vScrollBar.setMaxValue(0);
				content.addChild(vScrollBar.getContent());
				
				vScrollBar.addEventListener(Event.CHANGE, vScrollBarChange);
				
				// resize area
				resizeArea = new ResizeArea(config, assetFactory);
				content.addChild(resizeArea.getContent());
				
				resizeArea.addEventListener(ResizeArea.RESIZE_EVENT, resize);
				resizeArea.addEventListener(ResizeArea.RESIZE_STOP_EVENT, resizeStop);
				
				// shortcut
				shortcutKeys = [ "m" ];
				shortcutStates = [ false ];
				shortcutUseAlt = false;
				shortcutUseCtrl = true;
				shortcutUseShift = false;
				
				// stage events
				parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				parent.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				
				// update component
				alpha = DEFAULT_ALPHA;
				update();
			}
		}
		
		private function handleEmbedCommands(params:Array):Boolean
		{
			var i:int;
			
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
				
				for (i = memUsed.length - 1; i >= 0; i--)
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
			else if (params[0] == "plugins")
			{
				var empty:Boolean = true;
				
				for (i = 0; i < plugins.length; i++)
				{
					var plugin:ConsolePlugin = plugins[i];
					cpln((i + 1) + ". " + plugin.name + ": " + plugin.description);
					
					if (empty)
						empty = false;
				}
				
				if (empty)
					cpln("No installed plugins.");
				
				cpln("");
				
				return true;
			}
			else if (params[0] == "version")
			{
				println("AS3console version " + ConsoleConfig.VERSION);
				println("Created by Disturbed Coder.");
				println("Project page: https://github.com/loteixeira/as3console");
				println("");
				
				return true;
			}
			
			return false;
		}
		
		//
		// gui elements events
		//
		private function resize(event:Event):void
		{
			rect.width += resizeArea.widthOffset;
			rect.height += resizeArea.heightOffset;
			update();
			
			eventDispatcher.dispatchEvent(new ConsoleEvent(ConsoleEvent.RESIZE));
		}
		
		private function resizeStop(event:Event):void
		{
			inputField.getFocus();
		}
		
		private function vScrollBarChange(event:Event):void
		{
			textArea.scrollV = vScrollBar.getValue() + 1;
		}
		
		private function hScrollBarChange(event:Event):void
		{
			textArea.scrollH = hScrollBar.getValue() + 1;
		}
		
		private function input(event:Event):void
		{
			println("> " + inputField.getText());
			
			if (!handleEmbedCommands(inputField.getText().split(" ")))
			{
				eventDispatcher.dispatchEvent(new ConsoleEvent(ConsoleEvent.INPUT, false, false,  inputField.getText()));
			}
		}
		
		private function textScroll(event:Event):void
		{
			vScrollBar.setValue(textArea.scrollV - 1);
		}
		
		private function stopDrag(event:Event):void
		{
			container.stopDrag();
			rect.x = container.x;
			rect.y = container.y;
			inputField.getFocus();
		}
		
		private function startDrag(event:Event):void
		{
			toFront();
			container.startDrag();
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