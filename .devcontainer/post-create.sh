#!/bin/bash
#This script runs after the container is created. 
#It creates the venv, installs requirements, and sets up pre-commit hooks if desired.
set -e

echo "Creating Python virtual environment..."
python -m venv /workspace/.venv
source /workspace/.venv/bin/activate

echo "Upgrading pip and installing dependencies..."
pip install --upgrade pip
if [ -f /workspace/backend/requirements.txt ]; then
    pip install -r /workspace/backend/requirements.txt
else
    echo "No backend/requirements.txt found; creating minimal one."
    mkdir -p /workspace/backend
    echo -e "fastapi\nuvicorn\npython-multipart\nopenpyxl\npydantic\npytest\nhttpx\npsycopg2-binary\nsqlalchemy\npython-dotenv" > /workspace/backend/requirements.txt
    pip install -r /workspace/backend/requirements.txt
fi

echo "Post-create setup completed."