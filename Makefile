SHELL = /bin/bash

progress: progress.ua
	uiua test progress.ua
	uiua run $< < /bin/bash | cmp /bin/bash
	uiua stand --name $@ $<

test: test-copy

test-copy: test-copy-1

test-copy-1: copy.ua
	uiua run $< < /bin/bash | cmp /bin/bash

clean:
	$(RM) progress
