# Oji Forms

<p align="center">
<img src="client/public/img/logo.png" alt="Oji Forms Logo" width="200">
</p>

<p align="center">
<strong>Customized Form Builder for Omah Ngaji Al-Anshori Surakarta</strong><br>
<em>Built upon OpnForm - Open Source Form Builder</em>
</p>


## About Oji Forms

**Oji Forms** is a specialized form builder platform developed for **Omah Ngaji Al Anshori Surakarta**. This application is a customized version of **OpnForm** - a powerful and flexible open-source form builder.

### 🏢 Built for:
- Data collection and information gathering needs
- Registration for learning programs
- Surveys and feedback from community members
- Administrative tasks for Quranic study and learning activities

## Getting Started with Oji Forms

Oji Forms can be easily used for various needs of **Omah Ngaji Al Anshori Surakarta**, from student registration, learning surveys, to activity feedback collection.

For deployment and installation, please follow the deployment guide in the **Production Deployment** section below.

## Key Features

-   🚀 **Visual Form Builder** - Create forms with drag & drop without coding
-   📝 **Various Input Types** - Text, Date, URL, File uploads, Checkboxes, Select, etc.
-   🏫 **Perfect for Educational Institutions** - Templates and features tailored for Islamic learning
-   📧 **Email Notifications** - Automatic notifications for admins and registrants
-   💬 **Integrations** - WhatsApp, Telegram, and other communication platforms
-   🧠 **Form Logic** - Conditional logic for dynamic forms
-   🛡️ **Security Assured** - Captcha protection and data security
-   📊 **Analytics** - Reports and submission data analysis
-   🎨 **Custom Branding** - Aligned with Omah Ngaji Al Anshori identity
-   📱 **Mobile Friendly** - Responsive on all devices

For complete technical documentation, visit [Technical Documentation](https://docs.opnform.com).

## Production Deployment

### Docker Deployment (Recommended)

OpnForm provides two Docker deployment modes:

#### 🚀 Development Mode
For local development with hot-reload and debugging:
```bash
git clone https://github.com/JhumanJ/OpnForm.git
cd OpnForm
chmod +x scripts/docker-setup.sh
./scripts/docker-setup.sh --dev
```
Access: `http://localhost:3000` (Frontend) + `http://localhost/api` (API)

#### 🏭 Production Mode
For production deployment with optimized performance:
```bash
git clone https://github.com/JhumanJ/OpnForm.git
cd OpnForm
chmod +x scripts/docker-setup.sh
./scripts/docker-setup.sh
```
Access: `http://localhost` (Unified access)

### Custom Builds & Branding

If you've customized the UI/branding, you need to build custom Docker images for production:

#### Build Custom Images
```bash
# Make the build script executable
chmod +x scripts/build-images.sh

# Build custom images with your modifications
./scripts/build-images.sh
```

#### Deploy with Custom Images
```bash
# Deploy production with your custom images
docker compose up -d
```

### Architecture

**Production Mode includes:**
- ✅ **Nginx Reverse Proxy** - Unified access point
- ✅ **Laravel API** - Backend with PHP-FPM
- ✅ **Nuxt.js Frontend** - Server-side rendered
- ✅ **PostgreSQL** - Primary database
- ✅ **Redis** - Caching, sessions, queues
- ✅ **Queue Workers** - Background job processing
- ✅ **Scheduler** - Automated tasks
- ✅ **Health Checks** - Service monitoring

**Development Mode includes:**
- 🔧 **Hot Module Replacement** - Live code reload
- 🔧 **File-based Storage** - Simplified setup
- 🔧 **Synchronous Jobs** - Immediate processing
- 🔧 **Debug Mode** - Enhanced error reporting
- 🔧 **Direct Database Access** - Port 5432 exposed

### Environment Configuration

1. **Configure API** (`api/.env`):
```bash
APP_ENV=production
APP_URL=http://your-domain.com
DB_CONNECTION=pgsql
DB_HOST=db
DB_DATABASE=forge
DB_USERNAME=forge
DB_PASSWORD=your-secure-password
```

2. **Configure Frontend** (`client/.env`):
```bash
NUXT_PUBLIC_APP_URL=http://your-domain.com
NUXT_PUBLIC_API_BASE=http://your-domain.com/api
```

### Initial Setup

After deployment, login with default credentials:
- **Email:** `admin@opnform.com`
- **Password:** `password`

⚠️ **Important:** Change your email and password immediately after first login.

## Support & Community

If you need help or have questions, please join our [Discord community](https://discord.gg/YTSjU2a9TS). For more information and assistance, check out the following resources:

-   [Product Helpdesk](https://help.opnform.com)
-   [Technical Documentation](https://docs.opnform.com)

## License

OpnForm is open-source under the GNU Affero General Public License Version 3 (AGPLv3) or any later version. You can find it [here](https://github.com/JhumanJ/OpnForm/blob/main/LICENSE).
