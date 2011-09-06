// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	internal class DummyConsole extends Console
	{
		public function DummyConsole(stage:Stage)
		{
			super(stage, null);
		}
		
		public override function get area():Rectangle
		{
			return new Rectangle();
		} 
		
		public override function set area(rect:Rectangle):void
		{
		}
		
		public override function get caption():String
		{
			return "";
		}
		
		public override function set caption(text:String):void
		{
		}
		
		public override function update():void
		{
		}
		
		public override function show():void
		{
		}
		
		public override function hide():void
		{
		}
		
		public override function isVisible():Boolean
		{
			return false;
		}
		
		public override function maximize():void
		{
		}
		
		public override function minimize():void
		{
		}
		
		public override function isMaximized():Boolean
		{
			return false;
		}
		
		public override function shortcut(shortcutKeys:Array, shortcutUseAlt:Boolean = false, shortcutUseCtrl:Boolean = true, shortcutUseShift:Boolean = false):void
		{
		}
		
		public override function toFront():void
		{
		}
		
		public override function clear():void
		{
		}
		
		public override function println(info:Object):void
		{
		}
	}
}
