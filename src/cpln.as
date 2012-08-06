// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package 
{
	import br.dcoder.console.Console;

	/**
	 * Alias for <code>Console.instance.println</code> method. If <code>Console.instance</code> isn't valid, do nothing.
	 * @param info Any information to be printed. If is <code>null</code>, "(null)" string is used.
	 */
	public function cpln(info:Object):void
	{
		!Console.instance || Console.instance.println(info);
	}
}
