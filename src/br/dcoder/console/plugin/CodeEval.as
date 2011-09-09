package br.dcoder.console.plugin
{
	import br.dcoder.console.*;
	
	import com.hurlant.eval.CompiledESC;
	import com.hurlant.eval.ByteLoader;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	/**
	 * @author lteixeira
	 */
	public class CodeEval
	{
		private static var _context:Object;
		private static var esc:CompiledESC = new CompiledESC();
		
		public static function start(_context:Object = null):void
		{
			CodeEval._context = _context;
			Console.getInstance().addEventListener(ConsoleEvent.INPUT, input);
		}
		
		public static function get context():Object
		{
			return _context;
		}
		
		public static function set context(_context:Object):void
		{
			CodeEval._context = _context;
		}

		private static function input(event:ConsoleEvent):void
		{
			if (event.text.indexOf("eval ") == 0)
			{
				var src:String = "function evalCode(getDefinition:Function, context:Object):void { " + event.text.substr(5) + " }";
				var swf:ByteArray = ByteLoader.wrapInSWF([ esc.eval(src) ]);
				var loader:Loader = new Loader();

				loader.contentLoaderInfo.addEventListener(Event.INIT, function(event:Event):void
				{
					try
					{
						var getDefinition:Function = function(expression:String):* { return getDefinitionByName(expression); };
						loader.contentLoaderInfo.applicationDomain.getDefinition("evalCode")(getDefinition, _context);
					}
					catch (e:Error)
					{
						cpln("Error executing code:");
						cpln(e);
					}
				});
			
				loader.loadBytes(swf);
				event.stopImmediatePropagation();
			}
		}
	}
}
