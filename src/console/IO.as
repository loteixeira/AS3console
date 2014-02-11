package console
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public class IO extends EventDispatcher
	{
		internal static const READ_EVENT:String = "readEvent";
		
		protected var _opened:Boolean = false;
		protected var _input:IDataInput;
		protected var _output:IDataOutput;
		
		private var readEvent:Event = new Event(READ_EVENT);
		
		//
		// constructor
		//
		public function IO()
		{
		}
		
		//
		// getters and setters
		//
		public function get name():String
		{
			return "Empty IO";
		}
		
		public function get opened():Boolean
		{
			return _opened;
		}
		
		public function get input():IDataInput
		{
			return _input;
		}
		
		public function get output():IDataOutput
		{
			return _output;
		}
		
		//
		// public interface
		//
		public function open():void
		{
		}
		
		public function close():void
		{
		}
		
		public function flush():void
		{
		}
		
		//
		// protected interface
		//
		protected function dispatchReadEvent():void
		{
			dispatchEvent(readEvent);
		}
	}
}
