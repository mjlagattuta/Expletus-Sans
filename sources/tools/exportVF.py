from Glyphs import *
import sys
import os
from Foundation import NSURL

filename = sys.argv[-1]
directory = os.getcwd()
document = Glyphs.open((str(directory + "/" + filename)), False)
font = document.font()

def main(): 
	
	variationFontPlugin = Glyphs.objectWithClassName_("GlyphsFileFormatVariationFonts") #.fileFormatInstances()
	variationFontPlugin.setFont_(font)
	destination = NSURL.fileURLWithPath_(str(directory + "/"))
	print variationFontPlugin.writeVARTables_error_(destination, None)

	font.close(False)


if __name__ == '__main__':
	main()