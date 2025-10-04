# EduHope - Non-Profit Website

A modern, high-performance website built with Next.js, served through Nginx with SSL termination, and containerized with Docker.

## Features

- Next.js 14 with App Router
- SSL/TLS encryption with automatic certificate renewal
- Docker containerization
- Reverse proxy with Nginx
- Optimized production builds
- SEO optimized
- Fully responsive design

## Prerequisites

- Node.js 18+ & npm 9+ or Yarn 1.22+
- Docker 20.10+ & Docker Compose 2.0+
- Git 2.30+

## Quick Start

### Local Development

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/eduhope.git
cd eduhope

```

2. **Install dependencies**

```bash
npm install
# or
yarn install

```

3. **Start the development server**

```bash
npm run dev
# or
yarn dev

```

4. Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

## Docker Setup

### Development

1. **Build and start the containers**

```bash
docker-compose up --build

```

2. The application will be available at [http://localhost](http://localhost)

### Production

1. **Build and start the production stack**

```bash
docker-compose -f docker-compose.yml up --build -d

```

2. **Set up SSL certificates (first time only)**
   Make the initialization script executable and run it with your domain and email:

```bash
chmod +x init-letsencrypt.sh
./init-letsencrypt.sh example.com your-email@example.com

```

> **Note:** For testing, you can use the `--staging` flag in the script to avoid hitting rate limits.

3. **Verify the certificate**
   Check if the certificate was installed correctly:

```bash
docker-compose exec nginx nginx -t

```

4. **Auto-renewal**
   The Certbot container will automatically renew certificates before they expire. You can test the renewal process with:

```bash
docker-compose run --rm certbot renew --dry-run

```

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
NEXT_PUBLIC_API_URL=https://api.example.com
NODE_ENV=development

```

### Nginx Configuration

- Main config: `nginx/nginx.conf`
- Site config: `nginx/conf.d/app.conf`

## Deployment

### Prerequisites

- Domain name (e.g., example.com)
- Server with Docker and Docker Compose installed
- Ports 80 and 443 open

### Steps

1. **Clone the repository on your server**

```bash
git clone https://github.com/jobet1995/eduhope.git
cd eduhope

```

2. **Set up environment variables**

```bash
cp .env.example .env
nano .env  # Edit with your configuration

```

3. **Start the production stack**

```bash
docker-compose -f docker-compose.prod.yml up -d

```

4. **Set up SSL certificates** (if not using Let's Encrypt)
   - Place your SSL certificate and key in `./data/certbot/conf/live/example.com/`
   - Update `nginx/conf.d/app.conf` with the correct paths

## Security

- Automatic HTTPS with Let's Encrypt
- Security headers (CSP, HSTS, X-Frame-Options)
- Rate limiting
- Request size limits
- Disabled server tokens

## Monitoring

Access logs are available at:

- Nginx access logs: `./logs/nginx/access.log`
- Nginx error logs: `./logs/nginx/error.log`
- Application logs: `docker-compose logs -f app`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## CI/CD Pipeline

This project uses GitHub Actions for continuous integration and continuous deployment.

### Workflow Status

[![CI](https://github.com/jobet1995/eduhope/actions/workflows/ci.yml/badge.svg)](https://github.com/jobet1995/eduhope/actions/workflows/ci.yml)
[![CD](https://github.com/jobet1995/eduhope/actions/workflows/cd.yml/badge.svg)](https://github.com/jobet1995/eduhope/actions/workflows/cd.yml)

### Branch Strategy

- **`features`**: New feature development branches
- **`develop`**: Integration branch for tested features
- **`stagingTest`**: Testing branch for staging deployment
- **`releaseTest`**: Testing branch for production deployment
- **`release`**: Production deployment branch
- **`master`**: Final production branch (protected)

### Automated Pipeline

#### Continuous Integration (CI)

Runs automatically on:

- Pull requests to `develop`, `stagingTest`, `releaseTest`, `release`, and `master` branches
- Pushes to `develop`, `stagingTest`, `releaseTest`, `release`, and `master` branches

**CI Steps:**

1. Install dependencies
2. Run ESLint for code quality
3. Execute TypeScript type checking
4. Run unit tests with coverage
5. Build the application
6. Upload coverage reports to Codecov

#### Continuous Deployment (CD)

Runs automatically when:

- Code is pushed to the `release` branch → Deploys to Vercel production environment
- Code is pushed to the `master` branch → Deploys to Vercel production environment

**CD Steps:**

1. Deploy to Vercel production environment
2. Report deployment status
3. Failed deployments block merge to protected branches

### Deployment

#### Production Deployment

The application is automatically deployed to Vercel production environment when code is pushed to the `release` or `master` branch.

**Required Environment Variables for Production:**

```env
NEXT_PUBLIC_API_URL=https://api.eduhope.org
NODE_ENV=production
VERCEL_TOKEN=<your-vercel-token>
```

#### Manual Deployment

For manual deployments or testing:

```bash
# Deploy to Vercel manually
vercel --prod

# Or use Docker for custom hosting
docker-compose -f docker-compose.prod.yml up -d --build
```

### Environment Variables

#### Development

Create a `.env.local` file:

```env
NEXT_PUBLIC_API_URL=http://localhost:3000/api
NODE_ENV=development

```

#### Production (Vercel)

Set these in your Vercel dashboard:

- `NEXT_PUBLIC_API_URL`
- `NODE_ENV=production`
- Database connection strings
- API keys

#### Docker Production

Create a `.env` file for Docker deployments:

```env
NEXT_PUBLIC_API_URL=https://yourdomain.com
NODE_ENV=production
# Add other environment variables as needed

```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Next.js Documentation](https://nextjs.org/docs)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Docker Documentation](https://docs.docker.com/)
