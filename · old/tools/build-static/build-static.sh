# Builds static fonts

mkdir statics

cp ExpletusSans.glyphs Build-Roman.glyphs
cp ExpletusSans.glyphs Build-Italic.glyphs

python2 $(dirname ${BASH_SOURCE[0]})/prep-roman.py Build-Roman.glyphs
python2 $(dirname ${BASH_SOURCE[0]})/prep-italic.py Build-Italic.glyphs

# —————————————————————————————————————————————————————————————————————————————————————————————————————————————
# Build Roman —————————————————————————————————————————————————————————————————————————————————————————————————

fontmake -o ttf -g Build-Roman.glyphs -i

rm -rf master_ufo
rm -rf instance_ufo

for path in instance_ttf/*.ttf; do
	filename=${path##*/}
	gftools fix-dsig --autofix $path
	ttfautohint $path statics/$filename -I
done

rm -rf instance_ttf

rm -rf Build-Roman.glyphs


# —————————————————————————————————————————————————————————————————————————————————————————————————————————————
# Build Italic ————————————————————————————————————————————————————————————————————————————————————————————————

fontmake -o ttf -g Build-Italic.glyphs -i

rm -rf master_ufo
rm -rf instance_ufo

for path in instance_ttf/*.ttf; do
	filename=${path##*/}
	gftools fix-dsig --autofix $path
	ttfautohint $path statics/$filename -I
done

rm -rf instance_ttf

rm -rf Build-Italic.glyphs

