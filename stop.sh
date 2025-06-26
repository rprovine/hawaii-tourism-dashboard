#!/bin/bash

echo "Stopping Hawaii Tourism Dashboard..."
pkill -f "python.*app.py" 2>/dev/null || true
pkill -f "streamlit" 2>/dev/null || true
echo "✅ All services stopped"