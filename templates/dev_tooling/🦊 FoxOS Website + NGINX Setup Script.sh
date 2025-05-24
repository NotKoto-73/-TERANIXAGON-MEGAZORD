#!/usr/bin/env bash
# 🦊 FoxOS Website + NGINX Setup Script
# "fox-HI-jynk" edition for the clever fox

set -euo pipefail

echo "🦊 FoxOS Website Deployment Script"
echo "================================="

# Configuration
DOMAIN="foxos.dev"  # Your domain
WEBROOT="/var/www/foxos"
NGINX_CONFIG="/etc/nginx/sites-available/foxos"
ISO_STORAGE="/var/www/foxos/downloads"

# Create directory structure
setup_directories() {
    echo "📁 Creating directory structure..."
    sudo mkdir -p "$WEBROOT"/{assets,downloads,themes}
    sudo mkdir -p "$ISO_STORAGE"/{stable,unstable}
    sudo chown -R www-data:www-data "$WEBROOT"
}

# Generate the HTML site
generate_website() {
    echo "🌐 Generating FoxOS website..."
    
    cat > "$WEBROOT/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoxOS | hi, me</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Courier New', monospace;
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            color: #eee;
            line-height: 1.6;
            overflow-x: hidden;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            text-align: center;
            padding: 2rem 0;
            border-bottom: 2px solid #f84;
            margin-bottom: 2rem;
        }
        
        .fox-logo {
            font-size: 3rem;
            color: #f84;
            animation: foxGlow 2s ease-in-out infinite alternate;
        }
        
        @keyframes foxGlow {
            from { text-shadow: 0 0 10px #f84; }
            to { text-shadow: 0 0 20px #f84, 0 0 30px #fa4; }
        }
        
        nav {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 2rem;
            margin: 2rem 0;
        }
        
        nav a {
            color: #ffa;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border: 1px solid #ffa;
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        
        nav a:hover {
            background: #ffa;
            color: #1a1a2e;
            transform: translateY(-2px);
        }
        
        section {
            margin: 3rem 0;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            backdrop-filter: blur(10px);
        }
        
        h1, h2 {
            color: #f84;
            margin-bottom: 1rem;
        }
        
        .download-section {
            background: linear-gradient(45deg, rgba(248, 68, 0, 0.1), rgba(255, 170, 0, 0.1));
            border-left: 4px solid #f84;
        }
        
        .download-link {
            display: inline-block;
            margin: 1rem 1rem 1rem 0;
            padding: 1rem 2rem;
            background: #f84;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(248, 68, 0, 0.3);
        }
        
        .download-link:hover {
            background: #fa6;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(248, 68, 0, 0.4);
        }
        
        .download-stable { background: #28a745; }
        .download-stable:hover { background: #34ce57; }
        
        .hidden { display: none; }
        
        .easter-egg {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .easter-egg:hover {
            color: #f84;
            transform: scale(1.05);
        }
        
        .agent-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin: 1rem 0;
        }
        
        .agent-card {
            background: rgba(248, 68, 0, 0.1);
            padding: 1rem;
            border-radius: 6px;
            text-align: center;
            border: 1px solid #f84;
        }
        
        .contact-info {
            background: rgba(255, 170, 0, 0.1);
            padding: 1rem;
            border-radius: 6px;
            margin: 1rem 0;
        }
        
        footer {
            text-align: center;
            margin-top: 4rem;
            padding: 2rem;
            border-top: 1px solid #444;
            color: #888;
        }
        
        @media (max-width: 768px) {
            nav { flex-direction: column; align-items: center; }
            .container { padding: 10px; }
            section { padding: 1rem; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div class="fox-logo">🦊</div>
            <h1>hi, me</h1>
            <p>Welcome to the fox den</p>
        </header>

        <nav>
            <a href="#home" onclick="showSection('home')">Home</a>
            <a href="#downloads" onclick="showSection('downloads')">Downloads</a>
            <a href="#contact" onclick="showSection('contact')">Contact</a>
            <a href="#lore" onclick="showSection('lore')">Lore</a>
            <a href="#shoutouts" onclick="showSection('shoutouts')">Shoutouts</a>
            <a href="#agents" onclick="showSection('agents')">AI Agents</a>
            <a href="#blank" onclick="showSection('blank')">???</a>
        </nav>

        <section id="home">
            <h2>Welcome to: FoxOS</h2>
            <p><em>All is welcome but only the clever foxes truly understand & stay.</em></p>
            <p>FoxOS is a modular, enterprise-grade operating system framework built on NixOS. It features:</p>
            <ul style="margin: 1rem 0; padding-left: 2rem;">
                <li>🕸️ Octaquad disk partitioning system</li>
                <li>🔧 Hierarchical toggle management</li>
                <li>🎭 Dynamic theme resolution</li>
                <li>🌐 Multi-environment host matrix</li>
                <li>🔐 Full-disk encryption by default</li>
                <li>🚀 Live ISO with guided installation</li>
            </ul>
        </section>

        <section id="downloads" class="download-section hidden">
            <h2>Downloads</h2>
            <p><strong>Easy to find!! Why make it a labyrinth??</strong></p>
            
            <div style="margin: 2rem 0;">
                <a href="/downloads/stable/foxos-stable-latest.iso" class="download-link download-stable">
                    📀 FoxOS Stable (Recommended)
                </a>
                <a href="/downloads/unstable/foxos-unstable-latest.iso" class="download-link">
                    🧪 FoxOS Unstable (Dev)
                </a>
            </div>
            
            <div style="background: rgba(0,0,0,0.3); padding: 1rem; border-radius: 4px; margin: 1rem 0;">
                <h3>🔐 Verify Your Download</h3>
                <p>Always verify checksums before installation:</p>
                <code>sha256sum foxos-*.iso</code>
                <br><a href="/downloads/checksums.txt" style="color: #ffa;">📄 Download checksums.txt</a>
            </div>
            
            <div>
                <h3>📋 Installation Guide</h3>
                <ol style="margin: 1rem 0; padding-left: 2rem;">
                    <li>Create bootable USB with <code>dd</code> or Rufus</li>
                    <li>Boot from USB and select FoxOS</li>
                    <li>Run <code>foxos-install</code> in terminal</li>
                    <li>Follow the guided setup process</li>
                    <li>Reboot and enjoy your fox den! 🦊</li>
                </ol>
            </div>
        </section>

        <section id="contact" class="hidden">
            <h2>Consider Supporting</h2>
            <p>Dev-support, ideas, and feedback always welcome!</p>
            
            <div class="contact-info">
                <h3>📧 Contact Information</h3>
                <ul style="list-style: none; padding: 0;">
                    <li>📧 Email: kitsunekoto37@proton.me</li>
                    <li>📱 Phone: 1 (855) 688-9669</li>
                    <li>📸 Instagram: spooky68692</li>
                </ul>
            </div>
            
            <p style="text-align: center; margin-top: 2rem;">
                <strong>Thank You & Have a nice day! 🦊</strong>
            </p>
        </section>

        <section id="lore" class="hidden">
            <h2>🦊 The FoxOS Lore</h2>
            <p>Foundational FoxOS backstory — world-guiding without handholding. Think: <em>Morrowind vibes</em>.</p>
            
            <div style="background: rgba(248, 68, 0, 0.1); padding: 1rem; border-radius: 6px; margin: 1rem 0;">
                <h3>🗡️ The Clever Fox Philosophy</h3>
                <p><em>"Yeh, you'll get lost... & have fun exploring."</em></p>
                <p>FoxOS doesn't hold your hand. It gives you tools, shows you possibilities, then lets you build your own digital wilderness. Every configuration tells a story. Every toggle reveals intent. Every theme reflects the soul of its user.</p>
            </div>
            
            <h3>🏛️ The Quadrant Mythology</h3>
            <ul style="margin: 1rem 0; padding-left: 2rem;">
                <li><strong>❄️ North (Frostlands):</strong> Where logic crystallizes into pure system configuration</li>
                <li><strong>🌅 East (Kitsune Territory):</strong> Realm of secrets, shadows, and secure networks</li>
                <li><strong>🔥 South (Soleflare Wildlands):</strong> Chaotic forge of performance and digital creativity</li>
                <li><strong>🦊 West (Reddfox Enterprises):</strong> Corporate cunning meets technical precision</li>
            </ul>
            
            <div class="easter-egg" onclick="revealSecret()">
                <p><em>Some say there are hidden paths between the quadrants... 🕸️</em></p>
            </div>
        </section>

        <section id="shoutouts" class="hidden">
            <h2>🙏 Shoutouts & Inspiration</h2>
            <p>Standing on the shoulders of giants and fellow foxes:</p>
            
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem; margin: 2rem 0;">
                <div class="agent-card">
                    <h4>🦎 Community Heroes</h4>
                    <ul style="list-style: none; padding: 0;">
                        <li>Lexy @ LOTD</li>
                        <li>Chris Titus</li>
                        <li>Libre Phoenix</li>
                        <li>NixOS Community</li>
                    </ul>
                </div>
                
                <div class="agent-card">
                    <h4>🎮 Inspiration Vibes</h4>
                    <ul style="list-style: none; padding: 0;">
                        <li>Majora's Mask</li>
                        <li>Morrowind & Oblivion</li>
                        <li>Fallout 3/NV</li>
                        <li>Pokémon (Gen 1-5)</li>
                    </ul>
                </div>
            </div>
            
            <p><em>In spirit of: OldSchool + BleedingEdge + Innovation</em></p>
        </section>

        <section id="agents" class="hidden">
            <h2>🤖 The Agent A.I. Dev Team</h2>
            <p>Meet the artificial minds behind FoxOS development:</p>
            
            <div class="agent-grid">
                <div class="agent-card">
                    <h4>💎 Director Gemini</h4>
                    <p>Strategic oversight & creative direction</p>
                </div>
                <div class="agent-card">
                    <h4>🧠 GPT</h4>
                    <p>Code architecture & documentation</p>
                </div>
                <div class="agent-card">
                    <h4>🚀 DeepSeek</h4>
                    <p>Performance optimization & innovation</p>
                </div>
                <div class="agent-card">
                    <h4>🎭 Claude</h4>
                    <p>System design & user experience</p>
                </div>
            </div>
            
            <p style="text-align: center; margin-top: 2rem;">
                <em>Each agent brings unique perspectives to the FoxOS ecosystem. Some say they have secret lore... maybe they do, maybe they don't. 🦊</em>
            </p>
        </section>

        <section id="blank" class="hidden">
            <h2>This Page Left Blank On Purpose</h2>
            <div style="text-align: center; padding: 4rem 0;">
                <p style="font-size: 1.5rem; margin-bottom: 2rem;">🦊</p>
                <p><em>— L.E. ♡</em></p>
                
                <div id="secret-content" class="hidden" style="margin-top: 3rem; background: rgba(248, 68, 0, 0.1); padding: 2rem; border-radius: 8px;">
                    <h3>🕸️ You found the secret!</h3>
                    <p>Welcome to the hidden den, clever fox. Here's what the others don't see:</p>
                    <ul style="text-align: left; margin: 1rem 0;">
                        <li>The Octaquad isn't just a disk layout—it's a philosophy</li>
                        <li>Every toggle tells a story about the user who set it</li>
                        <li>The AI agents sometimes argue about code style at 3 AM</li>
                        <li>There's a hidden Konami code in the bootloader theme</li>
                        <li>The vault partition remembers everything</li>
                    </ul>
                    <p><em>Now you know. What will you do with this knowledge? 🦊✨</em></p>
                </div>
            </div>
        </section>

        <footer>
            <p>🦊 FoxOS - Built with cunning, configured with care</p>
            <p>Made possible by NixOS, Nix community, and endless cups of coffee</p>
            <p style="margin-top: 1rem; font-size: 0.9rem;">
                <a href="https://github.com/notkoto73/foxos" style="color: #ffa;">📂 Source Code</a> | 
                <a href="/docs" style="color: #ffa;">📖 Documentation</a> | 
                <a href="/api" style="color: #ffa;">🔧 API</a>
            </p>
        </footer>
    </div>

    <script>
        // Navigation functionality
        function showSection(sectionId) {
            // Hide all sections
            const sections = document.querySelectorAll('section');
            sections.forEach(section => {
                if (section.id !== sectionId) {
                    section.classList.add('hidden');
                } else {
                    section.classList.remove('hidden');
                }
            });
            
            // Update URL hash
            window.location.hash = sectionId;
        }
        
        // Show home by default or from URL hash
        document.addEventListener('DOMContentLoaded', function() {
            const hash = window.location.hash.substring(1) || 'home';
            showSection(hash);
        });
        
        // Secret revelation function
        function revealSecret() {
            const secret = document.getElementById('secret-content');
            secret.classList.toggle('hidden');
        }
        
        // Konami code easter egg
        let konamiCode = [];
        const konamiSequence = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]; // ↑↑↓↓←→←→BA
        
        document.addEventListener('keydown', function(e) {
            konamiCode.push(e.keyCode);
            if (konamiCode.length > konamiSequence.length) {
                konamiCode.shift();
            }
            
            if (konamiCode.toString() === konamiSequence.toString()) {
                document.body.style.background = 'linear-gradient(45deg, #ff6b35, #f7931e, #ffd23f, #06ffa5, #1fb3d3, #5d4e75)';
                document.body.style.backgroundSize = '400% 400%';
                document.body.style.animation = 'foxRainbow 3s ease infinite';
                
                alert('🦊 FOXOS POWER ACTIVATED! The clever fox sees all colors of the digital spectrum!');
            }
        });
        
        // Add rainbow animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes foxRainbow {
                0% { background-position: 0% 50%; }
                50% { background-position: 100% 50%; }
                100% { background-position: 0% 50%; }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
EOF

    echo "✅ Website generated"
}

# Configure NGINX
setup_nginx() {
    echo "🌐 Configuring NGINX..."
    
    cat > "${NGINX_CONFIG}" << EOF
# FoxOS Website Configuration
server {
    listen 80;
    listen [::]:80;
    server_name ${DOMAIN} www.${DOMAIN};
    
    # Redirect HTTP to HTTPS (after SSL setup)
    # return 301 https://\$server_name\$request_uri;
    
    root ${WEBROOT};
    index index.html;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    
    # Main site
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # Downloads directory with auto-indexing
    location /downloads/ {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        
        # Custom styling for directory listing
        add_before_body /downloads-header.html;
        add_after_body /downloads-footer.html;
        
        # Security for ISO files
        location ~* \\.iso\$ {
            add_header Content-Disposition 'attachment';
            add_header X-Content-Type-Options nosniff;
        }
    }
    
    # API endpoints (future)
    location /api/ {
        # Placeholder for future API
        return 503 "🦊 API coming soon!";
        add_header Content-Type text/plain;
    }
    
    # Documentation (future)
    location /docs/ {
        # Serve documentation when ready
        try_files \$uri \$uri/ /docs/index.html;
    }
    
    # Security: Hide sensitive files
    location ~ /\\. {
        deny all;
    }
    
    location ~ \\.nix\$ {
        deny all;
    }
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/json;
    
    # Cache static assets
    location ~* \\.(jpg|jpeg|png|gif|ico|css|js)\$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # ISO files - no cache but proper headers
    location ~* \\.iso\$ {
        expires 1d;
        add_header X-Content-Type-Options nosniff;
        add_header Content-Disposition 'attachment';
    }
    
    # Rate limiting for downloads
    location /downloads/ {
        limit_rate 10m;  # 10MB/s per connection
    }
    
    # Custom error pages
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
}

# HTTPS configuration (uncomment after SSL setup)
# server {
#     listen 443 ssl http2;
#     listen [::]:443 ssl http2;
#     server_name ${DOMAIN} www.${DOMAIN};
#     
#     ssl_certificate /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
#     ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;
#     
#     # SSL configuration
#     ssl_protocols TLSv1.2 TLSv1.3;
#     ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
#     ssl_prefer_server_ciphers off;
#     
#     # Include the main server block content here
# }
EOF

    # Enable the site
    sudo ln -sf "${NGINX_CONFIG}" "/etc/nginx/sites-enabled/foxos"
    
    # Test configuration
    sudo nginx -t
    
    echo "✅ NGINX configured"
}

# Create download directory styling
setup_download_styling() {
    echo "🎨 Setting up download directory styling..."
    
    cat > "${WEBROOT}/downloads-header.html" << 'EOF'
<!DOCTYPE html>
<html><head>
<title>FoxOS Downloads</title>
<style>
body { font-family: monospace; background: #1a1a2e; color: #eee; padding: 20px; }
h1 { color: #f84; text-align: center; }
.fox-header { text-align: center; margin-bottom: 2rem; }
a { color: #ffa; text-decoration: none; }
a:hover { color: #f84; }
</style>
</head><body>
<div class="fox-header">
    <h1>🦊 FoxOS Downloads</h1>
    <p>Choose your ISO, verify checksums, enjoy the fox life!</p>
    <hr style="border-color: #f84; margin: 2rem 0;">
</div>
EOF

    cat > "${WEBROOT}/downloads-footer.html" << 'EOF'
<hr style="border-color: #f84; margin: 2rem 0;">
<div style="text-align: center;">
    <p>🔐 Always verify checksums before installation!</p>
    <p><a href="/">← Back to FoxOS Home</a></p>
</div>
</body></html>
EOF

    echo "✅ Download styling created"
}

# SSL Setup with Let's Encrypt
setup_ssl() {
    echo "🔐 Setting up SSL with Let's Encrypt..."
    
    # Install certbot if not present
    if ! command -v certbot &> /dev/null; then
        sudo apt update
        sudo apt install -y certbot python3-certbot-nginx
    fi
    
    # Get SSL certificate
    sudo certbot --nginx -d "${DOMAIN}" -d "www.${DOMAIN}" --non-interactive --agree-tos --email "admin@${DOMAIN}"
    
    # Auto-renewal
    sudo systemctl enable certbot.timer
    
    echo "✅ SSL configured"
}

# Create ISO upload script
create_iso_management() {
    echo "📀 Creating ISO management tools..."
    
    cat > "${WEBROOT}/update-isos.sh" << 'EOF'
#!/bin/bash
# FoxOS ISO Update Script

ISO_DIR="/var/www/foxos/downloads"
TEMP_DIR="/tmp/foxos-release"

update_iso() {
    local release_type="$1"  # stable or unstable
    local iso_file="$2"
    
    echo "🦊 Updating ${release_type} ISO..."
    
    # Create directories
    mkdir -p "${ISO_DIR}/${release_type}"
    
    # Copy new ISO
    cp "${iso_file}" "${ISO_DIR}/${release_type}/foxos-${release_type}-latest.iso"
    
    # Generate checksum
    cd "${ISO_DIR}/${release_type}"
    sha256sum "foxos-${release_type}-latest.iso" > "foxos-${release_type}-latest.iso.sha256"
    
    # Update main checksums file
    cd "${ISO_DIR}"
    find . -name "*.iso" -exec sha256sum {} \; > checksums.txt
    
    # Set permissions
    chown -R www-data:www-data "${ISO_DIR}"
    
    echo "✅ ${release_type} ISO updated"
}

# Usage
case "$1" in
    stable)
        update_iso "stable" "$2"
        ;;
    unstable)
        update_iso "unstable" "$2"
        ;;
    both)
        update_iso "stable" "$2"
        update_iso "unstable" "$3"
        ;;
    *)
        echo "Usage: $0 {stable|unstable|both} <iso-file> [unstable-iso-file]"
        exit 1
        ;;
esac
EOF

    chmod +x "${WEBROOT}/update-isos.sh"
    echo "✅ ISO management tools created"
}

# Main execution
main() {
    echo "🦊 Starting FoxOS website deployment..."
    
    # Check if running as root or with sudo
    if [[ $EUID -eq 0 ]]; then
        echo "❌ Don't run as root. Use sudo when needed."
        exit 1
    fi
    
    # Install NGINX if not present
    if ! command -v nginx &> /dev/null; then
        echo "📦 Installing NGINX..."
        sudo apt update && sudo apt install -y nginx
    fi
    
    setup_directories
    generate_website
    setup_nginx
    setup_download_styling
    create_iso_management
    
    # Restart NGINX
    sudo systemctl restart nginx
    sudo systemctl enable nginx
    
    echo ""
    echo "🎉 FoxOS website deployed successfully!"
    echo "================================="
    echo "🌐 Website: http://${DOMAIN}"
    echo "📁 Web root: ${WEBROOT}"
    echo "📀 ISO storage: ${ISO_STORAGE}"
    echo "⚙️ Upload ISOs with: ${WEBROOT}/update-isos.sh"
    echo ""
    echo "🔐 Next steps:"
    echo "  1. Point your domain to this server"
    echo "  2. Run: ./setup_ssl to enable HTTPS"
    echo "  3. Upload your FoxOS ISOs"
    echo "  4. Share with the world! 🦊"
}

# SSL setup function (separate call)
if [[ "${1:-}" == "ssl" ]]; then
    setup_ssl
    exit 0
fi

# Run main deployment
main "$@"