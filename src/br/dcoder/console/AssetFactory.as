// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: http://code.google.com/p/as3console/
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import flash.display.Sprite;
	
	public class AssetFactory
	{
		/**
		 * Create a instance of AssetFactory class.
		 */
		public function AssetFactory()
		{
		}
		
		/**
		 * Get the value of background color.
		 * @return Background color.
		 */
		public function getBackgroundColor():uint
		{
			//return 0xffffff;
			return 0x555555;
		}
		
		/**
		 * Get the value of button foreground color.
		 * @return Button foreground color.
		 */
		public function getButtonForegroundColor():uint
		{
			//return 0x000000;
			return 0x00cc00;
		}
		
		/**
		 * Get the value of button background color.
		 * @return Button background color.
		 */
		public function getButtonBackgroundColor():uint
		{
			//return 0xd5d5d5;
			return 0x000000;
		}
		
		/**
		 * Get the default size of button.
		 * @return Default button size.
		 */
		public function getButtonSize():int
		{
			//return 13;
			return 16;
		}
		
		/**
		 * Get the default size of button container.
		 * @return Default button container size.
		 */
		public function getButtonContainerSize():int
		{
			//return 18;
			return 24;
		}
		
		/**
		 * Draw button to parameter sprite.
		 * @param sprite Sprite to draw the button.
		 * @param w Width of the button.
		 * @param h Height of the button.
		 */
		public function drawButton(sprite:Sprite, w:int, h:int):void
		{
			/*sprite.graphics.clear();
			sprite.graphics.lineStyle(1, getButtonForegroundColor());
			sprite.graphics.beginFill(getButtonBackgroundColor());
			sprite.graphics.drawRoundRect(0, 0, w, h, getButtonSize() / 2, getButtonSize() / 2);
			sprite.graphics.endFill();*/
			
			sprite.graphics.clear();
			sprite.graphics.lineStyle(1, getButtonForegroundColor());
			sprite.graphics.beginFill(getButtonBackgroundColor());
			sprite.graphics.drawRect(0, 0, w, h);
			sprite.graphics.endFill();
		}
		
		/**
		 * Draw an arrow pointing right to parameter sprite.
		 * @param sprite Sprite to draw the arrow.
		 * @param w Width of the arrow.
		 * @param h Height of the arrow.
		 */
		public function drawArrow(sprite:Sprite, w:int, h:int):void
		{
			sprite.graphics.clear();
			sprite.graphics.beginFill(getButtonForegroundColor());
			sprite.graphics.lineStyle(1, getButtonForegroundColor());
			sprite.graphics.moveTo(-w / 2, 0);
			sprite.graphics.lineTo(w / 2, -h / 2);
			sprite.graphics.lineTo(w / 2, h / 2);
			sprite.graphics.lineTo(-w / 2, 0);
			sprite.graphics.endFill();
		}
	}
}
