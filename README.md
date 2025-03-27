# Grouping Exercise

A Ruby program to identify rows in a CSV file that may represent the same person based on different matching strategies.

## Installation

1. Install Ruby (if not already installed) (Recommended 3.2)
2. Clone this repository
3. Run `bundle install`

## Usage

- bin/group_records <input_file.csv> <matching_type>


## Available matching types:
- `same_email`: Matches records with the same email address
- `same_phone`: Matches records with the same phone number
- `same_email_or_phone`: Matches records with the same email address OR the same phone number

## Examples

- bin/group_records samples/sample1.csv same_email
- bin/group_records samples/sample2.csv same_phone
- bin/group_records samples/sample3.csv same_email_or_phone


## Design

The solution uses a strategy pattern to implement different matching algorithms. The main components are:

- `Record`: Represents a single row from the CSV with normalized data
- `RecordGroup`: Represents a group of records that represent the same person
- `MatchingTypes`: Implement different matching algorithms (email, phone, or both)

## Testcases

- bundle exec spec to run testcases.

