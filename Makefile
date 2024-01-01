SHELL = /bin/bash

progress: progress.ua
	uiua stand --name $@ $<

test: test-copy
	uiua test progress.ua

test-copy: test-copy-1

test-copy-1: copy.ua
	uiua run $< < /bin/bash | cmp /bin/bash

clean:
	$(RM) progress
