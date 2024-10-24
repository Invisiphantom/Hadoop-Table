
hadoop jar hadoop-streaming.jar \
-files mapper.py,reducer.py \
-mapper mapper.py \
-reducer reducer.py \
-input word.txt \
-output output


dcat output/*
drm -r output
