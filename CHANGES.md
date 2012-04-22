# AS3console changes

## Version 0.4
* Console singleton class splited into two classes: Console (interface singleton) and ConsoleCore (component itself). The component isn't tied to the singleton anymore, it's possible to create and manage several ConsoleCore instances separately (thanks to creynders - https://github.com/creynders).
* In release mode ConsoleEvent.OUTPUT is thrown and TRACE_ECHO/JS_ECHO will work.
* Fixed bug that thrown an exception when input history is empty and the user presses up key (thanks to Diego Prestes - https://github.com/diegoprestes).
* br.dcoder.console.assets package created and AssetFactory refactored.
* Console singleton FIREBUG_ECHO flag renamed to JS_ECHO.
* Console demo app uses LocalClient plugin.
* File console-local-server.swf is distributed with binaries package.
* LocalServer and LocalClient plugins created.
* GUI componentes created: TextArea, InputField, ScrollBar, ResizeArea and CaptionBar.
* StringUtil class created.
* Simple GUI library created.

## Version 0.3
* CodeEval plugin added using As3Eval Lib
* Library package changed from 'br.dcoder' to 'br.dcoder.console'
* Top level free function 'cpln' added to be an alias of 'Console.getInstance().println'
* AssetFactory class added to manage console appearance
* Internal class 'br.dcoder.LightScrollBar' changed to 'br.dcoder.console.ScrollBar'
* 'FIREBUG_ECHO' property added to 'br.dcoder.console.Console' class