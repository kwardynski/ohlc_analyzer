# OhlcAnalyzer
Submission for the RBC Capital Markets STS take home interview assignment.

- [Instructions](#instructions)
  - [Requirements](#requirements)
  - [Data](#data)
  - [Guidelines](#guidelines)
  - [Deliverables](#deliverables)
- [Assumptions](#assumptions)
- [Notes](#notes)
- [Demo Instructions](#demo-instructions)
  - [Database Setup](#database-setup)
  - [Seeding Demo Data](#seeding-demo-data)
  - [Usage](#usage)

## Instructions
In this assignment, you are tasked with builiding an API that computes a [moving average](https://en.wikipedia.org/wiki/Moving_average) across [OHLC](https://en.wikipedia.org/wiki/Open-high-low-close_chart) data.

### Requirements
1. POST `/api/insert` - adds data to the application
2. GET `/api/average?window=last_10_items` - should return the moving average of the last 10 items
3. GET `/api/average?window=last_1_hour` - should return the moving average of **all items that were inserted to the data store in the past hour**

### Data
You should create a mock dataset that you can work with for development and testing
```
Sample Record
{
  "timestamp": "2021-09-01T08:00:00Z",
  "open": 16.83,
  "high": 19.13,
  "low": 15.49,
  "close": 16.04
}
```

### Guidelines
1. You can implement the assignment using any language/framework you find suitable for the task but using the Phoenix Framework is preferred
2. While the guidelines for this assignment are very loose, you should assume the API will be deployed to a production environment

### Deliverables
Please commit the relevant code to your GitHub account and share the link

## Assumptions
- Based on the [Key Takeaways](https://www.thebalancemoney.com/average-of-the-open-high-low-and-close-1031216#:~:text=The%20OHLC%20average%20uses%20the,on%20the%20insights%20you%20seek.) from this Balance Money article - OHLC averages are computed by using the average of the open, high, low, and close values. My interpretation is that the moving window average will be computed by averaging _all_ values in the included records.
- The instructions mention assuming the API will be deployed to a production environment, my interpretation of this is as follow:
  - Ensure the functions and controllers are properly unit tested - this solution includes a full testing suite.
  - Ensure the endpoints have documentation - `OpenApiSpex` has been used to generage Swagger docs for the exposed endpoints.
  - Authorization - it has been assumed that this production environment implements its own authorization, so the decision was made to omit auth for this exercise.

## Notes
- `CRUD` controller functions created by the Phoenix code generators have been pared down. Only functions which satisfy the requirements of the assignment have been left to minimize bloat. (`index`, `update`, `delete` not included for OHLC Records).
- The `window` parameter of the `GET` request has not been parsed in an effort to meet the requirements and prevent scope creep. The relevant controller simply matches against `last_10_items` and `last_1_hour`. Future solutions could implement a filter parser to extract the window type and size, or the endpoint could be modified to explicitly request this information from the user.
- Ecto's default `timestamps()` attributes are not used in the `Record` schema. The `timestamp` attribute has been made optional and will default to the current time if not provided. The `last_1_hour` `window` option filters against this `timestamp` value.
- To match the format of the Sample Record, `timestamp` values are truncated to seconds, using `DateTime.truncate(timestamp, :second)`.
- In order to handle floating point errors, the `Decimal` library is called when computing the moving average. Data is served to the user with 4 decimals of precision.

## Demo Instructions

### Database Setup
This solution assumes that Postgres is already installed and running as a background service. Create the repo(s) with `mix ecto.create` and run migrations with `mix ecto.migrate`.

### Seeding Demo Data
The `priv/repo/seeds.exs` script can be used to seed data for testing. It will seed 15 records to the `ohlc_analyzer_dev` database.
  1. 5 records from Jan 1, 2022 with all values = 1.234
  2. 5 records from Jan 1, 2023 with all values = 3.3
  3. 5 records using the script call time as the timestamp, with all values = 1.1

Submitting a `GET` request with `window=last_10_items` will use the records from `1` and `2` above, resulting in a moving average of 2.2. Submitting a `GET` request with `window=last_1_hour` will use only the records from `3`, resulting in a moving average of 1.1.

### Usage
Start the application with `mix phx.server`, the default url of `localhost:4000` is used. 
- Swagger documentation can be found at `localhost:4000/swaggerui`.
- `GET` requests can be made directly from the browser's url using the requested paths, either `localhost:4000/api/average?window=last_10_items` or `localhost:4000/api/average?window=last_1_hour`.
- Post request can be made using an external tool like `curl`:
```
# Insert an OHLC Record using current time as timestamp:
curl -d "open=1.1&high=2.2&low=3.45&close=6" -X POST http://localhost:4000/api/insert 

# Insert an OHLC Record specifying the timestamp
curl -d "open=16.83&high=19.13&low=15.49&close=16.04&timestamp=2021-09-01T08:00:00Z" -X POST http://localhost:4000/api/insert

```