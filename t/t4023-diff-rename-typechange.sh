#!/bin/sh

test_description='typechange rename detection'

. ./test-lib.sh

test_expect_success setup '

	rm -f foo bar &&
	cat ../../COPYING >foo &&
	ln -s linklink bar &&
	git add foo bar &&
	git commit -a -m Initial &&
	git tag one &&

	rm -f foo bar &&
	cat ../../COPYING >bar &&
	ln -s linklink foo &&
	git add foo bar &&
	git commit -a -m Second &&
	git tag two &&

	rm -f foo bar &&
	cat ../../COPYING >foo &&
	git add foo &&
	git commit -a -m Third &&
	git tag three &&

	mv foo bar &&
	ln -s linklink foo &&
	git add foo bar &&
	git commit -a -m Fourth &&
	git tag four &&

	# This is purely for sanity check

	rm -f foo bar &&
	cat ../../COPYING >foo &&
	cat ../../Makefile >bar &&
	git add foo bar &&
	git commit -a -m Fifth &&
	git tag five &&

	rm -f foo bar &&
	cat ../../Makefile >foo &&
	cat ../../COPYING >bar &&
	git add foo bar &&
	git commit -a -m Sixth &&
	git tag six

'

test_expect_success 'cross renames to be detected for regular files' '

	git diff-tree five six -r --name-status -B -M | sort >actual &&
	{
		echo "R100	foo	bar"
		echo "R100	bar	foo"
	} | sort >expect &&
	diff -u expect actual

'

test_expect_success 'cross renames to be detected for typechange' '

	git diff-tree one two -r --name-status -B -M | sort >actual &&
	{
		echo "R100	foo	bar"
		echo "R100	bar	foo"
	} | sort >expect &&
	diff -u expect actual

'

test_expect_success 'moves and renames' '

	git diff-tree three four -r --name-status -B -M | sort >actual &&
	{
		echo "R100	foo	bar"
		echo "T100	foo"
	} | sort >expect &&
	diff -u expect actual

'

test_done