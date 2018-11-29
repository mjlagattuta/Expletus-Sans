# Builds weight axis only VFs ExpletusSans and ExpletusSansItalic linked via the STAT table

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

mv ExpletusSans-VF.ttf VF-linked/ExpletusSans-VF.ttf


# —————————————————————————————————————————————————————————————————————————————————————————————————————————————
# Build Italic ————————————————————————————————————————————————————————————————————————————————————————————————

fontmake -o variable -g Build-Italic.glyphs

rm -rf Build-Italic.glyphs

cd variable_ttf

mv ExpletusSans-ItalicItalic-VF.ttf ../ExpletusSansItalic-VF.ttf

cd ..

rm -rf master_ufo
rm -rf variable_ttf

gftools fix-nonhinting ExpletusSansItalic-VF.ttf ExpletusSansItalic-VF.ttf
gftools fix-dsig --autofix ExpletusSansItalic-VF.ttf
gftools fix-gasp ExpletusSansItalic-VF.ttf

ttx ExpletusSansItalic-VF.ttf

rm -rf ExpletusSansItalic-VF.ttf
rm -rf ExpletusSansItalic-VF-backup-fonttools-prep-gasp.ttf

ttx ExpletusSansItalic-VF.ttf

rm -rf ExpletusSansItalic-VF.ttf
rm -rf ExpletusSansItalic-VF-backup-fonttools-prep-gasp.ttf

cat ExpletusSansItalic-VF.ttx | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat $(dirname ${BASH_SOURCE[0]})/patchItalic-STAT.xml | tr '\n' '\r')~" | tr '\r' '\n' > VF-linked/ExpletusSansItalic-VF.ttx

rm -rf ExpletusSansItalic-VF.ttx

ttx VF-linked/ExpletusSansItalic-VF.ttx

rm -rf VF-linked/ExpletusSansItalic-VF.ttx