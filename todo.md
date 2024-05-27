## Todo

- [ ] Add a check to see if the instance is initialized  with the following command: 
  - `aws ec2 describe-instance-status --instance-ids <id> --query 'InstanceStatuses[*].{Instance:InstanceId,InstanceStatus:InstanceStatus.Status,SystemStatus:SystemStatus.Status}' --no-cli-pager`
- [ ] Add `--no-cli-pager` everywhere that `aws` is used to avoid the pager