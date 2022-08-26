# This is the terraform-module-les-info module

## Requirements

No requirements.

## Providers

No providers.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | The application ID. | `string` | n/a | yes |
| <a name="input_les"></a> [les](#input\_les) | The Logical Environment Specifier (LES). Can be either "sbx", "dev", "stg" or "prd". | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_schemas"></a> [all\_schemas](#output\_all\_schemas) | A map of all the schemas (for the provided LES value) containing the database schema name for the microservice, the according environment ("sbx", "dev", "stg" or "prd") and the microservice name in the vault.<br>The result will look as follow:<br>all\_schemas = {<br>  microserviceNameA\_environmentNameA = {<br>    environment = "environmentNameA"<br>    schema = "microserviceNameA\_environmentNameA"<br>    vault\_microservice = "microserviceNameA"<br>  }<br>  microserviceNameA\_environmentNameB = {<br>    environment = "environmentNameB"<br>    schema = "microserviceNameA\_environmentNameB"<br>    vault\_microservice = "microserviceNameA"<br>  }<br>...<br>} |
| <a name="output_all_users"></a> [all\_users](#output\_all\_users) | A map of all the users (for the provided LES value) containing the database schema name for the microservice, the according environment ("sbx", "dev", "stg" or "prd"), the microservice name in the vault and the associated type ("fw", "rw" or "ro").<br>The result will look as follow:<br>all\_users = {<br>  microserviceNameA\_environmentNameA\_fw = {<br>    environment = "environmentNameA"<br>    schema = "microserviceNameA\_environmentNameA"<br>    type = "fw"<br>    vault\_microservice = "microserviceNameA"<br>  }<br>  microserviceNameA\_environmentNameA\_ro = {<br>    environment = "environmentNameA"<br>    schema = "microserviceNameA\_environmentNameA"<br>    type = "ro"<br>    vault\_microservice = "microserviceNameA"<br>  }<br>  microserviceNameA\_environmentNameA\_rw = {<br>    environment = "environmentNameA"<br>    schema = "microserviceNameA\_environmentNameA"<br>    type = "rw"<br>    vault\_microservice = "microserviceNameA"<br>  }<br>...<br>} |
| <a name="output_base_vault_path"></a> [base\_vault\_path](#output\_base\_vault\_path) | The base path for storing secrets in the vault. |
| <a name="output_cluster_identifier"></a> [cluster\_identifier](#output\_cluster\_identifier) | The identifier (name) of the cluster containing the database based on the provided LES ("sbx", "dev", "stg" or "prd") value. |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the database according to the provided LES ("sbx", "dev", "stg" or "prd") value. |
| <a name="output_db_security_group_name"></a> [db\_security\_group\_name](#output\_db\_security\_group\_name) | The name of the security group for the database depending on the provided LES value. |
| <a name="output_dr_vpc_id"></a> [dr\_vpc\_id](#output\_dr\_vpc\_id) | The VPC ID based on the selected environment (production or non-production) for the secondary (disaster recovery) region. |
| <a name="output_dr_vpc_subnet_ids_sorted"></a> [dr\_vpc\_subnet\_ids\_sorted](#output\_dr\_vpc\_subnet\_ids\_sorted) | The sorted VPC subnets for the zones in the secondary (disaster recovery) region based on the selected environment (production or non-production). |
| <a name="output_is_development"></a> [is\_development](#output\_is\_development) | A flag indicating whether the provided LES value corresponds to a development environment. |
| <a name="output_is_production"></a> [is\_production](#output\_is\_production) | A flag indicating whether the provided LES value corresponds to a production environment. |
| <a name="output_is_staging"></a> [is\_staging](#output\_is\_staging) | A flag indicating whether the provided LES value corresponds to a staging environment. |
| <a name="output_istio_aurora_db_client_port"></a> [istio\_aurora\_db\_client\_port](#output\_istio\_aurora\_db\_client\_port) | The Istio client port for the main writer.<br>Note that a few related client port values will be derived from it too (main reader, secondary writer and secondary reader). |
| <a name="output_istio_aurora_db_dr_client_port"></a> [istio\_aurora\_db\_dr\_client\_port](#output\_istio\_aurora\_db\_dr\_client\_port) | The Istio client port for the secondary (disaster recovery) writer. |
| <a name="output_istio_aurora_db_dr_reader_client_port"></a> [istio\_aurora\_db\_dr\_reader\_client\_port](#output\_istio\_aurora\_db\_dr\_reader\_client\_port) | The Istio client port for the secondary (disaster recovery) reader. |
| <a name="output_istio_aurora_db_reader_client_port"></a> [istio\_aurora\_db\_reader\_client\_port](#output\_istio\_aurora\_db\_reader\_client\_port) | The Istio client port for the main reader. |
| <a name="output_kms_administrators_arn"></a> [kms\_administrators\_arn](#output\_kms\_administrators\_arn) | The ARN of the IAM identity (role) in the AWS account having the administrator permissions for the KMS. |
| <a name="output_master_username"></a> [master\_username](#output\_master\_username) | The master username for the database. |
| <a name="output_paap_style_env"></a> [paap\_style\_env](#output\_paap\_style\_env) | The selected environment based on the provided LES value. Can be either "development", "staging" or "production". |
| <a name="output_vault_path_sep"></a> [vault\_path\_sep](#output\_vault\_path\_sep) | The vault path separator symbol if one wants to dynamically separate path elements outside of this module. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID based on the selected environment (production or non-production) for the primary region. |
| <a name="output_vpc_subnet_ids_sorted"></a> [vpc\_subnet\_ids\_sorted](#output\_vpc\_subnet\_ids\_sorted) | The sorted VPC subnets for the zones in the primary region based on the selected environment (production or non-production). |
The content of this file has been generated on Wed Mar  9 15:03:09 EST 2022

## Versioning

We use [SemVer](http://semver.org/) for versioning.

## Authors

* [Eve Hamilton](https://git.bnc.ca/plugins/servlet/user-contributions/hame008)
* [Laurent Raharison](https://git.bnc.ca/plugins/servlet/user-contributions/rahl002)
* [Joel Moum](https://git.bnc.ca/plugins/servlet/user-contributions/mouj010)

See also the list of [contributors](https://git.bnc.ca/plugins/servlet/graphs/activity/APP6157/terraform-module-les-info?refId=refs%2Fheads%2Ffeature%2FDTB-15784&from=2022-04-12&to=2022-05-12) who participated in this project.

## License

No License
