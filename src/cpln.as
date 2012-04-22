// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package 
{
	import br.dcoder.console.Console;

	/**
	 * Alias for Console.instance.println method.
	 * @param info Any information to be printed. If is null, "(null)" string is used.
	 */
	public function cpln(info:Object):void
	{
		Console.instance.println(info);
	}
}
