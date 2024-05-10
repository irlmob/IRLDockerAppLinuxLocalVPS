## Compose version
all: install
w = wg0.conf

install: wg0check
	@./bin/install.sh add

uninstall:
	@./bin/$(shell cat .servicename) uninstall
	
## 
.PHONY: wg0check    
wg0check:
	@echo ""
	@echo "-> 🔍 Checking $w"
	@if [ -f "$w" ]; then echo "✅ Found $w"; else echo "⛔️ \e[31mERROR!!! $w not found" && echo "\e[39m"; exit 1; fi
	@echo ""
	@echo "🔍 [Interface]"
	@if grep "PostUp = /etc/wireguard-redir/init.sh" $w > /dev/null; then echo "✅ PostUp ok"; else echo "⛔️ \e[31mERROR!!! $w - [Interface] | PostUp not found. Please add:\e[39m" && echo "PostUp = /etc/wireguard-redir/init.sh" && echo "" && exit 1; fi
	@if grep "PostDown = /etc/wireguard-redir/postdown.sh" $w > /dev/null; then echo "✅ PostDown ok"; else echo "⛔️ \e[31mERROR!!! $w - [Interface] | PostDown not found. Please add:\e[39m" && echo "PostDown = /etc/wireguard-redir/postdown.sh" && echo "" && exit 1; fi
	@echo ""
	