// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: http://code.google.com/p/as3console/
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	internal class ScrollBar extends Sprite
	{
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		private static const MOVEMENT_INTERVAL:uint = 50;
		
		private var assetFactory:AssetFactory;
		private var orientation:String;
		private var length:uint;
		
		private var maxValue:uint;
		private var value:uint, nextValue:uint;
		private var startTime:uint;
		private var increment:Boolean;
		private var decrement:Boolean;
		private var thumbDragOffset:int;
		private var draggingThumb:Boolean;
		
		private var incArrow:Sprite, decArrow:Sprite;
		private var incButton:Sprite, decButton:Sprite;
		private var thumb:Sprite;
		
		
		//
		// constructor
		//
		public function ScrollBar(assetFactory:AssetFactory, orientation:String, length:uint)
		{
			this.assetFactory = assetFactory;
			this.orientation = orientation;
			this.length = length;
			
			maxValue = 10;
			value = nextValue = 0;
			startTime = 0;
			increment = false;
			decrement = false;
			thumbDragOffset = 0;
			draggingThumb = false;
			
			decButton = new Sprite();
			decButton.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			decButton.addEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
			decButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
			decButton.buttonMode = true;
			addChild(decButton);
			
			incButton = new Sprite();
			incButton.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			incButton.addEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
			incButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
			incButton.buttonMode = true;
			addChild(incButton);
			
			decArrow = new Sprite();
			decArrow.mouseEnabled = false;
			decArrow.rotation = (orientation == HORIZONTAL ? 0 : 90);
			addChild(decArrow);
			
			incArrow = new Sprite();
			incArrow.mouseEnabled = false;
			incArrow.rotation = (orientation == HORIZONTAL ? 180 : 270);
			addChild(incArrow);
			
			thumb = new Sprite();
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
			thumb.buttonMode = true;
			addChild(thumb);
			
			assetFactory.drawButton(incButton, assetFactory.getButtonSize(), assetFactory.getButtonSize());
			assetFactory.drawButton(decButton, assetFactory.getButtonSize(), assetFactory.getButtonSize());
			assetFactory.drawArrow(incArrow, assetFactory.getButtonSize() / 2, assetFactory.getButtonSize() / 2);
			assetFactory.drawArrow(decArrow, assetFactory.getButtonSize() / 2, assetFactory.getButtonSize() / 2);
			
			draw();
			
			addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		
		//
		// public interface
		//
		public function getOrientation():String
		{
			return orientation;
		}
		
		public function getLength():uint
		{
			return length;
		}
		
		public function setLength(length:uint):void
		{
			this.length = length;
			draw();
		}
		
		public function getMaxValue():uint
		{
			return maxValue;
		}
		
		public function setMaxValue(maxValue:uint):void
		{
			this.maxValue = maxValue;
			draw();
		}
		
		public function getValue():uint
		{
			return value;
		}
		
		public function setValue(value:uint):void
		{
			this.value = value;
			drawThumb();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function toMaxValue():void
		{
			setValue(maxValue);
		}
		
		public function getWidth():uint
		{
			return (orientation == HORIZONTAL ? length : assetFactory.getButtonContainerSize());
		}
		
		public function getHeight():uint
		{
			return (orientation == HORIZONTAL ? assetFactory.getButtonContainerSize() : length);
		}
		
		public function draw():void
		{
			var width:uint = getWidth();
			var height:uint = getHeight();
			
			graphics.clear();
			graphics.lineStyle(1, assetFactory.getButtonForegroundColor());
			graphics.beginFill(assetFactory.getBackgroundColor());
			graphics.drawRect(0, 0, width - 1, height - 1);
			graphics.endFill();
			
			drawThumb();

			var halfDistance:Number = (assetFactory.getButtonContainerSize() - assetFactory.getButtonSize()) / 2;
			
			decButton.x = halfDistance;
			decButton.y = halfDistance;
			incButton.x = (orientation == HORIZONTAL ? length - assetFactory.getButtonSize() - halfDistance : halfDistance);
			incButton.y = (orientation == HORIZONTAL ? halfDistance : length - assetFactory.getButtonSize() - halfDistance);
			decArrow.x = decButton.x + assetFactory.getButtonSize() / 2;
			decArrow.y = decButton.y + assetFactory.getButtonSize() / 2;
			incArrow.x = incButton.x + assetFactory.getButtonSize() / 2;
			incArrow.y = incButton.y + assetFactory.getButtonSize() / 2;
		}
		
		// must be called by container class
		public function onStageMouseMove(event:MouseEvent):void
		{
			if (draggingThumb)
			{
				var pos:Point = globalToLocal(new Point(event.stageX, event.stageY));
				var thumbValue:int = getThumbValue((orientation == HORIZONTAL ? pos.x : pos.y) - thumbDragOffset);
				
				if (thumbValue < 0)
					thumbValue = 0;
				else if (thumbValue > maxValue)
					thumbValue = maxValue;
				
				nextValue = thumbValue;
					
				if (startTime == 0)
					startTime = getTimer();
			}
		}
		
		// must be called by container class
		public function onStageMouseUp(event:MouseEvent):void
		{
			draggingThumb = false;
		}
		
		
		//
		// private methods
		//		
		private function drawThumb():void
		{
			var thumbSize:uint = assetFactory.getButtonContainerSize() - (assetFactory.getButtonContainerSize() - assetFactory.getButtonSize());

			var thumbWidth:uint = (orientation == HORIZONTAL ? getThumbLength() : thumbSize);
			var thumbHeight:uint = (orientation == HORIZONTAL ? thumbSize : getThumbLength());
			
			var thumbPos:Number = getThumbPos(value);
			var thumbOffset:uint = (assetFactory.getButtonContainerSize() - assetFactory.getButtonSize()) / 2;
			
			assetFactory.drawButton(thumb, thumbWidth, thumbHeight);
			
			thumb.x = Math.round(orientation == HORIZONTAL ? assetFactory.getButtonContainerSize() + thumbPos : thumbOffset);
			thumb.y = Math.round(orientation == HORIZONTAL ? thumbOffset : assetFactory.getButtonContainerSize() + thumbPos);
		}
		
		private function getThumbLength():Number
		{
			return (length - assetFactory.getButtonContainerSize() * 2) / (maxValue + 1 < 10 ? maxValue + 1 : 10);
		}
		
		private function getThumbPos(value:uint):Number
		{
			if (maxValue == 0)
				return 0;

			return (value / maxValue) * (length - assetFactory.getButtonContainerSize() * 2 - getThumbLength());
		}
		
		private function getThumbValue(pos:Number):int
		{
			return (pos / (length - assetFactory.getButtonContainerSize() * 2 - getThumbLength())) * maxValue;
		}
		
		
		//
		// enter frame event
		//
		private function onRender(event:Event):void
		{
			if (startTime > 0)
			{
				var thumbPos:Number;
				var thumbOffset:uint;
				var d:Number = (getTimer() - startTime) / MOVEMENT_INTERVAL;
				
				if (d >= 1.0)
				{
					value = nextValue;
					d = 0;
					
					dispatchEvent(new Event(Event.CHANGE));

					if (increment && value < maxValue)
					{
						nextValue = value + 1;
						startTime = getTimer();
					}
					else if (decrement && value > 0)
					{
						nextValue = value - 1;
						startTime = getTimer();
					}
					else
					{
						startTime = 0;
					}
				}

				var thumbLastPos:Number = getThumbPos(value);
				var thumbNextPos:Number = getThumbPos(nextValue);
				thumbPos = thumbLastPos + (thumbNextPos - thumbLastPos) * d;
				thumbOffset = (assetFactory.getButtonContainerSize() - assetFactory.getButtonSize()) / 2;
					
				thumb.x = Math.round(orientation == HORIZONTAL ? assetFactory.getButtonContainerSize() + thumbPos : thumbOffset);
				thumb.y = Math.round(orientation == HORIZONTAL ? thumbOffset : assetFactory.getButtonContainerSize() + thumbPos);
			}
		}
		
		
		//
		// mouse events
		//
		private function onButtonMouseDown(event:MouseEvent):void
		{
			if (startTime == 0)
			{
				if (event.target == incButton && value < maxValue)
				{
					nextValue = value + 1;
					increment = true;
					startTime = getTimer();
				}
				else if (event.target == decButton && value > 0)
				{
					nextValue = value - 1;
					decrement = true;
					startTime = getTimer();
				}
			}
		}
		
		private function onButtonMouseUp(event:MouseEvent):void
		{
			if (event.target == incButton)
				increment = false;
			else if (event.target == decButton)
				decrement = false;
		}
		
		private function onButtonMouseOut(event:MouseEvent):void
		{
			if (event.target == incButton)
				increment = false;
			else if (event.target == decButton)
				decrement = false;
		}
		
		private function onThumbMouseDown(event:MouseEvent):void
		{
			thumbDragOffset = event.localX;
			draggingThumb = true;
		}

	}
}
