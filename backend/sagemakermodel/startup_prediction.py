
from __future__ import print_function

import argparse
import os
import pandas as pd

from sklearn import tree
import subprocess
import sys
import pickle

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

if __name__ == '__main__':
    install("joblib")
    import joblib
    parser = argparse.ArgumentParser()
    # Sagemaker specific arguments. Defaults are set in the environment variables.

    # Saves Checkpoints and graphs
    parser.add_argument('--output-data-dir', type=str, default=os.environ['SM_OUTPUT_DATA_DIR'])

    # Save model artifacts
    parser.add_argument('--model-dir', type=str, default=os.environ['SM_MODEL_DIR'])

    # Train data
    parser.add_argument('--train', type=str, default=os.environ['SM_CHANNEL_TRAIN'])

    args = parser.parse_args()

    file = os.path.join(args.train, "Input.csv")
    dataset = pd.read_csv(file, engine="python")

    # labels are in the first column
    X = dataset.iloc[:, [0,1,2,4,5,6]].values
    y = dataset.iloc[:, 3].values

    # Encoding categorical data
    from sklearn.preprocessing import LabelEncoder, OneHotEncoder
    from sklearn.compose import ColumnTransformer
    
    labelencoder = LabelEncoder()
    y = labelencoder.fit_transform(y)
    X[:, 2] = labelencoder.fit_transform(X[:, 2])
    X[:, 3] = labelencoder.fit_transform(X[:, 3])
    X[:, 5] = labelencoder.fit_transform(X[:, 5])
    
    
    ct = ColumnTransformer([('one_hot_encoder', OneHotEncoder(categories='auto'), [2,3,5])],remainder='passthrough')
    X = ct.fit_transform(X)

    # Avoiding the Dummy Variable Trap
    #X = X[:, 1:]

    from sklearn.model_selection import train_test_split

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)
    # from sklearn.linear_model import LinearRegression
    clf = tree.DecisionTreeClassifier(max_depth = 3, random_state = 2)
    clf.fit(X_train, y_train)
    score = clf.score(X_test, y_test)
    print(score)

    # Print the coefficients of the trained classifier, and save the coefficients
    joblib.dump(clf, os.path.join(args.model_dir, "model.joblib"))


def model_fn(model_dir):
    """Deserialized and return fitted model

    Note that this should have the same name as the serialized model in the main method
    """
    try:
        install("joblib")
        import joblib
    except:
        print("failed to load modules")

    clf = joblib.load(os.path.join(model_dir, "model.joblib"))
    return clf