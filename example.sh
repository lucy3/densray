DATA_DIR=./tmp/data/
TMP_DIR=./tmp/tmp/
RESULT_DIR=./tmp/results/
mkdir $DATA_DIR
mkdir $RESULT_DIR
mkdir $TMP_DIR

# Get data
#python -m utils.download_data --data_dir $DATA_DIR


# Run Lexicon Induction

python -m lexind.prepare \
		--embeddings ${DATA_DIR}cc.en.300.vec \
		--lex_train ${DATA_DIR}plant_vehicle_animal_train.txt \
		--lex_test ${DATA_DIR}plant_vehicle_animal_test.txt \
		--store ${TMP_DIR}lexind

#for method in densray,binary densray,continuous regression,svm regression,svr regression,linear regression,logistic
#do
method=densray,trinary
python -m lexind.run \
		--embeddings ${TMP_DIR}lexind,embeddings.txt \
		--lex_train ${DATA_DIR}plant_vehicle_animal_train.txt \
		--lex_train_version countable \
		--lex_test ${DATA_DIR}plant_vehicle_animal_test.txt \
		--lex_test_version countable \
		--store ${TMP_DIR}lexind \
		--densray__weights 0.5,0.5 \
		--method $method

python -m lexind.evaluate \
		--lex_true ${DATA_DIR}plant_vehicle_animal_test.txt \
		--lex_true_version countable \
		--lex_pred ${TMP_DIR}lexind,$method.predictions \
		--lex_pred_version continuous \
		--store ${RESULT_DIR}lexind \
		--method $method
#done

# Run Word Analogy Task
#python -m analogy.solve_analogy_task \
#--embeddings ${DATA_DIR}cc.en.300.vec \
#--bats false \
#--analogies ${DATA_DIR}questions-words.txt \
#--load_first_n 100000 \
#--method regression,svm \
#--pred_method clcomp \
#--use_proba false \
#--store ${RESULT_DIR}ga,regression,svm





