# AS3console
AS3console is a small and non-intrusive logging component for Actionscript3 language (Flash, Flex and AIR).
The component is a singleton that inherits from EventDispatcher class where you can listen for data input and output.
It has a customizable behavior and is easy to remove from release versions (avoiding overhead when it isn't used).
Using this component you don't need to install any plugin for your browser or any application on your computer.
It's embedded to the SWF/SWC file and can be accessed from any computer using shortcut keys.

## Usage example:
	Console.create(stage);
	cpln("Testing...");

## Plugins
Plugins are simple static classes which listen console input events in order to perform some action. Useful for adding new commands.

### CodeEval plugin
Executes code on the fly using AS3Eval Library (http://eval.hurlant.com/).
* Activating:
	Console.create(stage);
	CodeEval.start();
* Using (type in console input field):
	eval cpln("running code from as3console!");
	
## LocalServer plugin
Creates a LocalConnection instance, which allows console to receive output from a different SWF file. Also, it sends input to the client.
* Activating:
	LocalServer.start();
	
## LocalClient plugin
Creates a LocalConnection instance, which sends output to another SWF file running LocalServer plugin. Also, it receives text input from the server.
* Activating:
	LocalClient.start();