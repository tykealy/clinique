# Clinique 

## System Setup

### Prerequisites
- Docker 20.10+ and Docker Compose 2.20+
- Node.js 18+ (for asset compilation)
- AWS account (for production file storage)

### Development Environment
1. Clone repository and enter directory:
   ```bash
   git clone https://github.com/your-org/clinique.git && cd clinique
   ```

2. Configure environment:
   ```bash
   cp .env.dev.example .env.dev
   ```
   Configure env.dev with your environment varaibles.

3. Start services with hot-reload:
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```
4. Since tailwind always purge unused style, we have to keep wathcing for new build.

   ```bash
   docker exec clinique_app bin/rails tailwindcss:watch
   ```   
   This ensure hot relaod.

5. Access endpoints:
   - Application: http://localhost:3000
   - PostgreSQL: localhost:5432

### Production Deployment
1. Configure production environment:
   ```bash
   cp .env.prod.example .env.prod
   ```
   Configure env.dev with your environment varaibles.

2. Build and start cluster:
   ```bash
   docker-compose -f docker-compose.prod.yml build
   docker-compose -f docker-compose.prod.yml up -d
   ```

### Maintenance
- Restart services:
  ```bash
  docker-compose -f docker-compose.prod.yml restart app
  ```

- View logs:
  ```bash
  docker-compose -f docker-compose.prod.yml logs -f app
  ```

- Backup database:
  ```bash
   docker-compose -f docker-compose.prod.yml exec db \
     pg_dump -U $POSTGRES_USER $POSTGRES_DB > backup.sql
   ```

### Security Recommendations
1. Always set `RAILS_ENV=production` in production
2. Rotate `SECRET_KEY_BASE` periodically using:
   ```bash
   docker-compose -f docker-compose.prod.yml exec app rails secret
   ```
3. Never commit .env.* files to version control

### Troubleshooting
- Port conflicts: Stop local PostgreSQL if running (`brew services stop postgresql`)
- Database connection issues: Verify credentials in .env files match docker-compose
- Asset compilation errors: Run `docker-compose -f docker-compose.dev.yml exec app rails assets:precompile`
