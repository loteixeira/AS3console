# AS3console0.6.0
AS3console is a component designed to manage input/output for Actionscript3 (Flash, Flex and AIR). It's a generic logging system, where you can use the same interface
for several IO streams (trace, js console.log, server communication) including a simple GUI accessible from anywhere (available in flash right click menu).

Check online documentation: http://disturbedcoder.com/files/as3console-doc/

This software is distribuited under the terms of the GNU Lesser Public License.

## Usage
You have two options to work with as3console:

* a singleton - accessible from anywhere in the code
* objects - where you need manage your own instances

### Singleton Style
It's very simple to work with AS3console singleton since you don't need to worry about any object. Plus, you may use a top-level function to write to the log system.

Here's the simplest scenario of AS3console usage:

```actionscript
import br.dcoder.console.Console;
import flash.display.Sprite;

public class MySprite extends Sprite
{
	public function MySprite()
	{
		Console.create(this);
		cpln("Hello World!");
	}
}
```

The top level function cpln is a alias, which internally calls the singleton instance. The code above does exactly the same thing:

```actionscript
import br.dcoder.console.Console;
import flash.display.Sprite;

public class MySprite extends Sprite
{
	public function MySprite()
	{
		Console.create(this);
		// same effect of calling cpln("Hello World!");
		Console.instance.println("Hello World!");
	}
}
```

Note: the variable accessed through Console.instance is an instance of ConsoleCore class.

### Object Style
Using objects you may manage several instances of AS3console (ConsoleCore class).

```actionscript
import br.dcoder.console.ConsoleCore;
import flash.display.Sprite;

public class MySprite extends Sprite
{
	public function MySprite()
	{
		var consoleCore:ConsoleCore = new ConsoleCore(this);
		consoleCore.println("Hello World!");
	}
}
```

### IO Events/Redirects

Every input or output action dispatches an event. You may listen the EventDispatcher related to ConsoleCore in order to handle the data.

#### Output Events

The code below listens and sends every output action to a server.

```actionscript
import br.dcoder.console.Console;
import br.dcoder.console.ConsoleEvent;
import flash.display.Sprite;

public class MySprite extends Sprite
{
	public function MySprite()
	{
		Console.create(this);
		Console.instance.getEventDispatcher().addEventListener(ConsoleEvent.OUTPUT, output);
	}

	private function output(e:ConsoleEvent):void
	{
		sendToServer(e.text);
	}

	private function sendToServer(str:String):void
	{
		// send data to a hypothetical server
	}
}
```

#### Input Events

It's possible to create commands listening for input events. These events are dispatched when the user types text in GUI input field or when scan method is called in any ConsoleCore object.

```actionscript
import br.dcoder.console.Console;
import br.dcoder.console.ConsoleEvent;
import flash.display.Sprite;

public class MySprite extends Sprite
{
	public function MySprite()
	{
		Console.create(this);
		Console.instance.getEventDispatcher().addEventListener(ConsoleEvent.INPUT, input);
		cpln("Type 'number'...");

		// inputing "number" string into console
		Console.instance.scan("number");
		// you may also type this text in gui input field
	}

	private function input(e:ConsoleEvent):void
	{
		if (e.text == "number")
			cpln(42);
	}
}
```

Thus, you can link the console to other application which can communicates with your SWF.

#### Redirect to Trace

By default, every output is also redirected to trace top level function.

```actionscript
import br.dcoder.console.Console;
import br.dcoder.console.ConsoleEvent;
import flash.display.Sprite;

public class MySprite extends Sprite
{
	public function MySprite()
	{
		Console.create(this);
		// turning off trace redirect
		Console.instance.config.traceEcho = false;
	}
}
```

#### Redirect to JS console.log

By default, this feature is turned off. But whether you use it, every output event is redirected to JavaScript console.log function.

```actionscript
import br.dcoder.console.Console;
import br.dcoder.console.ConsoleEvent;
import flash.display.Sprite;

public class MySprite extends Sprite
{
	public function MySprite()
	{
		Console.create(this);
		// turning on js redirect - every output will reach JavaScript console
		Console.instance.config.jsEcho = true;
	}
}
```

### Without GUI

```actionscript
import br.dcoder.console.Console;
import br.dcoder.console.ConsoleEvent;
import flash.display.Sprite;

public class MySprite extends Sprite
{
	public function MySprite()
	{
		// no GUI!
		// however events and redirects still working
		Console.create();
		cpln("Hello non graphical world!");
	}
}
```