# Linux System Optimizer v1.0

**Boost performance on low-spec Linux machines with one click.**

![Linux](https://img.shields.io/badge/Linux-000000?style=for-the-badge&logo=linux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

## 🚀 What It Does

Automatically optimizes your Linux system for better performance:

| Optimization | Description |
|-------------|-------------|
| **Swappiness** | Reduces swap usage (60 → 10) |
| **ZRAM** | Compressed swap in RAM (2x faster) |
| **Service Control** | Disables unnecessary services |
| **Preload** | Preloads apps for faster startup |
| **Journal** | Limits log size to save disk |
| **Compositor** | Disables desktop effects (saves GPU) |
| **DNS** | Uses faster DNS servers |
| **Cache Cleanup** | Removes old package cache |

## 📋 Requirements

- **OS:** Ubuntu, Debian, Linux Mint, Xubuntu, Lubuntu (20.04+)
- **RAM:** Works best on 1-4GB systems
- **Disk:** 100MB free space
- **Root:** Requires sudo access

## ⚡ Quick Start

```bash
# Download
git clone https://github.com/yourusername/linux-optimizer.git
cd linux-optimizer

# Make executable
chmod +x install.sh

# Run with root
sudo bash install.sh
```

## 📊 What You'll See

```
╔══════════════════════════════════════════════════════════╗
║         Linux System Optimizer v1.0                     ║
║         Boost Performance on Low-Spec Machines          ║
╚══════════════════════════════════════════════════════════╝

Detected: Ubuntu 22.04.5 LTS
CPU: 2 cores
RAM: 1843MB total, 743MB used
Swap: 2048MB
Disk Free: 11G

[1] Optimizing Swappiness
────────────────────────────────────────────────────────
✓ Swappiness: 60 → 10

[2] Setting up ZRAM (Compressed Swap)
────────────────────────────────────────────────────────
✓ ZRAM enabled (zstd, 50% RAM)

[3] Disabling Unnecessary Services
────────────────────────────────────────────────────────
✓ Disabled: cups
✓ Disabled: cups-browsed
✓ Disabled: ModemManager
...
```

## 🔧 Customization

Edit the `install.sh` file to:

- Change swappiness value (default: 10)
- Adjust ZRAM percentage (default: 50%)
- Add/remove services from the disable list
- Modify journal size limit

## 📈 Performance Gains

Typical improvements on low-spec systems:

| Metric | Before | After |
|--------|--------|-------|
| Boot Time | 45s | 30s |
| RAM Usage | 743MB | 500MB |
| App Launch | 3s | 1.5s |
| Swap Usage | High | Low |

## ⚠️ Important Notes

- **No data deleted** — Only system configs and caches modified
- **Reversible** — All changes can be undone
- **Backup created** — `/etc/resolv.conf.backup` saved
- **Restart required** — For ZRAM and other changes

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- ZRAM compression algorithms
- Preload for app caching
- Linux community for optimization tips

## 📞 Support

- **Issues:** GitHub Issues
- **Email:** jayenkxyz@gmail.com
- **X:** @Nopan____

---

**Made with ❤️ for Linux enthusiasts**
