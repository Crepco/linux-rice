#!/bin/bash
uptime -p | sed -e 's/up //' -e 's/ days\?/d/g' -e 's/ hours\?/h/g' -e 's/ minutes\?/m/g' -e 's/, / /g'
