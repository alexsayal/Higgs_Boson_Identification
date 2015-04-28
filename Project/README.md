PATTERN RECOGNITION TECHNIQUES
PROJECT

ALEXANDRE SAYAL  |  SARA OLIVEIRA

FIRST-STAGE FILES:

Main file: Preprocessing.m
	Executes:
	1) Data Import
		Uses function dataimport.m to read the higgs dataset and return training and test subsets.

	2) Missing Values Handling
		Uses function missingvalues.m to handle the NaN by 3 different methods.

	3) Normalization
		Uses function scalestd.m to perform data normalization.

	4) Feature Selection
		Performs one of the 6 techniques:
			Option 1 - Kruskal-Wallis Test (FS_kruskal.m)
			Option 2 - Correlation between features (FS_corr.m)
			Option 3 - Correlation between features and labels (FS_corr.m)
			Option 4 - Minimum Redundancy Maximum Relevance (FS_mRMR.m)
			Option 5 - ROC Analysis - Area Under Curve (FS_AUC.m)
			Option 6 - Fisher Score (FS_fisher.m)

	 5) Feature Reduction
	 	Uses function FeatureReduction.m to perform PCA or LDA.

----------------------
April 2015
