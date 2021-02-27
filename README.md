# reef-pi-script-utils
Script utilities for the Reef-pi reef tank controller
## reef-py.py
```
usage: reef-py.py [-h] {list,show,buckets} ...

Command line interface for the reef-pi API. Modeled to resemble the 'reef-pi db' command

positional arguments:
  {list,show,buckets}
    list               List reef-pi items
    show               Show reef-pi items
    buckets            Show reef-pi buckets

optional arguments:
  -h, --help           show this help message and exit

 --help is available for subcommands: ./reef-py.py show --help

Examples: 
    ./reef-py.py list temperature --value id
    ./reef-py.py list temperature --value id,name --sep ' - '
    ./reef-py.py show temperature_usage 2 --value historical --last
    ./reef-py.py show ph_readings 4 --value current --last
    /reef-py.py show temperature_usage 2 --value current --last value
```

## Completion Scripts 
### reef-pi Completion Script ( _reef-pi )
### reef-py.py Completion Script ( _reef-py )

These Bash completion scripts will provide context-sensative options for the 
* ``reef-pi daemon ``
* ``reef-pi db ``  
* ``reef-pi install ``
* ``reef-pi reset-password ``
* ``reef-pi restore-db ``
* ``reef-py.py show ``
* ``reef-py.py list ``

commands using Bash's builtin completion feature with the &lt;TAB&gt; &lt;TAB&gt; key strokes.  

It will automatically provide the correct options for configured items in the user's reef-pi system.

Examples
<pre><code>%sudo reef-pi reset-password &lt;TAB&gt; &lt;TAB&gt;
-config    --help     -password  -user      

%sudo reef-pi db show e&lt;TAB&gt; &lt;TAB&gt; 
equipment  errors  
 
%sudo reef-pi db show equipment&lt;TAB&gt; &lt;TAB&gt; 
    11 &lt;Outlet 8&gt;
    3 &lt;Outlet 1&gt;
    4 &lt;Heater&gt;
    5 &lt;Outlet 2&gt;
    6 &lt;Skimmer&gt;
    7 &lt;Lights&gt;
    8 &lt;CO2 Regulator&gt;
    9 &lt;Main Filter&gt;
</code></pre>

Hitting &lt;TAB&gt; &lt;TAB&gt; after the equipment argument, will display the list of equiment items configured, with the internal id first and then help text in angle brackets with the configured name.

![Demo Gif](https://github.com/tmbarbour/reef-pi-script-utils/blob/main/images/reef-pi-completion-demo-2.gif?raw=true "reef-pi db completion demo")

The install script, copies the completion script to the ``/usr/share/bash-completion/completions/ ``directory so that it is automatically sourced and available for every new Bash shell

*NOTE: The _reef-py completion script requires a REEF_PY_PATH environment variable. That is created if you use the installation script.
The ./reef-py.py script requires authorization credentials (userid/password) for the API. Those are added in the ./auth/reef_py_secrets.py file*
