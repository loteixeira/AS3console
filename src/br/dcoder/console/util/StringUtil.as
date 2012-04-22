// AS3Console Copyright 2012 Lucas Teixeira (aka Disturbed Coder)
// Project page: https://github.com/loteixeira/as3console
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.console.util
{
	/**
	 * @author lteixeira
	 */
	public class StringUtil
	{
		public static function check(info:Object):String {
			if (info == null)
				return "(null)";
			else if (info is String)
				return info as String;
			
			return info.toString();
		}
	}
}
