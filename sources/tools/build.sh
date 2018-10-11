cp ExpletusSans.glyphs ExpletusSansBuild.glyphs

# Add bracket layers to build version
python2 tools/fixBrackets.py ExpletusSansBuild.glyphs

fontmake -o variable -g ExpletusSansBuild.glyphs

mv variable_ttf/ExpletusSans-VF.ttf ExpletusSans-VF.ttf

rm -rf ExpletusSansBuild.glyphs
rm -rf master_ufo
rm -rf variable_ttf

python2 tools/addItalics.py ExpletusSans-VF.ttf

gftools fix-nonhinting ExpletusSans-VF.ttf ExpletusSans-VF.ttf
gftools fix-dsig --autofix ExpletusSans-VF.ttf
gftools fix-gasp ExpletusSans-VF.ttf

ttx ExpletusSans-VF.ttf

rm -rf ExpletusSans-VF.ttf
rm -rf ExpletusSans-VF-backup-fonttools-prep-gasp.ttf

cat ExpletusSans-VF.ttx | tr '\n' '\r' | sed -e "s,<STAT>.*<\/STAT>,$(cat tools/patch1.xml | tr '\n' '\r')," | tr '\r' '\n' > ExpletusSans-VF-STAT.ttx

rm -rf ExpletusSans-VF.ttx

ttx ExpletusSans-VF-STAT.ttx

rm -rf ExpletusSans-VF-STAT.ttx

mv ExpletusSans-VF-STAT.ttf ExpletusSansBeta-VF.ttf