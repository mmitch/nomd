PERL_SOURCES  := $(wildcard */wrapper/*.pl) nomdoc nomdep

CHECKS        := $(wildcard check/*.check)
NOTIFICATIONS := $(wildcard notify/*.notify) 
BASH_SOURCES  := nomd check.default notify.default $(wildcard tool/*.tool) $(CHECKS) $(NOTIFICATIONS)

run:
	./nomd

clean:
	rm -f .perl-deps # not in use any more, remove later
	rm -f *~ */*~ */*/*~

test-perl: $(PERL_SOURCES)
	@for FILE in $(PERL_SOURCES); do perl -c "$$FILE" || exit 1; done

test-bash: $(BASH_SOURCES)
	@for FILE in $(BASH_SOURCES); do bash -n "$$FILE" && echo "$$FILE syntax OK" || exit 1; done

test: test-perl test-bash
