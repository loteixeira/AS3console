package br.dcoder.console.plugin
{
	import br.dcoder.console.*;

	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	/**
	 * @author lteixeira
	 */
	public class LocalServer
	{
		private static var conn:LocalConnection;
		
		public static function start():void
		{
			Console.instance.addEventListener(ConsoleEvent.INPUT, input);
			
			var client:Object =
			{
				output: function(text:String):void
				{
					cpln(text);
				}
			};
			
			conn = new LocalConnection();
			conn.client = client;
			
			conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(event:AsyncErrorEvent):void
			{
				cpln("LocalServer plugin error:");
				cpln(event);
			});
			
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityError):void
			{
				cpln("LocalServer plugin error:");
				cpln(event);
			});
			
			conn.addEventListener(StatusEvent.STATUS, function(event:StatusEvent):void
			{
				if (event.level == "warning")
					cpln("*** warning: " + event + " ***");
				else if (event.level == "error")
					cpln("*** error: " + event + " ***");
			});
			
			try
			{
				conn.connect("AS3ConsoleLocalServer");
			}
			catch (e:Error)
			{
				cpln("LocalServer plugin error:");
				cpln(e);
			}
		}

		private static function input(event:ConsoleEvent):void
		{
			try
			{
				conn.send("AS3ConsoleLocalClient", "input", event.text);
			}
			catch (e:Error)
			{
				cpln("LocalServer plugin error:");
				cpln(e);
			}
		}
	}
}
