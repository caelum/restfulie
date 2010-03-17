cd server
rake db:drop
rake db:migrate
script/server &
PID=$!
sleep 5
echo Starting $PID

cd ..
cd client
rake
CODE=$?

kill -9 $PID
echo Killed $PID

exit $CODE