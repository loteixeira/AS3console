// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console.plugin
{
	import br.dcoder.console.ConsoleCore;
	import br.dcoder.console.ConsoleEvent;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	/**
	 * Plugin to send/receive console output/input from a <code>LocalServer</code>.
	 * You can activate this plugin in your application (or execute as3console-demo.swf) and open the console-local-server.swf file to start the communication.
	 * @see LocalServer
	 */
	public class LocalClient extends ConsolePlugin
	{
		private var conn:LocalConnection;
		
		/**
		 * Create a instance of <code>LocalClient</code> plugin. Output is sent to a <code>LocalServer</code> and input is received from the same <code>LocalServer</code>.
		 * @see LocalServer
		 */
		public function LocalClient():void
		{
			super("LocalClient", "Sends console output and receives input from a LocalServer.");
		}
		
		/**
		 * @private
		 */
		override public function install(consoleCore:ConsoleCore):void
		{
			var client:Object = 
			{
				input: function(text:String):void
				{
					consoleCore.getEventDispatcher().dispatchEvent(new ConsoleEvent(ConsoleEvent.INPUT, false, false, text));
				}
			};
			
			conn = new LocalConnection();
			conn.client = client;
			
			conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(event:AsyncErrorEvent):void
			{
				consoleCore.println("LocalClient plugin error:");
				consoleCore.println(event);
			});
			
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityError):void
			{
				consoleCore.println("LocalClient plugin error:");
				consoleCore.println(event);
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
				consoleCore.println("LocalClient plugin error:");
				consoleCore.println(e);
			}
		}

		/**
		 * @private
		 */
		override protected function output(data:String):Boolean
		{
			try
			{
				conn.send("AS3ConsoleLocalServer", "output", data);
			}
			catch (e:Error)
			{
				// ignore this error
			}
			
			return false;
		}
	}
}
