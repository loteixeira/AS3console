// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import br.dcoder.console.*;
	import br.dcoder.console.plugin.CodeEval;
	import br.dcoder.console.plugin.LocalClient;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ConsoleDemo extends Sprite
	{		
		public function ConsoleDemo()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Console.create(stage);
			CodeEval.start(this);
			LocalClient.start();
			
			Console.getInstance().addEventListener(ConsoleEvent.INPUT, consoleInput);
			Console.getInstance().area = new Rectangle(50, 50, 500, 400);
			cpln("Starting Console Demo by Lucas Teixeira (Disturbed Coder)");
			cpln("Project page: https://github.com/loteixeira/as3console");
			cpln("Type 'help' for commands.");
			cpln("Press Ctrl+M to show/hide console component.");
			cpln("Press up/down arrow to navigate through input history.");
			cpln("");
		}
		
		private function consoleInput(event:ConsoleEvent):void
		{
			var args:Array = event.text.split(" ");
			
			if (args[0] == "help")
			{
				cpln("AS3Console Demo Help:");
				cpln("=====================");
				cpln("- alpha [value]");
				cpln("  Set console alpha if value is defined.");
				cpln("  Otherwise print current alpha.");
				cpln("- clear");
				cpln("  Clear console text.");
				cpln("- hide");
				cpln("  Hide console component.");
				cpln("- mem");
				cpln("  Print memory amount used by flash application.");
				cpln("- version");
				cpln("  Print console version.");
				cpln("");
			}
			else
			{
				cpln("Error: command " + args[0] + " is unknown");
				cpln("");
			}
		}
	}
}
