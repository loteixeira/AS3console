# AS3console
AS3console is a small and non-intrusive logging component for Actionscript3 language (Flash, Flex and AIR), designed to be small and simply to use, avoiding too much effort to get it running.<br/>
It's a generic logging system, where you can use the same interface for different output/input streams (trace, js console.log or even a socket server). It has a customizable behavior and is easy to remove from release versions (avoiding overhead when it isn't used).<br/>
Using this component you don't need to install any plugin for your browser or any application on your computer. It's embedded to the SWF/SWC file and can be accessed from any computer using shortcut keys.

This software is distribuited under the terms of the GNU Lesser Public License.

## Usage
You can access all the functionalities through Console static class.
To create the component you just need to call create static method with Stage instance parameter. 
```actionscript
Console.create(stage); // after calling this method, the ConsoleCore instance is created and may be accessed through Console.instance.
cpln("Testing..."); // print data in console
```
To write data you can use println method or cpln alias. Both calls have the same effect:
```actionscript
Console.instance.println("Hello World!"); // console println method
cpln("Hello World!"); // alias which internally calls console println method
```
In the case you want to manage the ConsoleCore object by yourself, you can create an instance of ConsoleCore class:
```actionscript
var consoleCore:ConsoleCore = new ConsoleCore(stage); // creates an instance of ConsoleCore, but doesn't store in Console static class.
consoleCore.println("Testing...."); // in this scenario you can't use cpln function, because it's tied to Console static class.
```

### Redirect output to trace window
Show console output in trace window. By default the value is true.
```actionscript
Console.instance.config.traceEcho = true;
```

### Redirect output to JS console.log
Show console output in JS console.log window. By default the value is false.
```actionscript
Console.instance.config.jsEcho = false;
```

### AS3console without graphical interface
You can create the console without creating the graphical interface (trace and js redirecting still work).
```actionscript
Console.create(); // just call create method without the Stage instance.
cpln("Testing...");
```

### Output events
Every console output throws ConsoleEvent.OUTPUT event.
```actionscript
Console.instance.getEventDispatcher().addEventListener(ConsoleEvent.OUTPUT, consoleOutput);

function consoleOutput(e:ConsoleEvent):void {
	// do something
	// output value is e.text
}
```

### Input events
Every console input throws ConsoleEvent.INPUT event.
```actionscript
Console.instance.getEventDispatcher().addEventListener(ConsoleEvent.INPUT, consoleInput);

function consoleInput(e:ConsoleEvent):void {
	// do something
	// input value is e.text
}
```