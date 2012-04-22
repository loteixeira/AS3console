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
	
	import br.dcoder.console.Console;
	import br.dcoder.console.assets.AssetFactory;

	/**
	 * @author lteixeira
	 */
	public class TextArea extends GUIBaseElement
	{
		public static const SCROLL_EVENT:String = "scrollEvent";
		
		private var textField:TextField;
		
		public function TextArea(assetFactory:AssetFactory)
		{
			super(assetFactory);
			
			// setup text field
			textField = new TextField();
			textField.multiline = true;
			textField.addEventListener(MouseEvent.MOUSE_WHEEL, textFieldMouseWheel);
			content.addChild(textField);
		}
		
		public function get scrollH():int
		{
			return textField.scrollH;
		}
		
		public function set scrollH(value:int):void
		{
			textField.scrollH = value;
		}
		
		public function get scrollV():int
		{
			return textField.scrollV;
		}
		
		public function set scrollV(value:int):void
		{
			textField.scrollV = value;
		}
		
		public function get maxScrollH():int
		{
			return textField.maxScrollH;
		}
		
		public function get maxScrollV():int
		{
			return textField.maxScrollV;
		}
		
		public function clear():void
		{
			textField.text = "";
		}
		
		public function writeln(str:String):void
		{
			while (str.length > Console.MAX_LINE_LENGTH)
			{
				var tmp:String = str.substr(0, Console.MAX_LINE_LENGTH);
				textField.appendText(tmp + "\n");
				str = str.substr(Console.MAX_LINE_LENGTH);
			}

			textField.appendText(str);
			textField.appendText("\n");
			
			if (textField.length > Console.MAX_CHARACTERS)
				textField.replaceText(0, textField.length - Console.MAX_CHARACTERS, "");
		}
		
		public override function update():void
		{
			// update text format
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = assetFactory.getButtonForegroundColor();
			textFormat.font = assetFactory.getFontName();
			textFormat.size = assetFactory.getLogFontSize();
			textField.defaultTextFormat = textFormat;
			
			// update text field
			textField.x = rect.left;
			textField.y = rect.top;
			textField.width = rect.width;
			textField.height = rect.height;
		}
		
		private function textFieldMouseWheel(event:MouseEvent):void
		{
			dispatchEvent(new Event(SCROLL_EVENT));
		}
	}
}
