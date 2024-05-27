#!/bin/zsh

# Lists the instances with their details
list_instances() {
    local refArray=$1
    local res
    # --filters "Name=instance-state-name,Values=stopped"
    res=$(aws ec2 describe-instances --query "Reservations[].Instances[].{InstanceId:InstanceId,InstanceType:InstanceType,State:State.Name}" --output json --no-cli-pager)
    table=$(echo "$res" | jq -r '.[] | "\(.InstanceId) | \(.InstanceType) | \(.State) \(.State)!"' | sed -e 's/running!/██/g' -e 's/stopped!/░░/g')
    adjusted_table=$(format_table "$table")
    instances=()
    while read -r line; do
      id=$(echo $line| cut -d' ' -f1 | tr -d ' ')
      instances[$id]=$line
    done < <(echo $adjusted_table)
    set -A "$refArray" ${(kv)instances}
}

# Describes the instance with the given instance id
describe_instance(){
    local instance_id=$1
    aws ec2 describe-instances --instance-ids $instance_id
}

# Formats the instance details for display
format_instance(){
  local instance_spec=$1
  echo $instance_spec|jq -r '.Reservations[].Instances[] | "==> \(.InstanceId) | \(.InstanceType) | \(.State.Name) \(.State.Name)!"' | sed -e 's/running!/██/g' -e 's/stopped!/░░/g'
}

# This function generates the menu options based on the state of the EC2 instance.
# It takes the instance specifications as input, extracts the instance ID and state,
# and then generates the appropriate menu options.
#
# Arguments:
#   instance_spec: A JSON string containing the specifications of the EC2 instance.
#
# Outputs:
#   A list of menu options. Each option is a string containing the name of the action
#   and the corresponding function to call. The options are separated by spaces.
#
# Example:
#   If the instance is stopped, the function will return:
#   "Start Instance start_instance <instance_id> Describe Instance describe_instance <instance_id>"
#   If the instance is running, the function will return:
#   "Stop Instance stop_instance <instance_id> Describe Instance describe_instance <instance_id>"
generate_ec2_menus() {
  local refArray=$1
  local instance_spec=$2
  local instance_id=$(echo "$instance_spec" | jq -r '.Reservations[].Instances[].InstanceId')
  local instance_state=$(echo "$instance_spec" | jq -r '.Reservations[].Instances[].State.Name')

  declare -A the_menu=()

  if [[ "$instance_state" == "stopped" ]]; then
    the_menu["start"]="<span foreground='green'><b>Start</b></span> the instance"
  elif [[ "$instance_state" == "running" ]]; then
    the_menu["stop"]="<span foreground='red'><b>Stop</b></span> the instance"
    the_menu["ssh"]="<span foreground='yellow'><b>SSH</b></span> into the instance"
  fi
  the_menu["describe"]="<b>Describe</b> the instance"
  the_menu["jupyter"]='<b>Portforward</b> jupyter to localhost:23000'

  set -A "$refArray" ${(kv)the_menu}
}

# Starts or stops the instance based on the desired state
start_stop_instance() {
    local instance_id=$1
    local desired_state=$2
    local instance_specs=$3
    local current_state

    if [[ "$desired_state" != "running" && "$desired_state" != "stopped" ]]; then
        echo "Invalid state. Please provide 'running' or 'stopped'."
        return 1
    fi

    current_state=$(echo $instance_specs | jq -r '.Reservations[].Instances[].State.Name')

    if [[ "$desired_state" == "running" && "$current_state" == "stopped" ]]; then
        aws ec2 start-instances --instance-ids "$instance_id"
    elif [[ "$desired_state" == "stopped" && "$current_state" == "running" ]]; then
        aws ec2 stop-instances --instance-ids "$instance_id"
    fi

    while [[ "$current_state" != "$desired_state" ]]; do
        current_state=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[*].Instances[*].State.Name' --output text)
        echo -e "Instance \e[1m$instance_id\e[0m state is \e[1m$current_state\e[0m $current_state! ..." | sed -e 's/running!/🟢/g' -e 's/stopped!/🔴/g'
        sleep 5
    done
    [[ "$desired_state" == "running" ]] && echo "Instance $instance_id has started."
}