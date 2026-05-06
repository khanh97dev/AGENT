# Laravel Docker Quick Start

Hướng dẫn nhanh Docker cho Laravel.

## 📋 Yêu cầu

- Docker & Docker Compose
- Laravel project

## 🚀 Setup (2 phút)

### Step 1: Copy template files

```bash
cp /path/to/.agent/docker-compose.base.yml ./docker-compose.yml
cp /path/to/.agent/.env.template ./.env
cp /path/to/Dockerfile ./Dockerfile
```

### Step 2: Configure .env

```env
PROJECT_NAME=my-laravel-app
APP_NAME=MyApp
APP_URL=http://localhost:8000
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret
```

### Step 3: Start containers

```bash
docker compose up -d
```

### Step 4: Initialize Laravel

```bash
# Install dependencies
docker compose exec app composer install

# Generate app key
docker compose exec app php artisan key:generate

# Run migrations
docker compose exec app php artisan migrate

# Create storage symlink
docker compose exec app php artisan storage:link
```

## 🌐 Access Points

| Service | URL |
|---------|-----|
| Laravel App | http://localhost:8000 |
| Adminer (DB) | http://localhost:8888 |
| Mailhog (Email) | http://localhost:8025 |

## 📝 Common Commands

```bash
# View logs
docker compose logs -f app

# Database shell
docker compose exec app mysql -h db -u laravel -p laravel

# Artisan commands
docker compose exec app php artisan tinker
docker compose exec app php artisan queue:work

# Composer
docker compose exec app composer require package/name

# Run tests
docker compose exec app php artisan test

# Stop containers
docker compose down
```

## 🐛 Troubleshooting

**Container won't start:**
```bash
docker compose logs app
docker compose build --no-cache
```

**Storage permission error:**
```bash
docker compose exec app chmod -R 755 storage bootstrap/cache
```

**Database connection failed:**
```bash
docker compose logs db
# Wait for db to be healthy, then run migrations
```

**Port already in use:**
```bash
# Change in .env
APP_PORT=8001
```

---

**Full documentation**: See `.agent/README.md`
