CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission

# Step 2: checking if ListExamples.java exists
if [[ -f student-submission/ListExamples.java ]]
then
    echo "ListExamples.java is found"
else
    echo "ListExamples.java is not found"
    echo "Grade: 0"
    exit 1
fi

# Step 3: Copy ListExamples.java into grading-area
cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area

# Step 4: cd into grading-area Compile ListExamples
cd grading-area
#javac -cp $CPATH student-submission/ListExamples.java
javac -cp $CPATH *.java
CUR_EXIT=$?
echo "The exit code for the compile step is $CUR_EXIT"

# Step 5: Report the grade given

if [[ $CUR_EXIT -eq 0 ]]
then
    #java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples

    CASE_RESULT=`java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples | tail -n 2` # | cut -d':' -f3`
    set $CASE_RESULT

    #echo $(("$TOTAL_FAIL"/"$TOTAL_CASES"))
    #echo $((100/"$TOTAL_CASES"))
    if [[ $1 == "OK" ]]
    then
        PASSED_CASED=$(echo $2 | cut -d"(" -f2)
        echo $PASSED_CASED "/" $PASSED_CASED
        echo "All test passed!"
        echo "Grade: 100"
    else
        TOTAL_FAIL=$(echo $3 | cut -d',' -f1)
        TOTAL_CASES=$5
        echo $CASE_RESULT
        echo "Grade: "$((("100"/"$TOTAL_CASES")*("$TOTAL_CASES"-"$TOTAL_FAIL")))
    fi

    #for char in $CASE_RESULT 
    #do
    #    echo $char | cut -d',' -f1
    #done

    #java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples | tail -n 2 | cut -d':' -f2
    #java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples | tail -n 2 | cut -d':' -f3
else
    echo "ListExamples.java did not compile"
    echo "Grade: 0"
fi


echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
