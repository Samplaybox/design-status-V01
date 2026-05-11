#!/bin/bash
# This script runs after the container is created.
# It creates the venv, installs requirements, and enables auto-activation in new terminals.

set -e

echo "Creating Python virtual environment..."

if [ ! -d /workspace/.venv ]; then
    python -m venv /workspace/.venv
else
    echo "Virtual environment already exists."
fi

source /workspace/.venv/bin/activate

echo "Upgrading pip and installing dependencies..."
pip install --upgrade pip

if [ -f /workspace/backend/requirements.txt ]; then
    pip install -r /workspace/backend/requirements.txt
elif [ -f /workspace/requirements.txt ]; then
    pip install -r /workspace/requirements.txt
else
    echo "No requirements.txt found; creating minimal backend/requirements.txt."
    mkdir -p /workspace/backend
    echo -e "fastapi\nuvicorn\npython-multipart\nopenpyxl\npydantic\npytest\nhttpx\npsycopg2-binary\nsqlalchemy\npython-dotenv" > /workspace/backend/requirements.txt
    pip install -r /workspace/backend/requirements.txt
fi

# Auto-activate venv in every new Bash terminal
if ! grep -q "source /workspace/.venv/bin/activate" ~/.bashrc; then
    echo 'source /workspace/.venv/bin/activate' >> ~/.bashrc
fi

echo "Post-create setup completed."