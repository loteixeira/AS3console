package br.dcoder.console.gui
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import br.dcoder.console.Console;
	import br.dcoder.console.assets.AssetFactory;

	/**
	 * @author lteixeira
	 */
	public class InputField extends GUIBaseElement
	{
		public static const INPUT_EVENT:String = "inputEvent";
		
		private var textField:TextField;
		private var inputHistory:Array;
		private var historyIndex:int;
			
		public function InputField(assetFactory:AssetFactory)
		{
			super(assetFactory);
			
			// setup text field
			textField = new TextField();
			textField.background = true;
			textField.type = TextFieldType.INPUT;
			textField.addEventListener(KeyboardEvent.KEY_DOWN, textFieldKeyDown);
			content.addChild(textField);
			
			// input history
			inputHistory = new Array();
			historyIndex = -1; 
			
			// update text format
			updateTextFormat();
		}
		
		public function getMinimumHeight():int
		{
			return textField.textHeight * 1.3; 
		}
		
		public function getFocus():void
		{
			content.stage.focus = textField;
			textField.setSelection(textField.text.length, textField.text.length);
		}
		
		public function getText():String
		{
			return textField.text;
		}
		
		public override function update():void
		{
			updateTextFormat();
			
			textField.x = rect.left;
			textField.y = rect.top;
			textField.width = rect.width;
			textField.height = rect.height;
			textField.backgroundColor = assetFactory.getButtonBackgroundColor();
		}
		
		private function updateTextFormat():void
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = assetFactory.getButtonForegroundColor();
			textFormat.font = assetFactory.getFontName();
			textFormat.size = assetFactory.getLogFontSize();
			textField.defaultTextFormat = textFormat;
		}
		
		private function textFieldKeyDown(event:KeyboardEvent):void
		{
			// enter key pressed
			if (event.charCode == 13)
			{
				dispatchEvent(new Event(INPUT_EVENT));

				inputHistory.splice(0, 0, textField.text);
					
				while (inputHistory.length > Console.MAX_INPUT_HISTORY)
					inputHistory.pop();
				
				textField.text = "";
				historyIndex = -1;
			// up key pressed
			} else if (event.keyCode == 38) {
				if (historyIndex < inputHistory.length - 1)
					historyIndex++;
					
				if (inputHistory.length > 0)
					textField.text = inputHistory[historyIndex];
			// down key pressed
			} else if (event.keyCode == 40) {
				if (historyIndex >= 0)
					historyIndex--;
				
				if (historyIndex == -1)
					textField.text = "";
				else
					textField.text = inputHistory[historyIndex];
			}
		}
	}
}
