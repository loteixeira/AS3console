// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.
//
// Contributed:
// - 04/20/2012, Camille Reynders, http://www.creynders.be

package br.dcoder.console
{
	import br.dcoder.console.assets.*;
	import br.dcoder.console.gui.*;
	import br.dcoder.console.plugin.*;
	import br.dcoder.console.util.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.geom.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;

	/**
	 * AS3console component main class, where you can write/read data, throw/listen events, etc.
	 * You can use AS3console through <code>Console</code> class, where a single instance may be accessed from any point of the code,
	 * or creating an instance of <code>ConsoleCore</code> class. If you instantiate this class you must keep a reference to the object
	 * and <code>cpln</code> don't work (this alias is tied to <code>Console</code> static instance).<br/>
	 * Using instances of this class instead of <code>Console</code> single instance allows you to manage several different consoles.<br/><br/>
	 * <strong>Console embed commands: </strong><br/><br/>
	 * There are some embed input commands that you can type in console window:
	 * <li>alpha [value]: get console component alpha value, if value exists set console alpha.</li>
	 * <li>clear: clear console text area.</li>
	 * <li>hide: hide console window.</li>
	 * <li>mem: show memory used by the flash player.</li>
	 * <li>plugins: list installed plugins.</li>
	 * <li>version: print console version details.</li><br/><br/>
	 * Everytime text is inserted into console input field <code>ConsoleEvent.INPUT</code> event is thrown, if the text isn't a embed command.
	 * @see Console
	 * @see ConsoleEvent
	 * @see br.dcoder.console.plugin.ConsolePlugin
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

		private var buffering:Boolean;
		private var buffer:Array;
		
		//
		// constructor
		//
		/**
		 * Create an instance of AS3console component. If parent is non-null the instance will have a graphical interface,
		 * otherwise it runs in release mode (only throwing events and responding to <code>config.traceEcho</code> and <code>config.jsEcho</code>).
		 * If <code>assetFactory</code> is null, a instance of <code>DefaultAssetFactory</code> is created.<br/>
		 * If you want a single instance through static <code>Console</code> class, see <code>Console.create()</code> method.<br/>
		 * Note: parent object <b>MUST</b> be part of the display list in such way that parent.stage attribute is valid.
		 * @param parent An instance of <code>DisplayObjectContainer</code> to add console component as child. If this value is null, console runs in release mode.
		 * @param assetFactory Use to specify a non-default instance of <code>AssetFactory</code>.
		 * @param eventDispatcher An object to dispatch <code>ConsoleCore</code> events.
		 * @see Console#create()
		 * @see ConsoleConfig
		 * @see br.dcoder.console.assets.AssetFactory
		 * @see br.dcoder.console.assets.DefaultAssetFactory
		 */
		public function ConsoleCore(parent:DisplayObjectContainer = null, assetFactory:AssetFactory = null, eventDispatcher:IEventDispatcher = null)
		{
			this.parent = parent;
			this.assetFactory = assetFactory;
			this.eventDispatcher = eventDispatcher || new EventDispatcher();
			
			_config = new ConsoleConfig();
			rect = new Rectangle(50, 50, 500, 400);
			plugins = [];

			buffering = true;
			buffer = [];
			
			if (parent)
			{
				if (parent.stage)
					init(null);
				else
					parent.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		//
		// getters and setters
		//
		/**
		 * Check whether console is running release mode.
		 * If <code>parent</code> value was null in <code>ConsoleCore</code> constructor or <code>stage</code> value was null in <code>Console</code> create method, console will run in release mode.
		 * @see #ConsoleCore()
		 * @see Console#create()
		 */
		public function get release():Boolean
		{
			return parent == null;
		}
		
		/**
		 * ConsoleConfig instance related to this <code>ConsoleCore</code> object.
		 */
		public function get config():ConsoleConfig
		{
			return _config;
		}
		
		/**
		 * Defines whether <code>ConsoleCore</code> object is resizable (default value is true).
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
		 * Defines whether <code>ConsoleCore</code> object is draggable (default value is true).
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
		 * Defines whether console graphical component has a title bar.
		 * If running release mode, this attribute is ignored.
		 */
		public function get titlebar():Boolean
		{
			return release ? false : captionBar.visible;
		}

		public function set titlebar(_titlebar:Boolean):void
		{
			if (!release)
			{
				captionBar.visible = _titlebar;
				update();
			}
		}
		
		/**
		 * Console position and dimension represented by a <code>Rectangle</code> object.
		 * This call will cause this instance to update the component graphical interface.
		 * @see #update()
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
		 * Set asset factory instance. <code>AssetFactory</code> class is used to defined how console graphical interface will render itself.
		 * This call will cause this instance to update the component graphical interface.
		 * @param assetFactory New asset factory instance.
		 * @see #update()
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
		 * Get the <code>IEventDispatcher</code> object related to this instance.
		 * @return An object to dispatch the ConsoleCore events.
		 */
		public function getEventDispatcher():IEventDispatcher
		{
			return eventDispatcher;
		}
		
		/**
		 * Update console graphical interface, redrawing all components.
		 * It's automatically called when console area has changed or a new <code>AssetFactory</code> instance was set.
		 * If running release mode does nothing.
		 * @see #area
		 * @see #setAssetFactory()
		 */
		public function update():void
		{
			if (!release)
			{
				// draw background
				content.y = captionBar.visible ? assetFactory.getButtonContainerSize() : 0;
				content.graphics.clear();
				content.graphics.lineStyle(1, assetFactory.getButtonForegroundColor());
				content.graphics.beginFill(assetFactory.getBackgroundColor());
				content.graphics.drawRect(0, 0, rect.width - 1, rect.height - 1 - (captionBar.visible ? assetFactory.getButtonContainerSize() : 0));
				content.graphics.endFill();
				
				// container
				container.x = rect.left;
				container.y = rect.top;
				
				// caption bar
				if (captionBar.visible)
				{
					captionBar.rect.x = 0;
					captionBar.rect.y = 0;
					captionBar.rect.width = rect.width;
					captionBar.rect.height = assetFactory.getButtonContainerSize();
					captionBar.update();
				}
				
				// text area
				textArea.rect.x = 1;
				textArea.rect.y = 1;
				textArea.rect.width = rect.width - assetFactory.getButtonContainerSize() - 1;
				textArea.rect.height = rect.height - assetFactory.getButtonContainerSize() - inputField.getMinimumHeight() - 1 - (captionBar.visible ? assetFactory.getButtonContainerSize() : 0);
				textArea.scrollV = textArea.maxScrollV;
				textArea.update();
				
				// input field
				inputField.rect.x = 1;
				inputField.rect.y = rect.height - assetFactory.getButtonContainerSize() - inputField.getMinimumHeight() - (captionBar.visible ? assetFactory.getButtonContainerSize() : 0);
				inputField.rect.width = rect.width - assetFactory.getButtonContainerSize();
				inputField.rect.height = inputField.getMinimumHeight();
				inputField.update();
				
				// horizontal scroll bar
				hScrollBar.rect.x = 0;
				hScrollBar.rect.y = rect.height - assetFactory.getButtonContainerSize() - 1 - (captionBar.visible ? assetFactory.getButtonContainerSize() : 0);
				hScrollBar.rect.width = 0; // value ignored
				hScrollBar.rect.height = 0; // value ignored
				hScrollBar.setLength(rect.width - assetFactory.getButtonContainerSize() - 1);
				hScrollBar.setMaxValue(textArea.maxScrollH == 0 ? 0 : textArea.maxScrollH - 1);
				hScrollBar.update();
				
				if (hScrollBar.getValue() > hScrollBar.getMaxValue())
					hScrollBar.toMaxValue();
				
				// vertical scroll bar
				vScrollBar.rect.x = rect.width - assetFactory.getButtonContainerSize() - 1;
				vScrollBar.rect.y = 0;
				vScrollBar.rect.width = 0; // value ignored
				vScrollBar.rect.height = 0; // value ignored 
				vScrollBar.setLength(rect.height - assetFactory.getButtonContainerSize() - 1 - (captionBar.visible ? assetFactory.getButtonContainerSize() : 0));
				vScrollBar.setMaxValue(textArea.maxScrollV == 0 ? 0 : textArea.maxScrollV - 1);
				vScrollBar.update();
				
				if (vScrollBar.getValue() > vScrollBar.getMaxValue())
					vScrollBar.toMaxValue();
				
				// resize area
				resizeArea.rect.x = hScrollBar.rect.left + hScrollBar.getLength() + 1;
				resizeArea.rect.y = vScrollBar.rect.top + vScrollBar.getLength() + 1;
				resizeArea.rect.width = 0; // value ignored
				resizeArea.rect.height = 0; // value ignored
				resizeArea.update();
			}
		}
		
		/**
		 * Show console component and throws <code>ConsoleEvent.SHOW</code>. If running release mode, does nothing.
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
		 * Hide console component and throws <code>ConsoleEvent.HIDE</code>. If running release mode, does nothing.
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
		 * Invert console visibility. If visible, hide it. If hidden, show it.
		 */
		public function invertVisibility():void
		{
			if (isVisible())
				hide();
			else
				show();
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
		 * Print information in console text area plus "\n". This method throws <code>ConsoleEvent.OUTPUT</code>. If running release mode, the event will be thrown and
		 * <code>config.traceEcho</code>/<code>config.jsEcho</code> still work. 
		 * @param info Any information to be printed. If is null, "(null)" string is used.
		 * @see ConsoleConfig
		 * @see ConsoleEvent
		 */
		public function println(info:Object):void
		{
			// if we're buffering, save data to print later
			if (buffering)
			{
				buffer.push(info);
				return;
			}

			// build string
			var str:String = StringUtil.check(info);
			
			if (config.printTimer)
				str = "[" + getTimer() + "] " + str;

			// throw events
			if (config.traceEcho)
				getDefinitionByName("trace")(str);
			
			if (config.jsEcho && ExternalInterface.available)
				ExternalInterface.call("console.log", "[AS3console" + ConsoleConfig.VERSION + "] " + str);
			
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
					toFront();
			}
		}

		/**
		 * Process data input. If isn't an embed command, <code>ConsoleEvent.INPUT</code> is thrown.
		 * @param info Any information to be scanned. If is null, "(null)" string is used.
		 * @see ConsoleEvent
		 */
		public function scan(info:Object):void
		{
			var str:String = StringUtil.check(info);

			if (!config.embedCommands || (config.embedCommands && !handleEmbedCommands(str.split(" "))))
				eventDispatcher.dispatchEvent(new ConsoleEvent(ConsoleEvent.INPUT, false, false,  str));
		}
		
		/**
		 * Install a plugin.
		 * @param plugin <code>ConsolePlugin</code> child class instance
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
		 */
		public function getPlugins():Array
		{
			return plugins;
		}
		
		//
		// private methods
		//
		private function init(e:Event):void
		{
			if (e)
				parent.removeEventListener(Event.ADDED_TO_STAGE, init);

			// do we need a new asset factory?
			if (!assetFactory)
				assetFactory = new DefaultAssetFactory();
				
			// console container
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

			// create context menu item
			if (!(parent is Stage))
			{
				var contextMenu:ContextMenu = new ContextMenu();
				var contextMenuItem:ContextMenuItem = new ContextMenuItem("AS3console" + ConsoleConfig.VERSION);
				contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItemClick);
				contextMenu.customItems.push(contextMenuItem);
				parent.contextMenu = contextMenu;
			}
			else
			{
				println("WARNING: can't create context menu in stage");
			}

			// write buffered data
			if (buffering)
			{
				buffering = false;

				for (var i:uint = 0; i < buffer.length; i++)
					println(buffer[i]);
			
				buffer = null;
			}
		}

		private function contextMenuItemClick(e:ContextMenuEvent):void
		{
			invertVisibility();
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
					println((i + 1) + ". " + plugin.name + ": " + plugin.description);
					
					if (empty)
						empty = false;
				}
				
				if (empty)
					println("No installed plugins.");
				
				println("");
				
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
			scan(inputField.getText());
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
				invertVisibility();
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