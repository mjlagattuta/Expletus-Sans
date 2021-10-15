mkdir VF-final

cp ExpletusSans.glyphs ExpletusSansBuild.glyphs

# Add bracket layers to build version
python2 $(dirname ${BASH_SOURCE[0]})/fixBrackets.py ExpletusSansBuild.glyphs

fontmake -o variable -g ExpletusSansBuild.glyphs

mv variable_ttf/ExpletusSans-VF.ttf ExpletusSans-VF.ttf

rm -rf ExpletusSansBuild.glyphs
rm -rf master_ufo
rm -rf variable_ttf

python2 addFeatureVars.py ExpletusSans-VF.ttf

rm -rf addFeatureVars.py

gftools fix-nonhinting ExpletusSans-VF.ttf ExpletusSans-VF.ttf
gftools fix-dsig --autofix ExpletusSans-VF.ttf
gftools fix-gasp ExpletusSans-VF.ttf

ttx ExpletusSans-VF.ttf

rm -rf ExpletusSans-VF.ttf
rm -rf ExpletusSans-VF-backup-fonttools-prep-gasp.ttf

cat ExpletusSans-VF.ttx | tr '\n' '\r' | sed -e "s,<STAT>.*<\/STAT>,$(cat $(dirname ${BASH_SOURCE[0]})/patch-STAT.xml | tr '\n' '\r')," | tr '\r' '\n' > ExpletusSans-VF-STAT.ttx

rm -rf ExpletusSans-VF.ttx

mv ExpletusSans-VF-STAT.ttx ExpletusSans-VF.ttx

ttx ExpletusSans-VF.ttx

mv ExpletusSans-VF.ttf VF-final/ExpletusSans-VF.ttf

rm -rf ExpletusSans-VF.ttx

rm -rf instance_ufo