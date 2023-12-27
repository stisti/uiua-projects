SHELL = /bin/bash

test: test-copy

test-copy: test-copy-1

test-copy-1: copy.ua
	uiua run $< < /bin/bash | cmp /bin/bash
