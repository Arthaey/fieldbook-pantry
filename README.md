# Purpose

This is a personal script that queries my fieldbook Pantry sheet to report on
which food items are about to expire soon.

It very much depends on the exact structure of the sheets and fields; as such,
it's really only meant to work for me, personally. If you're interested in
using this too, let me know and I'll help you out. :)

# Prerequisites

- Ruby (tested with 2.3)
- bundler (`gem install bundler`)

# Example

```
REPORT FOR THURSDAY, 12/29
============================================================

EXPIRING THIS WEEK:
- Half & Half                                    [Fri 12/30]
- Milk                                           [Thu   1/5]

FROZEN FOOD:
- Sausage (chicken apple)                            [ 12/4]
- Ravioli (beef)                                     [12/20]
- Soup dumplings                                     [12/20]

UNKNOWN EXPIRATION:
- Cheddar  
```

# Usage

## Setup

1. `git clone git@github.com:Arthaey/fieldbook-pantry.git`
2. `cd fieldbook-pantry`
3. `bundle install`
4. `rspec` (to verify that everything is working correctly)

## Configuration

Generate an API key for your Fieldbook account:

1. Log in to [Fieldbook](https://fieldbook.com).
2. Click the "API" button near the top right.
3. Click the "Manage API Access" button at the top right.
4. Click the "Generate a new API key" button at the bottom right.

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

1. `echo $GEM_PATH`
2. `echo $GEM_HOME`
3. `which ruby`

Using the above values, edit your crontab to email yourself daily (weekly, whenever). For example, if you wanted it to email you every day at 5:05 AM, you would `crontab -e` and add this entry:

```
5  5  *  *  *  GEM_PATH=<gem-path> GEM_HOME=<gem-home> <ruby-path> <full-path-to-repo>/fieldbook-pantry/print_report | /usr/bin/mail -s "Pantry Report" <your-email>
```

### Troubleshooting

1. Test that the first half (after the asterisks but before the pipe) works from the command line.
2. Test that the second half (after the pipe) works from the command line. Instead of `print_report`, use `echo "test"` to pipe content into the mail command.
3. Test both halves together from the command line.
4. Verify that a simple crontab entry works as expected.
