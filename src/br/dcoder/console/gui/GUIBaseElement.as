package br.dcoder.console.gui
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import br.dcoder.console.assets.AssetFactory;
	
	/**
	 * @author lteixeira
	 */
	public class GUIBaseElement extends EventDispatcher
	{
		public var rect:Rectangle = new Rectangle();
		protected var assetFactory:AssetFactory;
		protected var content:Sprite;
		
		public function GUIBaseElement(assetFactory:AssetFactory)
		{
			this.assetFactory = assetFactory;
			content = new Sprite();
		}
		
		public function getContent():Sprite
		{
			return content;
		}
		
		public function setAssetFactory(assetFactory:AssetFactory):void
		{
			this.assetFactory = assetFactory;
		}
		
		public function update():void
		{
		}
	}
}
