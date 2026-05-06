# Laravel Docker Template

Production-ready Docker setup cho Laravel applications.

## 📦 What's Included

- **Laravel App** - PHP 8.2 FPM
- **MySQL 8.0** - Database
- **Redis 7.0** - Cache & Queue
- **Mailhog** - Email testing
- **Adminer** - Database admin UI

## 🚀 Quick Start

```bash
# 1. Copy files
cp docker-compose.base.yml docker-compose.yml
cp .env.template .env

# 2. Configure .env
nano .env

# 3. Start
docker compose up -d

# 4. Setup Laravel
docker compose exec app composer install
docker compose exec app php artisan key:generate
docker compose exec app php artisan migrate
```

**Access app**: http://localhost:8000

## ⚙️ Configuration

### .env Settings

| Variable | Default | Purpose |
|----------|---------|---------|
| `PROJECT_NAME` | laravel-app | Project identifier |
| `APP_NAME` | Laravel | Application name |
| `APP_ENV` | local | Environment (local/production) |
| `APP_DEBUG` | true | Debug mode (disable in production) |
| `APP_URL` | http://localhost:8000 | App URL |
| `DB_PASSWORD` | secret | Database password |
| `REDIS_PASSWORD` | null | Redis password |

### Database

- **Host**: `db`
- **Port**: `3306`
- **User**: `laravel`
- **Password**: `secret` (change in .env)
- **Database**: `laravel`

### Redis

- **Host**: `redis`
- **Port**: `6379`
- **Used for**: Cache, Sessions, Queues

### Mail (Development)

- **Driver**: SMTP
- **Host**: `mailhog`
- **Port**: `1025`
- **UI**: http://localhost:8025

## 🐳 Services

### app
- PHP 8.2 FPM container
- Runs Laravel application
- Volume: `.` → `/app`
- Health check every 30s

### db
- MySQL 8.0
- Port: 3306 (external)
- Volume: `db_data` (persistent)
- Health check: mysqladmin ping

### redis
- Redis 7.0
- Port: 6379 (external)
- Volume: `redis_data` (persistent)
- Uses: Cache, Sessions, Queues

### mailhog
- Email testing service
- SMTP: 1025
- UI: 8025
- Good for development

### adminer
- Database management UI
- URL: http://localhost:8888
- Works with MySQL

## 📝 Common Tasks

### Run Artisan Commands

```bash
# Key generation
docker compose exec app php artisan key:generate

# Run migrations
docker compose exec app php artisan migrate

# Run seeders
docker compose exec app php artisan db:seed

# Tinker shell
docker compose exec app php artisan tinker

# Create model with migration
docker compose exec app php artisan make:model Post -m
```

### Queue Processing

```bash
# Run queue worker
docker compose exec app php artisan queue:work

# Process job
docker compose exec app php artisan queue:work --once
```

### Database Operations

```bash
# MySQL shell
docker compose exec app mysql -h db -u laravel -p laravel

# Run query
docker compose exec app mysql -h db -u laravel -plaravel laravel -e "SHOW TABLES;"

# Backup database
docker compose exec app mysqldump -h db -u laravel -plaravel laravel > backup.sql

# Restore database
docker compose exec app mysql -h db -u laravel -plaravel laravel < backup.sql
```

### File Operations

```bash
# Fix permissions
docker compose exec app chmod -R 755 storage bootstrap/cache
docker compose exec app chown -R www-data:www-data .

# View logs
docker compose exec app tail -f storage/logs/laravel.log
```

### Composer

```bash
# Install packages
docker compose exec app composer install

# Require package
docker compose exec app composer require package/name

# Update packages
docker compose exec app composer update
```

## 📊 Health Checks

All services have health checks:

```bash
# Check status
docker compose ps

# Detailed health
docker compose exec db mysql -h localhost -u root -proot -e "SELECT 1"
docker compose exec redis redis-cli ping
```

## 🔐 Production Setup

For production, update `.env`:

```env
APP_ENV=production
APP_DEBUG=false
DB_PASSWORD=<strong-password>
REDIS_PASSWORD=<strong-password>
MAIL_DRIVER=ses  # or smtp with real email service
```

Run migrations with care:

```bash
docker compose exec app php artisan migrate --force
```

## 🌐 Network

All services communicate via `app-network`:
- Internal DNS resolution working
- Isolated from host network
- Services accessible by container name

## 📈 Scaling

### More app containers
```yaml
# Add to docker-compose.override.yml
services:
  app2:
    extends: app
    container_name: myapp-app-2
```

### More resources
Edit docker-compose.yml and add:
```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
```

## 🐛 Troubleshooting

### Container won't start

```bash
# Check logs
docker compose logs app

# Rebuild image
docker compose build --no-cache

# Start with verbose output
docker compose up app
```

### Database connection error

```bash
# Check database is running
docker compose logs db

# Test connection
docker compose exec app mysql -h db -u laravel -psecret laravel

# Wait for database
docker compose restart app
```

### Storage permission errors

```bash
docker compose exec app chmod -R 755 storage
docker compose exec app chown -R www-data:www-data storage
```

### Redis connection failed

```bash
# Check redis status
docker compose logs redis

# Test connection
docker compose exec app redis-cli -h redis ping

# Restart redis
docker compose restart redis
```

### Port conflicts

```bash
# Check what's using the port
lsof -i :8000

# Change port in .env
APP_PORT=8001

# Restart
docker compose restart app
```

## 📚 File Structure

```
project/
├── docker-compose.yml      # Main compose file
├── .env                    # Configuration (gitignored)
├── .env.template           # Template
├── Dockerfile              # Laravel app container
├── app/                    # Laravel app code
├── storage/                # Logs, uploads
├── bootstrap/              # Cache directory
├── .docker/
│   └── mysql/              # MySQL configs
└── .agent/                 # Docker utilities
    ├── docker-compose.base.yml
    ├── .env.template
    └── README-LARAVEL.md
```

## 🔄 Persistence

Data persists in named volumes:

- `db_data` - MySQL data
- `redis_data` - Redis data

Survive container restart:
```bash
docker compose restart
```

Survive container deletion:
```bash
docker compose down
docker compose up -d
```

Remove data:
```bash
docker compose down -v
```

## ✅ Checklist

- [ ] Docker & Docker Compose installed
- [ ] `.env` configured correctly
- [ ] `docker compose up -d` runs successfully
- [ ] `docker compose ps` shows all healthy
- [ ] `docker compose exec app php artisan key:generate` works
- [ ] Migrations run successfully
- [ ] App accessible at http://localhost:8000
- [ ] Database accessible at http://localhost:8888
- [ ] Emails visible at http://localhost:8025

## 🆘 Support

For detailed information, see:
- Docker Docs: https://docs.docker.com/compose/
- Laravel Docs: https://laravel.com/docs
- PHP Docker Hub: https://hub.docker.com/_/php
- MySQL Docker Hub: https://hub.docker.com/_/mysql

---

**Happy coding! 🚀**
