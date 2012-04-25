// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console.assets
{
	import flash.display.Sprite;

	/**
	 * @author lteixeira
	 */
	public class HerculesAssetFactory implements AssetFactory
	{
		public function getBackgroundColor():uint
		{
			//return 0x555555;
			return 0x000000;
		}
		
		public function getButtonForegroundColor():uint
		{
			return 0x00cc00;
		}
		
		public function getButtonBackgroundColor():uint
		{
			return 0x000000;
		}
		
		public function getButtonSize():int
		{
			return 12;
		}
		
		public function getButtonContainerSize():int
		{
			return 22;
		}
		
		public function getCaptionFontSize():uint
		{
			return 14;
		}
		
		public function getLogFontSize():uint
		{
			return 12;
		}
		
		public function getFontName():String
		{
			return "_typewriter";
		}
		
		public function drawButton(sprite:Sprite, w:int, h:int):void
		{
			sprite.graphics.clear();
			sprite.graphics.lineStyle(1, getButtonForegroundColor());
			sprite.graphics.beginFill(getButtonBackgroundColor());
			sprite.graphics.drawRect(0, 0, w, h);
			sprite.graphics.endFill();
		}
		
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
