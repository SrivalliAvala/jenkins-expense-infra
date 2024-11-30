variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Environment = "dev"
    }
}


variable "zone_name" {
    default = "dev-ops81s.online"
}

variable "zone_id" {
    default = "Z075800523JQAT1TRA35I"
}
