# HIGGS BOSON IDENTIFICATION

Kaggle Contest

Pattern Recognition Course


Authors:

Alexandre Sayal, Biomedical Engineer MSc

Sara Oliveira, Biomedical Engineer MSc


---------------------------------------


The project has two main files:
	1) intro.fig
		Runs the Graphical User Interface developed to perform all pattern recognition tasks.
		The documentation for this interface can be accessed through the menu or by opening the file HELP.md.

	2) Main.m
		Matlab script with the same functions in different sections.


PROJECT FUNCTIONS:
	1) Data Import
		Uses function dataimport.m to read the higgs dataset and return matlab readable sets.

	2) Cross-Validation
		Splits the data into a set for training (75%) and one for testing (25%), simulating the additional test set that will be provided.

	3) Missing Values Handling
		Uses function missingvalues.m to handle the NaN by 4 different methods.

	4) Normalization
		Uses function scalestd.m to perform data normalization.

	5) Feature Selection
		Performs one of the 6 techniques:
			Option 1 - Kruskal-Wallis Test (FS_kruskal.m)
			Option 2 - Correlation between features (FS_corr.m)
			Option 3 - Correlation between features and labels (FS_corr.m)
			Option 4 - Minimum Redundancy Maximum Relevance (FS_mRMR.m)
			Option 5 - ROC Analysis - Area Under Curve (FS_AUC.m)
			Option 6 - Fisher Score (FS_fisher.m)

	 6) Feature Reduction
	 	Uses function FeatureReduction.m to perform PCA or LDA.

	 7) Classifiers
	 	Six classifier and one clustering techiques are available:
	 		Option 1 - Bayesian Classifier (CL_bayes.m)
	 		Option 2 - Fisher Linear Discriminant Classifier (CL_fisher.m)
	 		Option 3 - Support Vector Machine implemented by LIBLINEAR (CL_linSVM.m)
	 		Option 4 - Support Vector Machine implemented by LIBSVM (CL_libsvm.m)
	 		Option 5 - k-NN Classifier (CL_kNN.m)
	 		Option 6 - Minimum Distance Classifier with euclidean distance (CL_mindist.m)
	 		Option 7 - k-Means Clustering (C_kmeans.m)


----------------------
University of Coimbra

May 2015
