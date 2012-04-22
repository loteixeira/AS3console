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
	public interface AssetFactory
	{
		/**
		 * Get the value of background color.
		 * @return Background color.
		 */
		function getBackgroundColor():uint;
		
		/**
		 * Get the value of button foreground color.
		 * @return Button foreground color.
		 */
		function getButtonForegroundColor():uint;
		
		/**
		 * Get the value of button background color.
		 * @return Button background color.
		 */
		function getButtonBackgroundColor():uint;
		
		/**
		 * Get the default size of button.
		 * @return Default button size.
		 */
		function getButtonSize():int;
		
		/**
		 * Get the default size of button container.
		 * @return Default button container size.
		 */
		function getButtonContainerSize():int;
		
		/**
		 * Get the default caption font size.
		 * @return Caption font size.
		 */
		function getCaptionFontSize():uint;
		
		/**
		 * Get the default log text font size.
		 * @return Log text font size.
		 */
		function getLogFontSize():uint;
		
		/**
		 * Get the default font name.
		 * @return Default font name.
		 */
		function getFontName():String;
		
		/**
		 * Draw button to parameter sprite.
		 * @param sprite Sprite to draw the button.
		 * @param w Width of the button.
		 * @param h Height of the button.
		 */
		function drawButton(sprite:Sprite, w:int, h:int):void;
		
		/**
		 * Draw an arrow pointing right to parameter sprite.
		 * @param sprite Sprite to draw the arrow.
		 * @param w Width of the arrow.
		 * @param h Height of the arrow.
		 */
		function drawArrow(sprite:Sprite, w:int, h:int):void;
	}
}
