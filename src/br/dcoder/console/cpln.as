// AS3Console Copyright 2011 Lucas Teixeira (aka Disturbed Coder)
// Project page: http://code.google.com/p/as3console/
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console
{
	/**
	 * Alias for Console.getInstance().println method.
	 * @param info Any information to be printed. If is null, "(null)" string is used.
	 */
	public function cpln(info:Object):void
	{
		Console.getInstance().println(info);
	}
}
