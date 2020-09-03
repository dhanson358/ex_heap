# Sets a default for make
.DEFAULT_GOAL := help

MIX = docker run --rm \
		-v "${PWD}:/usr/src/ex_heap" \
		-w /usr/src/ex_heap \
		--name ex_aws_test \
		"elixir:latest" mix

help:; ## Output help
	printf "%s\\n"  \
		"Example:" \
		"Run the tests in a container:" \
		"	   make exunit_test"

exunit_test:
	${MIX} test

ifndef VERBOSE
  .SILENT:
endif
