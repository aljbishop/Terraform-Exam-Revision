policy "restrict-ec2-instance-type" {
    source = "./restrict-ec2-instance-type.sentinel"
    enforcement _level = "hard-mandatory"
}