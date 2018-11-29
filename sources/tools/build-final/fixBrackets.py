import sys
import os
import re
import time
import copy
from glyphsLib import GSFont
from glyphsLib import GSGlyph
from glyphsLib import GSLayer

filename = sys.argv[-1]
font = GSFont(filename)

needsDup = []
logged = {}


def getBracketGlyphs():
    newAddition = False
    for glyph in font.glyphs:
        if logged.get(glyph.name) == None:
            for layer in glyph.layers:
                if logged.get(glyph.name) != None:
                    break
                else:
                    if re.match('.*\d\]$', layer.name) != None:
                        needsDup.append(glyph.name)
                        logged.update({glyph.name: True})
                        newAddition = True
                        break
                    else:
                        for component in layer.components:
                            if logged.get(component.name) == None:
                                pass
                            else:
                                needsDup.append(glyph.name)
                                logged.update({glyph.name: True})
                                newAddition = True
                                break
        else:
            pass
    if newAddition == True:
        getBracketGlyphs()
        
            
# Recursively goes through all glyphs and determines if they will need a duplicate glyph
getBracketGlyphs()

print "Added %s glyphs for GSUB rvrn feature:" % str(len(needsDup))
print re.sub( '[\[\]]', '', re.sub('[\[|, ]u\'', '\'', str(needsDup)))      

for i in range(len(needsDup)):
    dupGlyph = copy.deepcopy(font.glyphs[needsDup[i]])
    dupGlyph.name = needsDup[i] + ".ital"
    dupGlyph.unicode = None
    
    font.glyphs.append(dupGlyph)


    delLayer = []
    for layer in font.glyphs[dupGlyph.name].layers:         
        if re.match("\[.*\d\]$", layer.name) != None:
            dupGlyph.layers[layer.associatedMasterId].paths = layer.paths
            dupGlyph.layers[layer.associatedMasterId].anchors = layer.anchors
            dupGlyph.layers[layer.associatedMasterId].width = layer.width
            delLayer.append(layer.layerId)
        elif re.match("\].*\d\]$", layer.name) != None:
            font.glyphs[needsDup[i]].layers[layer.associatedMasterId].paths = layer.paths
            font.glyphs[needsDup[i]].layers[layer.associatedMasterId].anchors = layer.anchors
            font.glyphs[needsDup[i]].layers[layer.associatedMasterId].width = layer.width
            delLayer.append(layer.layerId)
        else:
            for component in layer.components:
                if logged.get(component.name) == None:
                    pass
                else:
                    component.name = component.name + ".ital"
                    
    for layerId in delLayer:
        del font.glyphs[dupGlyph.name].layers[layerId]
        origGlyph = re.sub(".ital", "", dupGlyph.name)
        del font.glyphs[origGlyph].layers[layerId]

font.save(filename)