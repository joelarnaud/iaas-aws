# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2022-07-18

- Add missing backend.tf file in route-53 module.
- Resize the ElastiCache cluster (node type, number of shards and number of replicas) in all the environments. [hame008](https://git.bnc.ca/plugins/servlet/user-contributions/hame008)

## [1.2.9] - 2022-07-20

- Remove istio client port for elasticache. [rahl002](https://git.bnc.ca/plugins/servlet/user-contributions/rahl002)

## [1.2.8] - 2022-07-11

- Enable cloudwatch log. [rahl002](https://git.bnc.ca/plugins/servlet/user-contributions/rahl002)

## [1.2.7] - 2022-06-28

- Update module versions. [rahl002](https://git.bnc.ca/plugins/servlet/user-contributions/rahl002)

## [1.2.6] - 2022-06-28

- Expose istio port for elasticache. [rahl002](https://git.bnc.ca/plugins/servlet/user-contributions/rahl002)

## [1.2.5] - 2022-06-21

- Downsize the ElastiCache Redis cluster. [@hame008](https://git.bnc.ca/plugins/servlet/user-contributions/hame008)

## [1.2.4] - 2022-06-20

- Add timestamps to pipeline logs. [@hame008](https://git.bnc.ca/plugins/servlet/user-contributions/hame008)

## [1.2.3] - 2022-05-25

- Fix failure when Build with tag rather than branch. [@mouj010](https://git.bnc.ca/plugins/servlet/user-contributions/mouj010)

## [1.2.2] - 2022-06-01

- Fix the vault path containing the cache's configuration endpoint. [@hame008](https://git.bnc.ca/plugins/servlet/user-contributions/hame008)

## [1.2.1] - 2022-05-25

- added dev, staging and prod configurations for redis-cluster and route53. [@mouj010](https://git.bnc.ca/plugins/servlet/user-contributions/mouj010)

## [1.2.0] - 2022-05-24

- Do not create a global datastore with a DR replication group.
- Update the vault entry with the with the created DNS record in Route 53 to access the Redis cache cluster. [@hame008](https://git.bnc.ca/plugins/servlet/user-contributions/hame008)

## [1.1.0] - 2022-05-20

- Add a Route 53 module to create a CNAME record to map the cluster's configuration endpoint to a user-friendly DNS name. [@hame008](https://git.bnc.ca/plugins/servlet/user-contributions/hame008)

## [1.0.0] - 2022-05-17

- Add tags creation at the pipeline level. [@mouj010](https://git.bnc.ca/plugins/servlet/user-contributions/mouj010)
