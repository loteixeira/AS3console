// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import flash.events.Event;
	
	/**
	 * Events dispatched by <code>ConsoleCore</code> through the IEventDispatcher object which it owns.
	 * @see ConsoleCore
	 */
	public class ConsoleEvent extends Event
	{
		/**
		 * Defines data input event type.
		 */
		public static const INPUT:String = "input";
		/**
		 * Defines data output event type.
		 */
		public static const OUTPUT:String = "output";
		/**
		 * Defines show component event type.
		 */
		public static const SHOW:String = "show";
		/**
		 * Defines hide console event type.
		 */
		public static const HIDE:String = "hide";
		/**
		 * Defines resize component event type.
		 */
		public static const RESIZE:String = "resize";
		
		private var value:String;
		
		/**
		 * Creates an event object that contains information about console events.
		 * @param type The type of console event. Possible values are: <code>ConsoleEvent.INPUT</code>, <code>ConsoleEvent.OUTPUT</code>,
		 * <code>ConsoleEvent.SHOW</code>, <code>ConsoleEvent.HIDE</code> or <code>ConsoleEvent.RESIZE</code>.
		 * @param bubbles Determines whether the <code>Event</code> object participates in the bubbling phase of the event flow. 
		 * @param cancelable Determines whether the <code>Event</code> object can be canceled.
		 * @param value Text value of this event. Is valid for <code>ConsoleEvent.INPUT</code> and <code>ConsoleEvent.OUTPUT</code>.
		 * @see ConsoleCore
		 */
		public function ConsoleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, value:String = "")
		{
			super(type, bubbles, cancelable);
			this.value = value;
		}
		
		/**
		 * Get text value of this event. Is valid for ConsoleEvent.INPUT and ConsoleEvent.OUTPUT.
		 * For other events type this value is an empty string.
		 */
		public function get text():String
		{
			return value;
		}

		public function set text(value:String):void
		{
			this.value = value;
		}
	}
}
