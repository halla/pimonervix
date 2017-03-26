# Pimonervix

Experiments with monitoring sensors with Nerves on Raspberry Pi. Phoenix web interface.

Early. Very early.



Installation
- system is in /var/www/pimonervix (this can be a symlink)

Misc:
- enable dht11 overlay for one-wire protocol in /boot/config.txt
  - dtoverlay=dht11,gpiopin=4
  - (or command line:)
    - $ dtoverlay dht11 gpiopin=4 )

Enable run on boot (systemd)
- copy scripts/pimonnervix.service to /lib/systemd/system/
- sudo systemctl enable pimonervix


# Links

Nerves Project
http://nerves-project.org/

Elixir
http://elixir-lang.org/

Phoenix
http://phoenixframework.org/
