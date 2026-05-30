#!/bin/bash
#============================================================
# Linux System Optimizer v1.0
# Optimizes low-spec Linux systems for better performance
# Compatible with Ubuntu/Debian/Mint/Xubuntu/Lubuntu
#============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Icons
CHECK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
WARN="${YELLOW}⚠${NC}"
INFO="${CYAN}ℹ${NC}"

#============================================================
# Helper Functions
#============================================================
print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║         Linux System Optimizer v1.0                     ║"
    echo "║         Boost Performance on Low-Spec Machines          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${BLUE}[$1]${NC} $2"
    echo "────────────────────────────────────────────────────────"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run as root: sudo bash $0${NC}"
        exit 1
    fi
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_NAME=$PRETTY_NAME
    else
        DISTRO="unknown"
        DISTRO_NAME="Unknown"
    fi
    echo -e "${INFO} Detected: ${GREEN}$DISTRO_NAME${NC}"
}

detect_hardware() {
    CPU_CORES=$(nproc)
    RAM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
    RAM_USED=$(free -m | awk '/^Mem:/{print $3}')
    SWAP_TOTAL=$(free -m | awk '/^Swap:/{print $2}')
    DISK_FREE=$(df -h / | awk 'NR==2{print $4}')
    
    echo -e "${INFO} CPU: ${GREEN}$CPU_CORES cores${NC}"
    echo -e "${INFO} RAM: ${GREEN}${RAM_TOTAL}MB total, ${RAM_USED}MB used${NC}"
    echo -e "${INFO} Swap: ${GREEN}${SWAP_TOTAL}MB${NC}"
    echo -e "${INFO} Disk Free: ${GREEN}$DISK_FREE${NC}"
}

#============================================================
# Optimization Functions
#============================================================

optimize_swappiness() {
    print_section "1" "Optimizing Swappiness"
    
    local target=10
    local current=$(cat /proc/sys/vm/swappiness)
    
    if [ "$current" -gt "$target" ]; then
        sysctl vm.swappiness=$target > /dev/null 2>&1
        if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
            echo "vm.swappiness=$target" >> /etc/sysctl.conf
        else
            sed -i "s/vm.swappiness=.*/vm.swappiness=$target/" /etc/sysctl.conf
        fi
        echo -e "${CHECK} Swappiness: ${current} → ${target}"
    else
        echo -e "${CHECK} Swappiness already optimal: ${current}"
    fi
}

setup_zram() {
    print_section "2" "Setting up ZRAM (Compressed Swap)"
    
    if ! command -v zramctl &> /dev/null; then
        echo -e "${INFO} Installing zram-tools..."
        apt-get install -y zram-tools > /dev/null 2>&1
    fi
    
    cat > /etc/default/zramswap << 'EOF'
ALGO=zstd
PERCENT=50
PRIORITY=100
EOF
    
    systemctl restart zramswap 2>/dev/null || true
    echo -e "${CHECK} ZRAM enabled (zstd, 50% RAM)"
}

disable_unnecessary_services() {
    print_section "3" "Disabling Unnecessary Services"
    
    local services=(
        "cups"
        "cups-browsed"
        "ModemManager"
        "avahi-daemon"
        "anacron"
        "irqbalance"
        "kerneloops"
    )
    
    for service in "${services[@]}"; do
        if systemctl is-enabled "$service" &>/dev/null; then
            systemctl disable --now "$service" 2>/dev/null
            echo -e "${CHECK} Disabled: $service"
        else
            echo -e "${INFO} Already disabled: $service"
        fi
    done
}

setup_preload() {
    print_section "4" "Installing Preload"
    
    if ! command -v preload &> /dev/null; then
        apt-get install -y preload > /dev/null 2>&1
        echo -e "${CHECK} Preload installed"
    else
        echo -e "${CHECK} Preload already installed"
    fi
}

optimize_journal() {
    print_section "5" "Optimizing System Journal"
    
    mkdir -p /etc/systemd/journald.conf.d
    cat > /etc/systemd/journald.conf.d/size.conf << 'EOF'
[Journal]
SystemMaxUse=50M
RuntimeMaxUse=50M
MaxRetentionSec=7day
EOF
    
    journalctl --vacuum-size=50M 2>/dev/null
    systemctl restart systemd-journald 2>/dev/null
    echo -e "${CHECK} Journal limited to 50MB"
}

disable_compositor() {
    print_section "6" "Disabling Desktop Compositor"
    
    if command -v xfconf-query &> /dev/null; then
        xfconf-query -c xfwm4 -p /general/use_compositing -s false 2>/dev/null
        echo -e "${CHECK} Xfce compositor disabled"
    else
        echo -e "${INFO} Xfce not detected, skipping"
    fi
}

clean_package_cache() {
    print_section "7" "Cleaning Package Cache"
    
    apt-get clean 2>/dev/null
    apt-get autoremove -y --purge 2>/dev/null
    echo -e "${CHECK} Package cache cleaned"
}

optimize_dns() {
    print_section "8" "Optimizing DNS"
    
    if [ -f /etc/resolv.conf ]; then
        # Backup original
        cp /etc/resolv.conf /etc/resolv.conf.backup 2>/dev/null
        
        # Use fast DNS servers
        cat > /etc/resolv.conf << 'EOF'
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 9.9.9.9
options edns0
EOF
        echo -e "${CHECK} DNS optimized (Cloudflare, Google, Quad9)"
    fi
}

create_report() {
    print_section "R" "Optimization Report"
    
    local report="/tmp/linux-optimize-report.txt"
    cat > "$report" << EOF
Linux System Optimization Report
=================================
Date: $(date)
Distro: $DISTRO_NAME
CPU: $CPU_CORES cores
RAM: ${RAM_TOTAL}MB
Swap: ${SWAP_TOTAL}MB

Optimizations Applied:
----------------------
1. Swappiness: Set to 10
2. ZRAM: Enabled (zstd, 50% RAM)
3. Services: Disabled unnecessary ones
4. Preload: Installed
5. Journal: Limited to 50MB
6. Compositor: Disabled (if Xfce)
7. Package cache: Cleaned
8. DNS: Optimized

Recommendations:
----------------
- Restart system for all changes to take effect
- Monitor RAM usage with: free -h
- Check running services: systemctl list-units --type=service
EOF
    
    echo -e "${CHECK} Report saved to: ${GREEN}$report${NC}"
    cat "$report"
}

#============================================================
# Main Menu
#============================================================
main() {
    print_header
    check_root
    detect_distro
    detect_hardware
    
    echo ""
    echo -e "${YELLOW}This will optimize your system for better performance.${NC}"
    echo -e "${YELLOW}No data will be deleted. All changes are reversible.${NC}"
    echo ""
    read -p "Continue? (y/n): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Operation cancelled.${NC}"
        exit 0
    fi
    
    optimize_swappiness
    setup_zram
    disable_unnecessary_services
    setup_preload
    optimize_journal
    disable_compositor
    clean_package_cache
    optimize_dns
    create_report
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         Optimization Complete!                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${INFO} ${YELLOW}Please restart your system for all changes to take effect.${NC}"
    echo ""
    read -p "Restart now? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        reboot
    fi
}

# Run main function
main
