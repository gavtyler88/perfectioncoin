#!/bin/bash

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
BUILDDIR=${BUILDDIR:-$TOPDIR}

BINDIR=${BINDIR:-$BUILDDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

PERFECTIOND=${PERFECTIOND:-$BINDIR/perfectioncoind}
BITCOINCLI=${PERFECTIONCOINCLI:-$BINDIR/perfectioncoin-cli}
BITCOINTX=${PERFECTIONCOINTX:-$BINDIR/perfectioncoin-tx}
BITCOINQT=${PERFECTIONCOINQT:-$BINDIR/qt/perfectioncoin-qt}

[ ! -x $PERFECTIONCOIND ] && echo "$PERFECTIONCOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
BTCVER=($($PERFECTIONCOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for perfectioncoind if --version-string is not set,
# but has different outcomes for perfectioncoin-qt and perfectioncoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$PERFECTIONCOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $PERFECTIONCOIND $PERFECTIONCOINCLI $PERFECTIONCOINTX $PERFECTIONCOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${BTCVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${BTCVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
