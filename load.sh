cd $(dirname $0)
for file in library/models/*
do
	name=`echo $file | cut -d '/' -f 3 | tr '\.' '-'`
	`fastscore model add $name $file`
done

for file in library/schemas/*
do
	name=`echo $file | cut -d '/' -f 3`
	name=${name%.*}
	`fastscore schema add $name $file`
done

for file in library/streams/*
do
	name=`echo $file | cut -d '/' -f 3`
	name=${name%.*}
	`fastscore stream add $name $file`
done
