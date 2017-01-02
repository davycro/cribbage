# Cribbage

Simple gem to count a cribbage hand from the terminal.


## Installation

Install from your terminal's default ruby environment as:
    $ gem install cribbage

## Usage

Run `cribbage count` to compute points. The first argument is the flip card. The next 4 arguments are the players cards:

    $ cribbage count 4H 5D 6S 7C 8D

### Card syntax

The first character is the card's value. Face cards are labelled by their first letter. "J" = jack, "Q" = queen, "K" = king, and "A" = ace.

The last character is the card's suit. "H" = heart, "S" = spade, "D" = diamond, and "C" = club.

These characters are *not* case sensitive. "jD" and "Jd" would both mean a jack of diamonds.
