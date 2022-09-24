#!/bin/bash

FILE=./deploy.pid
if [ -f "$FILE" ]; then
    date | sed 's/$/: RUN chmod -R 777 storage/'
    chmod -R 777 storage > /dev/null 2>&1 || chmod -R 777 storage >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN updating files owner/'
    chown -R nginx:nginx ./ > /dev/null 2>&1 || chown -R nginx:nginx ./ >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN maintanance mode/'
    php artisan down > /dev/null 2>&1 || php artisan down >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN composer install/'
    composer install > /dev/null 2>&1 || composer install >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN migrations/'
    php artisan migrate --force > /dev/null 2>&1 || php artisan migrate --force >> /var/log/supervisor/laravel-deploy.log
#    date | sed 's/$/: RUN ziggy:generate/'
#    php artisan ziggy:generate --url=$(cat .env | grep APP_URL | awk -F = '{ print $2 }') > /dev/null 2>&1 || php artisan ziggy:generate --url=$(cat .env | grep APP_URL | awk -F = '{ print $2 }') >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN npm install/'
    npm i --quiet --no-progress > /dev/null 2>&1 || npm i --quiet --no-progress >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN npm run production/'
    npm run prod --silent > /dev/null 2>&1 || npm run prod --silent >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN clear caches/'
    php artisan cache:clear
    php artisan config:clear
    php artisan event:clear
    php artisan route:clear
    php artisan view:clear
#    date | sed 's/$/: RUN killing ssr process/'
#    kill -9 $(ps aux | grep ssr | awk '{ print $1  }') > /dev/null 2>&1 || kill -9 $(ps aux | grep ssr | awk '{ print $1  }') >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN disable maintanance mode/'
    php artisan up > /dev/null 2>&1 || php artisan up >> /var/log/supervisor/laravel-deploy.log
    rm -f ./deploy.pid
else
    date | sed 's/$/: wait for deploy/' && sleep 60
fi
