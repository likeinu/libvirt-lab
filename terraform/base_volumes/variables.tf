# My images
variable "bases" {
  type        = map(any)
  description = "Map (of maps) - a list of created volumes (attributes for each volume:  url and name)"
}

# Path to pool
variable "pools_path_root" {
  type        = string
  description = "Path to directory with all pools. It should be created before."
}

# Pool name
variable "pool_base" {
  type        = string
  default     = "bases"
  description = "Name of pool for base images."
}