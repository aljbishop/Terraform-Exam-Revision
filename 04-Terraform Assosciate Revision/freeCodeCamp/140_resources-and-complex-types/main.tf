terraform {
  
}

variable "planets" {
    type = list
    default = ["mars", "earth", "moon"]
}

variable "plans" {
    type = map
    default = {
        "PlanName" = "10 GBP"
        "PlanAmount" = "50 GBP"
    }

    
}


variable "plan" {
    type = object({
        PlanName = string
        PlanAmount = number
    })

    default = {
        "PlanName"   = "basic",
        "PlanAmount" = 50
    }
}

variable "random" {
    type = tuple([string, number, bool])
    default = ["hello", 22, false]

}