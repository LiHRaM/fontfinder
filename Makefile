prefix ?= /usr/local
bindir = $(prefix)/bin
appdir = $(prefix)/share/applications
icondir = $(prefix)/share/icons/hicolor/scalable/apps

CARGO_TARGET_DIR?=target
GTK=fontfinder-gtk
DESKTOP=fontfinder.desktop

all: $(GTK)

$(GTK):
	if [ -d vendor ]; then \
		cargo build --release --frozen --manifest-path gtk/Cargo.toml; \
	else \
		cargo build --release --manifest-path gtk/Cargo.toml; \
	fi

clean:
	cargo clean
	cargo clean --manifest-path gtk/Cargo.toml

distclean: clean
	rm -rf .cargo vendor

install:
	install -D $(CARGO_TARGET_DIR)/release/$(GTK) $(DESTDIR)$(bindir)/$(GTK)
	install -Dm644 assets/$(DESKTOP) $(DESTDIR)$(appdir)/$(DESKTOP)

uninstall:
	rm $(DESTDIR)$(bindir)/$(GTK)
	rm $(DESTDIR)$(appdir)/$(DESKTOP)

vendor: ./cargo/config
	cargo vendor
	touch vendor
