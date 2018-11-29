import os
import fontTools
from fontTools.ttLib import TTFont
from fontTools.varLib.featureVars import addFeatureVariations


fontPath = "ExpletusSans-VF.ttf"

f = TTFont(fontPath)

condSubst = [
    # A list of (Region, Substitution) tuples.
    ([{"ital": (0.5, 1.0)}], {"a": "a.ital"}),
    ([{"ital": (0.5, 1.0)}], {"aacute": "aacute.ital"}),
    ([{"ital": (0.5, 1.0)}], {"acircumflex": "acircumflex.ital"}),
    ([{"ital": (0.5, 1.0)}], {"agrave": "agrave.ital"}),
    ([{"ital": (0.5, 1.0)}], {"adieresis": "adieresis.ital"}),
    ([{"ital": (0.5, 1.0)}], {"aring": "aring.ital"}),
    ([{"ital": (0.5, 1.0)}], {"atilde": "atilde.ital"}),
]

addFeatureVariations(f, condSubst)

# newFontPath = fontPath.split(".")[0] + "-italic.ttf" 
f.save(fontPath)