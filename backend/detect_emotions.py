import os
import json
import cv2
from deepface import DeepFace

# Folder path where images are stored
IMAGE_FOLDER = r"C:\xampp\htdocs\SmartTutor\backend\images\neutral"

# Extract the expected emotion from the folder name
EXPECTED_EMOTION = os.path.basename(IMAGE_FOLDER)

def detect_emotion(image_path):
    try:
        # Load the image
        img = cv2.imread(image_path)
        if img is None:
            return {"image": image_path, "error": "Image not found or cannot be loaded"}

        # Analyze emotions
        result = DeepFace.analyze(img_path=image_path, actions=['emotion'], enforce_detection=False)

        # Extract emotions
        emotions = result[0]['emotion']
        dominant_emotion = max(emotions, key=emotions.get)

        # Return JSON output
        return {"image": os.path.basename(image_path), "emotion": dominant_emotion, "scores": emotions}

    except Exception as e:
        return {"image": os.path.basename(image_path), "error": str(e)}

def process_images_in_folder(folder_path):
    results = []
    correct_predictions = 0
    total_images = 0

    # Get all image files in the folder
    for filename in os.listdir(folder_path):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg')):  # Check image extensions
            image_path = os.path.join(folder_path, filename)
            result = detect_emotion(image_path)
            results.append(result)
            
            # Compare detected emotion with expected emotion
            predicted_emotion = result.get("emotion")
            if predicted_emotion == EXPECTED_EMOTION:
                correct_predictions += 1
            total_images += 1

    # Calculate accuracy
    accuracy = (correct_predictions / total_images) * 100 if total_images > 0 else 0

    # Print results as JSON
    print(json.dumps(results, indent=4))
    print(f"\nModel Accuracy: {accuracy:.2f}% ({correct_predictions}/{total_images} correct predictions)")

if __name__ == "__main__":
    process_images_in_folder(IMAGE_FOLDER)
