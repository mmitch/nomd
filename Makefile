PERL_DEPS    := .perl-deps
PERL_SOURCES := $(wildcard */wrapper/*.pl)

run:
	./nomd

clean:
	rm -f $(PERL_DEPS)
	rm -f *~ */*~ */*/*~

$(PERL_DEPS): $(PERL_SOURCES)
	@grep ^use $(PERL_SOURCES) | awk '{print $$2}' | sed 's/;$$//' | egrep -v '^(strict|warnings)$$' | sort | uniq > $@

show-perl-deps:	$(PERL_DEPS)
	@cat $(PERL_DEPS)

check-perl-deps: $(PERL_DEPS)
	@while read MOD; do perl -M$$MOD -e 1 2>/dev/null || echo "missing Perl module: $$MOD"; done < $(PERL_DEPS)

install-perl-deps: $(PERL_DEPS)
	cpanm --skip-satisfied < $(PERL_DEPS)

check-deps: check-perl-deps
