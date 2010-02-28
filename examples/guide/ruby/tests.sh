cd hotel-system
script/server &
PID=$!
sleep 5
echo Starting $PID

cd ..
cd client
rake

kill -9 $PID
echo Killed $PID

