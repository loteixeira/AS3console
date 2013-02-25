# WINDOWS WORK-AROUND (don't ask me)
# if you're not using windows you can comment the line below
SHELL=c:/windows/system32/cmd.exe

# external applications
SWF_COM=mxmlc
SWC_COM=compc
ASDOC=asdoc
RM=rm -rf

# project paths
SOURCE_PATH=src/

# demo stuff
DEMO_BIN=bin/as3console-demo.swf
DEMO_MAIN=src/br/dcoder/console/ConsoleDemo.as
DEMO_FLAGS=-static-link-runtime-shared-libraries=true

# library stuff
LIB_BIN=bin/as3console.swc
LIB_FLAGS=-debug=true

# documentation stuff
DOC_TITLE=AS3console
DOC_OUTPUT=./doc/
DOC_EXCLUDE=-exclude-classes br.dcoder.console.ConsoleDemo br.dcoder.console.ConsoleLocalServer br.dcoder.console.gui.CaptionBar br.dcoder.console.gui.GUIBaseElement br.dcoder.console.gui.InputField br.dcoder.console.gui.ResizeArea br.dcoder.console.gui.ScrollBar br.dcoder.console.gui.TextArea br.dcoder.console.util.StringUtil
DOC_FLAGS=-warnings=false -library-path ./lib/EvalES4.swc -doc-sources src/cpln.as


all: demo library documentation

demo:
	$(SWF_COM) $(DEMO_FLAGS) -source-path+=$(SOURCE_PATH) -output=$(DEMO_BIN) -- $(DEMO_MAIN)

documentation:
	$(RM) doc/*
	$(ASDOC) $(DOC_FLAGS) -doc-sources $(SOURCE_PATH) -main-title $(DOC_TITLE) -output $(DOC_OUTPUT) $(DOC_EXCLUDE)

library:
	$(SWC_COM) $(LIB_FLAGS) -include-sources=$(SOURCE_PATH) -output=$(LIB_BIN)