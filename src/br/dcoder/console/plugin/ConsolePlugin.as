// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console.plugin
{
	import br.dcoder.console.ConsoleCore;
	import br.dcoder.console.ConsoleEvent;

	/**
	 * AS3console plugins base class. A plugin can listen for console input and output.
	 * To add a plugin to a ConsoleCore instance use installPlugin method.
	 * One instance of a plugin <b>MUST</b> be installed in only one ConsoleCore object.
	 * @see br.dcoder.console.ConsoleCore
	 * @see br.dcoder.console.ConsoleCore#installPlugin()
	 */
	public class ConsolePlugin
	{
		private var _name:String;
		private var _description:String;
		
		/**
		 * ConsoleCore object in which this plugin was installed.
		 */
		protected var consoleCore:ConsoleCore;
		
		/**
		 * Creates plugin instance.
		 * @param _name Plugin internal name
		 */
		public function ConsolePlugin(_name:String, _description:String)
		{
			this._name = _name;
			this._description = _description;
		}
		
		/**
		 * Plugin internal name
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * Plugin description
		 */
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * Connects this plugin instance to a ConsoleCore instance.
		 * Do not call this method directly, instead use ConsoleCore installPlugin method.
		 * @param consoleCore Instance to install this plugin object
		 * @see br.dcoder.console.ConsoleCore#installPlugin()
		 */
		public function install(consoleCore:ConsoleCore):void
		{
			this.consoleCore = consoleCore;
			
			consoleCore.getEventDispatcher().addEventListener(ConsoleEvent.INPUT, inputHandler);
			consoleCore.getEventDispatcher().addEventListener(ConsoleEvent.OUTPUT, outputHandler);
		}
		
		/**
		 * Input method. Must be overriden by child class.
		 * @param data Input data
		 * @return True if the plugin has processed this input
		 */
		protected function input(data:String):Boolean
		{
			return false;
		}
		
		/**
		 * Output method. Must be overriden by child class.
		 * @param data Output data
		 * @return True if the plugin has processed this output
		 */
		protected function output(data:String):Boolean
		{
			return false;
		}
		
		private function inputHandler(e:ConsoleEvent):void
		{
			if (input(e.text))
				e.stopImmediatePropagation();
		}
		
		private function outputHandler(e:ConsoleEvent):void
		{
			if (output(e.text))
				e.stopImmediatePropagation();
		}
	}
}
