# Builds weight axis only VFs ExpletusSans and ExpletusSans-Italic linked via the STAT table

mkdir VF-linked

cp ExpletusSans.glyphs Build-Roman.glyphs
cp ExpletusSans.glyphs Build-Italic.glyphs

python2 $(dirname ${BASH_SOURCE[0]})/prep-roman.py Build-Roman.glyphs
python2 $(dirname ${BASH_SOURCE[0]})/prep-italic.py Build-Italic.glyphs

# —————————————————————————————————————————————————————————————————————————————————————————————————————————————
# Build Roman —————————————————————————————————————————————————————————————————————————————————————————————————

fontmake -o variable -g Build-Roman.glyphs

rm -rf Build-Roman.glyphs

cd variable_ttf

mv ExpletusSans-VF.ttf ../ExpletusSans-VF.ttf

cd ..

rm -rf master_ufo
rm -rf variable_ttf

gftools fix-nonhinting ExpletusSans-VF.ttf ExpletusSans-VF.ttf
gftools fix-dsig --autofix ExpletusSans-VF.ttf
gftools fix-gasp ExpletusSans-VF.ttf

ttx ExpletusSans-VF.ttf

rm -rf ExpletusSans-VF.ttf
rm -rf ExpletusSans-VF-backup-fonttools-prep-gasp.ttf

cat ExpletusSans-VF.ttx | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat $(dirname ${BASH_SOURCE[0]})/patchRoman-name.xml | tr '\n' '\r')~" | tr '\r' '\n' > ExpletusSans-VF2.ttx
cat ExpletusSans-VF2.ttx | tr '\n' '\r' | sed -e "s~<STAT>.*<\/STAT>~$(cat $(dirname ${BASH_SOURCE[0]})/patchRoman-STAT.xml | tr '\n' '\r')~" | tr '\r' '\n' > ExpletusSans-VF.ttx

rm -rf ExpletusSans-VF2.ttx

ttx ExpletusSans-VF.ttx

rm -rf ExpletusSans-VF.ttx

mv ExpletusSans-VF.ttf VF-linked/ExpletusSans-Roman-VF.ttf


# —————————————————————————————————————————————————————————————————————————————————————————————————————————————
# Build Italic ————————————————————————————————————————————————————————————————————————————————————————————————

fontmake -o variable -g Build-Italic.glyphs

rm -rf Build-Italic.glyphs

cd variable_ttf

mv ExpletusSans-Italic-VF.ttf ../ExpletusSans-Italic-VF.ttf

cd ..

rm -rf master_ufo
rm -rf variable_ttf

gftools fix-nonhinting ExpletusSans-Italic-VF.ttf ExpletusSans-Italic-VF.ttf
gftools fix-dsig --autofix ExpletusSans-Italic-VF.ttf
gftools fix-gasp ExpletusSans-Italic-VF.ttf

ttx ExpletusSans-Italic-VF.ttf

rm -rf ExpletusSans-Italic-VF.ttf
rm -rf ExpletusSans-Italic-VF-backup-fonttools-prep-gasp.ttf


cat ExpletusSans-Italic-VF.ttx | tr '\n' '\r' | sed -e "s~<STAT>.*<\/STAT>~$(cat $(dirname ${BASH_SOURCE[0]})/patchItalic-STAT.xml | tr '\n' '\r')~" | tr '\r' '\n' > ExpletusSans-Italic-VF2.ttx

rm -rf ExpletusSans-Italic-VF.ttx

mv ExpletusSans-Italic-VF2.ttx ExpletusSans-Italic-VF.ttx

ttx ExpletusSans-Italic-VF.ttx

rm -rf ExpletusSans-Italic-VF.ttx

mv ExpletusSans-Italic-VF.ttf VF-linked/ExpletusSans-Italic-VF.ttf

rm -rf instance_ufo
