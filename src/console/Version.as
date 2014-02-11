package console
{
	public class Version
	{
		public static const MAJOR:uint = 1;
		public static const MINOR:uint = 0;
		public static const REVISION:uint = 0;

		public static function get VERSION():String
		{
			return MAJOR + "." + MINOR + "." + REVISION;
		}
	}
}
