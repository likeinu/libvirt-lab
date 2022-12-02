variable "bases" {
  type        = map(any)
  description = "Map (of maps) - a list of created volumes (attributes for each volume:  url and name)"
}
variable "pools_path_root" {
  type        = string
  description = "Path to directory with all pools. It should be created before."
}
variable "pool_base" {
  type        = string
  default     = "bases"
  description = "Name of pool for base images."
}