// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.
// Contributed:
// - 04/20/2012, Camille Reynders, http://www.creynders.be

package br.dcoder.console
{
	import br.dcoder.console.assets.AssetFactory;
	
	import flash.display.Stage;

	/**
	 * Console static class is a wrapper of a ConsoleCore instance. You can use AS3console through this class,
	 * accessible from any point of your code, or create and manage instances of ConsoleCore separately.
	 * You shouldn't create it using regular constructor, instead use create static method.
	 */
	public class Console
	{
		//
		// internal data
		//
		private static var _instance:ConsoleCore = null;
		
		//
		// static methods
		//
		/**
		 * Create a ConsoleCore instance. Should be called once.
		 * If release parameter is true, an empty console is created to avoid overhead.
		 * @param stage Reference to application stage object.
		 * @param release Use to create release versions and remove console overhead.
		 * @param assetFactory Use to specify a non-default instance of AssetFactory.
		 * @return ConsoleCore instance.
		 */
		public static function create(stage:Stage, release:Boolean = false, assetFactory:AssetFactory = null):ConsoleCore
		{
			if (_instance)
				throw new Error("Create method should be called once");
			
			_instance = new ConsoleCore(stage, release, assetFactory);
			
			return _instance;
		}
		
		/**
		 * Return current instance of ConsoleCore.
		 * @return Console singleton instance.
		 */
		public static function get instance():ConsoleCore
		{
			return _instance;
		}
		
		//
		// constructor
		//
		/**
		 * @private
		 */
		public function Console() {
			throw new Error("Console class cannot be instantiated");
		}
	}
}
