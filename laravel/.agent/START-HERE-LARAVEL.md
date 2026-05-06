# 🚀 Laravel Docker - START HERE

Simple, production-ready Docker setup cho Laravel.

> Version: 1.0 | Optimized for Laravel 10/11

## ⚡ 30-Second Quick Start

```bash
# 1. Copy files to your Laravel project
cp docker-compose.base.yml docker-compose.yml
cp .env.template .env
cp ../Dockerfile .

# 2. Start containers
docker compose up -d

# 3. Setup Laravel
docker compose exec app composer install
docker compose exec app php artisan key:generate
docker compose exec app php artisan migrate

# Done! ✓
```

App running at: **http://localhost:8000**

---

## 📋 What You Get

| Component | Version | Purpose |
|-----------|---------|---------|
| **PHP** | 8.2-FPM | Laravel application runtime |
| **MySQL** | 8.0 | Database |
| **Redis** | 7.0 | Cache, Sessions, Queues |
| **Mailhog** | Latest | Email testing (dev) |
| **Adminer** | 4.8 | Database admin UI |

**Simple. Clean. Production-ready.**

---

## 🎯 Common Workflows

### Fresh Laravel Installation

```bash
# Setup Docker
bash setup-laravel.sh .
```

### Existing Laravel Project

```bash
# 1. Copy files
cp docker-compose.base.yml docker-compose.yml
cp .env.template .env

# 2. Configure
nano .env  # Update APP_NAME, DB credentials, etc.

# 3. Start
docker compose up -d
docker compose exec app composer install
```

### Run Commands

```bash
# Artisan
docker compose exec app php artisan migrate
docker compose exec app php artisan seed
docker compose exec app php artisan tinker

# Composer
docker compose exec app composer require vendor/package

# Queue
docker compose exec app php artisan queue:work

# Tests
docker compose exec app php artisan test
```

---

## 📁 File Structure

```
project/
├── docker-compose.yml          ← Docker setup
├── .env                        ← Configuration (gitignored)
├── .env.template               ← Template
├── Dockerfile                  ← PHP container
├── .docker/
│   └── mysql/                  ← MySQL configs
├── app/                        ← Laravel code
├── storage/                    ← Logs, files
└── bootstrap/                  ← Cache
```

---

## ⚙️ Configuration

Edit `.env`:

```env
# App
PROJECT_NAME=my-app
APP_NAME=MyApp
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

# Database
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret

# Redis (Cache, Sessions, Queues)
REDIS_HOST=redis
REDIS_PASSWORD=null

# Mail (Mailhog in development)
MAIL_DRIVER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_FROM_ADDRESS=hello@example.com
```

---

## 🌐 Access Points

After `docker compose up -d`:

| Service | URL | Purpose |
|---------|-----|---------|
| **Laravel** | http://localhost:8000 | Your app |
| **Adminer** | http://localhost:8888 | Database UI |
| **Mailhog** | http://localhost:8025 | Email testing |
| **MySQL** | localhost:3306 | Database (host access) |
| **Redis** | localhost:6379 | Cache (host access) |

---

## 🔧 Essential Commands

```bash
# View status
docker compose ps

# View logs
docker compose logs -f app        # App logs
docker compose logs -f db         # Database logs
docker compose logs -f redis      # Redis logs

# Enter container
docker compose exec app bash

# Stop all
docker compose down

# Remove all data
docker compose down -v
```

---

## 🚀 Docker Commands

```bash
# Build image
docker compose build

# Start containers
docker compose up -d

# Stop containers
docker compose down

# View running services
docker compose ps

# Follow logs
docker compose logs -f app
```

---

## 🐛 Troubleshooting

### Container won't start
```bash
docker compose logs app
docker compose build --no-cache
docker compose up app
```

### Database connection error
```bash
docker compose logs db
# Wait a few seconds for database to be ready
docker compose exec app php artisan migrate
```

### Storage/Permission errors
```bash
docker compose exec app chmod -R 755 storage bootstrap/cache
```

### Port already in use
```env
# Change in .env
APP_PORT=8001
```

### Need to clear everything
```bash
docker compose down -v
docker volume prune
docker compose build --no-cache
docker compose up -d
```

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| **README-LARAVEL.md** | Complete reference (40+ commands) |
| **QUICKSTART-LARAVEL.md** | 5-minute setup guide |
| **docker-compose.base.yml** | Main Docker Compose file |
| **.env.template** | Configuration template |

---

## 🎯 Next Steps

1. **Run the setup**:
   ```bash
   bash setup-laravel.sh .
   ```

2. **Check documentation**:
   - Read `README-LARAVEL.md` for full reference
   - See `QUICKSTART-LARAVEL.md` for more examples

3. **Deploy**:
   - Update `.env` for production settings
   - Follow production checklist in README

---

## ✅ Verification Checklist

After setup, verify everything works:

```bash
☐ docker compose ps              # All containers Up
☐ docker compose logs app        # No error messages
☐ curl http://localhost:8000     # App responds
☐ http://localhost:8888          # Adminer loads
☐ http://localhost:8025          # Mailhog loads
☐ composer install works         # Dependencies install
☐ key:generate works             # App key set
☐ migrate works                  # Database OK
```

---

## 🆘 Getting Help

1. **Check logs**: `docker compose logs [service]`
2. **Read README-LARAVEL.md**: Full troubleshooting guide
3. **Docker docs**: https://docs.docker.com/compose/
4. **Laravel docs**: https://laravel.com/docs

---

**Ready?** Run: `bash setup-laravel.sh .`

**Happy coding! 🚀**
