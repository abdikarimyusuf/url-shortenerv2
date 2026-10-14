CLOUDFRONT:
- distribution - cloudfront configuration e.g where should request go, what should catched 
- origin: where cloud front gets the content from e.g s3 alb 
- behavior: what to do with a request matching a particular path 
- catche: cloud front stores a particular request if not stored already (""catch hit"if stored "miss" if not ") to a local edge location to user.
- edge location: servers distributed across the globe where cloudfront can you use to bring content closer to users

Origin Access Control (OAC) allows cloudfront to securly access an s3 
S3 bucket = building
CloudFront = authorized delivery person
OAC = OAC is a CloudFront resource that controls how CloudFront authenticates when accessing an origin.
allowed_methods = Which methods can CloudFront accept
cached_methods = Which methods can CloudFront cache
GET    → can cache
HEAD   → can cache
OPTIONS → allowed, but don't cache



GET
↓
"Give me something"

HEAD
↓
"Give me the headers/information about it, but not the body"

OPTIONS
↓
"Tell me what is allowed / used for things like CORS preflight"



🍪 Basic Cookie Flow

Imagine you log into a website.

1. Login
Browser
   │
   │ POST /login
   │ username + password
   ▼
Server

The server checks your login details.

If they are correct, it responds:

Set-Cookie: session_id=abc123

The browser stores it:

example.com
   │
   └── session_id=abc123
2. Next request

You visit:

/profile

The browser automatically sends the cookie:

GET /profile
Cookie: session_id=abc123

The server receives:

session_id=abc123

So it knows:

"This request belongs to the session associated with abc123."


restrictions = where you define restrictions on who can access the CloudFront distribution based on geography

viewer_certificate =certificate used by CloudFront ↔ Browser

 headers = [
        "Authorization" = this allows cloudfront to forward authorization headers to the origin, usefull when you're using services taht need authentication

- GET — "Give me something"- retrieve/read data.
- POST — sending data to the server to create something or perform an action. e.g
{
  "url": "https://google.com"
}

- PUT — replace an existing resource completely e.g 
Imagine you have a user:
{
  "name": "Ali",
  "email": "ali@example.com",
  "age": 25
}
PUT /users/123

with:

{
  "name": "Ali",
  "email": "new@example.com",
  "age": 26
}


- PATCH — "Change part of it"
- DELETE — "Remove it
- HEAD - "Is it there"  - HEAD is similar to GET, but the server doesn't return the response body
- OPTIONS asks the server what HTTP methods or capabilities are available. e.g.
OPTIONS /users

The server might respond with something like:

Allow: GET, POST, OPTIONS
sni-only → how CloudFront identifies the certificate


Browser
   │
   │ "Where is abdikarim.co.uk?"
   ▼
Route 53
   │
   │ "It's CloudFront"
   ▼
CloudFront