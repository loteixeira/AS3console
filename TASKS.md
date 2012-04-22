# AS3console tasks

## Pending:
* when using up/down arrow to navigate through input history, the cursor must be placed at the end of the text.
* add print method (which won't add '\n' character to the end of the text).
* add 'cp' top-level shortcut function (similar to cpln).
* improve documentation.
* create a "how to" tutorial.
* create ConsoleProgram concept (to work differently from input events).
* create ConsoleConfig class to manage all public static variables used for runtime configuration.
* improve console gui api.
* refactor AssetFactory interface and DefaultAssetFactory class.
* add custom channel name for LocalClient and LocalServer plugins (each client or server can open different channels).
* add get embed command.
* improve scrollbar thumb dragging.
* close version 0.4;

## Resolved - version 0.4:
* [26/11/2011] even when running release mode, output events must be thrown and TRACE_ECHO and JS_ECHO must still work.
* [26/11/2011] fix bug when pressing up key in input text field that throws an exception when history is empty.
* [26/11/2011] create assets package and rename AssetFactory to DefaultAssetFactory (making AssetFactory an interface).
* [26/11/2011] fix scrollbar thumb not draggable bug.
* [26/11/2011] rename Console.FIREBUG_ECHO to Console.JS_ECHO.
* [10/11/2011] use LocalClient plugin in ConsoleDemo.
* [10/11/2011] build ConsoleLocalServer.swf.
* [10/11/2011] add to project LocalServer and LocalClient plugins.
* [10/11/2011] commit git repository as an eclipse fdt project.
* [10/11/2011] create fdt launch as common files.
* [10/11/2011] fix missing of ScrollBar class.
* [08/10/2011] create ConsoleLocalServer and TestLocalClient applications.
* [08/10/2011] create LocalServer and LocalClient plugins (to manage connections between differents SWFs through LocalConnection class).
* [15/09/2011] use anonymous function to handle console internal events.
* [15/09/2011] create a simple components set (to remove all components from Console class).
* [15/09/2011] create ResizeArea class, child of GUIBaseElement class.
* [15/09/2011] adapt ScrollBar class to be child o GUIBaseElement class.
* [14/09/2011] create InputField class, child of GUIBaseElement class.
* [14/09/2011] create TextArea class, child of GUIBaseElement class.
* [14/09/2011] create CaptionBar class, child of GUIBaseElement class.
* [14/09/2011] add StringUtil class.
* [14/09/2011] create GUIBaseElement class.