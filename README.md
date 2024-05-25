<h1 align="center"> 🌩️ AWS Terminal Console 💻 </h1>
<div align="center">
<a href="https://aws.amazon.com/ecs/">
<img alt="ecs" src="https://img.shields.io/badge/AWS-ECS-FF9900?logo=amazonecs"/></a>

<a href="https://aws.amazon.com/ec2/">
<img alt="ec2" src="https://img.shields.io/badge/AWS-EC2-FF9900?logo=amazonec2"/></a>

<a href="https://aws.amazon.com/s3/">
<img alt="s3" src="https://img.shields.io/badge/AWS-S3-569A31?logo=amazons3"/></a>

<br />

<a href="https://www.gnu.org/software/bash/">
<img alt="bash" src="https://img.shields.io/badge/Made_with-bash-1f425f.svg"/></a>

<a href="https://github.com/davatorium/rofi">
<img alt="rofi" src="https://img.shields.io/badge/uses-rofi-red.svg"/>
</a>
<a href="https://github.com/stilvoid/dmenu">
<img alt="rofi" src="https://img.shields.io/badge/uses-dmenu-red.svg"/>
</a>

<a href="https://ubuntu.com/">
<img alt="repo size" src="https://img.shields.io/badge/%20-Linux-1f425f.svg?logo=linux&logoColor=cyan"/></a>

<br>
<a href="https://github.com/existme/aws-terminal-console">
<img alt="file count" src="https://img.shields.io/github/directory-file-count/existme/aws-terminal-console"/></a>

<a href="https://github.com/existme/aws-terminal-console">
<img alt="repo size" src="https://img.shields.io/github/repo-size/existme/aws-terminal-console?logo=github"/></a>

</div>

### AWS Terminal Console

**AWS Terminal Console** is written in Bash, designed to provide a seamless and efficient command palette interface for managing AWS services. Utilizing `dmenu` and `rofi` for intuitive user interactions, this tool offers quick access to various AWS functionalities directly from the terminal.

Key Features:
- **EC2 Instance Management**: Easily list and select EC2 instances with dynamic command options based on the instance state.
    - For stopped instances: 'start' and 'open link to instance'.
    - For running instances: 'stop', 'logs', 'login', and 'open link to instance'.
- **User-Friendly Interface**: The command palette ensures that only relevant commands are displayed, enhancing user experience and operational efficiency.
- **Adaptable and Intuitive**: The smart system adjusts available commands based on the current status of the instances, ensuring users have the right tools at their fingertips.

AWS Terminal Console is perfect for users who prefer managing their AWS infrastructure directly from the terminal, leveraging the simplicity and power of Bash along with the sleek interfaces of `dmenu` and `rofi`.