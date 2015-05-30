PATTERN RECOGNITION TECHNIQUES
FINAL PROJECT
HIGGS BOSON IDENTIFICATION

ALEXANDRE SAYAL  |  SARA OLIVEIRA

Graphical User Interface DOCUMENTATION

1) LOAD DATA Button
    Reads the file higgs_data.mat and imports data into Matlab.
    Displays a pie graph with class distribution.
    Performs Cross-Validation - Splits the data into training and test (75/25%).

2) LOAD TEST Button
    If you want to replace the test set created by the above function, this button allows the selection of a .mat file, with the same structure of higgs_data.mat, to perform this action.

3) HELP Button
    Opens this help file.

4) RESET Button
    Clears the workspace and all inputs in the GUI.

5) QUIT Button
    Closes the GUI.

6) MISSING VALUES Panel
    Choose one of the 4 options to handle missing values:
        MEAN - replaces the mv values by its column mean.
        MODE - replaces the mv values by its column mode.
        EVENTS - removes all events that have at least one mv.
        FEATURES - removes all features that have at least one mv.
    Click RUN to perform this action.

7) NORMALIZATION Panel
    This step in mandatory for the following techniques to perform as required. Just click RUN to perform normalization to the training set, and then use the resulting mean and standard deviation to normalize the test set.

From this step, it is possible to perform Feature Selection, Feature Reduction, or Classification.

8) FEATURE SELECTION Panel
    Click one of the 6 options to select features:
        KRUSKAL-WALLIS
            A box shows for input of the desired number of features to retain.
            After RUN button is pressed, kruskal-wallis test is executed, selecting features based on the hightest chi2 value. When it ends, a graph of the chi2 values for each feature is shown.

        FEATURE CORRELATION
            A box shows for input of the desired cut-off value of correlation.
            The function finds the most correlated features which correlation is above the cut-off value.
            Press RUN to perform this selection.

        FEATURE/LABEL CORRELATION
            A box shows for input of the desired cut-off value of correlation.
            The function finds the features that are more correlated with its classification (labels) and deletes all features which correlation value is below the select cut off value.
            Press RUN to perform this selection.

        mRMR
            A box shows for input of the desired number of features to retain.
            After RUN button is pressed, minimum Redundacy Maximum Relevance algorithm runs and returns the set with the desired number of features that better performed.

        AUC
            A box shows for input of the desired cut-off value of AUC.
            Features that return a Area Under the Curve value lower than the selected cut-off value are removed.
            Press RUN to perform this selection.

        FISHER SCORE
            A box shows for input of the desired number of features to retain.
            The function calculates the fisher score for all features and returns the set with the desired number of features that return a higher score.
            Press RUN to perform this selection.

    All the methods are applied to the training set. The features of the testing set are also selected, based on the training results.
    If you run twice one of the FS methods, they always start from the normalizated sets.

9) FEATURE REDUCTION Panel
    Click one of the two options for reducing features:
        PCA
            A box shows for input of the desired eigenvalue percentage to retain.
            Press RUN to perform this reduction.

        LDA
            A box shows for input of the desired number of features to retain.
            Press RUN to perform this reduction.

10) CLASSIFICATION Panel
    Seven classification methods are available:
        BAYESIAN Classifier
            Select Default or With Reject Option.
            After RUN button is pressed, Bayesian Cassifier algorithm runs and returns both the performances obtained with the train group and test group.

        FLD Classifier
            Select Linear or Quadratic.
            After RUN button is pressed, FLD Cassifier algorithm runs and returns both the performances obtained with the train group and test group.

        LINEAR SVM
            LIBLINEAR 
            Define min,step and max values for parameter C.
            After RUN button is pressed, LibLinear algorithm runs and returns both the performances obtained with the train group and test group.

        LIBSVM RBF
            LIBSVM
            Define min,step and max values for parameter C and Gamma.
            Define event limit because for the complete training set (150000 events) the algorithm takes several hours to complete. Default is 1000 events.
            After RUN button is pressed, LibSVM algorithm runs and returns both the performances obtained with the train group and test group.

        k-NN Classifier
            Define min and max values for parameter K (number of neighbours)
            Define event limit because for the complete training set (150000 events) the algorithm takes several hours to complete. Default is 1000 events.
            After RUN button is pressed, k-NN Classifier algorithm runs and returns both the performances obtained with the train group and test group.

        MINIMUM DISTANCE Classifier
            Press RUN.

        K-MEANS Clustering
            Press RUN.





----------------------
May 2015
