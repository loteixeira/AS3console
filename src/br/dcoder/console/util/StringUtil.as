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
