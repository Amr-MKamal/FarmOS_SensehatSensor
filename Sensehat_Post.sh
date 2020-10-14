sense_rec -d 1 -i 1 test_1.hat
sense_csv --timestamp-format %m%d%H%M%S  test_1.hat - | cut -d, -f1-4,15-17 > experiment.csv
INPUT=experiment.csv
OLDIFS=$IFS
pitod=57.2957796
Public_key=
Private_key=
Url=
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read timestamp pressure pressure_temp humidity orient_x orient_y orient_z
do
	timestamp=$(echo "$timestamp" | awk '{printf "%d",$0}')
	pressure=$(echo "$pressure" | awk '{printf "%f",$0}')
	pressure_temp=$(echo "$pressure_temp" | awk '{printf "%f",$0}')
	humidity=$(echo "$humidity" | awk '{printf "%f",$0}')
	roll=$(echo  "$orient_x * $pitod" | bc | awk '{printf "%f",$0}')
	pitch=$(echo  "$orient_y * $pitod" | bc | awk '{printf "%f",$0}')
	orient_z=$(echo "$orient_z" | awk '{printf "%d",$0}')
	yaw=$(echo  "$orient_z * $pitod" | bc | awk '{printf "%f",$0}')
	echo '{"Temprature":'$pressure_temp',"Humidity " : '$humidity',"Pressure " : '$pressure',"Roll ":'$roll',"Pitch ":'$pitch',"Yaw ":'$yaw',"TimeStamp":'$timestamp'}' | farmos-cli-0.2.0/push --url $Url --feed sense-hat --public_key $Public_key --private_key Private_key
done < $INPUT
IFS=$OLDIFS
