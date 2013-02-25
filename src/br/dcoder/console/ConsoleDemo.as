// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import br.dcoder.console.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	[SWF(width="800", height="600", backgroundColor="#FFFFFF", frameRate="30")]
	
	public class ConsoleDemo extends Sprite
	{
		private var intervalId:int;

		public function ConsoleDemo()
		{			
			// create console singleton instance
			Console.create(this);
			// listen for input events
			Console.instance.getEventDispatcher().addEventListener(ConsoleEvent.INPUT, consoleInput);

			// welcome text
			cpln("Starting AS3console demo");
			cpln("Project page: https://github.com/loteixeira/as3console");
			cpln("");
			cpln("AS3console is a generic input/output system.");
			cpln("Using a unique method call you can send the output data to anywhere.");
			cpln("Also, you can enter text (similiar to C++ native consoles).");
			cpln("Enough chatting.");
			cpln("");
			cpln("Type 'start' to continue...");

			// used for drawing
			intervalId = -1;

			// stage stuff
			if (stage)
				addedToStage(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		private function addedToStage(e:Event):void
		{
			if (e)
				removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function consoleInput(e:ConsoleEvent):void
		{
			var args:Array = e.text.split(" ");

			// start command
			if (args[0] == "start")
			{
				if (intervalId != -1)
				{
					cpln("Already started! Doh!");
				}
				else
				{
					graphics.clear();
					intervalId = setInterval(draw, 500);
					cpln("Type 'stop' to cancel...");
				}
			}
			// stop command
			else if (args[0] == "stop")
			{
				clearInterval(intervalId);
				intervalId = -1;
				cpln("Turning off..");
				cpln("\nHey! Try enter my embedded commands:\nalpha, clear, hide, mem, plugins, version\n");
			}
		}

		private function draw():void
		{
			var color:uint = Math.round(Math.random() * 0xffffff);
			var x:Number = Math.random() * stage.stageWidth;
			var y:Number = Math.random() * stage.stageHeight;
			var w:Number = Math.random() * (stage.stageWidth - x);
			var h:Number = Math.random() * (stage.stageHeight - y);
			var shape:String = Math.round(Math.random()) == 0 ? "rect" : "ellipse";

			graphics.beginFill(color);

			if (shape == "rect")
				graphics.drawRect(x, y, w ,h);
			else if (shape == "ellipse")
				graphics.drawEllipse(x, y, w, h);

			graphics.endFill();

		}
	}
}
