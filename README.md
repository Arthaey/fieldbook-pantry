# Purpose

This is a personal script that queries my fieldbook Pantry sheet to report on
which food items are about to expire soon.

It very much depends on the exact structure of the sheets and fields; as such,
it's really only meant to work for me, personally. If you're interested in
using this too, let me know and I'll help you out. :)

# Prerequisites

- Ruby (tested with 2.3)
- bundler (`gem install bundler`)

# Usage

## Setup

- `git clone git@github.com:Arthaey/fieldbook-pantry.git`
- `cd fieldbook-pantry`
- `bundle install`
- `rspec` (to verify that everything is working correctly)

## Configuration

Create a `.env` file like the following:

```
export FIELDBOOK_KEY="your-fieldbook-api-key"
export FIELDBOOK_SECRET="your-fieldbook-api-password"
export FIELDBOOK_BOOK_ID="your-fieldbook-book-id"
export FIELDBOOK_SHEET_NAME="your-fieldbook-sheet-name"
```

## Running manually

- `./print_report`

## Running automatically

In additional to the above prerequisites, you will also need `crontab` and `mail` on your system.

Figure out all the absolute-path values of your Ruby installation. Cron won't have any of your environment variables set, so you have to reference them as absolute paths. Hints:

- `echo $GEM_PATH`
- `echo $GEM_HOME`
- `which ruby`

Using the above values, edit your crontab to email yourself daily (weekly, whenever). For example, if you wanted it to email you every day at 5:05 AM, you would `crontab -e` and add this entry:

```
5  5  *  *  *  GEM_PATH=<gem-path> GEM_HOME=<gem-home> <ruby-path> <full-path-to-repo>/fieldbook-pantry/print_report | /usr/bin/mail -s "Pantry Report" <your-email>
```

### Troubleshooting

- Test that the first half (after the asterisks but before the pipe) works from the command line.
- Test that the second half (after the pipe) works from the command line. Instead of `print_report`, use `echo "test"` to pipe content into the mail command.
- Test both halves together from the command line.
- Verify that a simple crontab entry works as expected.
