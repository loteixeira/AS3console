// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console.gui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import br.dcoder.console.ConsoleConfig;
	import br.dcoder.console.assets.AssetFactory;

	/**
	 * @author lteixeira
	 */
	public class ResizeArea extends GUIBaseElement
	{
		public static const RESIZE_EVENT:String = "resizeEvent";
		public static const RESIZE_STOP_EVENT:String = "resizeStopEvent";
		
		private var resizeOffset:Point;
		private var resizing:Boolean;
		private var _widthOffset:int, _heightOffset:int;
		
		public function ResizeArea(config:ConsoleConfig, assetFactory:AssetFactory)
		{
			super(config, assetFactory);
			
			resizeOffset = new Point();
			resizing = false;
			
			content.buttonMode = true;
			content.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void
			{
				resizeOffset.x = event.stageX;
				resizeOffset.y = event.stageY;
				resizing = true;
			});
			
			content.addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void
			{
				content.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
				content.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			});
		}
		
		public function get visible():Boolean
		{
			return content.visible;
		}
		
		public function set visible(_visible:Boolean):void
		{
			content.visible = _visible;
		}
		
		public function get widthOffset():int
		{
			return _widthOffset;
		}
		
		public function get heightOffset():int
		{
			return _heightOffset;
		}
		
		public override function update():void
		{
			content.graphics.clear();
			content.graphics.beginFill(assetFactory.getBackgroundColor());
			content.graphics.drawRect(0, 0, assetFactory.getButtonContainerSize() - 2, assetFactory.getButtonContainerSize() - 2);
			content.graphics.endFill();

			content.graphics.lineStyle(1, assetFactory.getButtonForegroundColor());			
			content.graphics.beginFill(assetFactory.getButtonBackgroundColor());
			content.graphics.moveTo(assetFactory.getButtonContainerSize() - 4, 3);
			content.graphics.lineTo(assetFactory.getButtonContainerSize() - 4, assetFactory.getButtonContainerSize() - 4);
			content.graphics.lineTo(3, assetFactory.getButtonContainerSize() - 4);
			content.graphics.endFill();
			
			content.x = rect.left;
			content.y = rect.top;
		}
		
		private function stageMouseMove(event:MouseEvent):void
		{
			if (resizing)
			{
				_widthOffset = event.stageX - resizeOffset.x;
				_heightOffset = event.stageY - resizeOffset.y;
				resizeOffset.x = event.stageX;
				resizeOffset.y = event.stageY;
				dispatchEvent(new Event(RESIZE_EVENT));
			}
		}
		
		private function stageMouseUp(event:MouseEvent):void
		{
			if (resizing)
			{
				resizing = false;
				dispatchEvent(new Event(RESIZE_STOP_EVENT));
			}
		}
	}
}
