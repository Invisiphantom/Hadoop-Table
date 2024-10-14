hadoop jar hadoop-streaming.jar \
-file mapper.py -file reducer.py \
-mapper mapper.py -reducer reducer.py \
-input word.txt -output output

dcat output/*
drm -r output