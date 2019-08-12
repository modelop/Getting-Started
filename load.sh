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

fastscore attachment upload fasttext-py3 library/attachments/my_lib.tar.gz
fastscore attachment upload lr-1-py3 library/attachments/lr_pickle1.tar.gz
fastscore attachment upload lr-2-py3 library/attachments/lr_pickle2.tar.gz
fastscore attachment upload lr-1-monitored-py3 library/attachments/lr_pickle1.tar.gz
fastscore attachment upload evaluator-py3 library/attachments/streamstats.tar.gz
fastscore attachment upload xgboost_iris-py3 library/attachments/xgboost_explicit.tar.gz
fastscore attachment upload lr-champion-py3 library/attachments/lr_pickle1.tar.gz
fastscore attachment upload lr-challenger-py3 library/attachments/lr_pickle2.tar.gz
fastscore attachment upload xgboost_iris_backtest-py3 library/attachments/xgboost_explicit.tar.gz


fastscore attachment upload hp_lasso-py3 library/attachments/hp_comparison.tar.gz
fastscore attachment upload hp_ridge-py3 library/attachments/hp_comparison.tar.gz
fastscore attachment upload hp_xgboost-py3 library/attachments/hp_comparison.tar.gz
fastscore attachment upload input_monitor-py3 library/attachments/hp_comparison.tar.gz
