# Troubleshoot
## Truncated icons
Revert to Ubuntu Mono Nerd Font 2.0

## Brightness permission denied
Add these lines in /etc/udev/rules.d/95/backlight.rules:
```
RUN+="/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
RUN+="/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
```
