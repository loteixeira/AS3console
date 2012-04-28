// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console.assets
{
	import flash.display.Sprite;

	/**
	 * Hercules asset factory, based in old hercules monitors.
	 */
	public class HerculesAssetFactory implements AssetFactory
	{
		/**
		 * Get the value of background color.
		 * @return Background color.
		 */
		public function getBackgroundColor():uint
		{
			return 0x000000;
		}
		
		/**
		 * Get the value of button foreground color.
		 * @return Button foreground color.
		 */
		public function getButtonForegroundColor():uint
		{
			return 0x00cc00;
		}
		
		/**
		 * Get the value of button background color.
		 * @return Button background color.
		 */
		public function getButtonBackgroundColor():uint
		{
			return 0x000000;
		}
		
		/**
		 * Get the default size of button.
		 * @return Default button size.
		 */
		public function getButtonSize():int
		{
			return 12;
		}
		
		/**
		 * Get the default size of button container.
		 * @return Default button container size.
		 */
		public function getButtonContainerSize():int
		{
			return 22;
		}
		
		/**
		 * Get the default caption font size.
		 * @return Caption font size.
		 */
		public function getCaptionFontSize():uint
		{
			return 14;
		}
		
		/**
		 * Get the default log text font size.
		 * @return Log text font size.
		 */
		public function getLogFontSize():uint
		{
			return 12;
		}
		
		/**
		 * Get the default font name.
		 * @return Default font name.
		 */
		public function getFontName():String
		{
			return "_typewriter";
		}
		
		/**
		 * Draw button to parameter sprite.
		 * @param sprite Sprite to draw the button.
		 * @param w Width of the button.
		 * @param h Height of the button.
		 */
		public function drawButton(sprite:Sprite, w:int, h:int):void
		{
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
			sprite.graphics.moveTo(-w / 2, 0);
			sprite.graphics.lineTo(w / 2, -h / 2);
			sprite.graphics.lineTo(w / 2, h / 2);
			sprite.graphics.lineTo(-w / 2, 0);
			sprite.graphics.endFill();
		}
	}
}
