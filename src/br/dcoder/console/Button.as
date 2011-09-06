// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: http://code.google.com/p/as3console/
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import flash.display.Sprite;
	
	internal class Button extends Sprite
	{
		public static const ARROW_ICON:String = "arrowIcon";
		
		private var iconType:String;
		private var assetFactory:AssetFactory;
		private var icon:Sprite;
		private var iconRotation:Number;
		private var iconScale:Number;
		
		public function Button(iconType:String, assetFactory:AssetFactory, iconScale:Number = 0.7)
		{
			this.iconType = iconType;
			this.assetFactory = assetFactory;
			
			icon = new Sprite();
			addChild(icon);
			
			iconRotation = 0;
		}
		
		public function getIconType():String
		{
			return iconType;
		}
		
		public function getAssetFactory():AssetFactory
		{
			return assetFactory;
		}
		
		public function getIcon():Sprite
		{
			return icon;
		}
		
		public function setIconRotation(iconRotation:Number):void
		{
			this.iconRotation = iconRotation;
		}
		
		public function getIconRotation():Number
		{
			return iconRotation;
		}
		
		public function setIconScale(iconScale:Number):void
		{
			this.iconScale = iconScale;
		}
		
		public function getIconScale():Number
		{
			return iconScale;
		}
		
		public function draw(w:Number, h:Number):void
		{
			//assetFactory.drawButton(this, w, h);
			
			if (iconType == ARROW_ICON)
			{
				assetFactory.drawButton(this, w, h);
				assetFactory.drawArrow(icon, w * iconScale, h * iconScale);
			}
			
//			icon.x = (w - w * iconScale) / 2;
	//		icon.y = (h - h * iconScale) / 2;
		}
	}
}
