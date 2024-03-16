UIUA = uiua
PROGRAMS = progress httpcli

all: $(PROGRAMS)
	ls -lh $(PROGRAMS)

%: %.ua
	$(UIUA) test $<
	$(UIUA) stand --name $@ $<

test: progress
	./$< < /bin/bash | cmp /bin/bash

clean:
	$(RM) $(PROGRAMS)

test-copy:
	$(UIUA) run copy.ua < /bin/bash | cmp /bin/bash
