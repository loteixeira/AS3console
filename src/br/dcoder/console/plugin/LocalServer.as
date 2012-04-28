// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console.plugin
{
	import br.dcoder.console.ConsoleCore;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	/**
	 * Plugin to receive/send console input/output to a <code>LocalClient</code>.
	 * This plugin is used in console-local-server.swf application, to communicate with a <code>LocalClient</code>.
	 * To test you can start console-local-server.swf and then as3console-demo.swf.
	 * @see LocalClient
	 */
	public class LocalServer extends ConsolePlugin
	{
		private var conn:LocalConnection;
		
		/**
		 * Create a instance of <code>LocalServer</code> plugin. Input is send to a <code>LocalClient</code> and output is received from a <code>LocalClient</code>.
		 * @see LocalClient
		 */
		public function LocalServer():void
		{
			super("LocalServer", "Receives console output and sends input to a LocalClient.");
		}
		
		/**
		 * @private
		 */
		override public function install(consoleCore:ConsoleCore):void
		{
			var client:Object =
			{
				output: function(text:String):void
				{
					consoleCore.println(text);
				}
			};
			
			conn = new LocalConnection();
			conn.client = client;
			
			conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(event:AsyncErrorEvent):void
			{
				consoleCore.println("LocalServer plugin error:");
				consoleCore.println(event);
			});
			
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityError):void
			{
				consoleCore.println("LocalServer plugin error:");
				consoleCore.println(event);
			});
			
			conn.addEventListener(StatusEvent.STATUS, function(event:StatusEvent):void
			{
				if (event.level == "warning")
					consoleCore.println("*** warning: " + event + " ***");
				else if (event.level == "error")
					consoleCore.println("*** error: " + event + " ***");
			});
			
			try
			{
				conn.connect("AS3ConsoleLocalServer");
			}
			catch (e:Error)
			{
				consoleCore.println("LocalServer plugin error:");
				consoleCore.println(e);
			}
		}

		/**
		 * @private
		 */
		override protected function input(data:String):Boolean
		{
			try
			{
				conn.send("AS3ConsoleLocalClient", "input", data);
			}
			catch (e:Error)
			{
				consoleCore.println("LocalServer plugin error:");
				consoleCore.println(e);
			}
			
			return false;
		}
	}
}
