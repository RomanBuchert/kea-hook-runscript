
OBJECTS = src/messages.o src/logger.o src/load.o src/runscript.o src/callouts.o src/version.o
DEPS = $(OBJECTS:.o=.d)
CXXFLAGS = -I /usr/include/kea -fPIC -Wno-deprecated
LDFLAGS = -L /usr/lib/kea/lib -shared -lkea-dhcpsrv -lkea-dhcp++ -lkea-hooks -lkea-log -lkea-util -lkea-exceptions

kea-hook-runscript.so: $(OBJECTS)
	g++ -o $@ $(CXXFLAGS) $(LDFLAGS) $(OBJECTS)

%.o: %.cc
	g++ -MMD -MP -c $(CXXFLAGS) -o $@ $<

# Compile messages (for logging)
src/messages.h src/messages.cc: s-messages
s-messages: src/messages.mes
	kea-msg-compiler -d src/ $<
	touch $@

clean:
	rm -f src/*.o
	rm -f src/messages.h src/messages.cc s-messages
	rm -f kea-auth-radius.so

-include $(DEPS)
