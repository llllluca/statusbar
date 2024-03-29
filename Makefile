# statusbar for dwm (dynamic window manager)
VERSION = 1.0

# paths
PREFIX = /usr/local
ACPI = /etc/acpi
NETWORK_MANAGER = /usr/lib/NetworkManager
SYSTEM_SLEEP = /lib/systemd/system-sleep

COMMANDS = \
    statusbar-battery \
    statusbar-brightness \
    statusbar-datetime \
    statusbar-volume \
    statusbar-wifi \
    statusbar-eth

ACPI_EVENTS = \
	jack-headphone-plug \
	jack-headphone-unplug \
	power-supply-plug

ACPI_SCRIPTS = \
	statusbar-refresh.sh

NETWORK_MANAGER_SCRIPTS = \
	statusbar-refresh.sh

SYSTEM_SLEEP_SCRIPTS = \
	statusbar-refresh.sh

all:
	@echo statusbar, version: ${VERSION}
	@echo Customize the path variables in the Makefile and run \'$$ make install\'. To uninstall run \'$$ make uninstall\'.
	@echo Install and uninstall may require superuser privileges depending on the path variables you set.

install: 
	mkdir -p ${PREFIX}/bin
	cp -f statusbar-deamon ${PREFIX}/bin
	chmod 755 ${PREFIX}/bin/statusbar-deamon
	cp -f statusbar-scheduler ${PREFIX}/bin
	chmod 755 ${PREFIX}/bin/statusbar-scheduler
	for s in ${COMMANDS} ; do \
		cp -f commands/$$s ${PREFIX}/bin ; \
		chmod 755 ${PREFIX}/bin/$$s ; \
	done
	for e in ${ACPI_EVENTS} ; do \
		cp -f acpi-events/$$e ${ACPI}/events ; \
	done
	for s in ${ACPI_SCRIPTS} ; do \
		cp -f acpi-events/$$s ${ACPI} ; \
		chmod 755 ${ACPI}/$$s ; \
	done
	for s in ${NETWORK_MANAGER_SCRIPTS} ; do \
		cp -f network-manager-events/$$s ${NETWORK_MANAGER}/dispatcher.d ; \
		chmod 755 ${NETWORK_MANAGER}/dispatcher.d/$$s ; \
	done
	for s in ${SYSTEM_SLEEP_SCRIPTS} ; do \
		cp -f system-sleep-events/$$s ${SYSTEM_SLEEP} ; \
		chmod 755 ${SYSTEM_SLEEP}/$$s ; \
	done



uninstall:
	for s in ${COMMANDS} ; do \
		rm -f ${PREFIX}/bin/$$s ; \
	done
	for e in ${ACPI_EVENTS} ; do \
		rm -f ${ACPI}/events/$$e ; \
	done
	for s in ${ACPI_SCRIPTS} ; do \
		rm -f ${ACPI}/$$s ; \
	done
	for s in ${NETWORK_MANAGER_SCRIPTS} ; do \
		rm -f ${NETWORK_MANAGER}/dispatcher.d/$$s ; \
	done
	for s in ${SYSTEM_SLEEP_SCRIPTS} ; do \
		rm -f ${SYSTEM_SLEEP}/$$s ; \
	done


.PHONY: all install uninstall
