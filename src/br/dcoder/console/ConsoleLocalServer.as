package br.dcoder.console
{
	import br.dcoder.console.plugin.LocalServer;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author lteixeira
	 */
	public class ConsoleLocalServer extends Sprite
	{
		public function ConsoleLocalServer()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			Console.create(stage);
			Console.getInstance().caption = "Console Local Server";
			
			LocalServer.start();
			
			stage.addEventListener(Event.RESIZE, resize);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		private function resize(event:Event):void
		{
			Console.getInstance().area = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		}
	}
}
