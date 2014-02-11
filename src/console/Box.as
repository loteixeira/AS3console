package console
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.IDataInput;

	public class Box
	{
		private var _eventDispatcher:IEventDispatcher;
		private var ios:Array;
		
		//
		// constructor
		//
		public function Box(_eventDispatcher:IEventDispatcher)
		{
			this._eventDispatcher = _eventDispatcher || new EventDispatcher();
			ios = [];
		}
		
		//
		// getters and setters
		//
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
		}
		
		//
		// public interface
		//
		public function connect(io:IO):void
		{
			ios.push(io);
			io.addEventListener(IO.READ_EVENT, onRead);
			io.open();
		}
		
		public function disconnect(io:IO):void
		{
			var l:uint = ios.length;
			
			for (var i:uint = 0; i < l; i++)
			{
				if (ios[i] == io)
				{
					io.close();
					io.removeEventListener(IO.READ_EVENT, onRead);
					ios.splice(i, 1);
					break;
				}
			}
		}

		public function writeln(obj:Object):void
		{
			var l:uint = ios.length;
			var str:String = object2String(obj);
			
			for (var i:uint = 0; i < l; i++)
			{
				var io:IO = ios[i];
				io.output.writeUTF(str);
				io.flush();
			}
		}
		
		//
		// private methods
		//
		private function object2String(obj:Object):String
		{
			if (obj)
				return obj.toString();
				
			return "(null)";
		}
		
		private function onRead(e:Event):void
		{
			var io:IO = e.target as IO;
			var input:IDataInput = io.input;
			var data:String = input.readUTFBytes(input.bytesAvailable);
		}
	}
}
 