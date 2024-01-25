hugo gen chromastyles --style=monokailight > chroma-light.css
# hugo gen chromastyles --style=emacs > chroma-light.css
hugo gen chromastyles --style=monokai > chroma-dark.css
# hugo gen chromastyles --style=dracula > chroma-dark.cs

# comment out empty rules
sed -i -e 's|/\* \(.*\) \*/ \(\.chroma \.[a-zA-Z]*\) {  }|/* \1 */ /* \2 {  } */|g' chroma-light.css
sed -i -e 's|/\* \(.*\) \*/ \(\.chroma \.[a-zA-Z]*\) {  }|/* \1 */ /* \2 {  } */|g' chroma-dark.css

# make these rules apply only for dark mode
sed -i 's/\.chroma/\.dark &/g' chroma-dark.css
