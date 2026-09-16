for key, repo in aws_ecr_repository.url_shortener :
    key => repo.repository_url

Creates a map like this:

Key        => Value
-------------------------------
api        => API repository URL
worker     => Worker repository URL
dashboard  => Dashboard repository URL

Person analogy

Person:
name = Ahmed
age  = 25

If you write: person.name

You get: Ahmed

Therefore:

repo.repository_url

means:

Go inside the repository object and get its URL.


From the root folder
module.ecr.repository_url

gets the whole map.

module.ecr.repository_url["api"]

gets only the API URL.








