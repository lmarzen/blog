hugo gen chromastyles --style=monokailight > chroma-light.css
# hugo gen chromastyles --style=emacs > chroma-light.css
hugo gen chromastyles --style=monokai > chroma-dark.css
# hugo gen chromastyles --style=dracula > chroma-dark.css
sed -i 's/\.chroma/\.dark &/g' chroma-dark.css
