"""Downloads a csv data from the url to a local file path.
Usage: download_data.py --url=<url> --file_path=<file_path> 

Options:
--url=<url>             URL for the CSV file to be downloaded
--file_path=<file_path>   Local file path to be saved
"""

import os
import pandas as pd
from docopt import docopt

opt = docopt(__doc__)

def main(url, file_path):
    data = pd.read_csv(url, header=None)
    try:
        folder_path = file_path.rsplit("/", 1)[0]
        if os.path.exists(folder_path) is False:
            os.makedirs(os.path.dirname(file_path))
        data.to_csv(file_path, index=False)
    except Exception as e: 
        print(e)

if __name__ == "__main__":
    main(opt["--url"], opt["--file_path"])