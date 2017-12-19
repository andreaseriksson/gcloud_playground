# README

Build a background job system that is compatible with the ActiveJob interface of
Rails and allows Rails developers to easily enqueue jobs to a Google Pub Sub backend.

### Get started

Run:

```
bundle install && rails db:migrate && rails db:test:prepare
```

### Start server

Run:

```
foreman start -f Procfile.dev
```

### Requirements

Create a .env file with:

```
GOOGLE_CLIENT_ID=AAAAAAA
GOOGLE_CLIENT_SECRET=BBBBBBB
PROJECT_ID=CCCCCCC
```
