
.PHONY:default
default: index.qmd
	quarto render

.PHONY:open
open:
	@open docs/index.html

.PHONY:preview
preview: index.qmd
	@quarto preview

index.qmd: index.dyndoc
	/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b 'dyntext "$<", saving("$@") replace nostop'
