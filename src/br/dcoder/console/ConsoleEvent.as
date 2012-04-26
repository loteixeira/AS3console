// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	import flash.events.Event;
	
	/**
	 * Events dispatched by ConsoleCore, or by the related IEventDispatcher object.
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
		 * @param type The type of console event. Possible values are: ConsoleEvent.INPUT, ConsoleEvent.OUTPUT,
		 * ConsoleEvent.SHOW or ConsoleEvent.HIDE.
		 * @param bubbles Determines whether the Event object participates in the bubbling phase of the event flow. 
		 * @param cancelable Determines whether the Event object can be canceled.
		 * @param value Text value of this event. Is valid for ConsoleEvent.INPUT and ConsoleEvent.OUTPUT.
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
	}
}
