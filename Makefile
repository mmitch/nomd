PERL_DEPS     := .perl-deps
PERL_SOURCES  := $(wildcard */wrapper/*.pl) $(wildcard tool/*.pl)

CHECKS        := $(wildcard check/*.check)
NOTIFICATIONS := $(wildcard notify/*.notify) 
BASH_SOURCES  := nomd check.default notify.default $(wildcard tool/*.tool) $(CHECKS) $(NOTIFICATIONS)

run:
	./nomd

clean:
	rm -f $(PERL_DEPS)
	rm -f *~ */*~ */*/*~

test-perl: $(PERL_SOURCES)
	@for FILE in $(PERL_SOURCES); do perl -c "$$FILE" || exit 1; done

test-bash: $(PERL_SOURCES)
	@for FILE in $(BASH_SOURCES); do bash -n "$$FILE" && echo "$$FILE syntax OK" || exit 1; done

test: test-perl test-bash

$(PERL_DEPS): $(PERL_SOURCES)
	@grep ^use $(PERL_SOURCES) | awk '{print $$2}' | sed 's/;$$//' | egrep -v '^(strict|warnings)$$' | sort | uniq > $@

show-perl-deps:	$(PERL_DEPS)
	@cat $(PERL_DEPS)

check-perl-deps: $(PERL_DEPS)
	@while read MOD; do perl -M$$MOD -e 1 2>/dev/null || echo "missing Perl module: $$MOD"; done < $(PERL_DEPS)

install-perl-deps: $(PERL_DEPS)
	cpanm --skip-satisfied < $(PERL_DEPS)

check-deps: check-perl-deps

doc:
	@tool/doccer.pl $(CHECKS) $(NOTIFICATIONS)

doc-check:
	@tool/doccer.pl $(CHECKS)

doc-notify:
	@tool/doccer.pl $(NOTIFICATIONS)
