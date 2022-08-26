variable "bucket" {
  description = "The bucket for the source code in the primary region."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}