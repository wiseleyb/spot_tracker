heroku pgbackups:capture --expire
curl -o tmp/latest.dump `heroku pgbackups:url`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U wiseleyb -d spot_development tmp/latest.dump
