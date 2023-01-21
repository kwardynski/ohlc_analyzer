# OhlcAnalyzer

## INSTRUCTIONS
In this assignment, you are tasked with builiding an API that computes a [moving average](https://en.wikipedia.org/wiki/Moving_average) across [OHLC](https://en.wikipedia.org/wiki/Open-high-low-close_chart) data.

### Requirements
1. POST `/api/insert` - adds data to the application
2. GET `/api/average?window=last_10_items` - should return the moving average of the last 10 items
3. GET `api/average?window=last_1_hour` - should return the moving average of **all items that were inserted to the data store in the past hour**

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

## NOTES
- using timestamp as proxy for inserted_at, updated_at