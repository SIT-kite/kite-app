# Expense Tracker

## Remote

1. Fetching the data, in json, form school website.
2. Mapping the raw data to "raw" dart classes, such as `TransactionRaw`
   in [remote.dart](entity/remote.dart).
3. Analyzing the "raw" dart classes, and transform them into several classes and enums, such
   as `Transaction` and `TranscationType` in [local.dart](entity/local.dart).

## Local

### Adding extra data

1. Adding TypeMark, `Food`, `TopUp`, `Subsidy` and so on, which can be modified manually by users.

### Persistence
- Option A: Serializing the local classes into Hive with generated TypeAdapter.
- Option B: Serializing the local classes in json for the future needs.

## Display
Transactions are page-splitted by month to display with an endless lazy column.