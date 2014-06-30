set -e
export CLASSPATH=lib/*:.
javac Students.java Student.java
java Students -for 100
