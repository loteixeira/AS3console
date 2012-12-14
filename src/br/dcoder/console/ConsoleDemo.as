// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import br.dcoder.console.*;
	import br.dcoder.console.assets.DefaultAssetFactory;
	import br.dcoder.console.assets.HerculesAssetFactory;
	import br.dcoder.console.plugin.CodeEval;
	import br.dcoder.console.plugin.LocalClient;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	[SWF(width="800", height="600", backgroundColor="#FFFFFF", frameRate="30")]
	
	public class ConsoleDemo extends Sprite
	{
		private var assetFactoryName:String;
		
		public function ConsoleDemo()
		{
			assetFactoryName = "default";
			
			Console.create(this);
			Console.instance.getEventDispatcher().addEventListener(ConsoleEvent.INPUT, consoleInput);

			cpln("Starting AS3console Demo by Lucas Teixeira (Disturbed Coder)");
			cpln("Project page: https://github.com/loteixeira/as3console");
			cpln("Type 'help' for commands.");
			cpln("Press Ctrl+M to show/hide console component.");
			cpln("Press up/down arrow to navigate through input history.");
			cpln("");

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		private function consoleInput(event:ConsoleEvent):void
		{
			var args:Array = event.text.split(" ");
			
			if (args[0] == "help")
			{
				cpln("AS3console embed commands:");
				cpln("==========================");
				cpln("- alpha [value]");
				cpln("  Set console alpha if value is defined.");
				cpln("  Otherwise print current alpha.");
				cpln("- clear");
				cpln("  Clear console text.");
				cpln("- hide");
				cpln("  Hide console component.");
				cpln("- mem");
				cpln("  Print memory amount used by flash application.");
				cpln("- plugins");
				cpln("  List installed plugins.");
				cpln("- version");
				cpln("  Print console version.");
				cpln("");
				cpln("AS3console demo commands:");
				cpln("=========================");
				cpln("- assetFactory [name]");
				cpln("  Set console AssetFacotry if name is defined. Valid values are: default and hercules");
				cpln("  Otherwise print current AssetFactory.");
				cpln("");
			}
			else if (args[0] == "assetFactory")
			{
				if (args.length == 1)
				{
					cpln("Current asset factory: " + assetFactoryName);
					cpln("");
				}
				else if (args.length == 2)
				{
					if (args[1] != "default" && args[1] != "hercules")
					{
						cpln("Error: valid asset factories are default and hercules");
						cpln("");
					}
					else
					{
						assetFactoryName = args[1];
						
						if (assetFactoryName == "default")
						{
							Console.instance.setAssetFactory(new DefaultAssetFactory());
						}
						else if (assetFactoryName == "hercules")
						{
							Console.instance.setAssetFactory(new HerculesAssetFactory());
						}
					}
				}
			}
			else
			{
				cpln("Error: command " + args[0] + " is unknown");
				cpln("");
			}
		}
	}
}
