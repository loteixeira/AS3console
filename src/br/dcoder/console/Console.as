// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.
//
// Contributed:
// - 04/20/2012, Camille Reynders, http://www.creynders.be

package br.dcoder.console
{
	import br.dcoder.console.assets.AssetFactory;
	
	import flash.display.Stage;
	import flash.events.IEventDispatcher;

	/**
	 * Wrapper of a single <code>ConsoleCore</code> instance, used to simplify logging process. You can use AS3console through this class,
	 * accessible from any point of your code, or creating and managing instances of <code>ConsoleCore</code> separately.
	 * You shouldn't instantiate this class using regular constructor, instead use <code>create</code> static method.
	 * @see #create()
	 * @see #instance
	 * @see ConsoleCore
	 */
	public class Console
	{
		private static var _instance:ConsoleCore = null;

		/**
		 * Create a <code>ConsoleCore</code> instance to be wrapped within <code>Console</code> static class. This method must be called once.
		 * If stage instance if null, <code>ConsoleCore</code> instance runs in release mode, where it dispatches all events but has no graphical interface.
		 * @param stage Reference to application stage object.
		 * @param assetFactory Use to specify a non-default instance of AssetFactory.
		 * @param eventDispatcher An object to dispatch ConsoleCore events.
		 * @return ConsoleCore instance.
		 * @see ConsoleCore#release
		 * @see br.dcoder.console.assets.AssetFactory
		 * @see br.dcoder.console.assets.DefaultAssetFactory
		 */
		public static function create(stage:Stage = null, assetFactory:AssetFactory = null, eventDispatcher:IEventDispatcher = null):ConsoleCore
		{
			if (_instance)
				throw new Error("Create method should be called once");
			
			_instance = new ConsoleCore(stage, assetFactory, eventDispatcher);
			return _instance;
		}
		
		/**
		 * Return current instance of <code>ConsoleCore</code> class.
		 * @return ConsoleCore instance.
		 */
		public static function get instance():ConsoleCore
		{
			return _instance;
		}

		/**
		 * @private
		 */
		public function Console() {
			throw new Error("Console class cannot be instantiated");
		}
	}
}
