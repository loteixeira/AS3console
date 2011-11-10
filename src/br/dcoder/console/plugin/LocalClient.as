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
	public class LocalClient
	{
		private static var conn:LocalConnection;
		
		public static function start():void
		{
			Console.getInstance().addEventListener(ConsoleEvent.OUTPUT, output);
			
			var client:Object = 
			{
				input: function(text:String):void
				{
					Console.getInstance().dispatchEvent(new ConsoleEvent(ConsoleEvent.INPUT, text));
				}
			};
			
			conn = new LocalConnection();
			conn.client = client;
			
			conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(event:AsyncErrorEvent):void
			{
				cpln("LocalClient plugin error:");
				cpln(event);
			});
			
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityError):void
			{
				cpln("LocalClient plugin error:");
				cpln(event);
			});
			
			conn.addEventListener(StatusEvent.STATUS, function(event:StatusEvent):void
			{
				// ignore this event
			});
			
			try
			{
				conn.connect("AS3ConsoleLocalClient");
				conn.send("AS3ConsoleLocalServer", "output", "*** client connected: " + conn.domain + " ***");
			}
			catch (e:Error)
			{
				cpln("LocalClient plugin error:");
				cpln(e);
			}
		}

		private static function output(event:ConsoleEvent):void
		{
			try
			{
				conn.send("AS3ConsoleLocalServer", "output", event.text);
			}
			catch (e:Error)
			{
				// ignore this error
			}
		}
	}
}
