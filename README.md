# README

Build a background job system that is compatible with the ActiveJob interface of
Rails and allows Rails developers to easily enqueue jobs to a Google Pub Sub backend.

The background for this app is that we store company data including VAT number. There is an external service for validating the (EU) VAT numbers. However, that service can be slow and sometimes down. https://vatlayer.com (requires an API key)

The service is called from the class [VatValidator](https://github.com/andreaseriksson/gcloud_playground/blob/master/app/services/vat_validator.rb) through a background job [VatValidatorJob](https://github.com/andreaseriksson/gcloud_playground/blob/master/app/jobs/vat_validator_job.rb) which is called in an [after_save callback](https://github.com/andreaseriksson/gcloud_playground/blob/master/app/models/company.rb#L7)  

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
VATLAYER_SECRET_KEY=DDDDDDD
```
