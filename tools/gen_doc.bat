rm -r doc/*
asdoc -doc-sources src/ -main-title AS3console -output ./doc/ -warnings=false -library-path ./lib/EvalES4.swc -doc-sources src/cpln.as -exclude-classes br.dcoder.console.ConsoleDemo br.dcoder.console.ConsoleLocalServer br.dcoder.console.gui.CaptionBar br.dcoder.console.gui.GUIBaseElement br.dcoder.console.gui.InputField br.dcoder.console.gui.ResizeArea br.dcoder.console.gui.ScrollBar br.dcoder.console.gui.TextArea br.dcoder.console.util.StringUtil