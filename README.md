# rtm-cli

A command line tool that provides a request URL to the Remember The Milk API based on input parameters.

\* This product uses the Remember The Milk API but is not endorsed or certified by Remember The Milk.

## Usage
```
USAGE: rtm_cli [--key <key>] [--secret <secret>] [--frob <frob>] [--token <token>] [--filter <filter>] <method>

ARGUMENTS:
  <method>                Specify the method of the request URL to be retrieved.

OPTIONS:
  --key <key>             Enter when specifying the API Key used for URL assembly.
  --secret <secret>       Enter when specifying the API Secret used for URL assembly.
  --frob <frob>           Enter the Frob obtained from Remember The Milk.
  --token <token>         Enter the Auth Token obtained from Remember The Milk.
  --filter <filter>       Task acquisition conditions.
  -h, --help              Show help information.
```
