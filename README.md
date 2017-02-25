# brute-probe
Shell script to loop `aireplay-ng` probe requests with a dictionary of possible (E)SSIDs.

# Usage
Run `airodump-ng` in another terminal to listen for any valid probe responses.

```
./brute-probe.sh [dictionary] -i [interface] -a [target BSSID] [-c [channel]]
```

* **[dictionary** is the list of possible SSIDs you want to send probe requests for, one per line. Must be the first parameter.
* **-i** lets you specify the **[interface]** you want to use with `aireplay-ng`. This can be the same adapter you are using `airmon-ng` to listen with. It can also be another adapter, and does not have to be in monitor mode.
* **-a** or **--bssid** lets you specify the **[target BSSID]**.
* **-c** optionally lets you specify the **[channel]** number you want to set your interface to. It must be the same channel as the AP/BSSID you want to send probe requests to in order to work, but omitting this option assumes you have already set it.

Example:
```
./brute-probe.sh dictionary.txt -i wlan0 -a 00:00:00:00:00:00 -c 1
```
