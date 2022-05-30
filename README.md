## Azure IoT Hub

Simple terraform deployment of Azure IoT Hub with limited public access.

```
az login
az extension add --name azure-iot

export PUB_IP=<whatismyip>

terraform init
terraform apply -var public_ip=$PUB_IP
```

Access to IoT Hub is limited to specific IP Address (set as PUB_IP):  
`portal / IoT Hub / <name> / Networking / Public network access: Selected IP ranges`

Created Device for tests:  
`portal / IoT Hub / <name> / Devices `

To test connection with IoT Hub you can play usig e.g. Python:  
https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-python-python-c2d

To clean up:
```
terraform destroy -var public_ip=$PUB_IP
```
