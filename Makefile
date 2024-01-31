UIUA = uiua

all: progress

%: %.ua
	$(UIUA) test $<
	$(UIUA) stand --name $@ $<

test: progress
	./$< < /bin/bash | cmp /bin/bash

clean:
	$(RM) progress

test-copy:
	$(UIUA) run copy.ua < /bin/bash | cmp /bin/bash
