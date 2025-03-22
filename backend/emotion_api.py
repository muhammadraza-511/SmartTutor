from fastapi import FastAPI, File, UploadFile
import cv2
import numpy as np
from deepface import DeepFace
import time
import io
from PIL import Image

app = FastAPI()

@app.post("/detect-emotion/")
async def detect_emotion(file: UploadFile = File(...)):  # Ensure FastAPI expects a file
    try:
        start_time = time.time()

        # Read image file
        contents = await file.read()
        image = Image.open(io.BytesIO(contents))
        image = np.array(image)  # Convert to NumPy array
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)  # Convert RGB to BGR for OpenCV

        # Resize image to 224x224 for faster processing
        image = cv2.resize(image, (224, 224))

        # Perform emotion detection
        result = DeepFace.analyze(image, actions=['emotion'], enforce_detection=False, detector_backend="opencv")

        # Extract emotions
        emotions = result[0]['emotion']
        dominant_emotion = max(emotions, key=emotions.get)

        elapsed_time = time.time() - start_time  # Processing time

        return {
            "emotion": dominant_emotion,
            "scores": emotions,
            "processing_time": f"{elapsed_time:.2f} seconds"
        }

    except Exception as e:
        return {"error": str(e)}
