# AS3console
AS3console is a small and non-intrusive logging component for Actionscript3 language (Flash, Flex and AIR).
The component is a singleton that inherits from EventDispatcher class where you can listen for data input and output.
It has a customizable behavior and is easy to remove from release versions (avoiding overhead when it isn't used).
Using this component you don't need to install any plugin for your browser or any application on your computer.
It's embedded to the SWF/SWC file and can be accessed from any computer using shortcut keys.

## Usage example
AS3console was created to be small and simply to use, avoiding too much effort to get it running. You can access all the functionalities through Console singleton.
To write data you can use println method or cpln alias. Both calls have the same effect:
```actionscript
Console.instance.println("Hello World!"); // console println method
cpln("Hello World!"); // alias which internally calls console println method
```
To create it you just need to call create static method with Stage instance parameter. 
```actionscript
Console.create(stage);
cpln("Testing...");
```

## Plugins
Plugins are simple static classes which listen console input events in order to perform some action. Useful for creating new commands.

### CodeEval plugin
Executes code on the fly using AS3Eval Library (http://eval.hurlant.com/).
Activating:
```actionscript
Console.create(stage);
CodeEval.start();
```
Using (type in console input field):
```actionscript
eval cpln("running code from as3console!");
```
	
### LocalServer plugin
Creates a LocalConnection instance, which allows console to receive output from a different SWF file. Also, it sends input to the client.
Activating:
```actionscript
LocalServer.start();
```
	
### LocalClient plugin
Creates a LocalConnection instance, which sends output to another SWF file running LocalServer plugin. Also, it receives text input from the server.
Activating:
```actionscript
LocalClient.start();
```