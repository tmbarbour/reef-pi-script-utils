# reef-pi-script-utils
Script utilities for the Reef-pi reef tank controller

## reef-pi Completion Script ( _reef-pi )

This Bash completion script will provide context-sensative options for the 
* ``reef-pi db ``  
* ``reef-pi reset-password ``

commands using Bash's builtin completion feature with the &lt;TAB&gt; &lt;TAB&gt; key strokes.  

It will automatically provide the correct options for configured items in the user's reef-pi system.

Example
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

![Demo Gif](https://github.com/tmbarbour/reef-pi-script-utils/raw/images/reef-pi-completion-demo-2.gif "reef-pi db completion demo")

The install script, copies the completion script to the ``/usr/share/bash-completion/completions/ ``directory so that it is automatically sourced and available for every new Bash shell