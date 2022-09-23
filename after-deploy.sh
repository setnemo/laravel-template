#!/bin/bash

FILE=./deploy.pid
if [ -f "$FILE" ]; then
    date | sed 's/$/: RUN composer install/'
    composer install > /dev/null 2>&1 || composer install >> /var/log/supervisor/mvp.out.log
    date | sed 's/$/: RUN migrations/'
    php artisan migrate --force > /dev/null 2>&1 || php artisan migrate --force >> /var/log/supervisor/mvp.out.log
    date | sed 's/$/: RUN npm install/'
    npm i --quiet --no-progress > /dev/null 2>&1 || npm i --quiet --no-progress >> /var/log/supervisor/mvp.out.log
    date | sed 's/$/: RUN ziggy:generate/'
    php artisan ziggy:generate > /dev/null 2>&1 || php artisan ziggy:generate >> /var/log/supervisor/mvp.out.log
    date | sed 's/$/: RUN npm run production/'
    npm run production --silent > /dev/null 2>&1 || npm run production --silent >> /var/log/supervisor/mvp.out.log
    date | sed 's/$/: RUN updating files owner/'
    chown -R nginx:nginx ./ > /dev/null 2>&1 || chown -R nginx:nginx ./ >> /var/log/supervisor/mvp.out.log
    date | sed 's/$/: RUN clear caches/'
    php artisan cache:clear
    php artisan config:clear
    php artisan event:clear
    php artisan route:clear
    php artisan view:clear
    rm -f ./deploy.pid
else
    date | sed 's/$/: wait for deploy/' && sleep 60
fi
