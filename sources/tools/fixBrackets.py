import sys
import os
import re
import time
import copy
from glyphsLib import *
from glyphsLib import GSFont
from glyphsLib import GSGlyph
from glyphsLib import GSLayer

filename = sys.argv[-1]
font = GSFont(filename)

# Brackets script part 1:
start = time.time()

getBrackets = []
# Make writeBrackets non-zero to start while loop in main()
writeBrackets = [1, 2, 3]
missingBrackets = []


# Checks if all master layers have a corresponding bracket layer
def checkBracketSetup(glyph):
    count = 0
    for layer in glyph.layers:
        if re.match('.*\d\]$', layer.name) != None:
            count = count + 1
    if count == len(font.masters):
        return True
    elif count == 0:
        return None
    else:
        return False

# Checks if current glyph already has bracket layers
def hasBracket(glyphName):
    for i in range(len(getBrackets)):
        if re.match('^%s$' % glyphName, getBrackets[i][0]) != None:
            return True
    return False

# Checks all components in a glyph until it matches to a glyph.name from getBrackets list. Appends name and index in getBrackets
def checkComponents(glyph):
    for layer in glyph.layers:
        for component in layer.components:
            for i in range(len(getBrackets)):
                if re.match('^%s$' % component.name, getBrackets[i][0]) != None:
                    # List used to track when script is done adding layers
                    writeBrackets.append([glyph.name, i])
                    genBrackets(glyph, i)
                    return

def genBrackets(glyph, i):
    # Runs through master layers
    for j in range(len(font.masters)):
        # Copies master layer (and layer.associatedMasterId)
        # create new layer
        newLayer = GSLayer()
        newLayer.associatedMasterId = glyph.layers[j].associatedMasterId
        newLayer.name = "temp"
        newLayer.components = copy.copy(glyph.layers[j].components)
        print newLayer
        # Runs through getBrackets list
        for k in range(len(font.masters)):
            if re.match(newLayer.associatedMasterId, getBrackets[i + k][2]) != None:
                # New layer takes name of bracket with corresponding master id
                newLayer.name = getBrackets[i + k][1]
                # Add new bracket layer
                print "Before", glyph.layers
                print newLayer.name
                glyph.layers.append(newLayer)
                print "After", glyph.layers
                break
    print "Added bracket layers for glyph '%s'" % glyph.name

def mainBrackets(font):
    wrongSetup = False
    # Check all glyphs for proper bracket setup and populate getBrackets list
    for glyph in font.glyphs:
        # If setup is good
        if checkBracketSetup(glyph) == True:
            for layer in glyph.layers:
                if re.match('.*\d\]$', layer.name) != None:
                    # print layer.parent.name, layer.name, re.match('.\d*\]$', layer.name)
                    getBrackets.append([glyph.name, layer.name, layer.associatedMasterId])
        # If no brackets
        elif checkBracketSetup(glyph) == None:
            pass
        # If setup is bad
        else:
            missingBrackets.append(glyph.name)
            wrongSetup = True

    # If wrong setup print list of glyphs, else check all components against existing bracket glyphs
    if wrongSetup == True:
        print "No changes were made due to missing bracket layers on the following glyphs:"
        for i in range(len(missingBrackets)):
            print missingBrackets[i]
        end = time.time()
        print end - start
    else:
        # Populate writeBrackets list
        for glyph in font.glyphs:
            # If glyph already has bracket layers, or is not exporting, no need to run through its layers and components
            if hasBracket(glyph.name) == True or glyph.export == False:
                pass
            else:
                checkComponents(glyph)
    print len(writeBrackets)

# Main function runs until there are no more glyphs in need of bracket layers
while len(writeBrackets) > 0:
    writeBrackets = []
    mainBrackets(font)

end = time.time()
print "Total time: %ds" % (end - start)


# Bracket script part 2
glyphList = ["aacute", "acircumflex", "adieresis", "agrave", "aring", "atilde"]

for glyphName in glyphList:
	i = 0
	for layer in font.glyphs[glyphName].layers:
		if re.match(".*Italic", layer.name) != None or re.match("\[0, 3\]", layer.name) != None:
			del(layer.components[0])
			layer.paths.append(copy.copy(font.glyphs["a"].layers[i].paths[0]))
		i = i + 1

font.save(filename)