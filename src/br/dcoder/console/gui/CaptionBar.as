// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console.gui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import br.dcoder.console.ConsoleConfig;
	import br.dcoder.console.assets.AssetFactory;
	import br.dcoder.console.util.StringUtil;

	/**
	 * @author lteixeira
	 */
	public class CaptionBar extends GUIBaseElement
	{
		public static const START_DRAG_EVENT:String = "startDragEvent";
		public static const STOP_DRAG_EVENT:String = "stopDragEvent";
		
		private var _draggable:Boolean;
		private var textField:TextField;
		
		public function CaptionBar(config:ConsoleConfig, assetFactory:AssetFactory)
		{
			super(config, assetFactory);
			
			_draggable = true;

			// setup content
			content.addEventListener(MouseEvent.MOUSE_UP, contentMouseUp);
			content.addEventListener(MouseEvent.MOUSE_DOWN, contentMouseDown);
			content.buttonMode = true;
			
			// setup text field
			textField = new TextField();
			textField.mouseEnabled = false;
			textField.selectable = false;
			textField.y = 2;
			content.addChild(textField);
		}

		public function get visible():Boolean
		{
			return content.visible;
		}
		
		public function set visible(_visible:Boolean):void
		{
			content.visible = _visible;
		}
		
		public function get draggable():Boolean
		{
			return _draggable;
		}
		
		public function set draggable(_draggable:Boolean):void
		{
			this._draggable = _draggable;
			content.buttonMode = _draggable;
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function set text(value:String):void
		{
			textField.text = StringUtil.check(value);
		}
		
		public override function update():void
		{
			// draw background
			content.graphics.clear();
			content.graphics.lineStyle(1, assetFactory.getButtonForegroundColor());
			content.graphics.beginFill(assetFactory.getButtonBackgroundColor());
			content.graphics.drawRect(0, 0, rect.width - 1, rect.height);
			content.graphics.endFill();
			
			// update text format
			var textFormat:TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.bold = true;
			textFormat.color = assetFactory.getButtonForegroundColor();
			textFormat.font = assetFactory.getFontName();
			textFormat.size = assetFactory.getCaptionFontSize();
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
			
			// update text field
			textField.width = rect.width;
			textField.height = rect.height;
			textField.y = (rect.height - textField.textHeight) / 2;
		}
		
		private function contentMouseUp(event:MouseEvent):void
		{
			if (_draggable)
			{
				dispatchEvent(new Event(STOP_DRAG_EVENT));
			}
		}
		
		private function contentMouseDown(event:MouseEvent):void
		{
			if (_draggable)
			{
				dispatchEvent(new Event(START_DRAG_EVENT));
			}
		}
	}
}
