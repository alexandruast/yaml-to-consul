# Generic source control key:value data store for services, backed by Consul

```
usage: kvstore.py [-h] [--config-dir CONFIG_DIR] [--import-dir IMPORT_DIR]

Import YAML into Consul

optional arguments:
  -h, --help            show this help message and exit
  --config-dir CONFIG_DIR
                        Config directory
  --import-dir IMPORT_DIR
                        YAML directory to import
```

## Issue
When writing code, some variables are final.  
Example: environment, service_endpoint, service_port, service_name etc...  
Even if these variables are final in the code at runtime, they might change over time. Because of increased complexity and number of services, changing these variables in all of the code base proves very difficult.  
**Another, very important reason, is that a variable change will trigger a new build with a new version number, even if the code itself did not change.**  
This approach is bad for productivity, and needs to be addressed by migrating to a single source of truth for the data in question.

## Anticipated Outcomes
By having a central source of truth for all this data, and make the code fetch the variables at runtime, we will achieve the following:  
  * no more builds without actual code changes
  * no more messing around with final variables inside code

## Proposed Solution
Data will be stored in version control(git/bitbucket), as multiple YAML files.  
After every change, the YAMLs will be parsed, converted to JSON format that Consul understands, tested, and then deployed into Consul.  

#### Local testing
OS requirements: python, python-pip  
You will need a consul server somewhere, you can install and start your own:
```
wget https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip
unzip consul_1.0.6_linux_amd64.zip
mv ./consul /usr/bin/consul
rm -f consul_1.0.6_linux_amd64.zip
consul agent -dev
```

Install pips from requirements.txt:  
```
pip install -r requirements.txt
```

If you run the consul server locally, no config is required.  
Otherwise, you will need to adjust config/main.yml file with actual consul servers and maybe other settings as well.  
Actual data to be imported is stored in import/ directory.  

Running the tool:
```
python ./kvstore.py
[info] Parsing config/export YAML files...
[info] Processing 10 records...
[info] Deleting all records from localhost:8500...
[info] Importing 10 records into localhost:8500...
[info] Importing 10 records into 127.0.0.1:8500...
[info] Done importing records into Consul.
```

Running tests(optional):
```
python ./tests/test_kvstore.py
```