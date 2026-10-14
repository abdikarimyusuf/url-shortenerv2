Node = one shop location
Node type = size of the shop
Multiple nodes = multiple shop locations
Replica = backup shop
Failover = backup shop takes over if the main shop closes


Part	What it means
Engine	The caching software, usually Redis
Node type	The size, processing power, and memory of the Redis server
Number of nodes	How many Redis servers you run
Subnet group	The private subnets where Redis is deployed
Security group	Controls which applications can connect
Port	Redis normally uses port 6379
Encryption in transit	Encrypts data moving between your app and Redis
Authentication	Requires credentials to access Redis
Automatic failover	Switches to a backup node if the primary fails
Multi-AZ	Places Redis nodes in different Availability Zones
Backups/snapshots	Allows Redis data to be recovered
Monitoring	Tracks memory, connections, cache hits, and performance


outputs: 
primary_endpoint_address	Read and write, especially writes
reader_endpoint_address	Read operations across replicas