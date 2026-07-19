import zipfile
import os

# Path to the zip file
zip_file_path ='mantled_beast_markings.zip'

# Directory to extract the files to
extract_to_dir = 'assets/mantled_beast_markings'

# Create the directory if it doesn't exist
os.makedirs(extract_to_dir, exist_ok=True)

# Extract the zip file
with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
    zip_ref.extractall(extract_to_dir)

print(f"Files extracted to {extract_to_dir}")