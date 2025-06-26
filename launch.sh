#!/bin/bash

# Kill any existing processes
echo "Stopping any existing processes..."
pkill -f "python.*app.py" 2>/dev/null || true
pkill -f "streamlit" 2>/dev/null || true
sleep 2

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Start backend
echo "Starting backend API..."
cd backend
PYTHONPATH=.. python app.py > ../backend.log 2>&1 &
BACKEND_PID=$!
cd ..

# Wait for backend to start
echo "Waiting for backend to start..."
sleep 3

# Check if backend is running
if curl -s http://localhost:8000/health > /dev/null; then
    echo "✅ Backend is running at http://localhost:8000"
else
    echo "❌ Backend failed to start. Check backend.log for errors"
    exit 1
fi

# Start frontend
echo "Starting frontend dashboard..."
streamlit run frontend/streamlit_app.py > frontend.log 2>&1 &
FRONTEND_PID=$!

# Wait for frontend to start
sleep 5

echo ""
echo "🚀 Hawaii Tourism Dashboard is running!"
echo "📊 Dashboard: http://localhost:8501"
echo "📚 API Docs: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for Ctrl+C
trap 'echo "Stopping services..."; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit' INT
wait