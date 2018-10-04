cp ExpletusSans.glyphs ExpletusSansBuild.glyphs

# Add bracket layers to build version
python2 tools/fixBrackets.py ExpletusSansBuild.glyphs

# Export the variable font from Glyphs App (Requires Glyphs App to be running)
python2 tools/exportVF.py ExpletusSansBuild.glyphs

rm -rf ExpletusSansBuild.glyphs

mv ExpletusSansGX.ttf ExpletusSans-VF.ttf

gftools fix-nonhinting ExpletusSans-VF.ttf ExpletusSans-VF.ttf
gftools fix-dsig --autofix ExpletusSans-VF.ttf
gftools fix-gasp ExpletusSans-VF.ttf

ttx ExpletusSans-VF.ttf

rm -rf ExpletusSans-VF.ttf
rm -rf ExpletusSans-VF-backup-fonttools-prep-gasp.ttf

cat ExpletusSans-VF.ttx | tr '\n' '\r' | sed -e "s,<STAT>.*<\/fvar>,$(cat tools/patch1.xml | tr '\n' '\r')," | tr '\r' '\n' > ExpletusSans-VF-Patch1.ttx
rm -rf ExpletusSans-VF.ttx

cat ExpletusSans-VF-Patch1.ttx | tr '\n' '\r' | sed -e "s,<FeatureVariations>.*<\/FeatureVariations>,$(cat tools/patch2.xml | tr '\n' '\r')," | tr '\r' '\n' > ExpletusSansBeta-VF.ttx
rm -rf ExpletusSans-VF-Patch1.ttx

ttx ExpletusSansBeta-VF.ttx

rm -rf ExpletusSansBeta-VF.ttx

mv ExpletusSansBeta-VF.ttf ../fonts/variable/ExpletusSansBeta-VF.ttf