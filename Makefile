md=$(shell find stata_markdown -name "*.md")
Stata_Rmd=$(md:.md=.Rmd)

stata_markdown/%.Rmd: stata_markdown/%.md
	@echo "$< -> $@"
	@/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b 'dyntext "$<", saving("$@") replace nostop'
#	Using <<dd_do: quiet>> produces empty codeblocks in output, remove them
	@perl -0777 -i -pe 's/~~~~\n~~~~//g' $@

index.html: index.Rmd $(Stata_Rmd)
	@echo "$< -> $@"
#	Bring images temporarily up to main directory
	@cp $(stata_file_path)/*.svg . 2>/dev/null || :
	@Rscript -e "rmarkdown::render('$<')"
#	Remove any images copied up
	@rm -rf *.svg

default: $(Stata_Rmd)  index.html

clean:
	@git clean -xdf

fresh: clean default

open:
	@open index.html
