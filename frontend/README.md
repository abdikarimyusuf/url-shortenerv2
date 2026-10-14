# Frontend → API Communication

The frontend is the part the user interacts with.
The API is the backend that processes the request.

The frontend does NOT directly talk to PostgreSQL, Redis, or SQS.
It talks to the API, and the API talks to those services.

## Basic Flow

                    👤 USER
                       │
                       │ enters URL
                       ▼
              ┌─────────────────┐
              │    FRONTEND     │
              │ HTML + CSS + JS │
              └────────┬────────┘
                       │
                       │ HTTP request
                       │ POST /shorten
                       ▼
              ┌─────────────────┐
              │       API       │
              │     FastAPI     │
              └────────┬────────┘
                       │
                       │ stores URL
                       ▼
              ┌─────────────────┐
              │   PostgreSQL    │
              │    Database     │
              └─────────────────┘


## What Happens When The User Clicks "Shorten URL"?

1. User enters:

       https://example.com

2. JavaScript reads the input:

       const url = input.value;

3. JavaScript sends an HTTP POST request:

       POST http://localhost:8020/shorten

4. The request contains JSON:

       {
         "url": "https://example.com"
       }

5. FastAPI receives the request:

       @app.post("/shorten")

6. The API generates a short code.

7. The API stores the URL in PostgreSQL.

8. The API sends a JSON response back:

       {
         "short": "a1b2c3d4",
         "url": "https://example.com"
       }

9. JavaScript receives the response:

       const data = await response.json();

10. The frontend displays the short URL to the user.


## The JavaScript → API Connection

Frontend JavaScript:

       fetch("http://localhost:8020/shorten", {
           method: "POST",

           headers: {
               "Content-Type": "application/json"
           },

           body: JSON.stringify({
               url: url
           })
       });


The important parts are:

       fetch()
          │
          │ sends HTTP request
          ▼
       localhost:8020
          │
          ▼
       /shorten
          │
          ▼
       FastAPI


## What Does fetch() Do?

fetch() is a JavaScript function used to make HTTP requests.

For example:

       fetch("http://localhost:8020/shorten")

means:

       "Send a request to the API at
        localhost on port 8020,
        using the /shorten endpoint."


## POST

       method: "POST"

POST means:

       "I am sending data to the server."

Our frontend sends:

       {
         "url": "https://example.com"
       }


## Content-Type

       "Content-Type": "application/json"

This tells the API:

       "The data I am sending is JSON."


## JSON.stringify()

       JSON.stringify({
           url: url
       })

Converts the JavaScript object into JSON text
that can be sent in the HTTP request.

Example:

       JavaScript object
              │
              ▼
       { url: "https://example.com" }
              │
              │ JSON.stringify()
              ▼
       '{"url":"https://example.com"}'


## API Response

The API processes the request and sends JSON back.

       API
        │
        │ JSON response
        ▼
       Frontend
        │
        │ response.json()
        ▼
       JavaScript object


## Complete Picture

                    👤 USER
                       │
                       │ enters URL
                       ▼
              ┌─────────────────┐
              │    FRONTEND     │
              │ HTML / CSS / JS │
              └────────┬────────┘
                       │
                       │ fetch()
                       │
                       │ POST /shorten
                       │
                       │ {"url":"https://example.com"}
                       ▼
              ┌─────────────────┐
              │       API       │
              │     FastAPI     │
              └────────┬────────┘
                       │
              ┌────────┼────────┐
              │        │        │
              ▼        ▼        ▼
           Redis   PostgreSQL   SQS
              │        │        │
              │        │        ▼
              │        │      Worker
              │        │        │
              │        │        ▼
              │        └──► PostgreSQL
              │
              └──► Cache


## Important Mental Model

Frontend
    = user interface

API
    = application logic / entry point

PostgreSQL
    = source of truth / permanent data

Redis
    = fast cache

SQS
    = message queue

Worker
    = background processing

Dashboard
    = analytics API