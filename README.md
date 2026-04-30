# Quote Editor

A Rails application allowing a collaborator to create and manage quotes directly from a simple quote editor. A quote has a name, contains line items, displays tax totals, and can be validated. Once validated, a quote becomes read-only and can no longer be modified or deleted.

## Features

- List existing quotes.
- Create a quote from the quote list screen.
- View a quote with its items and totals:
  - Total excluding VAT
  - VAT total
  - Total including VAT
- Edit a quote name from the quote screen.
- Add, edit, and delete quote items from the quote screen.
- Preview item totals (HT and TTC) while filling the item form.
- Validate a quote.
- Prevent any modification or deletion once a quote has been validated (UI, controllers and models).

The UX intentionally uses only two main screens:

- `quotes#index` for listing and creating quotes.
- `quotes#show` for viewing a quote, editing its name, and managing its items.

## Business Rules

The validated quote rule is enforced at several levels:

- UI: edit and delete actions are hidden once a quote is validated.
- Controllers: mutating actions are guarded before they run.
- Models: validated quotes and their items are protected from updates and deletes through validations and callbacks.

## Technical Stack

- Ruby 3.3.0
- Rails 8.0
- PostgreSQL
- Hotwire / Turbo
- Stimulus
- Minitest

## Setup

Install dependencies:

```bash
bundle install
```

Create and prepare the database:

```bash
bin/rails db:setup
```

Start the Rails server:

```bash
bin/rails server
```

Then open:

```text
http://localhost:3000
```

## Demo Data

The project includes seed data for local testing:

```bash
bin/rails db:seed
```

This will creates:

- 10 quotes
- 5 draft quotes
- 5 validated quotes
- 3 items per quote

The seed file is idempotent and can be run multiple times without duplicating existing seeded quotes.

To reset the database and reload the demo data:

```bash
bin/rails db:reset
```

## Running Tests

Run the full test suite:

```bash
bin/rails test
```

Run only model tests:

```bash
bin/rails test test/models
```

Run only controller tests:

```bash
bin/rails test test/controllers
```

## Code Quality

Run RuboCop:

```bash
bin/rubocop
```

Run Brakeman:

```bash
bin/brakeman
```

## Implementation Notes

### Turbo

Turbo Frames and Turbo Streams are used for inline interactions:

- Editing a quote name replaces only the quote name frame.
- Editing an item replaces the item row with a form.
- Creating, updating, or deleting an item refreshes the item list and quote totals without leaving the quote screen.

### Stimulus

Stimulus is used for a small client-side enhancement in the item form when user is filling it.

The controller `item_preview_controller.js` listens to changes on:

- quantity
- unit price excluding VAT
- VAT rate

It then recalculates:

- item total excluding VAT
- item total including VAT

This preview is only an UX improvement. The server-side model methods remain the source of truth for persisted totals and validation.

## Next Improvements

- Add concurrency safeguards around the quote validation and item mutations. In a production context, two requests can try to edit, delete, or validate the same quote at the same time. I would handle this with row-level locking, for example using `with_lock` around critical operations such as quote validation or item creation/update/deletion to ensure the quote is still editable at the exact moment the mutation is persisted.
- Extract pricing and tax calculations into dedicated domain objects or services if the rules become more complex. 

- Add a small amount of system coverage for the full browser flow.
- Improve the design while keeping the UI simple.
- Add pagination or search if the quote list grows.
