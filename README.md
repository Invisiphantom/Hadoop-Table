

https://hadoop.apache.org/releases.html  
https://spark.apache.org/downloads.html  
http://localhost:9870  


# Hadoop单机配置


```bash
sudo apt install -y openssh-server openjdk-11-jre-headless openjdk-11-jdk-headless

# 创建用户 hadoop
sudo useradd -m -s /bin/bash hadoop
sudo usermod -aG sudo hadoop
sudo passwd hadoop
su hadoop && cd

# 配置 ssh
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ssh localhost

# 下载安装 hadoop
wget -O hadoop.tar.gz https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
tar -xvf hadoop.tar.gz
sudo mv hadoop/ /usr/local/hadoop
sudo chown -R hadoop:hadoop /usr/local/hadoop

# 配置环境变量
vi ~/.bashrc && source ~/.bashrc

alias dls="hdfs dfs -ls"
alias drm="hdfs dfs -rm"
alias dcat="hdfs dfs -cat"
alias dput="hdfs dfs -put"
alias dget="hdfs dfs -get"
alias dmkdir="hdfs dfs -mkdir"

export HADOOP_HOME=/usr/local/hadoop
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=HADOOP_HOME/bin/:$PATH
export PATH=HADOOP_HOME/sbin/:$PATH

rm -f $HADOOP_HOME/bin/*.cmd
rm -f $HADOOP_HOME/sbin/*.cmd

vi $HADOOP_HOME/etc/hadoop/hadoop-env.sh
vi $HADOOP_HOME/etc/hadoop/core-site.xml
vi $HADOOP_HOME/etc/hadoop/hdfs-site.xml

# 初始化 HDFS
hdfs namenode -format


# 测试 hadoop
start-dfs.sh
http://localhost:9870/

dmkdir -p /user/hadoop/input
dput $HADOOP_HOME/etc/hadoop/*.xml input
dls input

hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep input output 'dfs[a-z.]+'
dcat output/*
drm -r output
stop-dfs.sh
```

core-site.xml
```xml
<configuration>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>file:/usr/local/hadoop/tmp</value>
    </property>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
```

hdfs-site.xml
```xml
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:/usr/local/hadoop/tmp/dfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:/usr/local/hadoop/tmp/dfs/data</value>
    </property>
</configuration>
```



# PySpark笔记

```py
from pyspark import SparkConf, SparkContext
conf = (
    SparkConf()
    .setMaster("local")
    .setAppName("My App")
    .set("spark.hadoop.fs.defaultFS", "hdfs://127.0.0.1:9000")
)
sc = SparkContext(conf=conf)
```